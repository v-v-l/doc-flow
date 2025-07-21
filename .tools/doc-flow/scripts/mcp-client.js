#!/usr/bin/env node

/**
 * Doc Flow - MCP Client
 * Handles communication with Model Context Protocol servers
 * Based on the MCP specification: https://spec.modelcontextprotocol.io/
 */

const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

class MCPClient {
  constructor(configPath = './.tools/doc-flow/config.json') {
    this.configPath = configPath;
    this.config = this.loadConfig();
    this.activeServers = new Map();
  }

  loadConfig() {
    try {
      const configData = fs.readFileSync(this.configPath, 'utf8');
      return JSON.parse(configData);
    } catch (error) {
      console.error('❌ Error loading config:', error.message);
      process.exit(1);
    }
  }

  async startServer(serverName) {
    const serverConfig = this.config.mcp_servers?.[serverName];
    if (!serverConfig) {
      throw new Error(`Server '${serverName}' not found in configuration`);
    }

    if (!serverConfig.enabled) {
      throw new Error(`Server '${serverName}' is disabled in configuration`);
    }

    if (this.activeServers.has(serverName)) {
      console.log(`🔄 Server '${serverName}' already running`);
      return this.activeServers.get(serverName);
    }

    console.log(`🚀 Starting MCP server: ${serverName}`);
    console.log(`📝 Description: ${serverConfig.description}`);

    const serverProcess = spawn(serverConfig.command, serverConfig.args, {
      env: { ...process.env, ...serverConfig.env },
      stdio: ['pipe', 'pipe', 'pipe']
    });

    const server = {
      process: serverProcess,
      name: serverName,
      config: serverConfig,
      ready: false
    };

    this.activeServers.set(serverName, server);

    // Handle server output
    serverProcess.stdout.on('data', (data) => {
      const output = data.toString();
      // MCP servers running on stdio are ready when they output their startup message
      if (output.includes('MCP Server running on stdio') || 
          output.includes('Knowledge AI MCP Server running on stdio') ||
          output.includes('MCP server ready') || 
          output.includes('Server listening')) {
        server.ready = true;
        console.log(`✅ Server '${serverName}' is ready`);
      }
      console.log(`[${serverName}] ${output}`);
    });

    serverProcess.stderr.on('data', (data) => {
      const output = data.toString().trim();
      // Check if this is actually a success message from MCP server
      if (output.includes('MCP Server running on stdio') || 
          output.includes('Knowledge AI MCP Server running on stdio') ||
          output.includes('server running on stdio')) {
        server.ready = true;
        console.log(`✅ Server '${serverName}' is ready: ${output}`);
      } else if (output) {
        console.error(`[${serverName} ERROR] ${output}`);
      }
    });

    serverProcess.on('close', (code) => {
      console.log(`🛑 Server '${serverName}' exited with code ${code}`);
      this.activeServers.delete(serverName);
    });

    // Wait for server to be ready or timeout
    const timeout = serverConfig.timeout || 30000;
    await this.waitForReady(server, timeout);

    return server;
  }

  async waitForReady(server, timeout) {
    return new Promise((resolve, reject) => {
      const checkReady = () => {
        if (server.ready) {
          resolve(server);
        } else {
          setTimeout(checkReady, 500);
        }
      };

      setTimeout(() => {
        if (!server.ready) {
          reject(new Error(`Server '${server.name}' did not start within ${timeout}ms`));
        }
      }, timeout);

      checkReady();
    });
  }

  async sendRequest(serverName, method, params = {}) {
    const server = this.activeServers.get(serverName);
    if (!server || !server.ready) {
      throw new Error(`Server '${serverName}' is not ready`);
    }

    const request = {
      jsonrpc: '2.0',
      id: Date.now(),
      method: method,
      params: params
    };

    console.log(`📤 Sending request to ${serverName}:`, method);

    return new Promise((resolve, reject) => {
      const requestTimeout = setTimeout(() => {
        reject(new Error(`Request to '${serverName}' timed out after 10 seconds`));
      }, 10000); // Shorter timeout for individual requests

      // Create a one-time listener for this specific request
      const responseHandler = (data) => {
        const output = data.toString();
        console.log(`📥 Received from ${serverName}:`, output);
        
        // Try to parse each line as JSON
        const lines = output.split('\n').filter(line => line.trim());
        for (const line of lines) {
          try {
            const response = JSON.parse(line);
            if (response.id === request.id) {
              clearTimeout(requestTimeout);
              server.process.stdout.removeListener('data', responseHandler);
              
              if (response.error) {
                reject(new Error(response.error.message));
              } else {
                resolve(response.result || response);
              }
              return;
            }
          } catch (e) {
            // Not JSON or not our response, continue
          }
        }
      };

      server.process.stdout.on('data', responseHandler);

      // Send request
      const requestStr = JSON.stringify(request);
      console.log(`📤 Sending: ${requestStr}`);
      server.process.stdin.write(requestStr + '\n');
    });
  }

  async processArchitectureUpdates(pendingFile) {
    const preferredServer = this.config.mcp_processing?.preferred_server;
    if (!preferredServer) {
      throw new Error('No preferred MCP server configured');
    }

    console.log('🏗️ Processing architecture updates via MCP...');

    try {
      // Read pending updates
      const pendingUpdates = fs.readFileSync(pendingFile, 'utf8');

      // Start the preferred server
      await this.startServer(preferredServer);

      // First, discover what tools are available
      console.log('🔍 Discovering available MCP tools...');
      let availableTools = [];
      try {
        const toolsResponse = await this.sendRequest(preferredServer, 'tools/list', {});
        availableTools = toolsResponse.tools || toolsResponse || [];
        console.log('📋 Available tools:', availableTools.map(t => t.name || t).join(', '));
      } catch (e) {
        console.log('💡 Could not list tools, trying known Obsidian tools...');
        // Fallback to known tools from your architecture prompt
        availableTools = [
          { name: 'search' },
          { name: 'list_notes' }, 
          { name: 'create_note' },
          { name: 'get_note_connections' },
          { name: 'add_wikilink' },
          { name: 'graph_search' }
        ];
      }

      // Process architecture updates using the knowledge management approach
      console.log('🏗️ Processing architecture update with knowledge tools...');
      
      // Parse the architecture update content
      const commitMatch = pendingUpdates.match(/## Auto-Captured: (.+)\n\*\*Branch:\*\* (.+) \| \*\*Commit:\*\* (.+)/);
      const messageMatch = pendingUpdates.match(/### Commit Message\n(.+)/);
      const filesMatch = pendingUpdates.match(/### Files Modified\n```\n(.+?)\n```/s);
      
      const commitInfo = {
        timestamp: commitMatch ? commitMatch[1] : new Date().toISOString(),
        branch: commitMatch ? commitMatch[2] : 'unknown',
        commit: commitMatch ? commitMatch[3] : 'unknown',
        message: messageMatch ? messageMatch[1] : 'No message',
        files: filesMatch ? filesMatch[1].split('\n').filter(f => f.trim()) : []
      };

      console.log('📊 Parsed commit info:', commitInfo);

      const results = [];

      // Step 1: Search for existing architecture overview
      try {
        console.log('🔍 Step 1: Checking existing architecture...');
        const searchResult = await this.sendRequest(preferredServer, 'tools/call', {
          name: 'list_notes',
          arguments: { 
            virtual_folder: 'architecture/overview',
            tags: ['foundational', 'system-design']
          }
        });
        results.push({ step: 'architecture_overview_check', result: searchResult });
      } catch (e) {
        console.log('⚠️ Could not check architecture overview:', e.message);
      }

      // Step 2: Search for existing components mentioned in the commit
      const componentRegex = /(?:add|new|create|implement)\s+(\w+(?:Service|Controller|Component|Manager|Handler))/gi;
      const components = [];
      let match;
      while ((match = componentRegex.exec(commitInfo.message)) !== null) {
        components.push(match[1]);
      }

      console.log('🧩 Detected components:', components);

      for (const component of components) {
        try {
          console.log(`🔍 Step 2: Searching for existing ${component}...`);
          const searchResult = await this.sendRequest(preferredServer, 'tools/call', {
            name: 'search',
            arguments: { query: component }
          });
          results.push({ step: `search_${component}`, result: searchResult });

          // If component doesn't exist, create documentation for it
          if (!searchResult || (searchResult.results && searchResult.results.length === 0)) {
            console.log(`📝 Step 3: Creating documentation for ${component}...`);
            const noteContent = this.generateComponentNote(component, commitInfo);
            const createResult = await this.sendRequest(preferredServer, 'tools/call', {
              name: 'create_note',
              arguments: {
                title: component,
                content: noteContent,
                virtual_folder: 'architecture/components/',
                tags: ['component', 'service', 'auto-documented']
              }
            });
            results.push({ step: `create_${component}`, result: createResult });
          }
        } catch (e) {
          console.log(`⚠️ Error processing component ${component}:`, e.message);
        }
      }

      console.log('✅ Architecture processing completed via MCP tools');
      return {
        status: 'success',
        message: 'Architecture updates processed via MCP knowledge tools',
        commit_info: commitInfo,
        detected_components: components,
        processing_results: results
      };

    } catch (error) {
      console.error('❌ MCP processing failed:', error.message);
      
      if (this.config.mcp_processing?.fallback_to_manual) {
        console.log('🔄 Falling back to manual processing instructions');
        return this.generateFallbackInstructions(pendingFile);
      }
      
      throw error;
    }
  }

  generateComponentNote(componentName, commitInfo) {
    const currentDate = new Date().toISOString().split('T')[0];
    
    return `# ${componentName}

**Type:** Component  
**Added:** ${currentDate}  
**Source Commit:** ${commitInfo.commit} on ${commitInfo.branch}  
**Status:** #auto-documented #component #service

## Purpose
${componentName} component added via commit: "${commitInfo.message}"

## Files
${commitInfo.files.map(f => `- \`${f}\``).join('\n')}

## Dependencies (Upstream)
<!-- Add dependencies here -->

## Used By (Downstream) 
<!-- Add dependents here -->

## Key Methods
<!-- Document main methods/functionality -->

## Integration Points
<!-- Document external connections -->

## Related Architecture
<!-- Add wikilinks to related components -->

---
**Auto-generated:** ${new Date().toISOString()}  
**Source:** doc-flow MCP integration`;
  }

  generateFallbackInstructions(pendingFile) {
    const pendingUpdates = fs.readFileSync(pendingFile, 'utf8');
    
    return {
      status: 'fallback',
      message: 'MCP processing failed, manual processing required',
      instructions: [
        '1. Review the pending updates in your knowledge management system',
        '2. Process the captured architecture changes manually',
        '3. Update your documentation following project conventions'
      ],
      content: pendingUpdates
    };
  }

  async stopServer(serverName) {
    const server = this.activeServers.get(serverName);
    if (server) {
      console.log(`🛑 Stopping server: ${serverName}`);
      server.process.kill('SIGTERM');
      this.activeServers.delete(serverName);
    }
  }

  async stopAllServers() {
    console.log('🛑 Stopping all MCP servers...');
    for (const [serverName] of this.activeServers) {
      await this.stopServer(serverName);
    }
  }

  listServers() {
    const servers = this.config.mcp_servers || {};
    console.log('🖥️  Available MCP Servers:');
    for (const [name, config] of Object.entries(servers)) {
      const status = config.enabled ? '🟢 enabled' : '🔴 disabled';
      const running = this.activeServers.has(name) ? '▶️ running' : '⏸️ stopped';
      console.log(`  ${name}: ${status} | ${running}`);
      console.log(`    ${config.description}`);
    }
  }
}

// CLI interface
async function main() {
  const args = process.argv.slice(2);
  const command = args[0];

  const client = new MCPClient();

  try {
    switch (command) {
      case 'start':
        const serverName = args[1];
        if (!serverName) {
          console.error('❌ Server name required: node mcp-client.js start <server-name>');
          process.exit(1);
        }
        await client.startServer(serverName);
        break;

      case 'stop':
        const stopServerName = args[1];
        if (stopServerName) {
          await client.stopServer(stopServerName);
        } else {
          await client.stopAllServers();
        }
        break;

      case 'list':
        client.listServers();
        break;

      case 'process':
        const pendingFile = args[1] || './.tools/doc-flow/pending-updates.md';
        const result = await client.processArchitectureUpdates(pendingFile);
        console.log('📋 Processing result:', result);
        break;

      default:
        console.log(`
Doc Flow MCP Client

Usage:
  node mcp-client.js start <server-name>     Start an MCP server
  node mcp-client.js stop [server-name]      Stop server(s)
  node mcp-client.js list                    List available servers
  node mcp-client.js process [file]          Process architecture updates

Examples:
  node mcp-client.js start obsidian_knowledge
  node mcp-client.js process .tools/doc-flow/pending-updates.md
  node mcp-client.js list
        `);
    }
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

// Handle cleanup on exit
process.on('SIGINT', async () => {
  console.log('\n🛑 Shutting down MCP client...');
  const client = new MCPClient();
  await client.stopAllServers();
  process.exit(0);
});

if (require.main === module) {
  main();
}

module.exports = MCPClient;
#!/bin/bash
# Doc Flow - Claude Code MCP Processor
# Integrates with Claude Code's doc-flow MCP for architecture documentation

TOOLS_DIR=".tools/doc-flow"
CONFIG_FILE="$TOOLS_DIR/config.json"
PENDING_FILE="$TOOLS_DIR/pending-updates.md"
PROCESSING_LOG="$TOOLS_DIR/processing.log"

# Check if auto-processing is enabled
AUTO_PROCESS=$(grep -o '"auto_process_via_mcp":\s*true' "$CONFIG_FILE" 2>/dev/null)

if [ -z "$AUTO_PROCESS" ]; then
    echo "🔄 Auto-processing disabled in config - skipping MCP processing"
    exit 0
fi

# Check if pending updates exist
if [ ! -f "$PENDING_FILE" ]; then
    echo "📭 No pending updates found"
    exit 0
fi

# Log processing attempt
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting MCP processing" >> "$PROCESSING_LOG"

# Create processing instructions for Claude Code
PROCESS_FILE="$TOOLS_DIR/claude-processing-request.md"

cat > "$PROCESS_FILE" << 'EOF'
# Architecture Documentation Processing Request

## Task
Process the pending architecture updates using the doc-flow MCP system.

## Instructions
1. Read the pending updates from `.tools/doc-flow/pending-updates.md`
2. Use the architecture documentation prompt from `docs/architecture-documentation-prompt.md`
3. Follow the discovery-first approach:
   - Search for existing components before creating new ones
   - Use proper wikilink connections
   - Follow naming conventions (PascalCase for components, etc.)
   - Organize in correct virtual folders

## Processing Steps
1. Parse commit information from pending updates
2. Extract architectural components and changes  
3. Use MCP tools to:
   - Search for existing documentation
   - Create new component notes
   - Update system overview with connections
   - Maintain bidirectional wikilinks

## Expected Output
- New/updated notes in the doc-flow MCP knowledge base
- Proper virtual folder organization
- Connected architecture graph with relationships

## Reference Files
- Configuration: `.tools/doc-flow/config.json`
- Architecture Prompt: `docs/architecture-documentation-prompt.md`
- Pending Updates: `.tools/doc-flow/pending-updates.md`

EOF

echo "📋 Created processing request for Claude Code"
echo "📝 Processing file: $PROCESS_FILE"
echo ""
echo "🎯 Next Step: Tell Claude Code to:"
echo "   'Process the architecture documentation request in $PROCESS_FILE'"
echo ""
echo "💡 Or run directly: 'Process pending architecture updates using doc-flow MCP'"
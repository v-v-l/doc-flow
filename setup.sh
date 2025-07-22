#!/bin/bash
# Doc Flow - Interactive Setup Script
# Choose your documentation workflow and get started quickly

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
TOOLS_DIR=".tools/doc-flow"
CONFIG_FILE="$TOOLS_DIR/config.json"

# Function to print colored output
print_header() {
    echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  $1  ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
}

print_workflow() {
    echo -e "${CYAN}$1${NC}"
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Show workflow diagrams
show_workflow_overview() {
    print_header "📊 Doc Flow - How It Works"
    echo ""
    
    print_workflow "   ┌─────────────┐    ┌──────────────┐    ┌─────────────────┐"
    print_workflow "   │ Git Commit  │───▶│ Hook Detect  │───▶│ Capture Changes │"
    print_workflow "   │ with arch   │    │ Keywords     │    │ to pending-     │"  
    print_workflow "   │ keywords    │    │              │    │ updates.md      │"
    print_workflow "   └─────────────┘    └──────────────┘    └─────────────────┘"
    print_workflow "                                                      │"
    print_workflow "   ┌─────────────┐    ┌──────────────┐                 │"
    print_workflow "   │ Knowledge   │◀───│ Process via  │◀────────────────┘"
    print_workflow "   │ System      │    │ MCP/AI       │"
    print_workflow "   │ Updated     │    │ Assistant    │"
    print_workflow "   └─────────────┘    └──────────────┘"
    echo ""
    
    print_workflow "🔍 Detection Keywords: add, new, create, implement + service, component, module"
    print_workflow "📝 Auto-captures: Component dependencies, relationships, integration points"
    print_workflow "🏗️  Updates: README.md, Obsidian, Notion, or custom knowledge systems"
    echo ""
}

show_documentation_options() {
    print_header "📚 Choose Your Documentation System"
    echo ""
    
    echo -e "${GREEN}1) Simple Markdown${NC} - README.md and docs/ folder"
    print_workflow "   ├── README.md (auto-updated architecture section)"
    print_workflow "   ├── docs/architecture/"
    print_workflow "   │   ├── overview.md"
    print_workflow "   │   ├── components/"
    print_workflow "   │   └── integrations/"
    print_workflow "   └── .tools/doc-flow/pending-updates.md"
    echo ""
    
    echo -e "${PURPLE}2) Obsidian Vault${NC} - Advanced knowledge management"
    print_workflow "   ├── Your-Vault/"
    print_workflow "   │   ├── Architecture/"
    print_workflow "   │   │   ├── 🏗️ System Overview.md"  
    print_workflow "   │   │   ├── Components/"
    print_workflow "   │   │   │   ├── [[UserService]].md"
    print_workflow "   │   │   │   └── [[PaymentService]].md"
    print_workflow "   │   │   └── Integrations/"
    print_workflow "   │   └── Graph View (visual connections)"
    print_workflow "   └── Wikilinks: [[Component]] → [[Dependency]]"
    echo ""
    
    echo -e "${CYAN}3) Notion Database${NC} - Team collaboration"
    print_workflow "   ├── Architecture Database"
    print_workflow "   │   ├── Components Table"
    print_workflow "   │   │   ├── Name | Type | Dependencies"
    print_workflow "   │   │   ├── Status | Owner | Last Updated"
    print_workflow "   │   │   └── Integration Points"
    print_workflow "   │   ├── Relations & Rollups"  
    print_workflow "   │   └── Templates for consistency"
    print_workflow "   └── API Integration for auto-updates"
    echo ""
    
    echo -e "${YELLOW}4) Custom/Multiple${NC} - Your own system"
    print_workflow "   ├── JSON/API output format"
    print_workflow "   ├── Webhook notifications"
    print_workflow "   ├── Custom templates"
    print_workflow "   └── Integration with your tools"
    echo ""
    
    echo -e "${GREEN}5) MCP Integration${NC} - Claude Code knowledge system"
    print_workflow "   ├── Direct integration with Claude Code"
    print_workflow "   ├── Real-time architecture documentation"
    print_workflow "   ├── Graph-based knowledge connections"
    print_workflow "   └── Virtual folder organization"
    echo ""
}

# Get user choice
get_documentation_choice() {
    while true; do
        echo -e "${BLUE}Which documentation system do you want to use?${NC}"
        echo -e "Enter choice (1-5): \c"
        read choice
        
        case $choice in
            1) 
                KNOWLEDGE_SYSTEM="markdown"
                SYSTEM_NAME="Simple Markdown"
                break
                ;;
            2)
                KNOWLEDGE_SYSTEM="obsidian"
                SYSTEM_NAME="Obsidian Vault"
                break
                ;;
            3)
                KNOWLEDGE_SYSTEM="notion"
                SYSTEM_NAME="Notion Database"
                break
                ;;
            4)
                KNOWLEDGE_SYSTEM="custom"
                SYSTEM_NAME="Custom System"
                break
                ;;
            5)
                KNOWLEDGE_SYSTEM="local_mcp"
                SYSTEM_NAME="MCP Integration (Claude Code)"
                break
                ;;
            *)
                print_error "Invalid choice. Please enter 1-5."
                ;;
        esac
    done
    
    echo ""
    print_success "Selected: ${SYSTEM_NAME}"
    echo ""
}

# Configure based on choice
configure_system() {
    case $KNOWLEDGE_SYSTEM in
        "markdown")
            configure_markdown
            ;;
        "obsidian")
            configure_obsidian
            ;;
        "notion")
            configure_notion
            ;;
        "custom")
            configure_custom
            ;;
        "local_mcp")
            configure_mcp
            ;;
    esac
}

configure_markdown() {
    print_status "Configuring Simple Markdown system..."
    
    cat > "$CONFIG_FILE" << 'EOF'
{
  "knowledge_system": "markdown",
  "output_format": "markdown",
  "detection_keywords": [
    "add", "new", "create", "implement", "feat",
    "service", "controller", "component", "module", 
    "integration", "api", "database", "auth"
  ],
  "naming_conventions": {
    "components": "PascalCase",
    "modules": "kebab-case",
    "systems": "Title Case"
  },
  "virtual_folders": {
    "architecture": "docs/architecture/",
    "components": "docs/architecture/components/",
    "modules": "docs/architecture/modules/",
    "integrations": "docs/architecture/integrations/"
  },
  "auto_capture": true,
  "auto_update_readme": true,
  "include_file_analysis": true,
  "markdown_config": {
    "readme_section": "## 🏗️ Architecture",
    "docs_folder": "docs/architecture/",
    "component_template": "component-simple.md"
  }
}
EOF

    # Create docs structure
    mkdir -p docs/architecture/{components,modules,integrations}
    
    # Create simple README architecture section
    if [ -f "README.md" ] && ! grep -q "## 🏗️ Architecture" README.md; then
        echo "" >> README.md
        echo "## 🏗️ Architecture" >> README.md
        echo "" >> README.md
        echo "Architecture documentation is automatically maintained in \`docs/architecture/\`" >> README.md
        echo "" >> README.md
        echo "### Components" >> README.md
        echo "<!-- Auto-generated component list will appear here -->" >> README.md
        echo "" >> README.md
    fi
    
    print_success "Markdown system configured"
    print_status "📁 Created: docs/architecture/ structure"
    print_status "📝 Updated: README.md architecture section"
}

configure_obsidian() {
    print_status "Configuring Obsidian Vault integration..."
    
    echo -e "Enter your Obsidian vault path (e.g., /Users/name/Documents/MyVault): \c"
    read vault_path
    
    echo -e "Use wikilinks [[Component]] format? (y/n, default: y): \c" 
    read use_wikilinks
    use_wikilinks=${use_wikilinks:-y}
    
    WIKILINKS="true"
    if [ "$use_wikilinks" != "y" ]; then
        WIKILINKS="false"
    fi
    
    cat > "$CONFIG_FILE" << EOF
{
  "knowledge_system": "obsidian",
  "output_format": "markdown",
  "detection_keywords": [
    "add", "new", "create", "implement", "feat",
    "service", "controller", "component", "module", 
    "integration", "api", "database", "auth"
  ],
  "naming_conventions": {
    "components": "PascalCase",
    "modules": "kebab-case", 
    "systems": "Title Case"
  },
  "virtual_folders": {
    "architecture": "Architecture/",
    "components": "Architecture/Components/",
    "modules": "Architecture/Modules/", 
    "integrations": "Architecture/Integrations/"
  },
  "auto_capture": true,
  "include_file_analysis": true,
  "obsidian_config": {
    "vault_path": "$vault_path",
    "use_wikilinks": $WIKILINKS,
    "avoid_hash_in_titles": true,
    "component_template": "obsidian-component.md",
    "auto_create_folders": true
  }
}
EOF
    
    print_success "Obsidian configuration saved"
    print_status "📁 Vault path: $vault_path"
    print_status "🔗 Wikilinks enabled: $WIKILINKS"
}

configure_notion() {
    print_status "Configuring Notion Database integration..."
    
    echo -e "Enter your Notion Integration Token: \c"
    read -s notion_token
    echo ""
    
    echo -e "Enter your Notion Database ID: \c"
    read notion_database
    
    cat > "$CONFIG_FILE" << EOF
{
  "knowledge_system": "notion",
  "output_format": "json",
  "detection_keywords": [
    "add", "new", "create", "implement", "feat",
    "service", "controller", "component", "module", 
    "integration", "api", "database", "auth"
  ],
  "naming_conventions": {
    "components": "PascalCase",
    "modules": "kebab-case",
    "systems": "Title Case"
  },
  "virtual_folders": {
    "architecture": "Architecture",
    "components": "Components",
    "modules": "Modules",
    "integrations": "Integrations"
  },
  "auto_capture": true,
  "include_file_analysis": true,
  "notion_config": {
    "database_id": "$notion_database",
    "api_token": "$notion_token",
    "component_properties": {
      "Name": "title",
      "Type": "select",
      "Dependencies": "relation",
      "Status": "select",
      "Last Updated": "last_edited_time"
    }
  }
}
EOF
    
    print_success "Notion configuration saved"
    print_status "🗃️  Database ID: ${notion_database:0:8}..."
}

configure_custom() {
    print_status "Configuring Custom system integration..."
    
    echo -e "Enter your API endpoint (optional): \c"
    read api_endpoint
    
    echo -e "Enter output format (json/yaml/markdown, default: json): \c"
    read output_format
    output_format=${output_format:-json}
    
    cat > "$CONFIG_FILE" << EOF
{
  "knowledge_system": "custom",
  "output_format": "$output_format",
  "detection_keywords": [
    "add", "new", "create", "implement", "feat",
    "service", "controller", "component", "module", 
    "integration", "api", "database", "auth"
  ],
  "naming_conventions": {
    "components": "PascalCase",
    "modules": "kebab-case",
    "systems": "Title Case"
  },
  "virtual_folders": {
    "architecture": "architecture/",
    "components": "architecture/components/",
    "modules": "architecture/modules/",
    "integrations": "architecture/integrations/"
  },
  "auto_capture": true,
  "include_file_analysis": true,
  "custom_config": {
    "api_endpoint": "$api_endpoint",
    "output_file": ".tools/doc-flow/architecture-export.$output_format",
    "webhook_enabled": false,
    "custom_template": "custom-component.md"
  }
}
EOF
    
    print_success "Custom system configuration saved"
    print_status "📤 Output format: $output_format"
    if [ ! -z "$api_endpoint" ]; then
        print_status "🌐 API endpoint: $api_endpoint"
    fi
}

configure_mcp() {
    print_status "Configuring MCP Integration (Claude Code)..."
    
    cat > "$CONFIG_FILE" << 'EOF'
{
  "knowledge_system": "local_mcp",
  "output_format": "markdown",
  "use_mcp": true,
  "detection_keywords": [
    "add", "new", "create", "implement", "feat",
    "service", "controller", "component", "module", 
    "integration", "api", "database", "auth", "mcp"
  ],
  "naming_conventions": {
    "components": "PascalCase",
    "modules": "kebab-case",
    "systems": "Title Case"
  },
  "virtual_folders": {
    "architecture": "architecture/",
    "components": "architecture/components/",
    "modules": "architecture/modules/",
    "integrations": "architecture/integrations/"
  },
  "auto_capture": true,
  "include_file_analysis": true,
  "auto_process_via_mcp": true,
  "knowledge_system_config": {
    "local_mcp": {
      "mode": "local",
      "api_url": "http://localhost:3000",
      "use_wikilinks": true,
      "avoid_hash_in_titles": true
    }
  },
  "mcp_processing": {
    "auto_process_on_capture": true,
    "preferred_method": "claude_code",
    "fallback_to_manual": true,
    "architecture_prompt_path": "docs/architecture-documentation-prompt.md"
  }
}
EOF
    
    print_success "MCP Integration configured"
    print_status "🤖 Claude Code integration enabled"
    print_status "📊 Graph-based knowledge system ready"
}

# Show final workflow for selected system
show_final_workflow() {
    print_header "🎯 Your Documentation Workflow"
    echo ""
    
    case $KNOWLEDGE_SYSTEM in
        "markdown")
            print_workflow "📝 Simple Markdown Workflow:"
            print_workflow "   1. git commit -m 'add UserService component'"
            print_workflow "   2. Hook detects → captures to pending-updates.md"  
            print_workflow "   3. Manual: Review and update docs/architecture/"
            print_workflow "   4. README.md architecture section auto-updated"
            ;;
        "obsidian")
            print_workflow "🧠 Obsidian Vault Workflow:"
            print_workflow "   1. git commit -m 'add UserService component'"
            print_workflow "   2. Hook detects → captures to pending-updates.md"
            print_workflow "   3. Process in Obsidian with AI assistant"
            print_workflow "   4. Creates [[UserService]] with wikilinks"
            print_workflow "   5. Graph view shows component relationships"
            ;;
        "notion")
            print_workflow "🗃️  Notion Database Workflow:"
            print_workflow "   1. git commit -m 'add UserService component'"
            print_workflow "   2. Hook detects → captures to pending-updates.md"
            print_workflow "   3. API pushes to Notion database"
            print_workflow "   4. Team can see component in structured table"
            print_workflow "   5. Relations and rollups show dependencies"
            ;;
        "custom") 
            print_workflow "⚙️  Custom System Workflow:"
            print_workflow "   1. git commit -m 'add UserService component'"
            print_workflow "   2. Hook detects → captures to pending-updates.md"
            print_workflow "   3. Export to your format: JSON/YAML/Markdown"
            print_workflow "   4. Webhook/API integration (if configured)"
            print_workflow "   5. Process with your custom tools"
            ;;
        "local_mcp")
            print_workflow "🤖 MCP Integration Workflow:"
            print_workflow "   1. git commit -m 'add UserService component'"
            print_workflow "   2. Hook detects → captures to pending-updates.md"
            print_workflow "   3. Tell Claude Code: 'Process pending updates'"
            print_workflow "   4. AI creates structured component documentation"
            print_workflow "   5. Graph relationships maintained automatically"
            ;;
    esac
    
    echo ""
    print_workflow "🔍 Detected keywords: add, new, create, implement + service, component, module"
    print_workflow "📁 Virtual folders: architecture/{components,modules,integrations}/"  
    print_workflow "🏗️  Auto-captures: dependencies, relationships, integration points"
    echo ""
}

# Show quick test
show_quick_test() {
    print_header "🧪 Quick Test"
    echo ""
    
    print_status "Try this to test your setup:"
    echo -e "${CYAN}git commit -m 'add TestService component for demo'${NC}"
    echo -e "${CYAN}cat .tools/doc-flow/pending-updates.md${NC}"
    echo ""
    
    case $KNOWLEDGE_SYSTEM in
        "markdown")
            print_status "Then check: docs/architecture/ and README.md"
            ;;
        "obsidian")
            print_status "Then process in Obsidian with your AI assistant"
            ;;
        "notion")
            print_status "Then check your Notion database for new entries"
            ;;
        "custom")
            print_status "Then check: .tools/doc-flow/architecture-export.*"
            ;;
        "local_mcp")
            print_status "Then tell Claude Code: 'Process pending architecture updates'"
            ;;
    esac
    echo ""
}

# Main interactive setup
main() {
    clear
    echo ""
    print_header "🏗️  Doc Flow - Interactive Setup"
    echo ""
    
    # Check if we're in a git repository
    if [ ! -d ".git" ]; then
        print_error "Not in a git repository. Please run 'git init' first or navigate to your project root."
        exit 1
    fi
    
    show_workflow_overview
    show_documentation_options
    get_documentation_choice
    
    print_status "Setting up Doc Flow with ${SYSTEM_NAME}..."
    echo ""
    
    # Run base installation
    if [ -f "install.sh" ]; then
        print_status "Running base installation..."
        ./install.sh > /dev/null 2>&1
        print_success "Base system installed"
    else
        print_error "install.sh not found. Please run from doc-flow directory."
        exit 1
    fi
    
    # Configure chosen system
    configure_system
    
    # Show final workflow
    show_final_workflow
    show_quick_test
    
    print_header "🎉 Setup Complete!"
    echo ""
    print_success "Doc Flow configured for: ${SYSTEM_NAME}"
    print_success "Configuration saved: $CONFIG_FILE" 
    print_success "Git hook installed: .git/hooks/post-commit"
    echo ""
    print_status "📖 Usage guide: .tools/doc-flow/README.md"
    print_status "⚙️  Configuration: $CONFIG_FILE"
    echo ""
    print_workflow "Happy documenting! 🚀"
    echo ""
}

# Run interactive setup
main "$@"
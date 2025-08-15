#!/bin/bash
# Doc Flow - Installation Script
# Minimal footprint installation for any project

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOC_FLOW_DIR=".doc-flow"
CONFIG_FILE="$DOC_FLOW_DIR/config.json"
PENDING_FILE="$DOC_FLOW_DIR/pending-changes.md"
HOOK_FILE=".git/hooks/post-commit"

# Function to print colored output
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

# Check if we're in a git repository
check_git_repo() {
    if [ ! -d ".git" ]; then
        print_error "Not in a git repository. Please run 'git init' first or navigate to your project root."
        exit 1
    fi
    print_success "Git repository detected"
}

# Detect and handle older installations
detect_and_upgrade_old_version() {
    local is_upgrade=false
    
    print_status "Checking for existing Doc Flow installation..."
    
    # Check for old file patterns
    if [ -f ".doc-flow/pending-updates.md" ]; then
        print_warning "Found old version: pending-updates.md (will be renamed to pending-changes.md)"
        is_upgrade=true
    fi
    
    # Check for old template files
    if [ -f ".doc-flow/templates/local-instructions.md" ] || [ -f ".doc-flow/templates/mcp-instructions.md" ]; then
        print_warning "Found old version: separate local/mcp templates (will use unified template)"
        is_upgrade=true
    fi
    
    # Check for old config format
    if [ -f "doc-flow-config.json" ] && grep -q '"output_mode"' "doc-flow-config.json"; then
        print_warning "Found old config format with output_mode (will be updated)"
        is_upgrade=true
    fi
    
    if [ "$is_upgrade" = true ]; then
        print_status "🔄 Upgrading from older version..."
        
        # Backup old pending file if it exists
        if [ -f ".doc-flow/pending-updates.md" ]; then
            mv ".doc-flow/pending-updates.md" ".doc-flow/pending-changes.md"
            print_success "Renamed pending-updates.md → pending-changes.md"
        fi
        
        # Remove old template files
        rm -f ".doc-flow/templates/local-instructions.md"
        rm -f ".doc-flow/templates/mcp-instructions.md"
        rm -f ".doc-flow/templates/local-architecture-prompt.md"
        rm -f ".doc-flow/templates/mcp-architecture-prompt.md"
        print_success "Removed old template files"
        
        # Clean up .gitignore entries
        if [ -f ".gitignore" ]; then
            # Remove old patterns and add new one
            sed -i.bak '/pending-updates\.md/d; /pending-changes-.*\.md/d' .gitignore 2>/dev/null || true
            rm -f .gitignore.bak
        fi
        
        print_success "Upgrade preparation complete"
    else
        print_success "Fresh installation detected"
    fi
}

# Setup directory structure
setup_directories() {
    print_status "Setting up directory structure..."
    
    # Create isolated .doc-flow directory
    mkdir -p "$DOC_FLOW_DIR/scripts"
    mkdir -p "$DOC_FLOW_DIR/templates"
    
    # Create git hooks directory
    mkdir -p .git/hooks
    
    print_success "Directory structure created"
}

# Update .gitignore to exclude doc-flow files
update_gitignore() {
    print_status "Updating .gitignore..."
    
    # Check if .gitignore exists, create if not
    touch .gitignore
    
    # Remove old Doc Flow entries if they exist
    if grep -q "# Doc Flow" .gitignore; then
        sed -i.bak '/# Doc Flow/,/^$/d' .gitignore 2>/dev/null || true
        rm -f .gitignore.bak
    fi
    
    # Add new doc-flow entries
    cat >> .gitignore << 'EOF'

# Doc Flow - Architecture Documentation Tool
.doc-flow/pending-changes.md
.doc-flow/temp/
EOF
    print_success "Updated .gitignore with new patterns"
}

# Update .claudeignore to exclude doc-flow internals
update_claudeignore() {
    print_status "Updating .claudeignore..."
    
    # Create .claudeignore if it doesn't exist
    touch .claudeignore
    
    # Add doc-flow entries if not already present
    if ! grep -q "# Doc Flow" .claudeignore; then
        cat >> .claudeignore << 'EOF'

# Doc Flow - Hide internal tool files from Claude
.doc-flow/scripts/
.doc-flow/templates/
EOF
        print_success "Updated .claudeignore"
    else
        print_warning ".claudeignore already contains Doc Flow entries"
    fi
}

# Install the git hook with clean paths
install_git_hook() {
    print_status "Installing git post-commit hook..."
    
    # Backup existing hook if it exists
    if [ -f "$HOOK_FILE" ]; then
        print_warning "Existing post-commit hook found, backing up..."
        mv "$HOOK_FILE" "$HOOK_FILE.backup"
    fi
    
    # Read config to determine settings
    KEYWORDS="add|new|create|implement|service|controller|component|module|integration|api"
    
    if [ -f "doc-flow-config.json" ]; then
        KEYWORDS=$(grep -o '"detection_keywords":\s*\[[^]]*\]' "doc-flow-config.json" 2>/dev/null | grep -o '"[^"]*"' | tr -d '"' | tr '\n' '|' | sed 's/|$//')
    fi
    
    # Create the clean post-commit hook
    cat > "$HOOK_FILE" << EOF
#!/bin/bash
# Doc Flow - Architecture Documentation Hook
# Auto-generated - reads config: .doc-flow/config.json

# Check if config and doc-sync script exist
if [ ! -f ".doc-flow/config.json" ]; then
    echo "⚠️  Doc Flow config not found: .doc-flow/config.json"
    exit 0
fi

if [ ! -f ".doc-flow/scripts/doc-sync.sh" ]; then
    echo "⚠️  Doc Flow script not found: .doc-flow/scripts/doc-sync.sh"
    exit 0
fi

# Load detection keywords from config
KEYWORDS=\$(grep -o '"detection_keywords":\s*\[[^]]*\]' ".doc-flow/config.json" 2>/dev/null | grep -o '"[^"]*"' | tr -d '"' | tr '\n' '|' | sed 's/|\$//')
if [ -z "\$KEYWORDS" ]; then
    KEYWORDS="$KEYWORDS"
fi

# Get commit info
COMMIT_MSG=\$(git log -1 --pretty=%B)

# Check if this looks like an architectural change
if echo "\$COMMIT_MSG" | grep -iE "\$KEYWORDS" > /dev/null; then
    echo ""
    echo "🏗️  Architecture change detected..."
    
    # Use doc-sync.sh to capture the change
    ./.doc-flow/scripts/doc-sync.sh --from-commit
    
    echo "💡 Next: Tell Claude to 'Process pending changes' (specify: using MCP tools OR to local documentation)"
    echo ""
else
    # Silent for non-architecture commits to avoid noise
    :
fi
EOF

    # Make hook executable
    chmod +x "$HOOK_FILE"
    
    print_success "Git hook installed"
}

# Check/update configuration 
check_config() {
    if [ ! -f "doc-flow-config.json" ]; then
        print_error "Configuration file doc-flow-config.json not found!"
        echo ""
        echo "Please create doc-flow-config.json before running install:"
        echo ""
        echo "Example configuration:"
        cat << 'EOF'
{
  "auto_capture": true,
  "detection_keywords": [
    "add", "new", "create", "implement", "feat",
    "service", "controller", "component", "module", 
    "integration", "api", "database", "auth", "fix"
  ],
  "ignore_keywords": [
    "typo", "format", "lint", "style", "comment", "docs:"
  ]
}
EOF
        echo ""
        echo "Then run: ./install.sh"
        exit 1
    else
        print_success "Configuration found: doc-flow-config.json"
        
        # Update config if it has old output_mode field
        if grep -q '"output_mode"' "doc-flow-config.json"; then
            print_status "Updating config format..."
            # Remove output_mode line and custom_template_path line
            sed -i.bak '/"output_mode"/d; /"custom_template_path"/d; /,$/{s/,$//}' "doc-flow-config.json" 2>/dev/null || true
            rm -f "doc-flow-config.json.bak"
            print_success "Updated config to new format"
        fi
    fi
}

# Ensure required files exist
check_required_files() {
    print_status "Checking required files..."
    
    # Get the directory where this script is located (doc-flow source)
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    
    if [ ! -f "$SCRIPT_DIR/scripts/doc-sync.sh" ]; then
        print_error "Required file not found: $SCRIPT_DIR/scripts/doc-sync.sh"
        exit 1
    fi
    
    # Check for unified template
    if [ ! -f "$SCRIPT_DIR/templates/unified-instructions.md" ]; then
        print_error "Required template not found: $SCRIPT_DIR/templates/unified-instructions.md"
        exit 1
    fi
    
    print_success "All required files found"
}

# Copy required files to .doc-flow directory
copy_required_files() {
    print_status "Copying required files to .doc-flow directory..."
    
    # Get the directory where this script is located (doc-flow source)
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    
    # Copy configuration
    cp "doc-flow-config.json" "$CONFIG_FILE"
    
    # Copy scripts
    cp -r "$SCRIPT_DIR/scripts"/* "$DOC_FLOW_DIR/scripts/"
    chmod +x "$DOC_FLOW_DIR/scripts"/*
    
    # Copy templates
    cp -r "$SCRIPT_DIR/templates"/* "$DOC_FLOW_DIR/templates/"
    
    print_success "Required files copied to .doc-flow/"
}

# Uninstall doc-flow completely
uninstall() {
    echo "🗑️  Doc Flow - Uninstallation"
    echo "================================="
    echo ""
    
    print_status "Removing doc-flow from your project..."
    
    # Remove .doc-flow directory
    if [ -d "$DOC_FLOW_DIR" ]; then
        rm -rf "$DOC_FLOW_DIR"
        print_success "Removed .doc-flow/ directory"
    else
        print_warning ".doc-flow/ directory not found"
    fi
    
    # Remove git hook
    if [ -f "$HOOK_FILE" ]; then
        rm -f "$HOOK_FILE"
        print_success "Removed git post-commit hook"
        
        # Restore backup if it exists
        if [ -f "$HOOK_FILE.backup" ]; then
            mv "$HOOK_FILE.backup" "$HOOK_FILE"
            print_success "Restored previous git hook from backup"
        fi
    else
        print_warning "Git hook not found"
    fi
    
    # Remove doc-flow entries from .gitignore
    if [ -f ".gitignore" ] && grep -q "# Doc Flow" .gitignore; then
        # Create temp file without doc-flow entries
        grep -v "# Doc Flow" .gitignore | grep -v "\.doc-flow/" > .gitignore.tmp
        mv .gitignore.tmp .gitignore
        print_success "Cleaned .gitignore"
    fi
    
    # Remove doc-flow entries from .claudeignore
    if [ -f ".claudeignore" ] && grep -q "# Doc Flow" .claudeignore; then
        # Create temp file without doc-flow entries
        grep -v "# Doc Flow" .claudeignore | grep -v "\.doc-flow/" > .claudeignore.tmp
        mv .claudeignore.tmp .claudeignore
        print_success "Cleaned .claudeignore"
    fi
    
    echo ""
    print_success "🎉 Doc Flow completely uninstalled!"
    echo ""
    print_status "Note: Your doc-flow-config.json is kept for future reinstalls"
    print_status "To remove it: rm doc-flow-config.json"
    echo ""
}

# Main installation
main() {
    echo "🏗️  Doc Flow - Installation"
    echo "================================="
    echo ""
    
    print_status "Installing with minimal footprint..."
    
    # Run installation steps
    check_git_repo
    detect_and_upgrade_old_version
    check_config
    check_required_files
    setup_directories
    copy_required_files
    update_gitignore
    update_claudeignore
    install_git_hook
    
    echo ""
    echo "🎉 Installation Complete!"
    echo ""
    echo "📋 What's installed:"
    echo "  ✅ Git hook: .git/hooks/post-commit"
    echo "  ✅ Configuration: $CONFIG_FILE"
    echo "  ✅ Unified template system"
    echo "  ✅ Updated: .gitignore and .claudeignore"
    echo ""
    echo "🚀 Test it:"
    echo "  git commit -m 'add new UserService component'"
    echo "  cat .doc-flow/pending-changes.md"
    echo ""
    echo "💡 Next: Tell Claude to 'Process pending changes' (specify: using MCP tools OR to local documentation)"
    echo ""
}

# Handle command line arguments
if [ "$1" = "--uninstall" ] || [ "$1" = "uninstall" ]; then
    uninstall
else
    main "$@"
fi
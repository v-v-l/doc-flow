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
PENDING_FILE="$DOC_FLOW_DIR/pending-updates.md"
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
    
    # Add doc-flow entries if not already present
    if ! grep -q "# Doc Flow" .gitignore; then
        cat >> .gitignore << 'EOF'

# Doc Flow - Architecture Documentation Tool
.doc-flow/pending-updates.md
.doc-flow/temp/
EOF
        print_success "Updated .gitignore"
    else
        print_warning ".gitignore already contains Doc Flow entries"
    fi
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
    
    # Read config to determine output mode and settings
    OUTPUT_MODE="mcp"  # default
    KEYWORDS="add|new|create|implement|service|controller|component|module|integration|api"
    
    if [ -f "doc-flow-config.json" ]; then
        OUTPUT_MODE=$(grep -o '"output_mode":[[:space:]]*"[^"]*"' "doc-flow-config.json" | cut -d'"' -f4)
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
    
    echo "💡 Next: Tell Claude to 'Process pending architecture updates'"
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

# Check configuration (don't create, require user to configure first)
check_config() {
    if [ ! -f "doc-flow-config.json" ]; then
        print_error "Configuration file doc-flow-config.json not found!"
        echo ""
        echo "Please create doc-flow-config.json before running install:"
        echo ""
        echo "Example configuration:"
        cat << 'EOF'
{
  "output_mode": "mcp",
  "auto_capture": true,
  "detection_keywords": [
    "add", "new", "create", "implement", "feat",
    "service", "controller", "component", "module", 
    "integration", "api", "database", "auth", "fix"
  ],
  "ignore_keywords": [
    "typo", "format", "lint", "style", "comment"
  ],
  "custom_template_path": null
}
EOF
        echo ""
        echo "Then run: ./install.sh"
        exit 1
    else
        print_success "Configuration found: doc-flow-config.json"
        # Copy config to .doc-flow directory
        cp "doc-flow-config.json" "$CONFIG_FILE"
    fi
}

# Ensure required files exist
check_required_files() {
    print_status "Checking required files..."
    
    if [ ! -f "scripts/doc-sync.sh" ]; then
        print_error "Required file not found: scripts/doc-sync.sh"
        exit 1
    fi
    
    # Check templates based on config  
    OUTPUT_MODE=$(grep -o '"output_mode":[[:space:]]*"[^"]*"' "doc-flow-config.json" | cut -d'"' -f4)
    TEMPLATE_FILE="templates/${OUTPUT_MODE}-instructions.md"
    
    if [ ! -f "$TEMPLATE_FILE" ]; then
        print_error "Required template not found: $TEMPLATE_FILE"
        echo "Available output modes: mcp, local"
        exit 1
    fi
    
    print_success "All required files found"
}

# Copy required files to .doc-flow directory
copy_required_files() {
    print_status "Copying required files to .doc-flow directory..."
    
    # Copy scripts
    cp -r scripts/* "$DOC_FLOW_DIR/scripts/"
    chmod +x "$DOC_FLOW_DIR/scripts"/*
    
    # Copy templates
    cp -r templates/* "$DOC_FLOW_DIR/templates/"
    
    print_success "Required files copied to .doc-flow/"
}

# Main installation
main() {
    echo "🏗️  Doc Flow - Installation"
    echo "================================="
    echo ""
    
    print_status "Installing with minimal footprint..."
    
    # Run installation steps
    check_git_repo
    check_config
    check_required_files
    setup_directories
    copy_required_files
    update_gitignore
    update_claudeignore
    install_git_hook
    
    echo ""
    # Get configured output mode for display
    OUTPUT_MODE=$(grep -o '"output_mode":[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    
    echo "🎉 Installation Complete!"
    echo ""
    echo "📋 What's installed:"
    echo "  ✅ Git hook: .git/hooks/post-commit"
    echo "  ✅ Configuration: $CONFIG_FILE"
    echo "  ✅ Output mode: $OUTPUT_MODE"
    echo "  ✅ Updated: .gitignore and .claudeignore"
    echo ""
    echo "🚀 Test it:"
    echo "  git commit -m 'add new UserService component'"
    echo "  cat .doc-flow/pending-updates.md"
    echo ""
    echo "💡 Next: Tell Claude to 'Process pending architecture updates'"
    echo ""
}

# Run main function
main "$@"
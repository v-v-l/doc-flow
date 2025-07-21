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
TOOLS_DIR=".tools/doc-flow"
CONFIG_FILE="$TOOLS_DIR/config.json"
PENDING_FILE="$TOOLS_DIR/pending-updates.md"
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

# Setup clean directory structure
setup_directories() {
    print_status "Setting up clean directory structure..."
    
    # Create .tools/doc-flow directory
    mkdir -p "$TOOLS_DIR/scripts"
    mkdir -p "$TOOLS_DIR/templates"
    
    # Create git hooks directory
    mkdir -p .git/hooks
    
    print_success "Clean directory structure created"
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
.tools/doc-flow/pending-updates.md
.tools/doc-flow/temp/
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
.tools/doc-flow/scripts/
.tools/doc-flow/templates/
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
    
    # Create the clean post-commit hook
    cat > "$HOOK_FILE" << 'EOF'
#!/bin/bash
# Doc Flow - Architecture Documentation Hook
# Auto-generated - do not edit directly

# Configuration
TOOLS_DIR=".tools/doc-flow"
CONFIG_FILE="$TOOLS_DIR/config.json"
PENDING_FILE="$TOOLS_DIR/pending-updates.md"

# Load configuration
if [ -f "$CONFIG_FILE" ]; then
    KEYWORDS=$(grep -o '"detection_keywords":\s*\[[^]]*\]' "$CONFIG_FILE" 2>/dev/null | grep -o '"[^"]*"' | tr -d '"' | tr '\n' '|' | sed 's/|$//')
else
    KEYWORDS="add|new|create|implement|service|controller|component|module|integration|api"
fi

# Get commit info
COMMIT_MSG=$(git log -1 --pretty=%B)
COMMIT_HASH=$(git log -1 --pretty=format:"%h")
BRANCH=$(git branch --show-current)
CHANGED_FILES=$(git diff --name-only HEAD~1)

# Check if this looks like an architectural change
if echo "$COMMIT_MSG" | grep -iE "$KEYWORDS" > /dev/null; then
    echo ""
    echo "🏗️  Architecture change detected..."
    
    # Create documentation update in clean location
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Create pending file if it doesn't exist
    if [ ! -f "$PENDING_FILE" ]; then
        echo "# Doc Flow - Pending Architecture Updates" > "$PENDING_FILE"
        echo "" >> "$PENDING_FILE"
        echo "This file contains automatically captured architecture changes that need processing." >> "$PENDING_FILE"
    fi
    
    cat >> "$PENDING_FILE" << EOL

---

## Auto-Captured: $TIMESTAMP
**Branch:** $BRANCH | **Commit:** $COMMIT_HASH

### Commit Message
$COMMIT_MSG

### Files Modified
\`\`\`
$CHANGED_FILES
\`\`\`

### Processing Instructions
Auto-detected architecture change. Please analyze and document:

1. **Review Changes**: Examine commit and modified files
2. **Extract Components**: Identify new/modified components, modules, integrations
3. **Document Relationships**: Map dependencies and connections
4. **Update Architecture**: Create/update documentation following project conventions

**Next Steps**: Process this update in your knowledge management system
**Configuration**: See $CONFIG_FILE for project-specific settings

EOL

    echo "✅ Architecture documentation queued"
    echo "📝 See: $PENDING_FILE"
    echo "💡 Next: Process updates in your knowledge management system"
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

# Create clean configuration
create_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        print_status "Creating configuration..."
        
        cat > "$CONFIG_FILE" << 'EOF'
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
    "architecture": "architecture/",
    "components": "architecture/components/",
    "modules": "architecture/modules/"
  },
  "auto_capture": true,
  "include_file_analysis": true
}
EOF
        print_success "Configuration created: $CONFIG_FILE"
    else
        print_warning "Configuration already exists: $CONFIG_FILE"
    fi
}

# Copy helper scripts and templates
copy_tools() {
    print_status "Installing helper tools..."
    
    # Get script directory
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    
    # Copy scripts if available
    if [ -d "$SCRIPT_DIR/scripts" ]; then
        cp -r "$SCRIPT_DIR/scripts"/* "$TOOLS_DIR/scripts/" 2>/dev/null || true
        chmod +x "$TOOLS_DIR/scripts"/* 2>/dev/null || true
    fi
    
    # Copy templates if available  
    if [ -d "$SCRIPT_DIR/templates" ]; then
        cp -r "$SCRIPT_DIR/templates"/* "$TOOLS_DIR/templates/" 2>/dev/null || true
    fi
    
    print_success "Helper tools installed"
}

# Create usage guide
create_usage_guide() {
    cat > "$TOOLS_DIR/README.md" << 'EOF'
# Doc Flow - Usage Guide

## What's Installed

- **Git Hook**: `.git/hooks/post-commit` - Automatically captures architecture changes
- **Configuration**: `.tools/doc-flow/config.json` - Customize detection and output
- **Pending Updates**: `.tools/doc-flow/pending-updates.md` - Queue of changes to process
- **Helper Scripts**: `.tools/doc-flow/scripts/` - Manual processing tools
- **Templates**: `.tools/doc-flow/templates/` - Documentation templates

## Quick Start

1. **Make a commit with architecture keywords**:
   ```bash
   git commit -m "add UserService component for authentication"
   ```

2. **Check captured documentation**:
   ```bash
   cat .tools/doc-flow/pending-updates.md
   ```

3. **Process updates in your knowledge management system**

## Configuration

Edit `.tools/doc-flow/config.json` to customize:
- Detection keywords
- Naming conventions  
- Virtual folder structure
- Knowledge system integration

## Manual Processing

Use helper scripts in `.tools/doc-flow/scripts/` for manual documentation sync.

## Clean Uninstall

To remove Doc Flow completely:
```bash
rm -rf .tools/doc-flow
rm .git/hooks/post-commit
# Remove Doc Flow entries from .gitignore and .claudeignore
```
EOF
}

# Main installation
main() {
    echo "🏗️  Doc Flow - Installation"
    echo "================================="
    echo ""
    
    print_status "Installing with minimal footprint..."
    
    # Run installation steps
    check_git_repo
    setup_directories
    update_gitignore
    update_claudeignore
    install_git_hook
    create_config
    copy_tools
    create_usage_guide
    
    echo ""
    echo "🎉 Clean Installation Complete!"
    echo ""
    echo "📋 What's installed:"
    echo "  ✅ Git hook: .git/hooks/post-commit"
    echo "  ✅ Tool files: .tools/doc-flow/"
    echo "  ✅ Updated: .gitignore and .claudeignore"
    echo ""
    echo "🎯 Minimal footprint:"
    echo "  • No files in project root"
    echo "  • All tools in .tools/doc-flow/"
    echo "  • Properly excluded from git and Claude"
    echo ""
    echo "🚀 Test it:"
    echo "  git commit -m 'add new UserService component'"
    echo "  cat .tools/doc-flow/pending-updates.md"
    echo ""
    echo "📖 Usage: .tools/doc-flow/README.md"
    echo ""
}

# Run main function
main "$@"
#!/bin/bash
# Doc Flow - Clean Release Preparation Script
# Prepares a clean version for final repository release

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

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

echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  🧹 Doc Flow - Clean Release Prep  ${BLUE}║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "install.sh" ] || [ ! -f "setup.sh" ]; then
    print_error "Please run from doc-flow directory"
    exit 1
fi

# Create clean release directory
CLEAN_DIR="../doc-flow-clean"
print_status "Creating clean release directory: $CLEAN_DIR"

if [ -d "$CLEAN_DIR" ]; then
    print_warning "Clean directory exists, removing..."
    rm -rf "$CLEAN_DIR"
fi

mkdir -p "$CLEAN_DIR"

# Copy essential files
print_status "Copying core files..."

# Core scripts
cp install.sh "$CLEAN_DIR/"
cp setup.sh "$CLEAN_DIR/"
cp existing-app-setup.sh "$CLEAN_DIR/"

# Documentation
cp README.md "$CLEAN_DIR/"
cp QUICK-START.md "$CLEAN_DIR/"
cp CONTRIBUTING.md "$CLEAN_DIR/"
mkdir -p "$CLEAN_DIR/docs"
cp docs/WORKFLOWS.md "$CLEAN_DIR/docs/"
cp docs/EXISTING-APP-INTEGRATION.md "$CLEAN_DIR/docs/"
cp docs/OPEN-SOURCE-WORKFLOW.md "$CLEAN_DIR/docs/"
if [ -f "docs/architecture-documentation-prompt.md" ]; then
    cp docs/architecture-documentation-prompt.md "$CLEAN_DIR/docs/"
fi

# GitHub Actions
mkdir -p "$CLEAN_DIR/.github/workflows"
cp .github/workflows/architecture-review.yml "$CLEAN_DIR/.github/workflows/"
cp .github/workflows/update-architecture-docs.yml "$CLEAN_DIR/.github/workflows/"

# Templates and tools structure
mkdir -p "$CLEAN_DIR/.tools/doc-flow/"{scripts,templates}

# Core templates
cp .tools/doc-flow/templates/component-simple.md "$CLEAN_DIR/.tools/doc-flow/templates/"
cp .tools/doc-flow/templates/obsidian-component.md "$CLEAN_DIR/.tools/doc-flow/templates/"
cp .tools/doc-flow/templates/notion-component.json "$CLEAN_DIR/.tools/doc-flow/templates/"
cp .tools/doc-flow/templates/custom-component.yaml "$CLEAN_DIR/.tools/doc-flow/templates/"
cp .tools/doc-flow/templates/architecture-prompt.md "$CLEAN_DIR/.tools/doc-flow/templates/"
cp .tools/doc-flow/templates/mcp-architecture-prompt.md "$CLEAN_DIR/.tools/doc-flow/templates/"

# Core scripts
cp .tools/doc-flow/scripts/doc-sync.sh "$CLEAN_DIR/.tools/doc-flow/scripts/"
cp .tools/doc-flow/scripts/mcp-client.js "$CLEAN_DIR/.tools/doc-flow/scripts/"
cp .tools/doc-flow/scripts/claude-mcp-processor.sh "$CLEAN_DIR/.tools/doc-flow/scripts/"

# License and other files
if [ -f "LICENSE" ]; then
    cp LICENSE "$CLEAN_DIR/"
fi

# Create clean .gitignore
cat > "$CLEAN_DIR/.gitignore" << 'EOF'
# Doc Flow - Clean Repository .gitignore

# Node modules (if using Node.js scripts)
node_modules/
npm-debug.log*

# Doc Flow generated files
.tools/doc-flow/pending-updates.md
.tools/doc-flow/temp/
.tools/doc-flow/processing.log

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Editor files
.vscode/
.idea/
*.swp
*.swo
*~

# Logs
*.log
logs/

# Runtime files
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/

# Test files
test/
tests/
__tests__/
spec/
*.test.*
*.spec.*
EOF

# Create clean README for release
cat > "$CLEAN_DIR/README.md" << 'EOF'
# Doc Flow 🏗️📝

**Universal Architecture Documentation - From Simple READMEs to Advanced Knowledge Systems**

Automatically capture and document your software architecture as you code. Works with **any documentation system** - from a simple README.md to advanced knowledge management platforms like Obsidian, Notion, or custom solutions.

## 🌟 Works Everywhere

- **📝 Simple Markdown** - Auto-update README.md or docs/ARCHITECTURE.md
- **🧠 Knowledge Systems** - Obsidian, Notion, Logseq, Roam Research  
- **🤖 AI Assistants** - Claude, ChatGPT, or any AI that processes text
- **📚 Documentation Platforms** - GitBook, Confluence, custom wikis
- **🔗 No External Dependencies** - Works entirely with git and text files

## 🎯 What It Does

- **Auto-captures** architectural changes from git commits
- **Generates structured documentation** in any format you need
- **Maps dependencies and relationships** between components  
- **Updates documentation automatically** - README, wiki, or knowledge base
- **Zero overhead** - just commit code normally
- **No cloud dependencies** - everything runs locally

## ⚡ Quick Start

```bash
# 1. Interactive setup (recommended)
curl -sSL https://raw.githubusercontent.com/v-v-l/doc-flow/main/setup.sh | bash

# 2. Start developing normally  
git add auth-service.js
git commit -m "add JWT authentication service"
# ✅ Architecture docs automatically captured!

# 3. Check captured documentation
cat .tools/doc-flow/pending-updates.md

# 4. Process updates in your knowledge system
# Tell your AI assistant: "Process pending architecture updates"
```

## 🏗️ How It Works

### 1. **Smart Git Hook Detection**
Analyzes commits for architecture keywords:
- `add`, `new`, `create`, `implement`
- `service`, `controller`, `component`, `module`
- `integration`, `api`, `database`

### 2. **Structured Documentation Generation**
Creates detailed instructions for your knowledge system:
- Component relationships and dependencies
- Module organization and naming conventions
- Data flow documentation
- Integration mapping

### 3. **Knowledge System Integration**
Works with any AI-powered knowledge management system:
- Obsidian with Claude/ChatGPT
- Notion AI
- Logseq
- Custom knowledge bases

## 📊 Choose Your Documentation Style

| System | Best For | Complexity | Team Size |
|--------|----------|------------|-----------|
| 📝 **Simple Markdown** | Solo devs, simple projects | ⚪⚪⚪ | 1-3 |
| 🧠 **Obsidian** | Visual thinkers, complex projects | ⚪⚪⚫ | 1-10 |
| 🗃️ **Notion** | Team collaboration | ⚪⚪⚫ | 3-50 |
| 🤖 **MCP/Claude** | AI-powered automation | ⚪⚪⚫ | Any |
| ⚙️ **Custom** | Existing toolchains | ⚪⚫⚫ | Any |

## 🚀 Setup Options

### New Project Setup
```bash
# Interactive setup with system choice
./setup.sh
```

### Existing Application Integration  
```bash
# Smart analysis and integration
./existing-app-setup.sh
```

### Manual Installation
```bash
# Clone and install
git clone https://github.com/v-v-l/doc-flow.git
cd your-project
/path/to/doc-flow/install.sh
```

## 📚 Documentation

- **🚀 Quick Start Guide**: [QUICK-START.md](QUICK-START.md)
- **📊 Complete Workflows**: [docs/WORKFLOWS.md](docs/WORKFLOWS.md)
- **🔍 Existing App Integration**: [docs/EXISTING-APP-INTEGRATION.md](docs/EXISTING-APP-INTEGRATION.md)
- **🤖 Architecture AI Prompt**: [docs/architecture-documentation-prompt.md](docs/architecture-documentation-prompt.md)

## 🎯 Features

### ✅ Automatic Capture
- **Git Hook Integration** - Runs on every commit
- **Smart Detection** - Only captures relevant changes
- **Context Aware** - Includes commit info, changed files, branch data
- **Flexible Triggers** - Configurable keywords and patterns

### ✅ Multiple Input Modes
```bash
# Automatic from git hooks
git commit -m "add PaymentService" # Auto-captured

# Manual with description
./scripts/doc-sync.sh "Added PaymentService, depends on stripe-sdk"

# Interactive mode
./scripts/doc-sync.sh --interactive

# From recent commit
./scripts/doc-sync.sh --from-commit
```

### ✅ Universal Compatibility
- **Any Documentation System** - README.md, wikis, knowledge bases
- **Structured Output** - Works with any AI assistant or manual processing
- **Configurable Templates** - Adapt to your documentation style
- **Multiple Formats** - Markdown, JSON, plain text, custom formats
- **API Ready** - Can integrate with any documentation platform

## 🧪 Quick Test

```bash
# Test the system
git commit -m "add UserService component for authentication"
cat .tools/doc-flow/pending-updates.md

# You'll see structured architecture documentation ready for processing!
```

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes** and test thoroughly
4. **Commit your changes**: `git commit -m 'Add amazing feature'`
5. **Push to the branch**: `git push origin feature/amazing-feature`  
6. **Open a Pull Request**

### Development Setup
```bash
git clone https://github.com/v-v-l/doc-flow.git
cd doc-flow
# Test on your own projects
./existing-app-setup.sh
```

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙋 Support

- **🐛 Issues**: [GitHub Issues](https://github.com/v-v-l/doc-flow/issues)
- **💬 Discussions**: [GitHub Discussions](https://github.com/v-v-l/doc-flow/discussions)
- **📖 Wiki**: [GitHub Wiki](https://github.com/v-v-l/doc-flow/wiki)

---

**Made with ❤️ for developers who love good documentation**

*Automatically bridge the gap between code and knowledge. Because great architecture deserves great documentation.*
EOF

print_success "Clean release prepared in: $CLEAN_DIR"
echo ""
print_status "📁 Clean release contents:"
echo ""
find "$CLEAN_DIR" -type f | sort | sed 's|../doc-flow-clean/||' | sed 's/^/   /'
echo ""

print_status "🎯 Next steps:"
echo "1. Review clean release in: $CLEAN_DIR"
echo "2. Create new GitHub repository: doc-flow"
echo "3. Initialize and push clean version:"
echo ""
echo "   cd $CLEAN_DIR"
echo "   git init"
echo "   git add ."
echo "   git commit -m \"Initial release of Doc Flow v1.0\""
echo "   git branch -M main"
echo "   git remote add origin https://github.com/v-v-l/doc-flow.git"
echo "   git push -u origin main"
echo ""
print_success "Ready for clean repository release! 🚀"
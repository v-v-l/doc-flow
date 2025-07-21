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
# 1. Quick install (minimal footprint)
curl -sSL https://raw.githubusercontent.com/your-repo/doc-flow/main/install.sh | bash

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

## 📋 Features

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

## 🛠️ Installation Options

### Option 1: Quick Install (Recommended)
```bash
curl -sSL https://raw.githubusercontent.com/your-repo/doc-flow/main/install.sh | bash
```

### Option 2: Manual Setup
```bash
# Clone the tool
git clone <repo-url> .doc-flow

# Run setup in your project
./.doc-flow/scripts/setup-hooks.sh

# Configure for your knowledge system
cp .doc-flow/config/vault-config.json.example vault-config.json
# Edit configuration as needed
```

## 📁 Project Structure After Install

```
your-project/
├── .git/hooks/post-commit              # Auto-installed git hook
├── .doc-flow/                          # Tool installation
│   ├── scripts/                        # Core functionality
│   ├── templates/                      # Documentation templates  
│   └── config/                         # Configuration options
│   ├── pending-updates.md              # Generated documentation queue
└── vault-config.json                   # Your customizations
```

## ⚙️ Configuration

### Basic Configuration (`vault-config.json`)
```json
{
  "knowledge_system": "obsidian",
  "output_format": "markdown",
  "detection_keywords": [
    "add", "new", "create", "implement",
    "service", "controller", "component", "module"
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
  }
}
```

### Advanced Configuration
- **Custom Keywords** - Define your own trigger words
- **Template Customization** - Adapt documentation format
- **Integration Hooks** - Connect to knowledge system APIs
- **Filtering Rules** - Control what gets documented

## 🎯 Use Cases & Examples

### 📝 **Simple Documentation** ([See Example](examples/README_SIMPLE.md))
- **README.md updates** - Auto-maintain architecture sections
- **Wiki documentation** - GitHub/GitLab wikis with commit sync
- **Markdown files** - No external tools required
- **Perfect for**: Solo developers, simple projects, quick documentation

### 🧠 **Advanced Knowledge Systems** ([See Obsidian Example](examples/OBSIDIAN_ADVANCED.md))  
- **Obsidian** - Graph view, wikilinks, advanced relationships ⭐ **Best Integration**
- **Notion** - Database-driven architecture documentation
- **Logseq** - Block-based architecture tracking
- **Perfect for**: Complex projects, team collaboration, visual architecture mapping

### 🏢 **Enterprise & Team Development**
- **Microservice dependency mapping** across distributed teams
- **API documentation automation** with integration tracking
- **Architecture decision records (ADRs)** with automatic updates
- **System integration tracking** across multiple services

### 📚 **Open Source & Community**
- **Contributor onboarding** - Auto-generated architecture guides
- **Evolution tracking** - Document how architecture changes over time
- **Integration examples** - Show how components work together
- **Community documentation** - Keep public docs synchronized

## 🔧 Advanced Usage

### Custom Templates
Create your own documentation templates in `templates/`:
```markdown
# templates/custom-component.md
# {{component_name}}

## Purpose
{{component_purpose}}

## Dependencies  
{{dependencies}}

## Integration Points
{{integrations}}
```

### API Integration
```bash
# Direct API calls to your knowledge system
./scripts/doc-sync.sh --api-mode "Added UserService"
# Posts directly to your knowledge base API
```

### Team Workflows
```bash
# Team-specific configuration
./scripts/setup-hooks.sh --team-config team-settings.json

# Shared documentation standards
./scripts/doc-sync.sh --template enterprise
```

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup
```bash
git clone <repo-url>
cd doc-flow
./scripts/dev-setup.sh
```

### Adding Knowledge System Support
1. Create template in `templates/systems/your-system/`
2. Add configuration in `config/systems/`
3. Test with example project
4. Submit PR with documentation

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙋 Support

- **Issues**: [GitHub Issues](https://github.com/your-repo/doc-flow/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-repo/doc-flow/discussions)
- **Documentation**: [Wiki](https://github.com/your-repo/doc-flow/wiki)

---

**Made with ❤️ for developers who love good documentation**

*Automatically bridge the gap between code and knowledge. Because great architecture deserves great documentation.*
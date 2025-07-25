# Doc Flow 🏗️📝

**Simple Architecture Documentation - Two Modes, Zero Complexity**

Automatically capture your software architecture changes and transform them into documentation. Choose between **MCP-powered knowledge systems** or **simple local markdown files**.

## 🎯 What It Does

- **Auto-captures** architectural changes from git commits
- **Three output modes**: MCP integration, local docs, or both for comparison  
- **Zero complexity** - just commit code normally
- **Transparent workflow** - config → install → documentation

## ⚡ Quick Start

### Step 1: Get Doc Flow
```bash
# In your project directory
git clone https://github.com/v-v-l/doc-flow.git .doc-flow-setup
cd .doc-flow-setup
```

### Step 2: Configure Your Mode
```bash
# In your project root (where you want doc-flow installed)
cd ..
cat > doc-flow-config.json << 'EOF'
{
  "output_mode": "local",
  "auto_capture": true,
  "detection_keywords": ["add", "new", "create", "implement", "feat", "service", "controller", "component", "module", "integration", "api", "database", "auth", "fix"],
  "ignore_keywords": ["typo", "format", "lint", "style", "comment"]
}
EOF
```

### Step 3: Install Doc Flow
```bash
# Run installer from doc-flow directory
./.doc-flow-setup/install.sh

# Clean up temporary files
rm -rf .doc-flow-setup
```

**What the installer does:**
1. ✅ Creates `.doc-flow/` directory in your project
2. ✅ Copies scripts and templates to `.doc-flow/`
3. ✅ Copies your config to `.doc-flow/config.json`
4. ✅ Installs git hook at `.git/hooks/post-commit`
5. ✅ Updates `.gitignore` and `.claudeignore`

### Step 4: Start Using
```bash
# Develop normally - doc-flow captures architecture changes automatically
git add auth-service.js
git commit -m "add JWT authentication service"
# ✅ Architecture docs automatically captured!

# Check captured updates
cat .doc-flow/pending-updates.md

# Process updates with Claude
# Tell Claude: "please proceed the file" to process pending-updates.md
```

## 🔧 Three Simple Modes

### **Local Mode** (`"output_mode": "local"`) - *Default*
Perfect for simple documentation workflows:
- Updates `docs/ARCHITECTURE.md`
- Maintains README.md sections
- Creates markdown dependency tables
- Works with any text editor

### **MCP Mode** (`"output_mode": "mcp"`)
Perfect for knowledge systems with MCP integration (Obsidian, Notion, etc.):
- Creates structured notes with wikilinks  
- Maps component relationships
- Uses virtual folders and tags
- Builds knowledge graphs

### **Both Mode** (`"output_mode": "both"`)
Perfect for comparing workflows and efficiency:
- Creates two files: `pending-updates.md-local` and `pending-updates.md-mcp`
- Same commit details, different documentation approaches
- Lets you test which mode works better for your project
- Ideal for evaluation and team decision-making

## 🏗️ How It Works

### 1. **Configuration First**
```json
{
  "output_mode": "local",       // "local", "mcp", or "both"
  "auto_capture": true,
  "detection_keywords": [...],  // what triggers capture
  "ignore_keywords": [...]      // what to skip
}
```

### 2. **Transparent Installation**
- `install.sh` reads your config
- Sets up git hooks accordingly
- Changes require re-running install (transparent!)

### 3. **Smart Git Hook Detection**
Analyzes commits for architecture keywords:
- `add`, `new`, `create`, `implement`
- `service`, `controller`, `component`, `module`
- `integration`, `api`, `database`

### 4. **Mode-Specific Output**
Creates documentation files based on your mode:
- **Local Mode**: `pending-updates.md` with file-based documentation instructions
- **MCP Mode**: `pending-updates.md` with MCP function calls and wikilink instructions  
- **Both Mode**: `pending-updates.md-local` AND `pending-updates.md-mcp` for comparison

## 📁 Clean Project Structure

**Doc Flow Repository:**
```
doc-flow/
├── README.md                      # This documentation
├── LICENSE                        # MIT license
├── doc-flow-config.json           # Example configuration
├── install.sh                     # Installation script
├── scripts/
│   └── doc-sync.sh               # Core capture script
└── templates/
    ├── local-architecture-prompt.md  # Local documentation system prompt
    ├── mcp-architecture-prompt.md    # MCP documentation system prompt
    ├── local-instructions.md         # Local processing workflow
    └── mcp-instructions.md           # MCP processing workflow
```

**After Installation in Your Project:**
```
your-project/
├── doc-flow-config.json           # Your configuration (root level)
├── .doc-flow/                     # Hidden, isolated folder
│   ├── config.json               # Copied from your config
│   ├── pending-updates.md        # Generated documentation queue
│   ├── scripts/
│   │   └── doc-sync.sh          # Core capture script
│   └── templates/
│       ├── local-architecture-prompt.md  # Local documentation system prompt
│       ├── mcp-architecture-prompt.md    # MCP documentation system prompt
│       ├── local-instructions.md         # Local processing workflow
│       └── mcp-instructions.md           # MCP processing workflow
└── .git/hooks/post-commit        # Auto-installed git hook
```

## 📋 Features

### ✅ Automatic Capture
- **Git Hook Integration** - Runs on every commit
- **Smart Detection** - Only captures relevant changes
- **Context Aware** - Includes commit info, changed files

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

### ✅ Transparent Configuration
- Config changes require re-install (no mysterious behavior)
- External templates can be customized
- Simple two-mode design

## 🎯 Examples

### MCP Mode Output
```markdown
### Claude Processing Instructions
1. `search("PaymentService")` to check existing docs
2. `create_note` with tags: ["component", "service"]
3. `add_wikilink` for bidirectional connections
4. Place in virtual folder: `architecture/components/`
```

### Local Mode Output  
```markdown
### Claude Processing Instructions
1. Read existing `/docs/ARCHITECTURE.md`
2. Add PaymentService under "## Components" section
3. Update dependency table
4. Create component documentation in `/docs/components/`
```

## ⚙️ Configuration Options

### Basic Config (`doc-flow-config.json`)
```json
{
  "output_mode": "local",             // "local", "mcp", or "both"
  "auto_capture": true,
  "detection_keywords": [
    "add", "new", "create", "implement", "feat",
    "service", "controller", "component", "module", 
    "integration", "api", "database", "auth", "fix"
  ],
  "ignore_keywords": [
    "typo", "format", "lint", "style", "comment"
  ],
  "custom_template_path": null        // optional override
}
```

### Custom Templates
Override default architecture prompt by setting `custom_template_path`:
```json
{
  "output_mode": "local",
  "custom_template_path": "my-templates/custom-local-prompt.md"
}
```

**Note**: The `custom_template_path` overrides the architecture prompt only, not the workflow instructions.

## 🔄 Workflow

1. **Configure** → Create `doc-flow-config.json`
2. **Install** → Run `./install.sh` (reads config, sets up hooks)
3. **Code** → Commit normally with architecture keywords
4. **Process** → Tell Claude to "please proceed the file" for pending-updates.md
5. **Update Config** → Re-run `./install.sh` for changes

## 🎯 When to Use Which Mode

### Use **Local Mode** when:
- Simple markdown documentation
- No external knowledge systems  
- Team uses basic docs folder structure
- Want self-contained documentation
- Starting with doc-flow (recommended default)

### Use **MCP Mode** when:
- You have Claude with MCP integration
- Using Obsidian, Notion, or knowledge systems
- Want structured relationships and wikilinks
- Building complex architecture documentation

### Use **Both Mode** when:
- Evaluating which approach works better
- Want to compare workflow efficiency
- Team is deciding between documentation approaches
- Testing doc-flow capabilities before committing to one mode

## 🗑️ Uninstalling

To completely remove doc-flow from your project:

```bash
# Get the installer
git clone https://github.com/v-v-l/doc-flow.git .doc-flow-temp
cd .doc-flow-temp

# Run uninstaller
./install.sh --uninstall

# Clean up
cd ..
rm -rf .doc-flow-temp
```

**What gets removed:**
- ✅ `.doc-flow/` directory and all contents
- ✅ Git post-commit hook (restores backup if exists)
- ✅ Doc Flow entries from `.gitignore` and `.claudeignore`
- ✅ Clean uninstall with no traces left

**Note:** Your `doc-flow-config.json` is kept for easy reinstallation.

## 🤝 Contributing

We welcome contributions! The system is designed to be simple and extensible.

### Adding New Templates
1. Create template in `templates/yourmode-instructions.md`
2. Update config validation
3. Test with example project

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

**Simple, Transparent, Effective Architecture Documentation**

*Three modes. Zero complexity. Maximum value.*
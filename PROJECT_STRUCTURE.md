# Doc Flow - Project Structure

## 📁 Repository Structure

```
doc-flow/
├── README.md                           # Main project documentation
├── install.sh                         # Universal installer script
├── LICENSE                            # MIT license
├── PROJECT_STRUCTURE.md               # This file
├── 
├── scripts/                           # Core functionality scripts
│   ├── doc-sync.sh                   # Manual/interactive documentation sync
│   └── setup-hooks.sh                # Git hook setup (standalone)
│
├── templates/                         # Documentation templates
│   ├── architecture-prompt.md        # AI assistant system prompt
│   ├── obsidian-component.md         # Obsidian component template
│   ├── notion-component.md           # Notion component template (planned)
│   └── custom-template.md            # Generic template (planned)
│
├── config/                           # Configuration files
│   ├── vault-config.json.example    # Example configuration
│   ├── obsidian-config.json         # Obsidian-specific settings (planned)
│   └── notion-config.json           # Notion-specific settings (planned)
│
├── examples/                         # Usage examples and guides
│   ├── GETTING_STARTED.md           # Step-by-step setup guide
│   ├── sample-project/              # Example project setup (planned)
│   └── use-cases/                   # Real-world usage examples (planned)
│
└── docs/                            # Additional documentation
    ├── CONFIGURATION.md             # Detailed configuration guide (planned)
    ├── TEMPLATES.md                 # Template customization guide (planned)
    └── INTEGRATIONS.md              # Knowledge system integrations (planned)
```

## 🎯 After Clean Installation in User Project

When installed in a user's project with minimal footprint:

```
user-project/
├── .git/
│   └── hooks/
│       └── post-commit              # Auto-installed git hook
├── .tools/
│   └── doc-flow/                    # Clean tool installation
│       ├── config.json              # User's configuration
│       ├── pending-updates.md       # Generated documentation queue
│       ├── scripts/                 # Helper tools
│       ├── templates/               # Documentation templates
│       └── README.md                # Usage guide
├── .gitignore                       # Auto-updated (excludes temp files)
├── .claudeignore                    # Auto-updated (hides internals)
│
└── [user's project files...]        # Zero clutter in project root
```

## 🔧 Core Components

### 1. **installer (install.sh)**
- Universal installation script
- Works in any git repository
- Configurable for different knowledge systems
- Creates git hooks automatically
- Sets up default configuration

### 2. **Git Hook (.git/hooks/post-commit)**
- Automatically runs after each commit
- Analyzes commit messages for architecture keywords
- Extracts component information from file changes
- Generates structured documentation instructions
- Respects user configuration settings

### 3. **Manual Tools (scripts/doc-sync.sh)**
- Interactive documentation sync
- Multiple input modes (manual, from-commit, interactive)
- Git context analysis
- Fallback when automatic capture isn't sufficient

### 4. **Configuration System (.tools/doc-flow/config.json)**
- Customizable detection keywords
- Knowledge system specific settings
- Naming convention definitions
- Virtual folder organization
- Template selection

### 5. **Template System (.tools/doc-flow/templates/)**
- Knowledge system specific templates
- Customizable documentation formats
- AI assistant system prompts
- Component/module/system templates

## 🚀 Design Principles

### Universal Compatibility
- **Knowledge System Agnostic**: Works with Obsidian, Notion, custom systems
- **Language Agnostic**: Detects patterns regardless of programming language
- **Framework Agnostic**: Adapts to any project structure

### Zero Configuration Start
- **Sensible Defaults**: Works out of the box with minimal setup
- **Progressive Enhancement**: Advanced features available when needed
- **Backward Compatible**: Existing projects integrate seamlessly

### Developer Experience First
- **Zero Overhead**: Normal git workflow unchanged
- **Non-Intrusive**: Doesn't interfere with existing tools
- **Flexible**: Multiple ways to capture and process documentation

### Extensibility
- **Plugin Architecture**: Templates and configurations are modular
- **API Ready**: Can integrate with knowledge system APIs
- **Team Scalable**: Configuration shareable across teams

## 🎯 Target Use Cases

### 1. **Individual Developers**
- Personal project documentation
- Learning and reference materials
- Code exploration and understanding

### 2. **Small Teams**
- Shared architecture understanding
- Onboarding new team members
- Technical decision tracking

### 3. **Enterprise Development**
- Microservice dependency mapping
- System integration documentation
- Compliance and audit trails

### 4. **Open Source Projects**
- Contributor guidance
- Architecture evolution tracking
- Community documentation

## 🔄 Workflow Integration

### Development Workflow
```
Code Changes → Git Commit → Auto Documentation Capture → Knowledge System Processing
```

### Documentation Workflow  
```
Capture → Review → Process → Organize → Maintain
```

### Team Workflow
```
Individual Capture → Team Review → Shared Knowledge Base → Collective Understanding
```

This structure supports both immediate individual productivity and long-term team knowledge management.
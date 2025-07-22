# 🚀 Doc Flow - Quick Start Guide

## ⚡ 30-Second Setup

1. **Clone & Run Interactive Setup**:
   ```bash
   git clone https://github.com/v-v-l/doc-flow.git
   cd your-project
   /path/to/doc-flow/setup.sh
   ```

2. **Choose Your Documentation System** from the visual menu:
   - 📝 **Simple Markdown** → README.md + docs/
   - 🧠 **Obsidian Vault** → Graph-based knowledge  
   - 🗃️ **Notion Database** → Team collaboration
   - ⚙️ **Custom System** → Your tools
   - 🤖 **MCP Integration** → Claude Code AI

3. **Test It**:
   ```bash
   git commit -m "add UserService component for auth"
   cat .tools/doc-flow/pending-updates.md
   ```

**Done!** Architecture changes now auto-captured and processed.

---

## 🎯 How It Works

```
┌─────────────────────────────────────────────────────────┐
│                     Your Workflow                      │
├─────────────────────────────────────────────────────────┤
│  Code → Git Commit → Auto-Detect → Document → Update   │
│         ↓            ↓           ↓          ↓           │  
│  Normal   Keywords   Captured   Processed  Knowledge   │
│  dev       found     pending    via AI     system      │
└─────────────────────────────────────────────────────────┘
```

### What Gets Detected
- **Keywords**: `add`, `new`, `create`, `implement` 
- **Components**: `service`, `controller`, `component`, `module`
- **Context**: Files changed, dependencies, relationships

### What Gets Documented  
- 🏗️ Component architecture and responsibilities
- 🔗 Dependencies and relationships
- 📡 Integration points and APIs
- 🎯 Design decisions and rationale

---

## 📊 Choose Your Documentation Style

### 📝 Simple Markdown - Perfect for Startups
```
README.md                    ← Auto-updated architecture
docs/architecture/
├── overview.md             ← System documentation  
├── components/             ← Component docs
│   ├── UserService.md
│   └── PaymentService.md
└── integrations/           ← External systems
```

**Workflow**: Commit → Review pending → Update docs/ → README updated

---

### 🧠 Obsidian - Best for Complex Projects
```
Your-Obsidian-Vault/
├── Architecture/
│   ├── 🏗️ System Overview.md    
│   ├── Components/
│   │   ├── [[UserService]]      ← Wikilinked components
│   │   └── [[PaymentService]]
│   └── Graph View              ← Visual relationships
```

**Workflow**: Commit → Process with AI → Wikilinks created → Graph updated

---

### 🗃️ Notion - Great for Teams
```
Architecture Database
┌─────────────────────────────────────┐
│ Name          │ Type    │ Owner     │
├─────────────────────────────────────┤
│ UserService   │ Service │ @alice    │
│ PaymentAPI    │ API     │ @bob      │
│ Database      │ System  │ @charlie  │
└─────────────────────────────────────┘
```

**Workflow**: Commit → Auto-sync to database → Team visibility

---

### 🤖 MCP Integration - AI-Powered
```
Claude Code Knowledge System
├── Graph-based architecture
├── Real-time AI documentation  
├── Automatic relationship mapping
└── Virtual folder organization
```

**Workflow**: Commit → Tell Claude "Process pending updates" → Done!

---

## 🎨 Visual Workflow Comparison

| System | Complexity | Team Size | Automation | Visual |
|--------|------------|-----------|------------|--------|
| Markdown | ⚪⚪⚪ | 1-3 | Manual | Basic |
| Obsidian | ⚪⚪⚫ | 1-10 | Semi-auto | ⭐⭐⭐ |
| Notion | ⚪⚪⚫ | 3-50 | Auto | ⭐⭐ |
| Custom | ⚪⚫⚫ | Any | Full | Custom |
| MCP | ⚪⚪⚫ | Any | AI-auto | ⭐⭐⭐ |

---

## 🧪 Quick Test Examples

### Test 1: Add a New Service
```bash
git commit -m "implement NotificationService for real-time alerts"
# ✅ Auto-detected: "implement" + "NotificationService"
# 📝 Captured dependencies, integration points, responsibilities
```

### Test 2: Add Integration  
```bash
git commit -m "add Stripe payment integration to checkout"
# ✅ Auto-detected: "add" + "integration" 
# 📝 Captured external system connection, API endpoints
```

### Test 3: Create Module
```bash  
git commit -m "create user-management module with auth"
# ✅ Auto-detected: "create" + "module"
# 📝 Captured module structure, authentication components
```

---

## 📚 Full Documentation

- **📖 Complete Workflows**: [`docs/WORKFLOWS.md`](docs/WORKFLOWS.md)
- **🔧 Configuration**: [`.tools/doc-flow/config.json`](.tools/doc-flow/config.json)  
- **📝 Templates**: [`.tools/doc-flow/templates/`](.tools/doc-flow/templates/)
- **🎯 Architecture Prompt**: [`docs/architecture-documentation-prompt.md`](docs/architecture-documentation-prompt.md)

---

## 🎉 What's Next?

1. **Run Setup**: `./setup.sh` and choose your system
2. **Make Commits**: Use architecture keywords in commit messages
3. **Process Updates**: Follow your chosen workflow
4. **Iterate**: Refine configuration based on your needs

**Happy documenting!** 🚀

---

*Made with ❤️ for developers who love good documentation*
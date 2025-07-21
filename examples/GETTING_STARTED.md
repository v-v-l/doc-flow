# Getting Started with Doc Flow

This guide walks you through setting up architecture documentation for a new project.

## 📋 Prerequisites

- Git repository (run `git init` if needed)
- A knowledge management system (Obsidian, Notion, etc.)
- An AI assistant that can process structured instructions (Claude, ChatGPT, etc.)

## 🚀 Quick Setup

### 1. Install Doc Flow

```bash
# Option A: Quick install (recommended)
curl -sSL https://raw.githubusercontent.com/doc-flow/main/install.sh | bash

# Option B: Manual install  
git clone <repo-url> doc-flow-installer
./doc-flow-installer/install.sh
```

### 2. Configure for Your Knowledge System

Edit `.tools/doc-flow/config.json`:

```json
{
  "knowledge_system": "obsidian",  // or "notion", "custom"
  "detection_keywords": [
    "add", "new", "create", "implement", "feat",
    "service", "controller", "component", "module"
  ],
  "virtual_folders": {
    "architecture": "architecture/",
    "components": "architecture/components/"
  }
}
```

### 3. Test the Setup

```bash
# Create a test file
echo "class UserService {}" > user-service.js

# Commit with architecture keywords
git add user-service.js
git commit -m "add UserService component for user management"

# Check generated documentation
cat .tools/doc-flow/pending-updates.md
```

You should see something like:
```markdown
## Auto-Captured: 2024-01-15 10:30:00
**Branch:** main | **Commit:** abc123

### Architecture Description
add UserService component for user management - components: UserService

### Processing Instructions
Auto-detected architecture change. Please analyze and document...
```

## 🎯 Real Project Example

Let's document a typical web application:

### Commit 1: Add Authentication
```bash
git add auth-service.js auth-controller.js
git commit -m "implement JWT authentication service with login/logout endpoints"
```

**Generated Documentation:**
- Detects "implement" keyword
- Identifies AuthService and AuthController components
- Captures file relationships
- Creates structured instructions for your AI assistant

### Commit 2: Add Database Integration
```bash
git add user-repository.js database-config.js
git commit -m "create UserRepository with PostgreSQL integration"
```

**Generated Documentation:**
- Detects "create" keyword
- Maps database integration
- Documents data layer components
- Links to authentication system

### Commit 3: Connect Frontend
```bash
git add user-dashboard.vue api-client.js
git commit -m "add user dashboard component with API integration"
```

**Generated Documentation:**
- Documents frontend-backend connection
- Maps API integration points
- Shows data flow from UI to database

## 📝 Processing Documentation

### With Claude/ChatGPT

```
You: "Process pending architecture updates using the architecture documentation workflow"

AI Assistant: 
- Reads .tools/doc-flow/pending-updates.md
- Follows structured instructions
- Creates/updates notes in your knowledge system
- Maps relationships between components
- Updates architecture overview
```

### Manual Processing

1. **Review Updates**: Read `.tools/doc-flow/pending-updates.md`
2. **Create Notes**: Manually create architecture documentation
3. **Map Relationships**: Link components and modules
4. **Update Overview**: Keep system-level docs current

## ⚙️ Advanced Configuration

### Custom Keywords
```json
{
  "detection_keywords": [
    "add", "new", "create", "implement", "feat",
    "refactor", "migrate", "integrate", "deploy"
  ],
  "ignore_keywords": [
    "fix typo", "update comment", "format code"
  ]
}
```

### File Pattern Analysis
```json
{
  "analysis_patterns": {
    "components": ["Service", "Controller", "Component", "Manager"],
    "configs": ["config", "settings", "env"],
    "infrastructure": ["docker", "k8s", "terraform"]
  }
}
```

### Knowledge System Integration
```json
{
  "knowledge_system_config": {
    "obsidian": {
      "vault_path": "/path/to/vault",
      "use_wikilinks": true,
      "avoid_hash_in_titles": true
    }
  }
}
```

## 🔧 Troubleshooting

### Git Hook Not Running
```bash
# Check hook exists and is executable
ls -la .git/hooks/post-commit
chmod +x .git/hooks/post-commit
```

### No Documentation Generated
```bash
# Check configuration
cat .tools/doc-flow/config.json

# Test with explicit keywords
git commit -m "add new UserService component"
```

### Documentation Not Processed
- Ensure your AI assistant has access to project files
- Check that `.tools/doc-flow/pending-updates.md` exists
- Verify architecture prompt is accessible

## 🎓 Best Practices

### 1. **Descriptive Commit Messages**
```bash
# Good
git commit -m "add PaymentService with Stripe integration"

# Better  
git commit -m "implement PaymentService component - depends on stripe-sdk, used by CheckoutController"
```

### 2. **Regular Processing**
- Process documentation updates weekly
- Review and organize captured information
- Keep architecture overview current

### 3. **Team Coordination**
- Share `.tools/doc-flow/config.json` settings
- Establish documentation conventions
- Regular architecture review sessions

## 🚀 Next Steps

1. **Customize Templates** - Adapt documentation format to your needs
2. **Integrate with CI/CD** - Automatically process documentation in pipelines  
3. **Team Rollout** - Share configuration across development team
4. **Knowledge System Optimization** - Fine-tune for your specific tools

---

**Need Help?**
- 📖 [Full Documentation](../README.md)
- 🐛 [Report Issues](https://github.com/doc-flow/issues)
- 💬 [Community Discussions](https://github.com/doc-flow/discussions)
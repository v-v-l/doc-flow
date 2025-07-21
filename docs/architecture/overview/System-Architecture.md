# Doc Flow - System Architecture Overview

**Last Updated:** 2025-07-21  
**Status:** Active Development

## Purpose

Doc Flow is an automated architecture documentation system that captures architectural changes from git commits and generates structured documentation. It bridges the gap between code changes and architectural understanding.

## Core System Components

### Documentation Processing Layer
- **ArchitectureProcessor** - Core engine for processing captured architecture updates
  - Processes pending architecture changes
  - Generates structured documentation
  - Integrates with version control

### Capture & Integration Layer
- **Git Hooks** - Automated capture of architectural changes
- **Doc Sync Scripts** - Manual and batch processing capabilities
- **Configuration System** - Flexible configuration for different workflows

## System Data Flow

```
Developer Commits → Git Hook Triggers → Architecture Changes Captured → 
Pending Updates Queue → ArchitectureProcessor → Documentation Generated →
Architecture Knowledge Updated
```

## Key Design Decisions

### 1. Minimal Footprint Approach
- All tool files contained in `.tools/doc-flow/`
- Zero clutter in project root
- Automatic `.gitignore` and `.claudeignore` management

### 2. Flexible Processing
- Automatic processing via git hooks
- Manual processing via Claude Code or other AI assistants
- Batch processing capabilities

### 3. Universal Compatibility
- Works with any documentation system
- Markdown-based output for maximum portability
- Configurable templates and formats

## External Dependencies

- **Git** - Version control integration
- **Node.js** - For advanced scripting (optional)
- **AI Assistants** - For processing captured updates (Claude Code, ChatGPT, etc.)

## Architecture Evolution

### Phase 1: Core Capture (Complete)
- ✅ Git hook integration
- ✅ Architecture change detection
- ✅ Structured update queuing

### Phase 2: Processing Engine (In Progress)
- ✅ ArchitectureProcessor component
- 🔄 Documentation template system
- 🔄 Relationship mapping

### Phase 3: Advanced Features (Planned)
- 📋 Visual architecture diagrams
- 📋 Dependency analysis
- 📋 Architecture health metrics

## Integration Points

Doc Flow integrates seamlessly with:
- **Development Workflow** - Automatic capture on commits
- **AI Assistants** - Processing via Claude Code, ChatGPT
- **Documentation Systems** - Output to any markdown-compatible system
- **Version Control** - Full git integration and history tracking

---
**Generated:** 2025-07-21T22:22:30.000Z  
**Source:** Claude Code architecture analysis
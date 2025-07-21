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

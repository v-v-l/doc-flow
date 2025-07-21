#!/bin/bash
# Enhanced Architecture Documentation Sync Script
# Can work standalone OR with git hooks

# Function to analyze git changes and suggest architecture description
analyze_git_changes() {
    local RECENT_COMMIT_MSG=$(git log -1 --pretty=%B 2>/dev/null || echo "No git history")
    local CHANGED_FILES=$(git diff --name-only HEAD~1 2>/dev/null || git diff --cached --name-only 2>/dev/null || echo "No changes detected")
    
    # Extract potential components from filenames
    local COMPONENTS=$(echo "$CHANGED_FILES" | grep -E "(Service|Controller|Component|Repository|Handler|Manager|Provider)" | sed 's/.*\///' | sed 's/\.[^.]*$//' | head -5)
    
    echo "🔍 Git Analysis:"
    echo "  Recent commit: $(echo "$RECENT_COMMIT_MSG" | head -1)"
    echo "  Changed files: $(echo "$CHANGED_FILES" | wc -l) files"
    if [ ! -z "$COMPONENTS" ]; then
        echo "  Detected components: $(echo $COMPONENTS | tr '\n' ', ' | sed 's/, $//')"
    fi
    echo ""
}

# Main script logic
if [ $# -eq 0 ]; then
    echo "🏗️  Enhanced Architecture Documentation Sync"
    echo ""
    
    # Show git analysis
    analyze_git_changes
    
    echo "Usage options:"
    echo "  1. Manual description:"
    echo "     ./enhanced-doc-sync.sh 'Added PaymentService, depends on stripe-sdk'"
    echo ""
    echo "  2. Use recent commit message:"
    echo "     ./enhanced-doc-sync.sh --from-commit"
    echo ""
    echo "  3. Interactive mode:"
    echo "     ./enhanced-doc-sync.sh --interactive"
    exit 1
fi

# Handle different input modes
if [ "$1" = "--from-commit" ]; then
    COMMIT_MSG=$(git log -1 --pretty=%B 2>/dev/null || echo "No commit found")
    DESCRIPTION="From commit: $(echo "$COMMIT_MSG" | head -1)"
    echo "📝 Using recent commit message as description"
    
elif [ "$1" = "--interactive" ]; then
    analyze_git_changes
    echo "💬 Enter architecture description (or press Enter to use commit message):"
    read -r USER_INPUT
    
    if [ -z "$USER_INPUT" ]; then
        COMMIT_MSG=$(git log -1 --pretty=%B 2>/dev/null || echo "No commit found")
        DESCRIPTION="From commit: $(echo "$COMMIT_MSG" | head -1)"
    else
        DESCRIPTION="$USER_INPUT"
    fi
    
else
    DESCRIPTION="$1"
fi

# Rest of the script (same as original doc-sync)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
COMMIT_HASH=$(git log -1 --pretty=format:"%h" 2>/dev/null || echo "no-git")
BRANCH=$(git branch --show-current 2>/dev/null || echo "no-branch")
CHANGED_FILES=$(git diff --name-only HEAD~1 2>/dev/null || git diff --cached --name-only 2>/dev/null || echo "No changes")

# Create or append to pending updates file
cat >> pending-architecture-updates.md << EOF

---

## Update: $TIMESTAMP
**Branch:** $BRANCH | **Commit:** $COMMIT_HASH

### Changes Description
$DESCRIPTION

### Files Modified
\`\`\`
$CHANGED_FILES
\`\`\`

### Claude Processing Instructions
Please process this architectural update using the architecture documentation workflow:

1. **Discovery Phase:**
   - \`search("component-name")\` to check existing docs
   - \`list_notes\` with \`virtual_folder: "architecture/overview"\`
   - \`graph_search("related-concepts")\` for connections

2. **Documentation Actions Needed:**
   - Parse description for: components, dependencies, relationships
   - Create/update notes following architecture naming conventions:
     * Components: PascalCase (PaymentService)
     * Modules: kebab-case (payment-processing)  
     * Systems: Title Case (Payment Gateway)
   - Use appropriate tags: \`["component", "service"]\` or \`["module", "core"]\`
   - Place in correct virtual folder: \`architecture/components/\` or \`architecture/modules/\`

3. **Relationship Mapping:**
   - Document dependencies: what this component needs
   - Document dependents: what uses this component
   - Use \`add_wikilink\` for bidirectional connections
   - Update data flow documentation if applicable

4. **Validation:**
   - \`validate_note_links\` to ensure all connections work
   - \`suggest_connections\` for additional relationships
   - \`get_knowledge_base_health\` for overall integrity

**Architecture Prompt Reference:** @docs/architecture-documentation-prompt.md

EOF

echo "✅ Architecture update queued successfully!"
echo "📝 Added to: pending-architecture-updates.md"
echo ""
echo "Summary:"
echo "  - Description: $DESCRIPTION"
echo "  - Files: $(echo "$CHANGED_FILES" | wc -l) files changed"
echo "  - Commit: $COMMIT_HASH on $BRANCH"
echo ""
echo "Next: Tell Claude to 'Process pending architecture updates'"
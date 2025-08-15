#!/bin/bash
# Doc Flow - Architecture Documentation Sync Script
# Reads doc-flow-config.json for output mode and templates

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

# Simple configuration check
CONFIG_FILE=".doc-flow/config.json"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Configuration file $CONFIG_FILE not found!"
    echo "Please run from the project root directory where doc-flow is installed."
    exit 1
fi

# Rest of the script
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
COMMIT_HASH=$(git log -1 --pretty=format:"%h" 2>/dev/null || echo "no-git")
BRANCH=$(git branch --show-current 2>/dev/null || echo "no-branch")
CHANGED_FILES=$(git diff --name-only HEAD~1 2>/dev/null || git diff --cached --name-only 2>/dev/null || echo "No changes")

# Function to ensure file has header with instructions
ensure_pending_file_header() {
    local pending_file="$1"
    local template_file="$2"
    
    if [ ! -f "$pending_file" ] || ! grep -q "## Pending Changes" "$pending_file"; then
        cat << EOF > "$pending_file"
# Pending Architecture Changes

$(cat "$template_file")

---

## Pending Changes

EOF
    fi
}

# Function to generate commit entry (without instructions)
generate_commit_entry() {
    local commit_msg=$(git log -1 --pretty=%B 2>/dev/null | head -1)
    cat << EOF

### $TIMESTAMP - $COMMIT_HASH ($BRANCH)
**Description:** $DESCRIPTION
**Files:** $(echo "$CHANGED_FILES" | wc -l) files - $(echo "$CHANGED_FILES" | head -3 | tr '\n' ', ' | sed 's/, $//')$([ $(echo "$CHANGED_FILES" | wc -l) -gt 3 ] && echo "...")

EOF
}

# Simple single file approach
UNIFIED_TEMPLATE="templates/unified-instructions.md"
PENDING_FILE=".doc-flow/pending-changes.md"

if [ ! -f "$UNIFIED_TEMPLATE" ]; then
    echo "❌ Unified template file $UNIFIED_TEMPLATE not found!"
    exit 1
fi

# Ensure file has header with unified instructions
ensure_pending_file_header "$PENDING_FILE" "$UNIFIED_TEMPLATE"

# Append only commit entry
generate_commit_entry >> "$PENDING_FILE"

echo "✅ Architecture update queued successfully!"
echo "📝 Added to: $PENDING_FILE"

echo ""
echo "Summary:"
echo "  - Description: $DESCRIPTION"
echo "  - Files: $(echo "$CHANGED_FILES" | wc -l) files changed"
echo "  - Commit: $COMMIT_HASH on $BRANCH"
echo ""
echo "Next: Tell Claude to 'Process pending changes' (specify: using MCP tools OR to local documentation)"
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

# Read configuration
CONFIG_FILE="doc-flow-config.json"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Configuration file $CONFIG_FILE not found!"
    echo "Please create $CONFIG_FILE or run from the project root directory."
    exit 1
fi

# Extract output mode from config (simple grep-based approach)
OUTPUT_MODE=$(grep -o '"output_mode":[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
if [ -z "$OUTPUT_MODE" ]; then
    OUTPUT_MODE="mcp"  # default fallback
fi

# Load the appropriate template
TEMPLATE_FILE="templates/${OUTPUT_MODE}-instructions.md"
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "❌ Template file $TEMPLATE_FILE not found!"
    echo "Available templates should be: templates/mcp-instructions.md, templates/local-instructions.md"
    exit 1
fi

# Rest of the script
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

$(cat "$TEMPLATE_FILE")

EOF

echo "✅ Architecture update queued successfully!"
echo "📝 Added to: pending-architecture-updates.md"
echo "🔧 Output mode: $OUTPUT_MODE (from $CONFIG_FILE)"
echo ""
echo "Summary:"
echo "  - Description: $DESCRIPTION"
echo "  - Files: $(echo "$CHANGED_FILES" | wc -l) files changed"
echo "  - Commit: $COMMIT_HASH on $BRANCH"
echo ""
echo "Next: Tell Claude to 'Process pending architecture updates'"
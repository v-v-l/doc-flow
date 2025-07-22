#!/bin/bash
# Doc Flow - Existing Application Integration Script
# Smart setup for applications with existing code and documentation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
TOOLS_DIR=".tools/doc-flow"
CONFIG_FILE="$TOOLS_DIR/config.json"
SCAN_RESULTS="$TOOLS_DIR/initial-scan.md"

print_header() {
    echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  $1  ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_scan() {
    echo -e "${CYAN}[SCAN]${NC} $1"
}

# Analyze existing project structure
analyze_existing_project() {
    print_header "📊 Analyzing Existing Project"
    echo ""
    
    # Project size and complexity
    TOTAL_FILES=$(find . -type f -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" -o -name "*.go" -o -name "*.php" -o -name "*.rb" -o -name "*.cs" 2>/dev/null | wc -l | tr -d ' ')
    TOTAL_LINES=$(find . -type f -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" -o -name "*.go" -o -name "*.php" -o -name "*.rb" -o -name "*.cs" 2>/dev/null | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
    
    # Detect project type and structure
    PROJECT_TYPE="unknown"
    LANGUAGE="unknown"
    FRAMEWORK="unknown"
    
    if [ -f "package.json" ]; then
        PROJECT_TYPE="nodejs"
        LANGUAGE="javascript"
        if grep -q "react" package.json 2>/dev/null; then
            FRAMEWORK="react"
        elif grep -q "express" package.json 2>/dev/null; then
            FRAMEWORK="express"
        elif grep -q "next" package.json 2>/dev/null; then
            FRAMEWORK="nextjs"
        fi
    elif [ -f "requirements.txt" ] || [ -f "setup.py" ] || [ -f "pyproject.toml" ]; then
        PROJECT_TYPE="python"
        LANGUAGE="python"
        if [ -d "django" ] || grep -q "django" requirements.txt 2>/dev/null; then
            FRAMEWORK="django"
        elif grep -q "flask" requirements.txt 2>/dev/null; then
            FRAMEWORK="flask"
        elif grep -q "fastapi" requirements.txt 2>/dev/null; then
            FRAMEWORK="fastapi"
        fi
    elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        PROJECT_TYPE="java"
        LANGUAGE="java"
        if grep -q "spring" pom.xml 2>/dev/null; then
            FRAMEWORK="spring"
        fi
    elif [ -f "go.mod" ]; then
        PROJECT_TYPE="golang"
        LANGUAGE="go"
    elif [ -f "Cargo.toml" ]; then
        PROJECT_TYPE="rust" 
        LANGUAGE="rust"
    fi
    
    # Detect architectural patterns
    print_scan "Detecting architectural patterns..."
    
    PATTERNS=()
    
    # Check for common patterns
    if find . -name "*Service*.js" -o -name "*Service*.ts" -o -name "*Service*.py" | head -1 | grep -q .; then
        PATTERNS+=("Service Layer")
    fi
    
    if find . -name "*Controller*.js" -o -name "*Controller*.ts" -o -name "*Controller*.py" | head -1 | grep -q .; then
        PATTERNS+=("MVC Pattern")
    fi
    
    if find . -name "*Repository*.js" -o -name "*Repository*.ts" -o -name "*Repository*.py" | head -1 | grep -q .; then
        PATTERNS+=("Repository Pattern")
    fi
    
    if find . -name "*Handler*.js" -o -name "*Handler*.ts" -o -name "*Handler*.py" | head -1 | grep -q .; then
        PATTERNS+=("Handler Pattern")
    fi
    
    if find . -name "docker-compose.yml" -o -name "Dockerfile" | head -1 | grep -q .; then
        PATTERNS+=("Containerized")
    fi
    
    if find . -name "*middleware*" -o -name "*Middleware*" | head -1 | grep -q .; then
        PATTERNS+=("Middleware Pattern")
    fi
    
    # Check for microservices indicators
    if [ -d "services" ] || [ -d "microservices" ] || find . -maxdepth 2 -name "docker-compose.yml" | grep -q .; then
        PATTERNS+=("Microservices")
    fi
    
    # Display analysis results
    print_success "Project Analysis Complete"
    echo ""
    echo -e "${CYAN}📋 Project Summary:${NC}"
    echo -e "   Language: ${YELLOW}$LANGUAGE${NC}"
    echo -e "   Framework: ${YELLOW}$FRAMEWORK${NC}" 
    echo -e "   Type: ${YELLOW}$PROJECT_TYPE${NC}"
    echo -e "   Files: ${YELLOW}$TOTAL_FILES${NC} source files"
    echo -e "   Size: ${YELLOW}$TOTAL_LINES${NC} lines of code"
    echo ""
    
    if [ ${#PATTERNS[@]} -gt 0 ]; then
        echo -e "${CYAN}🏗️ Detected Patterns:${NC}"
        for pattern in "${PATTERNS[@]}"; do
            echo -e "   ✅ $pattern"
        done
    else
        echo -e "${YELLOW}⚠️  No clear architectural patterns detected${NC}"
    fi
    echo ""
    
    # Store analysis results
    cat > "$SCAN_RESULTS" << EOF
# Initial Architecture Scan Results

**Generated**: $(date '+%Y-%m-%d %H:%M:%S')

## Project Overview
- **Language**: $LANGUAGE
- **Framework**: $FRAMEWORK  
- **Type**: $PROJECT_TYPE
- **Source Files**: $TOTAL_FILES
- **Lines of Code**: $TOTAL_LINES

## Detected Architectural Patterns
$(if [ ${#PATTERNS[@]} -gt 0 ]; then
    for pattern in "${PATTERNS[@]}"; do
        echo "- $pattern"
    done
else
    echo "- No clear patterns detected"
fi)

## Discovered Components
<!-- Will be populated by component discovery -->

## Recommended Next Steps
1. Run component discovery scan
2. Choose documentation system
3. Process discovered architecture  
4. Set up ongoing documentation workflow

EOF
}

# Discover existing components
discover_components() {
    print_header "🔍 Component Discovery"
    echo ""
    
    print_scan "Scanning for architectural components..."
    
    COMPONENTS=()
    
    # Find Services
    while IFS= read -r -d '' file; do
        filename=$(basename "$file" | sed 's/\.[^.]*$//')
        if [[ $filename =~ Service$ ]] || [[ $filename =~ service$ ]]; then
            COMPONENTS+=("$filename:Service:$file")
        fi
    done < <(find . -name "*[Ss]ervice*" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" \) -print0 2>/dev/null)
    
    # Find Controllers
    while IFS= read -r -d '' file; do
        filename=$(basename "$file" | sed 's/\.[^.]*$//')
        if [[ $filename =~ Controller$ ]] || [[ $filename =~ controller$ ]]; then
            COMPONENTS+=("$filename:Controller:$file")
        fi
    done < <(find . -name "*[Cc]ontroller*" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" \) -print0 2>/dev/null)
    
    # Find Models/Entities
    while IFS= read -r -d '' file; do
        filename=$(basename "$file" | sed 's/\.[^.]*$//')
        if [[ $filename =~ Model$ ]] || [[ $filename =~ Entity$ ]] || [[ $filename =~ model$ ]]; then
            COMPONENTS+=("$filename:Model:$file")
        fi
    done < <(find . -name "*[Mm]odel*" -o -name "*[Ee]ntity*" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" \) -print0 2>/dev/null)
    
    # Find Repositories
    while IFS= read -r -d '' file; do
        filename=$(basename "$file" | sed 's/\.[^.]*$//')
        if [[ $filename =~ Repository$ ]] || [[ $filename =~ repository$ ]] || [[ $filename =~ Repo$ ]]; then
            COMPONENTS+=("$filename:Repository:$file")
        fi
    done < <(find . -name "*[Rr]epository*" -o -name "*[Rr]epo*" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" \) -print0 2>/dev/null)
    
    # Find Handlers
    while IFS= read -r -d '' file; do
        filename=$(basename "$file" | sed 's/\.[^.]*$//')
        if [[ $filename =~ Handler$ ]] || [[ $filename =~ handler$ ]]; then
            COMPONENTS+=("$filename:Handler:$file")
        fi
    done < <(find . -name "*[Hh]andler*" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" \) -print0 2>/dev/null)
    
    # Find Middleware
    while IFS= read -r -d '' file; do
        filename=$(basename "$file" | sed 's/\.[^.]*$//')
        if [[ $filename =~ [Mm]iddleware ]]; then
            COMPONENTS+=("$filename:Middleware:$file")
        fi
    done < <(find . -name "*[Mm]iddleware*" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" \) -print0 2>/dev/null)
    
    # Display discovered components
    echo -e "${CYAN}📦 Discovered Components (${#COMPONENTS[@]} total):${NC}"
    
    if [ ${#COMPONENTS[@]} -gt 0 ]; then
        # Group by type
        declare -A COMPONENT_TYPES
        for component in "${COMPONENTS[@]}"; do
            IFS=':' read -r name type file <<< "$component"
            if [[ -z "${COMPONENT_TYPES[$type]}" ]]; then
                COMPONENT_TYPES[$type]="$name"
            else
                COMPONENT_TYPES[$type]="${COMPONENT_TYPES[$type]}, $name"
            fi
        done
        
        for type in "${!COMPONENT_TYPES[@]}"; do
            echo -e "   ${GREEN}$type:${NC} ${COMPONENT_TYPES[$type]}"
        done
        
        echo ""
        echo -e "${CYAN}Sample component files:${NC}"
        for component in "${COMPONENTS[@]:0:5}"; do
            IFS=':' read -r name type file <<< "$component"
            echo -e "   📄 $name ($type) → $file"
        done
        
        if [ ${#COMPONENTS[@]} -gt 5 ]; then
            echo -e "   ${YELLOW}... and $((${#COMPONENTS[@]} - 5)) more${NC}"
        fi
    else
        echo -e "   ${YELLOW}⚠️  No architectural components detected${NC}"
        echo -e "   ${BLUE}💡 This might be a different architectural style${NC}"
    fi
    
    # Append to scan results
    cat >> "$SCAN_RESULTS" << EOF

## Discovered Components (${#COMPONENTS[@]} total)
$(if [ ${#COMPONENTS[@]} -gt 0 ]; then
    for component in "${COMPONENTS[@]}"; do
        IFS=':' read -r name type file <<< "$component"
        echo "- **$name** ($type) - \`$file\`"
    done
else
    echo "- No architectural components auto-detected"
fi)

EOF
}

# Check existing documentation
check_existing_docs() {
    print_header "📚 Documentation Assessment"
    echo ""
    
    HAS_README=false
    HAS_DOCS_FOLDER=false
    HAS_ARCHITECTURE_DOCS=false
    EXISTING_DOC_FILES=()
    
    # Check for README
    if [ -f "README.md" ] || [ -f "readme.md" ] || [ -f "README.txt" ]; then
        HAS_README=true
        README_SIZE=$(wc -l README.* 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
    fi
    
    # Check for docs folder
    if [ -d "docs" ] || [ -d "documentation" ] || [ -d "doc" ]; then
        HAS_DOCS_FOLDER=true
        DOC_FILES=$(find docs documentation doc -name "*.md" -o -name "*.txt" 2>/dev/null | wc -l | tr -d ' ')
    fi
    
    # Check for architecture-specific docs
    if find . -name "*architecture*" -o -name "*ARCHITECTURE*" -o -name "*design*" -o -name "*DESIGN*" 2>/dev/null | grep -q .; then
        HAS_ARCHITECTURE_DOCS=true
        while IFS= read -r -d '' file; do
            EXISTING_DOC_FILES+=("$file")
        done < <(find . -name "*architecture*" -o -name "*ARCHITECTURE*" -o -name "*design*" -o -name "*DESIGN*" -print0 2>/dev/null)
    fi
    
    # Display documentation assessment
    print_scan "Assessing existing documentation..."
    echo ""
    
    if [ "$HAS_README" = true ]; then
        echo -e "   ✅ README found (${README_SIZE} lines)"
    else
        echo -e "   ❌ No README file"
    fi
    
    if [ "$HAS_DOCS_FOLDER" = true ]; then
        echo -e "   ✅ Documentation folder found (${DOC_FILES} files)"
    else
        echo -e "   ❌ No docs/ folder"
    fi
    
    if [ "$HAS_ARCHITECTURE_DOCS" = true ]; then
        echo -e "   ✅ Architecture documentation found:"
        for doc in "${EXISTING_DOC_FILES[@]:0:3}"; do
            echo -e "      📄 $doc"
        done
        if [ ${#EXISTING_DOC_FILES[@]} -gt 3 ]; then
            echo -e "      ${YELLOW}... and $((${#EXISTING_DOC_FILES[@]} - 3)) more${NC}"
        fi
    else
        echo -e "   ❌ No architecture documentation found"
    fi
    
    # Append to scan results  
    cat >> "$SCAN_RESULTS" << EOF

## Existing Documentation Assessment
- **README**: $(if [ "$HAS_README" = true ]; then echo "✅ Found ($README_SIZE lines)"; else echo "❌ Not found"; fi)
- **Docs Folder**: $(if [ "$HAS_DOCS_FOLDER" = true ]; then echo "✅ Found ($DOC_FILES files)"; else echo "❌ Not found"; fi)  
- **Architecture Docs**: $(if [ "$HAS_ARCHITECTURE_DOCS" = true ]; then echo "✅ Found (${#EXISTING_DOC_FILES[@]} files)"; else echo "❌ Not found"; fi)

$(if [ "$HAS_ARCHITECTURE_DOCS" = true ]; then
    echo "### Existing Architecture Files"
    for doc in "${EXISTING_DOC_FILES[@]}"; do
        echo "- \`$doc\`"
    done
fi)

EOF
}

# Show integration recommendations
show_integration_recommendations() {
    print_header "💡 Integration Recommendations"
    echo ""
    
    # Determine complexity level
    COMPLEXITY="simple"
    if [ $TOTAL_FILES -gt 100 ] || [ $TOTAL_LINES -gt 10000 ]; then
        COMPLEXITY="complex"
    elif [ $TOTAL_FILES -gt 20 ] || [ $TOTAL_LINES -gt 2000 ]; then
        COMPLEXITY="medium"
    fi
    
    echo -e "${CYAN}Based on your project analysis:${NC}"
    echo -e "   📊 Complexity: ${YELLOW}$COMPLEXITY${NC}"
    echo -e "   🏗️  Components: ${YELLOW}${#COMPONENTS[@]}${NC} discovered"
    echo -e "   📚 Docs: $(if [ "$HAS_ARCHITECTURE_DOCS" = true ]; then echo "${GREEN}Existing${NC}"; else echo "${YELLOW}Missing${NC}"; fi)"
    echo ""
    
    echo -e "${CYAN}Recommended approach:${NC}"
    
    case $COMPLEXITY in
        "simple")
            echo -e "   📝 ${GREEN}Simple Markdown${NC} - Perfect for your project size"
            echo -e "   🎯 Start with README.md architecture section"
            echo -e "   📁 Use docs/architecture/ for component details"
            RECOMMENDED_SYSTEM="markdown"
            ;;
        "medium") 
            echo -e "   🧠 ${PURPLE}Obsidian${NC} or ${CYAN}MCP Integration${NC} - Great for growing projects"
            echo -e "   🔗 Visual relationships will help understand connections"
            echo -e "   📊 Graph view shows architecture complexity"
            RECOMMENDED_SYSTEM="obsidian"
            ;;
        "complex")
            echo -e "   🗃️ ${YELLOW}Notion Database${NC} or ${CYAN}MCP Integration${NC} - Best for large projects"
            echo -e "   👥 Team collaboration features essential"  
            echo -e "   📈 Structured data helps manage complexity"
            RECOMMENDED_SYSTEM="notion"
            ;;
    esac
    
    echo ""
    echo -e "${CYAN}Integration strategy:${NC}"
    
    if [ "$HAS_ARCHITECTURE_DOCS" = true ]; then
        echo -e "   🔄 ${YELLOW}Migration Mode${NC} - Preserve existing documentation"
        echo -e "   📋 Import existing architecture files"
        echo -e "   🔗 Connect with new component documentation"
    else
        echo -e "   🆕 ${GREEN}Fresh Start${NC} - Create new architecture documentation"
        echo -e "   📝 Generate docs from discovered components"
        echo -e "   🏗️  Build complete architecture picture"
    fi
    
    if [ ${#COMPONENTS[@]} -gt 10 ]; then
        echo -e "   ⚡ ${BLUE}Batch Processing${NC} - Handle large component count"
        echo -e "   🤖 Use AI assistance for bulk documentation"
    fi
    
    # Final recommendations in scan results
    cat >> "$SCAN_RESULTS" << EOF

## Integration Recommendations

### Recommended System
**$RECOMMENDED_SYSTEM** - Based on project complexity ($COMPLEXITY) and component count (${#COMPONENTS[@]})

### Integration Strategy
$(if [ "$HAS_ARCHITECTURE_DOCS" = true ]; then
    echo "**Migration Mode** - Preserve and enhance existing documentation"
    echo "- Import existing architecture files: ${#EXISTING_DOC_FILES[@]} files found"
    echo "- Connect with new component-based documentation"
    echo "- Maintain backward compatibility"
else
    echo "**Fresh Start** - Create comprehensive new documentation"
    echo "- Generate documentation from ${#COMPONENTS[@]} discovered components"
    echo "- Build complete architecture picture from scratch"
    echo "- Establish documentation standards"
fi)

### Next Steps
1. Run interactive setup: \`./setup.sh\`
2. Choose $(echo $RECOMMENDED_SYSTEM) system
3. $(if [ "$HAS_ARCHITECTURE_DOCS" = true ]; then echo "Import existing documentation"; else echo "Generate initial architecture docs"; fi)
4. Set up ongoing workflow for future changes

EOF
}

# Offer to run initial documentation generation
offer_initial_generation() {
    print_header "🚀 Next Steps"
    echo ""
    
    echo -e "${CYAN}Your options:${NC}"
    echo -e "1. ${GREEN}Run Interactive Setup${NC} - Choose system and configure"
    echo -e "2. ${BLUE}Generate Initial Docs${NC} - Create docs for discovered components" 
    echo -e "3. ${YELLOW}Review Scan Results${NC} - Analyze findings first"
    echo ""
    
    echo -e "Scan results saved to: ${YELLOW}$SCAN_RESULTS${NC}"
    echo ""
    
    while true; do
        echo -e "${BLUE}What would you like to do next? (1-3):${NC} \c"
        read choice
        
        case $choice in
            1)
                echo ""
                print_status "Starting interactive setup..."
                if [ -f "setup.sh" ]; then
                    ./setup.sh
                else
                    print_error "setup.sh not found. Please run from doc-flow directory."
                fi
                break
                ;;
            2)
                echo ""
                print_status "Generating initial documentation..."
                generate_initial_docs
                break
                ;;
            3)
                echo ""
                print_status "Opening scan results..."
                if command -v code > /dev/null; then
                    code "$SCAN_RESULTS"
                elif command -v nano > /dev/null; then
                    nano "$SCAN_RESULTS" 
                else
                    cat "$SCAN_RESULTS"
                fi
                break
                ;;
            *)
                print_error "Invalid choice. Please enter 1-3."
                ;;
        esac
    done
}

# Generate initial documentation for discovered components
generate_initial_docs() {
    print_status "Creating initial documentation for ${#COMPONENTS[@]} components..."
    
    # Create initial pending updates with discovered components
    INITIAL_PENDING="$TOOLS_DIR/initial-components.md"
    
    cat > "$INITIAL_PENDING" << EOF
# Initial Architecture Documentation - Discovered Components

**Generated**: $(date '+%Y-%m-%d %H:%M:%S')  
**Source**: Existing codebase analysis

This file contains architecture documentation for components discovered in your existing codebase.

---

EOF
    
    # Process each discovered component
    for component in "${COMPONENTS[@]}"; do
        IFS=':' read -r name type file <<< "$component"
        
        cat >> "$INITIAL_PENDING" << EOF
## Component: $name

### Auto-Discovery Info
**Type**: $type  
**File**: \`$file\`  
**Discovered**: $(date '+%Y-%m-%d %H:%M:%S')

### Processing Instructions
Component discovered in existing codebase. Please analyze and document:

1. **Review Implementation**: Examine \`$file\` for component purpose
2. **Extract Dependencies**: Identify what this component needs  
3. **Document Interface**: Public methods, APIs, or endpoints
4. **Map Relationships**: How other components use this
5. **Integration Points**: External systems or services

**Next Steps**: Process this component in your knowledge management system

---

EOF
    done
    
    print_success "Initial documentation created: $INITIAL_PENDING"
    
    if [ ${#COMPONENTS[@]} -gt 0 ]; then
        echo ""
        echo -e "${CYAN}💡 Recommendation:${NC}"
        echo -e "   Process these discovered components with your chosen documentation system"
        echo -e "   Use: ${YELLOW}Process pending architecture updates${NC} (for MCP integration)"
        echo -e "   Or manually review: ${YELLOW}$INITIAL_PENDING${NC}"
    fi
}

# Main execution
main() {
    clear
    echo ""
    print_header "🔍 Doc Flow - Existing Application Integration"
    echo ""
    
    # Check if we're in a git repository
    if [ ! -d ".git" ]; then
        print_error "Not in a git repository. Please run 'git init' first."
        exit 1
    fi
    
    # Create tools directory
    mkdir -p "$TOOLS_DIR"
    
    print_status "Analyzing your existing application for Doc Flow integration..."
    echo ""
    
    # Run analysis steps
    analyze_existing_project
    discover_components
    check_existing_docs
    show_integration_recommendations
    offer_initial_generation
    
    echo ""
    print_success "Analysis complete! Check $SCAN_RESULTS for full details."
    echo ""
}

# Run main function
main "$@"
# 🌍 Doc Flow - Open Source Project Workflow

This guide covers how Doc Flow works in open source projects, handling external contributions, and maintaining architecture documentation with community involvement.

---

## 🏗️ Repository Management Strategy

### **Two-Repository Approach (Recommended)**

```
┌─────────────────────────────────────┐  ┌─────────────────────────────────────┐
│ doc-flow (PUBLIC)                   │  │ doc-flow-dev (PRIVATE/INTERNAL)     │
├─────────────────────────────────────┤  ├─────────────────────────────────────┤
│ ✅ Clean commit history             │  │ 🔧 Full development history         │
│ ✅ Professional documentation       │  │ 🔧 Testing commits                  │  
│ ✅ Stable releases only             │  │ 🔧 Experimental features            │
│ ✅ External contributors welcome    │  │ 🔧 Internal development             │
│ ✅ Architecture docs maintained     │  │ 🔧 Raw architectural evolution      │
└─────────────────────────────────────┘  └─────────────────────────────────────┘
            ↑                                           ↓
            │                                           │
    ┌──────────────────┐                    ┌──────────────────┐
    │ Community        │                    │ Core Development │
    │ Contributions    │                    │ & Iteration      │
    └──────────────────┘                    └──────────────────┘
```

### **Development Workflow**

```
Internal Development:
├── Feature development in doc-flow-dev
├── Testing and iteration
├── Architecture documentation generation
├── Clean up and prepare for release
└── Cherry-pick/clean merge to public repo

External Contributions:
├── Contributors fork public doc-flow repo
├── Submit PRs with architectural changes  
├── Doc Flow auto-detects architecture changes in PR
├── Maintainer reviews both code + architecture docs
└── Merge generates updated architecture documentation
```

---

## 🔄 External Contributor Documentation Workflow

### **The Challenge**
When external contributors submit PRs with architectural changes, how does Doc Flow document them while maintaining quality and consistency?

### **Solution: PR-Based Architecture Documentation**

#### **Phase 1: Contributor Submits PR**
```
External Contributor:
├── Forks repository
├── Makes architectural changes (adds Service, Controller, etc.)
├── Commits with Doc Flow keywords: "add UserAuthService component"
├── Doc Flow git hook triggers in their fork
├── Captures architectural changes in .tools/doc-flow/pending-updates.md
└── Submits PR including both code changes AND pending documentation
```

#### **Phase 2: Automated PR Analysis**
```
GitHub Actions Workflow:
├── PR submitted with code changes
├── Check for .tools/doc-flow/pending-updates.md changes
├── Auto-run architecture analysis on PR files
├── Generate architecture documentation preview  
├── Comment on PR with documentation summary
└── Label PR as "architecture-change" if applicable
```

#### **Phase 3: Maintainer Review Process**
```
Maintainer Review:
├── Review code changes (normal process)
├── Review architectural impact via pending-updates.md
├── Validate architectural documentation accuracy
├── Request improvements if needed
├── Approve both code AND architecture documentation
└── Merge with architecture docs included
```

#### **Phase 4: Post-Merge Documentation Processing**
```
After PR Merge:
├── Main branch updated with new architectural changes
├── Doc Flow processes pending updates automatically
├── Updates project architecture documentation
├── Maintains architectural knowledge base
├── Archives processed updates
└── Documentation stays current with community contributions
```

---

## 🤖 GitHub Actions Integration

### **PR Architecture Analysis Workflow**

```yaml
# .github/workflows/architecture-review.yml
name: Architecture Documentation Review

on:
  pull_request:
    paths:
      - '**/*.js'
      - '**/*.ts'
      - '**/*.py'
      - '**/*.java'
      - '**/package.json'
      - '**/requirements.txt'

jobs:
  architecture-analysis:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
          
      - name: Detect Architecture Changes
        run: |
          # Check if commit messages contain architecture keywords
          git log --oneline origin/main..HEAD | grep -iE "(add|new|create|implement).*(service|controller|component|module)" || exit 0
          
          echo "🏗️ Architecture changes detected in PR"
          echo "architecture_changes=true" >> $GITHUB_OUTPUT
        id: detect
        
      - name: Run Architecture Analysis  
        if: steps.detect.outputs.architecture_changes == 'true'
        run: |
          # Run existing-app-setup.sh to analyze architectural changes
          ./existing-app-setup.sh --pr-mode --output=pr-architecture-analysis.md
          
      - name: Comment Architecture Analysis
        if: steps.detect.outputs.architecture_changes == 'true'
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const analysis = fs.readFileSync('pr-architecture-analysis.md', 'utf8');
            
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## 🏗️ Architecture Change Analysis\n\n${analysis}\n\n**Please review the architectural impact of this PR.**`
            });
            
      - name: Label Architecture PR
        if: steps.detect.outputs.architecture_changes == 'true'
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.addLabels({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              labels: ['architecture-change', 'needs-docs-review']
            });
```

### **Post-Merge Documentation Update**

```yaml
# .github/workflows/update-architecture-docs.yml
name: Update Architecture Documentation

on:
  push:
    branches: [main]
    paths:
      - '**/*.js'
      - '**/*.ts' 
      - '**/*.py'
      - '**/*.java'

jobs:
  update-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Check for Architecture Changes
        run: |
          if [ -f ".tools/doc-flow/pending-updates.md" ] && [ -s ".tools/doc-flow/pending-updates.md" ]; then
            echo "📝 Pending architecture updates found"
            echo "has_updates=true" >> $GITHUB_OUTPUT
          fi
        id: check
        
      - name: Process Architecture Updates
        if: steps.check.outputs.has_updates == 'true'
        run: |
          # Process pending updates and update documentation
          ./scripts/process-architecture-updates.sh --auto-commit
          
      - name: Commit Updated Documentation
        if: steps.check.outputs.has_updates == 'true'
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add .
          git commit -m "📝 Update architecture documentation from community contributions" || exit 0
          git push
```

---

## 👥 Contributor Guidelines

### **Contributing to Architecture**

When contributing code that affects the project architecture:

#### **1. Use Architectural Keywords in Commits**
```bash
# ✅ Good - Will trigger documentation
git commit -m "add EmailNotificationService for user alerts"
git commit -m "implement new PaymentGateway integration"
git commit -m "create UserProfileController with validation"

# ❌ Won't trigger documentation
git commit -m "fix bug in email system"  
git commit -m "update styling"
git commit -m "refactor helper functions"
```

#### **2. Include Architecture Context**
```bash
# Excellent commit message with context
git commit -m "add RedisSessionStore component for distributed sessions

- Implements SessionStore interface
- Depends on Redis client configuration
- Used by AuthMiddleware for session management
- Replaces in-memory session storage for scalability"
```

#### **3. Review Generated Documentation**
- Check `.tools/doc-flow/pending-updates.md` after committing
- Ensure architectural documentation accurately reflects your changes
- Include any missing context or dependencies

#### **4. Submit Complete PRs**
```
Your PR Should Include:
├── Code changes
├── Updated .tools/doc-flow/pending-updates.md (if architectural)
├── Any necessary documentation updates
├── Tests for new components
└── Clear description of architectural impact
```

---

## 🔍 Maintainer Review Process

### **Architecture Review Checklist**

When reviewing PRs with architectural changes:

#### **Code Review (Standard)**
- [ ] Code quality and standards
- [ ] Test coverage
- [ ] Performance impact
- [ ] Security considerations

#### **Architecture Review (Doc Flow Enhanced)**
- [ ] Architectural changes properly detected by Doc Flow
- [ ] Component responsibilities clearly defined
- [ ] Dependencies accurately documented
- [ ] Integration points identified
- [ ] Naming conventions followed
- [ ] Documentation quality meets standards

#### **Documentation Review**
- [ ] Generated architecture docs are accurate
- [ ] Component relationships correctly mapped
- [ ] API endpoints properly documented
- [ ] Configuration changes noted
- [ ] Migration impact assessed

### **Review Tools**

#### **Architecture Diff View**
```bash
# Compare architecture before/after PR
./scripts/architecture-diff.sh main pr-branch

# Shows:
# + New components added
# - Components removed  
# ~ Components modified
# → Dependency changes
```

#### **Impact Analysis**
```bash
# Analyze architectural impact of changes
./scripts/impact-analysis.sh --pr=123

# Generates:
# - Affected components
# - Dependency chain impact
# - Integration point changes
# - Potential breaking changes
```

---

## 🏢 Team & Community Management

### **Role-Based Documentation Workflow**

#### **Core Maintainers**
- **Responsibility**: Architecture oversight and documentation quality
- **Tools**: Full Doc Flow setup with all documentation systems
- **Process**: Review all architectural PRs, maintain documentation standards

#### **Regular Contributors** 
- **Responsibility**: Follow architectural documentation guidelines
- **Tools**: Basic Doc Flow setup, use architectural commit keywords
- **Process**: Include architecture docs in PRs, respond to review feedback

#### **Occasional Contributors**
- **Responsibility**: Basic architectural awareness
- **Tools**: Git hooks auto-detect architectural changes
- **Process**: Write clear commit messages, maintainers handle documentation

### **Community Documentation Health**

#### **Metrics to Track**
```
Documentation Health Dashboard:
├── Architecture Coverage: % of components documented
├── Documentation Freshness: Days since last update
├── Contributor Adoption: % of architectural PRs with proper docs
├── Review Efficiency: Time from PR to architecture doc approval
└── Community Engagement: Contributors actively improving docs
```

#### **Quality Gates**
```
PR Merge Requirements:
├── Code review approved
├── Tests passing
├── Architecture documentation reviewed (if applicable)
├── Doc Flow validation passed
└── No pending documentation issues
```

---

## 📊 Open Source Success Patterns

### **Documentation-First Communities**

Projects that successfully maintain architecture documentation:

#### **Pattern 1: Architecture Champions**
- Designate team members as architecture documentation champions
- They review all architectural PRs and maintain doc quality
- Regular architecture documentation review sessions

#### **Pattern 2: Automated Quality Gates**
- Doc Flow enforces documentation standards automatically
- PRs cannot merge without proper architectural documentation
- CI/CD validates documentation completeness

#### **Pattern 3: Community Education**
- Clear contributor guidelines for architectural changes
- Documentation templates and examples
- Regular community calls discussing architecture evolution

### **Scaling Documentation with Growth**

#### **Small Project (1-10 contributors)**
```
Simple Setup:
├── README.md with architecture section
├── Basic Doc Flow git hooks
├── Manual review of architectural changes
└── Maintainer processes documentation updates
```

#### **Growing Project (10-50 contributors)**
```
Enhanced Setup:  
├── Obsidian/Notion for visual architecture docs
├── GitHub Actions for automated PR analysis
├── Architecture review process
└── Multiple maintainers with doc responsibilities
```

#### **Large Project (50+ contributors)**
```
Full Automation:
├── MCP integration with AI-powered documentation
├── Automated architecture impact analysis
├── Multi-tier review process
├── Architecture working groups
└── Documentation quality metrics tracking
```

---

## 🚀 Implementation Timeline

### **Week 1: Repository Setup**
- [ ] Create clean public repository
- [ ] Set up GitHub Actions workflows
- [ ] Configure Doc Flow for community contributions
- [ ] Write initial contributor guidelines

### **Week 2: Community Process**
- [ ] Test PR workflow with architecture changes
- [ ] Refine automated documentation generation
- [ ] Create architecture review checklist
- [ ] Document maintainer processes

### **Month 1: Community Adoption**
- [ ] Onboard first external contributors
- [ ] Iterate on documentation workflow based on feedback
- [ ] Track documentation quality metrics
- [ ] Refine automation based on real usage

### **Ongoing: Maintenance & Evolution**
- [ ] Regular architecture documentation reviews
- [ ] Community feedback integration
- [ ] Process improvements
- [ ] Tool enhancements based on community needs

---

## 🎯 Success Metrics

### **Community Health**
- **Contributor Adoption**: % of contributors using Doc Flow properly
- **Documentation Quality**: Architecture docs accuracy and completeness
- **Review Efficiency**: Time from architectural PR to merge
- **Community Engagement**: Active participation in architecture discussions

### **Technical Health**
- **Architecture Coverage**: % of codebase with proper documentation
- **Documentation Freshness**: How current architecture docs are
- **Automation Success**: % of architectural changes auto-documented
- **Quality Gates**: % of PRs meeting documentation standards

---

**Ready to launch your open source project with Doc Flow?**

This workflow ensures that community contributions enhance rather than degrade your project's architectural documentation, creating a sustainable process for long-term open source success! 🌟
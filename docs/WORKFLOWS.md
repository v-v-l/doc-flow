# 🏗️ Doc Flow - Workflow Documentation

Visual guides and schemas for different documentation workflows supported by Doc Flow.

## 📊 System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        Doc Flow Architecture                     │
├─────────────────────────────────────────────────────────────────┤
│  Developer  →  Git Commit  →  Hook Detection  →  Documentation  │
│     ↓              ↓              ↓                    ↓         │
│  Codes new    Contains arch    Captures to       Updates chosen  │
│  features     keywords         pending file      knowledge sys   │
└─────────────────────────────────────────────────────────────────┘
```

### Core Flow Stages

1. **🎯 Detection Phase**
   - Git hook scans commit messages
   - Keywords: `add`, `new`, `create`, `implement` + `service`, `component`, `module`
   - Context capture: files changed, commit info, branch data

2. **📋 Capture Phase** 
   - Structured data extraction
   - Saves to `.tools/doc-flow/pending-updates.md`
   - Template-based documentation generation

3. **🔄 Processing Phase**
   - Manual or automated processing
   - Integration with chosen knowledge system
   - Updates documentation following conventions

---

## 📝 Workflow Option 1: Simple Markdown

**Best for**: Solo developers, small teams, simple documentation needs

### Architecture Diagram
```
Project Root/
├── README.md                    ← Auto-updated architecture section
├── docs/
│   └── architecture/
│       ├── overview.md          ← System documentation
│       ├── components/          ← Individual components  
│       │   ├── UserService.md
│       │   └── PaymentService.md
│       ├── modules/             ← Feature modules
│       └── integrations/        ← External integrations
├── .tools/doc-flow/
│   ├── pending-updates.md       ← Captured changes queue
│   └── config.json             ← Configuration
└── .git/hooks/post-commit      ← Auto-installation hook
```

### Workflow Steps
```
1. Developer commits:
   git commit -m "add UserService component for authentication"
   
2. Git hook detects architectural keywords:
   🔍 Keywords found: "add" + "UserService" + "component"
   
3. Auto-capture to pending file:
   📝 .tools/doc-flow/pending-updates.md updated
   
4. Manual documentation process:
   📖 Review pending updates
   ✍️  Create/update docs/architecture/components/UserService.md
   🔗 Update README.md architecture section
   
5. Result: 
   ✅ Structured documentation in docs/
   ✅ README.md automatically reflects new components
```

### Sample Output Structure
```markdown
## 🏗️ Architecture

### Components
- **UserService** - Authentication and user management
- **PaymentService** - Payment processing and billing
- **NotificationService** - Multi-channel notifications

### Modules  
- **user-management** - User lifecycle and profiles
- **payment-processing** - Transaction handling

*Architecture documentation automatically maintained in `docs/architecture/`*
```

---

## 🧠 Workflow Option 2: Obsidian Vault  

**Best for**: Complex projects, visual thinkers, advanced knowledge management

### Architecture Diagram
```
Obsidian Vault/
├── Architecture/                ← Main architecture folder
│   ├── 🏗️ System Overview.md    ← Central system documentation
│   ├── Components/              ← Component documentation
│   │   ├── [[UserService]].md   ← Wikilinked components
│   │   ├── [[PaymentService]].md
│   │   └── [[NotificationService]].md  
│   ├── Modules/                 ← Feature modules
│   │   ├── [[user-management]].md
│   │   └── [[payment-processing]].md
│   ├── Integrations/            ← External systems
│   │   ├── [[Stripe API]].md
│   │   └── [[Firebase Auth]].md
│   └── Data Flows/              ← Process documentation
│       ├── [[User Registration Flow]].md
│       └── [[Payment Flow]].md
└── Graph View                   ← Visual relationship map
    ├── Component connections
    ├── Dependency visualization  
    └── Architecture overview
```

### Workflow Steps
```
1. Developer commits:
   git commit -m "implement PaymentService with Stripe integration"
   
2. Git hook captures architectural change:
   🔍 Detected: "implement" + "PaymentService" + "integration"
   📝 Saved to pending-updates.md
   
3. Process in Obsidian:
   🧠 Open Obsidian vault
   📖 Review pending updates
   🤖 Use AI assistant (Claude, ChatGPT) to process
   
4. AI creates structured documentation:
   📄 Creates [[PaymentService]] note
   🔗 Links to [[Stripe API]] integration  
   ↗️  Updates [[System Overview]] with connections
   🌐 Graph view automatically shows relationships
   
5. Result:
   ✅ Wikilinked component documentation
   ✅ Visual graph of system architecture
   ✅ Searchable knowledge base
```

### Sample Obsidian Note Structure
```markdown
# PaymentService

#component #service #payment

## Dependencies
- [[Stripe API]] - Payment processing
- [[UserService]] - User authentication
- [[Database]] - Transaction storage

## Used By
- [[OrderService]] - Payment confirmation
- [[SubscriptionService]] - Recurring billing

## Integration Points
- **API Endpoints**: `/payments/*`
- **Webhooks**: Stripe event handling
- **Database**: transactions table

## Related
- [[Payment Flow]] - End-to-end process
- [[Stripe Integration Guide]] - Setup docs
```

---

## 🗃️ Workflow Option 3: Notion Database

**Best for**: Team collaboration, project management, structured data

### Architecture Diagram  
```
Notion Workspace/
├── Architecture Database        ← Main components database
│   ├── Properties:
│   │   ├── Name (Title)        ← Component name
│   │   ├── Type (Select)       ← Service/Controller/Module
│   │   ├── Status (Select)     ← Active/Deprecated/Planned
│   │   ├── Dependencies (Relation) ← Links to other components
│   │   ├── Owner (Person)      ← Responsible developer
│   │   ├── Last Updated (Date) ← Maintenance tracking
│   │   └── Description (Text)  ← Component purpose
│   ├── Views:
│   │   ├── 🏗️ All Components   ← Complete architecture view
│   │   ├── 🔥 Active Services  ← Currently maintained
│   │   ├── 🔗 Dependencies     ← Relationship mapping
│   │   └── 👥 By Owner         ← Team responsibility
│   └── Templates:
│       ├── Service Template    ← Standardized service docs
│       ├── Controller Template ← API endpoint documentation  
│       └── Integration Template← External system connections
├── Integration Flows           ← Process documentation
├── Decision Records           ← Architecture decisions (ADRs)
└── Team Dashboard            ← High-level metrics
```

### Workflow Steps
```
1. Developer commits:
   git commit -m "create NotificationService for real-time alerts"
   
2. Git hook captures and processes:
   🔍 Detected: "create" + "NotificationService" + architecture context
   📝 Structured data prepared for Notion API
   
3. Automated Notion integration:
   🚀 API call creates new database entry
   📊 Properties auto-populated from commit analysis
   🔗 Dependencies linked to existing components
   
4. Team collaboration:
   👥 Team sees new component in database
   ✏️  Can edit/enhance documentation
   📈 Rollup fields show system complexity
   🎯 Filtered views for different perspectives
   
5. Result:
   ✅ Structured component in team database
   ✅ Automatic relationship tracking
   ✅ Team visibility and collaboration
```

### Sample Notion Database Entry
```
┌─────────────────────────────────────────────────────────┐
│ NotificationService                              Active │
├─────────────────────────────────────────────────────────┤
│ Type: Service                    Owner: @developer      │
│ Dependencies: → WebSocket, → EmailService, → Firebase  │
│ Used By: ← UserInterface, ← MobileApp                  │
│ Last Updated: 2025-01-21                               │
│                                                         │  
│ Description:                                           │
│ Real-time notification system supporting WebSocket,    │
│ email, and push notifications. Handles message         │
│ queuing and delivery status tracking.                  │
│                                                         │
│ Integration Points:                                     │
│ • WebSocket: /ws/notifications                         │  
│ • Email: SMTP + templates                              │
│ • Push: Firebase Cloud Messaging                       │
└─────────────────────────────────────────────────────────┘
```

---

## ⚙️ Workflow Option 4: Custom System

**Best for**: Existing toolchain integration, custom requirements

### Architecture Diagram
```  
Custom Integration/
├── Doc Flow Output
│   ├── JSON/YAML/XML export     ← Structured data
│   ├── Custom templates         ← Your format
│   ├── Webhook notifications    ← Real-time integration  
│   └── API endpoints           ← Programmatic access
├── Your Existing Tools
│   ├── CI/CD Pipeline          ← Build integration
│   ├── Documentation Portal    ← Custom docs site
│   ├── Monitoring Systems      ← Architecture tracking
│   └── Team Chat               ← Notifications
└── Processing Scripts
    ├── Transform data          ← Format conversion
    ├── Validate structure      ← Quality checks
    └── Deploy docs             ← Auto-publishing
```

### Workflow Steps
```
1. Developer commits:
   git commit -m "add CacheService component with Redis"
   
2. Git hook processes and exports:
   🔍 Architecture change detected
   📤 Export to custom format (JSON/YAML/etc)
   📡 Optional webhook fired
   
3. Your custom processing:
   ⚙️  Custom scripts process exported data
   🔄 Transform to your documentation format
   ✅ Validate against your standards
   
4. Integration with your tools:
   📚 Update documentation portal
   💬 Post to team chat: "New component added"
   📊 Update architecture dashboards
   🚀 Trigger CI/CD documentation build
   
5. Result:
   ✅ Seamless integration with existing workflow
   ✅ Custom format and processing
   ✅ Team notifications and visibility
```

### Sample Custom Export (JSON)
```json
{
  "timestamp": "2025-01-21T10:30:00Z",
  "commit": "a1b2c3d",
  "branch": "feature/cache-service",
  "detected_components": [
    {
      "name": "CacheService",
      "type": "service",
      "naming_convention": "PascalCase",
      "dependencies": [
        {"name": "Redis", "type": "external"},
        {"name": "ConfigService", "type": "internal"}
      ],
      "integration_points": [
        {"type": "api", "endpoint": "/cache/*"},
        {"type": "database", "system": "Redis"}
      ],
      "metadata": {
        "files_changed": ["cache-service.js", "redis-client.js"],
        "keywords": ["add", "CacheService", "component", "Redis"]
      }
    }
  ]
}
```

---

## 🤖 Workflow Option 5: MCP Integration (Claude Code)

**Best for**: Real-time AI assistance, graph-based knowledge, advanced automation

### Architecture Diagram  
```
MCP Knowledge System/
├── Claude Code Integration      ← Direct AI processing
│   ├── Real-time documentation ← Immediate processing
│   ├── Graph connections       ← Relationship mapping
│   ├── Virtual folders         ← Organized structure
│   └── Wikilink management     ← Cross-references
├── Knowledge Graph
│   ├── Components              ← Service/Controller nodes
│   ├── Dependencies           ← Relationship edges
│   ├── Data flows             ← Process connections
│   └── Search capabilities     ← Semantic queries
├── Architecture Templates      ← AI-powered generation
│   ├── Component documentation ← Standardized formats
│   ├── Integration guides      ← Connection patterns  
│   └── Decision records        ← Architecture choices
└── Auto-processing            ← Intelligent workflow
    ├── Discovery-first         ← Check existing docs
    ├── Template generation     ← AI-created content
    ├── Relationship mapping    ← Automatic connections
    └── Quality validation      ← Consistency checks
```

### Workflow Steps  
```
1. Developer commits:
   git commit -m "implement APIGateway component for microservices"
   
2. Git hook with MCP integration:
   🔍 Architecture keywords detected
   📝 Captured to pending-updates.md
   🤖 MCP processing enabled notification
   
3. AI-powered processing:
   🧠 Claude Code processes pending updates
   🔍 Discovery: Searches for existing components
   📄 Creates structured APIGateway documentation
   🔗 Updates system overview with connections
   📊 Graph relationships maintained automatically
   
4. Intelligent documentation:
   ✨ AI infers dependencies from context
   🏗️  Generates component relationships
   📖 Creates comprehensive documentation
   🌐 Graph view shows system connections
   
5. Result:
   ✅ Immediate, intelligent documentation
   ✅ Graph-based architecture knowledge
   ✅ AI-maintained relationships and connections
```

### Sample MCP Processing Flow
```
🔍 Discovery Phase:
   search("APIGateway") → No existing docs found
   list_notes(virtual_folder: "architecture/overview") → System context
   graph_search("microservices") → Related components found
   
📝 Documentation Generation:
   create_note(
     title: "APIGateway Component",
     virtual_folder: "architecture/components/",
     content: AI-generated comprehensive docs
   )
   
🔗 Relationship Mapping:
   update_note("System Overview") → Add [[APIGateway Component]]
   create connections → Services, Load Balancer, Authentication
   
✅ Validation:
   validate_note_links → Ensure all connections work
   suggest_connections → Recommend additional relationships
```

---

## 🎯 Choosing Your Workflow

| Factor | Markdown | Obsidian | Notion | Custom | MCP |
|--------|----------|----------|--------|---------|-----|
| **Complexity** | Simple | Medium | Medium | High | Medium |
| **Team Size** | 1-3 | 1-10 | 3-50 | Any | Any |
| **Automation** | Manual | Semi-auto | Auto | Full | AI-auto |
| **Visual** | Basic | Advanced | Good | Custom | Graph |
| **Learning Curve** | Easy | Medium | Easy | Hard | Medium |
| **Integration** | None | Limited | Good | Full | AI-native |

### Quick Decision Guide

**Choose Markdown if:**
- ✅ Simple project documentation
- ✅ Want everything in your repository
- ✅ Prefer manual control over automation

**Choose Obsidian if:**  
- ✅ Love visual knowledge mapping
- ✅ Want advanced linking and search
- ✅ Individual or small team use

**Choose Notion if:**
- ✅ Need team collaboration features
- ✅ Want structured, database-driven docs
- ✅ Like project management integration

**Choose Custom if:**
- ✅ Have existing documentation toolchain
- ✅ Need specific format requirements
- ✅ Want full integration control

**Choose MCP if:**
- ✅ Use Claude Code regularly
- ✅ Want AI-powered documentation
- ✅ Prefer automated relationship management

---

## 🚀 Getting Started

1. **Run Interactive Setup**:
   ```bash
   ./setup.sh
   ```

2. **Choose Your System** from the visual menu

3. **Test the Workflow**:
   ```bash
   git commit -m "add TestService component for demo"
   cat .tools/doc-flow/pending-updates.md
   ```

4. **Process Documentation** according to your chosen workflow

5. **Iterate and Improve** based on your team's needs

Happy documenting! 🎉
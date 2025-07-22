# 🤝 Contributing to Doc Flow

Thank you for your interest in contributing to Doc Flow! This guide will help you contribute effectively while maintaining our architecture documentation standards.

## 🎯 Types of Contributions

### 🏗️ **Architecture-Related Contributions**
These require special attention to documentation:
- Adding new components (Services, Controllers, etc.)
- Creating new integrations or APIs
- Modifying data flow or system architecture
- Adding new modules or major features

### 🔧 **Non-Architecture Contributions**
Standard contribution process:
- Bug fixes
- Performance optimizations
- Documentation improvements
- Test additions
- Refactoring without architectural impact

---

## 🏗️ Contributing Architecture Changes

### **Before You Start**

1. **Set Up Doc Flow** (if contributing architectural changes):
   ```bash
   # In your fork of the project
   ./setup.sh
   # Choose option 5 (MCP Integration) for best experience
   ```

2. **Understand Architecture Keywords**:
   Use these words in commit messages to trigger documentation:
   - **Action words**: `add`, `new`, `create`, `implement`, `feat`
   - **Component words**: `service`, `controller`, `component`, `module`, `integration`, `api`, `database`

### **Writing Architecture Commits**

#### ✅ **Good Examples**:
```bash
# Will trigger architecture documentation
git commit -m "add EmailNotificationService for user alerts

- Implements NotificationInterface
- Depends on SMTP configuration and UserService  
- Used by AccountService for registration emails
- Handles template rendering and delivery status"

git commit -m "implement PaymentGateway integration with Stripe

- Creates PaymentGateway component with Stripe adapter
- Adds webhook handling for payment events
- Integrates with OrderService for payment confirmation
- Includes retry logic and error handling"

git commit -m "create UserProfileController with validation middleware

- New REST controller for user profile operations
- Depends on UserService and ValidationService
- Implements CRUD operations for user profiles
- Includes input sanitization and authorization"
```

#### ❌ **Examples that won't trigger documentation**:
```bash
# These won't generate architecture docs
git commit -m "fix typo in email template"
git commit -m "update styling for profile page"  
git commit -m "refactor helper utility functions"
git commit -m "add unit tests for validation"
```

### **Architecture Commit Template**

```bash
git commit -m "<action> <ComponentName> <brief description>

<detailed description with context>
- Purpose: What this component does
- Dependencies: What it needs to work  
- Integration: How other parts use it
- Implementation notes: Key technical details"

# Example:
git commit -m "add RedisSessionStore component for distributed sessions

Replaces in-memory session storage with Redis-backed store
- Purpose: Distributed session management for horizontal scaling
- Dependencies: Redis client, SessionInterface, ConfigService
- Integration: Used by AuthMiddleware and SessionManager
- Implementation: Includes connection pooling and automatic cleanup"
```

### **What Happens After Your Commit**

1. **Automatic Detection**: Doc Flow git hook analyzes your commit
2. **Documentation Capture**: Creates entry in `.tools/doc-flow/pending-updates.md`
3. **Include in PR**: Your PR should include both code and documentation changes
4. **Review Process**: Maintainers review both code and architecture documentation

---

## 📋 Pull Request Process

### **Standard PR Checklist**
- [ ] Code follows project style guidelines
- [ ] Tests are included and passing
- [ ] Documentation is updated (if needed)
- [ ] Changes are described clearly in PR description

### **Architecture PR Additional Checklist**
- [ ] Architecture commit keywords used appropriately
- [ ] `.tools/doc-flow/pending-updates.md` includes your changes
- [ ] Component relationships are documented
- [ ] Integration points are explained
- [ ] Breaking changes are highlighted

### **What to Expect**

#### **Automated Analysis**
Our GitHub Actions will automatically:
- ✅ Detect architectural changes in your PR
- 📊 Analyze impact level (low/medium/high)
- 🏷️ Label your PR appropriately
- 💬 Comment with architecture analysis
- 👥 Request architecture review (for high-impact changes)

#### **Review Process**
- **Code Review**: Standard code quality review
- **Architecture Review**: Component design, relationships, documentation quality
- **Documentation Review**: Accuracy and completeness of generated docs

#### **Merge Process**
- ✅ All checks passing
- ✅ Code review approved
- ✅ Architecture documentation reviewed (if applicable)
- 🤖 Automatic architecture documentation update after merge

---

## 🔍 Architecture Review Guidelines

### **Component Design Principles**

#### **Single Responsibility**
```javascript
// ✅ Good - focused responsibility
class EmailNotificationService {
  async sendEmail(recipient, template, data) { ... }
  async getDeliveryStatus(messageId) { ... }
}

// ❌ Avoid - multiple responsibilities  
class NotificationService {
  async sendEmail() { ... }
  async sendSMS() { ... }
  async pushToMobile() { ... }
  async logAnalytics() { ... }
}
```

#### **Clear Dependencies**
```javascript
// ✅ Good - explicit dependencies
class OrderService {
  constructor(paymentGateway, inventoryService, notificationService) {
    this.paymentGateway = paymentGateway;
    this.inventoryService = inventoryService;
    this.notificationService = notificationService;
  }
}

// ❌ Avoid - hidden dependencies
class OrderService {
  processOrder(order) {
    // Hidden dependency on global PaymentGateway
    PaymentGateway.charge(order.amount);
  }
}
```

#### **Integration Points**
Document how your component integrates:
```bash
# In your commit message, explain:
- What APIs/endpoints it exposes
- What events it publishes/subscribes to  
- What databases/external services it uses
- How error handling works
- What configuration it needs
```

### **Architecture Review Criteria**

#### **Component Quality**
- [ ] **Purpose**: Clear, single responsibility
- [ ] **Interface**: Well-defined public API
- [ ] **Dependencies**: Explicit and minimal
- [ ] **Integration**: Clear connection points
- [ ] **Error Handling**: Robust error management

#### **Documentation Quality**
- [ ] **Accuracy**: Documentation matches implementation
- [ ] **Completeness**: All dependencies and integrations covered
- [ ] **Clarity**: Easy to understand for new contributors
- [ ] **Consistency**: Follows project documentation standards

#### **System Impact**
- [ ] **Compatibility**: Doesn't break existing functionality
- [ ] **Performance**: No significant performance regression
- [ ] **Scalability**: Design supports system growth
- [ ] **Security**: No new security vulnerabilities introduced

---

## 👥 Community Guidelines

### **Communication Standards**

#### **In Pull Requests**
- 💬 **Clear Description**: Explain what you're building and why
- 🎯 **Architectural Context**: How does this fit into the bigger picture?
- 🔗 **Related Work**: Link to relevant issues, discussions, or PRs
- 📝 **Breaking Changes**: Highlight any backward compatibility issues

#### **In Code Reviews**
- 🤝 **Constructive Feedback**: Focus on code and architecture, not people
- 💡 **Suggest Alternatives**: Offer better approaches when providing feedback
- 📚 **Share Knowledge**: Help others learn and understand architectural decisions
- 🎉 **Celebrate Good Work**: Acknowledge excellent contributions

### **Architecture Discussions**

#### **When to Start a Discussion**
- 🏗️ **Major Architectural Changes**: Before implementing large system changes
- 🤔 **Design Questions**: When unsure about component design or patterns
- 🔄 **Breaking Changes**: Before making changes that affect other components
- 📊 **Performance Impact**: When changes may affect system performance

#### **How to Structure Discussions**
```markdown
## Architecture Discussion: [Component/Feature Name]

### Context
What problem are you solving?

### Proposed Solution  
High-level approach and component design

### Alternatives Considered
What other approaches did you evaluate?

### Impact Analysis
- Dependencies affected
- Integration points
- Performance considerations
- Breaking changes

### Questions for Community
Specific questions you'd like feedback on
```

---

## 🚀 Getting Started Guide

### **First-Time Contributors**

1. **🍴 Fork the Repository**
2. **🔧 Set Up Development Environment**:
   ```bash
   git clone https://github.com/your-username/doc-flow.git
   cd doc-flow
   
   # Set up Doc Flow for architecture documentation
   ./setup.sh
   ```

3. **🎯 Choose Your First Contribution**:
   - 🐛 **Bug fixes**: Great for getting familiar with the codebase
   - 📝 **Documentation**: Help improve guides and examples
   - 🧪 **Tests**: Add test coverage for existing functionality
   - 🏗️ **Small features**: Add focused, well-defined functionality

4. **🔍 Understand the Architecture**:
   - Read `docs/WORKFLOWS.md` for system overview
   - Check `docs/architecture/` for existing component documentation
   - Review recent PRs to understand contribution patterns

### **Development Workflow**

1. **🌟 Create Feature Branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **💻 Make Your Changes**:
   - Follow existing code patterns and styles
   - Write tests for new functionality
   - Use architecture commit messages for architectural changes

3. **📝 Document Your Changes**:
   - Update relevant documentation
   - Include architecture documentation for new components
   - Update README if needed

4. **🧪 Test Your Changes**:
   ```bash
   # Run existing tests
   ./scripts/test.sh  # (if available)
   
   # Test Doc Flow integration
   git commit -m "add TestComponent for demonstration"
   cat .tools/doc-flow/pending-updates.md
   ```

5. **📤 Submit Pull Request**:
   - Clear title and description
   - Reference related issues
   - Include architecture impact summary (if applicable)

### **Advanced Contributors**

#### **Architecture Champions**
Experienced contributors who help maintain architecture quality:
- 👁️ **Review Architecture PRs**: Focus on component design and documentation
- 📚 **Improve Documentation**: Enhance architecture guides and examples
- 🤝 **Mentor New Contributors**: Help others understand architectural patterns
- 🏗️ **Lead Major Initiatives**: Drive significant architectural improvements

#### **Becoming an Architecture Champion**
1. **Demonstrate Expertise**: Consistently high-quality architectural contributions
2. **Community Involvement**: Active in discussions and reviews
3. **Documentation Skills**: Help improve and maintain architecture docs
4. **Mentoring**: Help other contributors with architectural questions

---

## 📊 Contribution Types & Impact

### **Impact Levels**

#### **🟢 Low Impact** 
- Single component changes
- Bug fixes
- Minor feature additions
- Documentation updates

**Review Process**: Standard code review

#### **🟡 Medium Impact**
- Multiple component changes  
- New integrations
- API modifications
- Performance improvements

**Review Process**: Code + architecture review

#### **🔴 High Impact**
- New major components/modules
- System-wide architectural changes
- Breaking changes
- Security-sensitive modifications

**Review Process**: Code + architecture + maintainer review

### **Contribution Recognition**

#### **Community Recognition**
- 🏆 **Contributor of the Month**: Outstanding contributions
- 🌟 **Architecture Excellence**: Exceptional architectural contributions
- 🤝 **Community Helper**: Active in helping other contributors
- 📚 **Documentation Champion**: Significant documentation improvements

#### **Ways to Get Recognized**
- 💻 **Quality Contributions**: Well-designed, documented changes
- 🤝 **Help Others**: Answer questions, review PRs, mentor newcomers  
- 📝 **Improve Documentation**: Make architecture docs clearer and more complete
- 🐛 **Report and Fix Issues**: Find and resolve problems proactively

---

## 🛟 Getting Help

### **Where to Ask Questions**

#### **Architecture Questions**
- 💬 [GitHub Discussions](https://github.com/v-v-l/doc-flow/discussions) - Design discussions
- 📝 [Architecture Issues](https://github.com/v-v-l/doc-flow/labels/architecture) - Specific architectural topics

#### **Contribution Help**
- 🆘 [Discord/Slack Community](#) - Real-time help (if available)
- 📧 [Email Maintainers](#) - Direct communication for complex questions
- 📖 [Documentation](docs/) - Comprehensive guides and examples

#### **Bug Reports & Feature Requests**
- 🐛 [Bug Reports](https://github.com/v-v-l/doc-flow/issues/new?template=bug_report.md)
- ✨ [Feature Requests](https://github.com/v-v-l/doc-flow/issues/new?template=feature_request.md)

### **Response Times**
- 🐛 **Critical Bugs**: 24-48 hours
- ❓ **General Questions**: 2-5 days  
- 🏗️ **Architecture Discussions**: 3-7 days
- 📝 **Documentation**: 1-3 days

---

## 📄 Additional Resources

### **Documentation**
- 🚀 [Quick Start Guide](QUICK-START.md)
- 📊 [Complete Workflows](docs/WORKFLOWS.md)
- 🔍 [Existing App Integration](docs/EXISTING-APP-INTEGRATION.md)
- 🌍 [Open Source Workflow](docs/OPEN-SOURCE-WORKFLOW.md)

### **Examples**
- 🎯 [Example Components](examples/) - Well-documented component examples
- 🔧 [Integration Examples](examples/integrations/) - How to integrate with different systems
- 📝 [Documentation Templates](templates/) - Templates for consistent documentation

### **Development Tools**
- 🛠️ [Development Scripts](scripts/) - Useful development utilities
- 🧪 [Testing Tools](tests/) - Testing frameworks and utilities
- 📋 [Code Style Guide](STYLE.md) - Coding standards and conventions

---

**Thank you for contributing to Doc Flow! 🎉**

Your contributions help developers worldwide maintain better architecture documentation and build more sustainable software systems.

*Questions? Don't hesitate to ask in our [community discussions](https://github.com/v-v-l/doc-flow/discussions)!*
### Claude Processing Instructions

Please process this architectural update using the local documentation workflow:

1. **Discovery Phase:**
   - Read existing `/docs/ARCHITECTURE.md` if it exists
   - Check `/docs/` folder for related documentation
   - Identify which sections need updates

2. **Documentation Actions Needed:**
   - Create or update `/docs/ARCHITECTURE.md` with:
     * New components under "## Components" section
     * Dependencies under "## Dependencies" section
     * Data flow changes under "## Data Flow" section
   - Update main `README.md` if new features are user-facing
   - Create component-specific documentation in `/docs/components/` if needed

3. **Structure Format:**
   - Use clear markdown headings and bullet points
   - Create dependency tables when helpful
   - Include code examples for key interfaces
   - Link between documentation files using relative paths
   - Use mermaid diagrams for complex data flows / schemas

4. **Validation:**
   - Ensure all internal links work
   - Verify documentation is consistent with codebase
   - Check that new components are properly categorized

5. **Cleanup:**
   - Remove any outdated or unused documentation files
   - Archive old versions of documentation if necessary
   - cleanup @.doc-flow/pending-updates.md
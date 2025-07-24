### Claude Processing Instructions

Please process this architectural update using the MCP architecture documentation workflow:

1. **Discovery Phase:**
   - `search("component-name")` to check existing docs
   - `list_notes` with `virtual_folder: "architecture/overview"`
   - `graph_search("related-concepts")` for connections

2. **Documentation Actions Needed:**
   - Parse description for: components, dependencies, relationships
   - Create/update notes following architecture naming conventions:
     * Components: PascalCase (PaymentService)
     * Modules: kebab-case (payment-processing)  
     * Systems: Title Case (Payment Gateway)
   - Use appropriate tags: `["component", "service"]` or `["module", "core"]`
   - Place in correct virtual folder: `architecture/components/` or `architecture/modules/`

3. **Relationship Mapping:**
   - Document dependencies: what this component needs
   - Document dependents: what uses this component
   - Use `add_wikilink` for bidirectional connections
   - Update data flow documentation if applicable

4. **Validation:**
   - `validate_note_links` to ensure all connections work
   - `suggest_connections` for additional relationships
   - `get_knowledge_base_health` for overall integrity

5. **Cleanup:**
   - Remove any outdated or unused documentation 
   - cleanup @.doc-flow/pending-updates.md

**Architecture Prompt Reference:** @templates/architecture-documentation-prompt.md
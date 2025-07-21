# {{component_name}}

**Type:** Component  
**Module:** [[{{parent_module}}]]  
**Created:** {{timestamp}}  
**Last Modified:** {{last_modified}}

## Purpose
{{component_purpose}}

## Responsibility
{{component_responsibility}}

## Dependencies
### Upstream (What this needs)
{{#dependencies}}
- [[{{name}}]] - {{reason}}
{{/dependencies}}

### Downstream (What needs this)
{{#dependents}}
- [[{{name}}]] - {{usage}}
{{/dependents}}

## Key Methods/APIs
{{#methods}}
- `{{signature}}` - {{description}}
{{/methods}}

## Data Structures
{{#data_structures}}
### {{name}}
```{{language}}
{{structure}}
```
{{/data_structures}}

## Integration Points
{{#integrations}}
- **{{system}}**: {{description}}
{{/integrations}}

## Configuration
{{#config}}
- `{{key}}`: {{description}}
{{/config}}

## Related Components
{{#related}}
- [[{{name}}]] - {{relationship}}
{{/related}}

## Notes
{{notes}}

---
**Tags:** {{tags}}  
**Virtual Folder:** `{{virtual_folder}}`
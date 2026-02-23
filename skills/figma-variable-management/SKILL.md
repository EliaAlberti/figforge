---
name: figma-variable-management
description: "Create, audit, rename, and organise Figma design variables/tokens. Use when building or maintaining a design token system."
---

# Figma Variable Management

## When to Use
- Building token system from scratch
- Auditing existing variables
- Renaming to follow conventions
- Cleaning up unused variables

## Token Hierarchy
```
Primitive (raw values) > Semantic (meaning) > Component (usage)
```

## Process
1. Audit: `figma_get_variables`
2. Categorise by type (colour, number, string)
3. Map to naming convention
4. Execute (Local Mode tools) or plan (Remote Mode report)
5. Verify: re-read variables

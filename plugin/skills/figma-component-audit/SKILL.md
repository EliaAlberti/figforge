---
name: figma-component-audit
description: "Audit Figma component library for consistency, completeness, and proper variant setup. Use when evaluating design system health."
---

# Figma Component Audit

## When to Use
- Evaluating design system health
- Finding inconsistencies across components
- Preparing for design system overhaul

## Process
1. List all components: `figma_get_components`
2. For each component, check:
   - Naming follows convention
   - Variants are properly set up
   - Properties are consistent across similar components
   - Tokens are used (not hardcoded values)
   - Auto-layout is applied where appropriate
3. Generate audit report with findings and recommendations

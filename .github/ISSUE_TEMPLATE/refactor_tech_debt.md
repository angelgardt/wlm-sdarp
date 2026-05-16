---
name: "Refactor/Tech Debt"
about: Code refactoring or technical debt reduction
title: "[REFACTOR] "
labels: refactoring
assignees:
  - angelgardt
---

## 📝 Description
<!-- What code needs refactoring and why? -->

## 🔍 Current State
<!-- Describe the current implementation and its issues -->

## 🎯 Goals
<!-- What improvements will this bring? -->
- [ ] Improve readability
- [ ] Reduce duplication
- [ ] Enhance performance
- [ ] Simplify maintenance
- [ ] Better error handling
- [ ] Other: [specify]

## 📋 Scope
<!-- Which files/components are affected? -->
- `scripts/deploy.R`
- `book/_quarto.yml`
- `shared/css/...`
- Other: [specify]

## ⚠️ Risks
<!-- Potential risks or breaking changes -->
- Risk 1
- Risk 2

## ✅ Checklist
- [ ] Identify refactoring targets
- [ ] Write tests (if applicable)
- [ ] Perform refactoring
- [ ] Test all functionality
- [ ] Update documentation
- [ ] Review with team (if applicable)

## 🧪 Testing Plan
```bash
# Commands to verify nothing broke
quarto render book/ --profile ru
./deploy --version alpha --profile ru --project book --dry-run
```

## 📎 Additional Context
<!-- Add any other context, code snippets, or references -->

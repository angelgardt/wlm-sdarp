---
name: "Deployment/Infrastructure"
about: CI/CD, deployment scripts, or infrastructure tasks
title: "[DEPLOY] "
labels: deploy
assignees:
  - angelgardt
---

## 📝 Description
<!-- What infrastructure work is needed? -->

## 🎯 Objective
<!-- What should this achieve? -->

## 📋 Scope
- [ ] Deploy script (`scripts/deploy.R`)
- [ ] GitHub Actions workflows
- [ ] GitHub Pages configuration
- [ ] Branch protection rules
- [ ] Environment variables/secrets
- [ ] Build optimization
- [ ] Other: [specify]

## 🔧 Technical Details
<!-- Technical implementation notes -->

## ✅ Checklist
- [ ] Implement changes
- [ ] Test locally
- [ ] Test on staging (beta)
- [ ] Test on production (stable)
- [ ] Update documentation
- [ ] Rollback plan ready

## 🧪 Testing
```bash
# Test commands
./deploy --version alpha --profile ru --project book --dry-run
./deploy --version beta --profile ru --project book --dry-run
./deploy --version stable --profile ru --project book --tag vX.Y.Z --dry-run
```

##⚠️ Risks
<!-- Potential risks or downtime -->

##🔄 Rollback Plan
<!-- How to revert if something goes wrong -->

##📎 Additional Context
<!-- Add any other context or references -->

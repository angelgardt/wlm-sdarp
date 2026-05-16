---
name: "Translation/i18n"
about: Translation or localization tasks
title: "[I18N] "
labels: i18n
assignees: angelgardt
---

## 🌍 Language
**Target Language:** [e.g., English, Esperanto]
**Language Code:** [e.g., en, eo]

## 📝 Scope
<!-- What needs to be translated? -->
- [ ] Chapter(s): [list chapters]
- [ ] UI strings (`_langs/_lang-*.yml`)
- [ ] Metadata (`_meta/_metadata-*.yml`)
- [ ] README/Documentation
- [ ] Assessment materials
- [ ] Other: [specify]

## ✅ Checklist
- [ ] Translate content
- [ ] Adapt examples for cultural context (if needed)
- [ ] Update `_quarto-<lang>.yml` profile
- [ ] Test rendering with new profile
- [ ] Verify formula rendering
- [ ] Check cross-references
- [ ] Proofread by native speaker
- [ ] Update documentation

## 🔗 Resources
- [ ] Translation guide/style guide
- [ ] Glossary of terms
- [ ] Reference materials

## 🧪 Testing
```bash
# Test the new language profile
quarto preview book/ --profile <lang>
```

## 📅 Timeline
Translation Start: [date]
Review Complete: [date]
Target Milestone: v0.X.0

## 👥 Reviewers
<!-- Native speakers or language experts -->
@username1
@username2

## 📎 Additional Notes
<!-- Special considerations for this language -->

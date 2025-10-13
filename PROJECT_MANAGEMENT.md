# Project Management Guide 📊

This guide explains how to manage the Surgical Cognitive Monitoring Suite project across both repositories.

---

## 🎯 Project Overview

**GitHub Project:** [Surgical Cognitive Monitoring Suite](https://github.com/users/mohdasti/projects/)

**Linked Repositories:**
- 🏥 [surgical-cognitive-dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard) (Production)
- 🧪 [surgical-training-lab](https://github.com/mohdasti/surgical-training-lab) (Research)

---

## 📋 Recommended Project Views

### **View 1: All Items (Board)**
**Purpose:** See everything at a glance

**Setup:**
1. In your project, click current view name (top left)
2. Click "+ New view"
3. Choose "Board" layout
4. Name: "All Items"
5. Group by: "Status"
6. Columns: Backlog → In Progress → Done

---

### **View 2: By Repository (Board)**
**Purpose:** Separate production from research

**Setup:**
1. Create new Board view
2. Name: "By Repository"
3. Group by: "Repository"
4. This shows:
   - surgical-cognitive-dashboard items
   - surgical-training-lab items

---

### **View 3: Production Only (Board)**
**Purpose:** Focus on clinical features

**Setup:**
1. Create new Board view
2. Name: "Production Only"
3. Filter: `repo:mohdasti/surgical-cognitive-dashboard`
4. Group by: "Status"

---

### **View 4: Research Only (Board)**
**Purpose:** Focus on experimental features

**Setup:**
1. Create new Board view
2. Name: "Research Only"
3. Filter: `repo:mohdasti/surgical-training-lab`
4. Group by: "Status"

---

### **View 5: Roadmap (Timeline)**
**Purpose:** See what's coming when

**Setup:**
1. Create new view, choose "Roadmap"
2. Name: "Roadmap"
3. Shows issues with milestones on timeline
4. Great for presentations and planning

---

### **View 6: By Priority (Table)**
**Purpose:** See high-priority items first

**Setup:**
1. Create new view, choose "Table"
2. Name: "By Priority"
3. Sort by: Labels (show `critical`, `high` first)
4. Columns: Title, Repository, Status, Labels, Assignees

---

## 🏷️ Label Strategy

### **Recommended Labels for Both Repos:**

#### **Repository Labels:**
```
🏥 production     (Green)    - For surgical-cognitive-dashboard
🧪 research       (Purple)   - For surgical-training-lab
📚 education      (Blue)     - Educational features/materials
```

#### **Type Labels:**
```
🐛 bug            (Red)      - Something isn't working
✨ enhancement    (Green)    - New feature or request
📖 documentation  (Blue)     - Documentation improvements
🔬 theory         (Purple)   - Cognitive theory implementation
🎨 ui/ux          (Pink)     - User interface improvements
⚡ performance    (Yellow)   - Performance optimization
🔧 maintenance    (Gray)     - Code maintenance, refactoring
```

#### **Priority Labels:**
```
🔴 critical       (Red)      - Blocks production use
🟠 high           (Orange)   - Important for next release
🟡 medium         (Yellow)   - Should have
🟢 low            (Green)    - Nice to have
```

#### **Status Labels:**
```
🚦 needs-triage   (Gray)     - New, not yet reviewed
💬 discussion     (Blue)     - Needs community input
🔍 investigating  (Yellow)   - Being researched
✅ ready          (Green)    - Ready to implement
🚧 in-progress    (Orange)   - Currently being worked on
🧪 testing        (Purple)   - In testing phase
```

#### **Special Labels:**
```
👋 good first issue  (Green)    - Good for newcomers
🙏 help wanted       (Blue)     - Extra attention needed
❓ question          (Purple)   - Question about the code
🔄 duplicate         (Gray)     - Duplicate of another issue
⛔ wontfix           (Gray)     - Will not be fixed
```

---

## 📝 Creating and Managing Issues

### **When to Create Issues:**

**Production Dashboard Issues:**
- Clinical feature requests
- Bugs affecting patient safety
- Performance issues
- Deployment problems
- Security concerns

**Training Lab Issues:**
- New paradigm suggestions
- Educational features
- Parameter enhancements
- Research use cases
- Documentation improvements

### **Issue Best Practices:**

1. **Use Templates**
   - Choose appropriate template
   - Fill out all required fields
   - Add relevant labels

2. **Link Related Issues**
   - Use "Closes #123" in PR descriptions
   - Reference related issues with #number
   - Link across repos when relevant

3. **Add to Project**
   - Issues auto-add to project (if configured)
   - Manually add if needed
   - Set status appropriately

4. **Be Specific**
   - Clear, descriptive titles
   - Steps to reproduce (for bugs)
   - Research citations (for theories)
   - Use cases (for features)

---

## 🔄 Research → Production Workflow

### **Standard Flow:**

```
🧪 Training Lab                    🏥 Production Dashboard
     │                                      │
     ├─ 1. Open Issue                      │
     │     "[RESEARCH] Explore AGT"        │
     │                                      │
     ├─ 2. Implement & Test                │
     │     Create PR in Training Lab       │
     │                                      │
     ├─ 3. Validate                        │
     │     Use in research/teaching        │
     │                                      │
     ├─ 4. Document Results                │
     │     "AGT validated, ready for       │
     │      production"                    │
     │                                      │
     └─────────────────────────────────────→ 5. Create Issue
                                            │     "[PRODUCTION] Add AGT"
                                            │
                                            ├─ 6. Port & Harden
                                            │     Refactor for reliability
                                            │
                                            ├─ 7. Test Thoroughly
                                            │     Production standards
                                            │
                                            └─ 8. Deploy ✅
```

### **Example Issue Linking:**

**Training Lab Issue #5:**
```markdown
# [RESEARCH] Implement Adaptive Gain Theory

**Status:** Completed ✅

**Findings:** AGT successfully reduces false alerts by 23% while 
maintaining sensitivity. Validated across 100 simulated cases.

**Next Step:** Ready for production implementation
See mohdasti/surgical-cognitive-dashboard#12
```

**Dashboard Issue #12:**
```markdown
# [PRODUCTION] Port AGT from Training Lab

**Based on:** mohdasti/surgical-training-lab#5

**Validation:** Completed in research environment
**Risk:** Low - well-tested paradigm
**Timeline:** 2 weeks

**Tasks:**
- [ ] Port core algorithm
- [ ] Add production error handling
- [ ] Performance optimization
- [ ] Clinical validation testing
- [ ] Documentation
```

---

## 🎯 Milestone Strategy

### **Training Lab Milestones:**

**v0.1 - Initial Release** ✅
- Three paradigms functional
- Basic documentation
- Educational use ready

**v0.2 - Enhanced Education**
- Add lesson plan materials
- Create video tutorials
- Export functionality

**v0.5 - Research Complete**
- Fourth paradigm (dual-task)
- Comprehensive comparison tools
- Publication-ready

**v1.0 - Validation Ready**
- Clinical validation data integrated
- Complete educational package
- Research paper submitted

### **Production Dashboard Milestones:**

**v1.0 - Clinical Deployment**
- Hospital-ready deployment
- Authentication system
- Zero-error guarantee

**v1.5 - Multi-site**
- Multi-hospital support
- Centralized monitoring
- Advanced analytics

**v2.0 - AGT Integration**
- Adaptive thresholds (from Training Lab)
- Validated algorithms only
- Clinical trial data

---

## 📊 Project Automation

### **Auto-move Cards:**

Set up in Project Settings → Workflows:

1. **Item added** → Move to "Backlog"
2. **Item closed** → Move to "Done"
3. **PR merged** → Move to "Done"
4. **Item labeled "critical"** → Move to "In Progress"

### **GitHub Actions Integration:**

Actions automatically:
- Label new issues with `needs-triage`
- Greet first-time contributors
- Run tests on PRs
- Update project status

---

## 📈 Tracking Progress

### **Weekly Review:**

**Monday:**
- Review "Backlog" column
- Prioritize issues
- Assign work for the week

**Friday:**
- Move completed items to "Done"
- Update roadmap view
- Plan next week

### **Monthly Review:**

- Check milestone progress
- Update cross-repo dependencies
- Plan research → production transitions
- Review contributor activity

### **Quarterly Review:**

- Major feature planning
- Roadmap adjustments
- Publication planning
- Educational materials assessment

---

## 🤝 Collaboration Patterns

### **For Solo Development:**

1. Create issues for all work (even solo)
2. Use project board to track progress
3. Document decisions in issues
4. Link related work across repos

### **For Team Development:**

1. Assign issues to team members
2. Use labels for coordination
3. Regular standups via project board
4. Cross-repo communication in issues

### **For Community Contributors:**

1. Label good first issues
2. Respond to questions in issues
3. Review PRs promptly
4. Acknowledge contributions

---

## 🎓 Educational Project Management

### **For Course Integration:**

Create milestone for each semester:

**Example: "Fall 2025 - NEUR 520"**
- Issues: Each week's activities
- PRs: Student contributions (if applicable)
- Status: Track course progress

### **For Workshop:**

Create project for each workshop:

**Example: "AGT Workshop - Oct 2025"**
- Pre-workshop prep issues
- During-workshop materials
- Post-workshop follow-up

---

## 📞 Communication Channels

### **GitHub Discussions:**

Use for:
- General questions
- Feature brainstorming
- Educational use cases
- Research collaborations

### **Issues:**

Use for:
- Specific bugs
- Feature requests
- Tasks to complete
- Work tracking

### **Pull Requests:**

Use for:
- Code changes
- Documentation updates
- Feature implementations

---

## 🎯 Success Metrics

### **Training Lab:**

- Number of educational users
- New paradigms contributed
- Research citations
- Community engagement

### **Production Dashboard:**

- Hospital deployments
- Clinical validations
- Uptime reliability
- User satisfaction

### **Cross-Repo:**

- Features ported from lab → production
- Community contributors
- Documentation completeness
- Open science impact

---

## 🔧 Project Settings

### **Recommended Settings:**

**In Project Settings:**
- ✅ Enable README
- ✅ Enable workflows (automation)
- ✅ Link both repositories
- ✅ Make project public (for transparency)

**Custom Fields (Optional):**
- Priority (single select: critical, high, medium, low)
- Complexity (number: 1-5)
- Theory Area (text: AGT, Resource Competition, etc.)
- Target Version (milestone)

---

## 📚 Resources

### **GitHub Project Documentation:**
- [Projects Overview](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [Automation](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project)
- [Custom Fields](https://docs.github.com/en/issues/planning-and-tracking-with-projects/understanding-fields)

### **Our Documentation:**
- [Training Lab README](https://github.com/mohdasti/surgical-training-lab/blob/main/README.md)
- [Comparison Table](https://github.com/mohdasti/surgical-training-lab/blob/main/COMPARISON.md)
- [GitHub Project Setup](https://github.com/mohdasti/surgical-training-lab/blob/main/GITHUB_PROJECT_SETUP.md)

---

## 💡 Tips & Tricks

### **Quick Filters:**

In project search bar:
- `repo:surgical-training-lab` - Show only Training Lab
- `label:critical` - Show critical issues
- `is:open` - Show open items
- `assignee:@me` - Show your assignments

### **Keyboard Shortcuts:**

- `c` - Create new issue
- `x` - Select item
- `e` - Edit selected item
- `/` - Focus search bar

### **Batch Operations:**

- Select multiple items (click checkboxes)
- Apply labels in bulk
- Move to different status
- Assign to milestone

---

## 🚀 Next Steps

1. **Set up views** following this guide
2. **Create labels** in both repositories
3. **Add first milestone** to each repo
4. **Create initial issues** for upcoming work
5. **Invite collaborators** (if applicable)

---

*This is a living document - update as your project management needs evolve!*


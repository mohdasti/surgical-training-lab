# Quick Reference Card 🚀

Fast answers to common questions about managing the Surgical Cognitive Monitoring ecosystem.

---

## 🔗 Important Links

| Resource | Link |
|----------|------|
| 🧪 Training Lab Repo | https://github.com/mohdasti/surgical-training-lab |
| 🏥 Production Dashboard | https://github.com/mohdasti/surgical-cognitive-dashboard |
| 📊 GitHub Project | https://github.com/users/mohdasti/projects/ |
| 💬 Discussions (Training Lab) | https://github.com/mohdasti/surgical-training-lab/discussions |
| 🐛 Report Bug (Training Lab) | https://github.com/mohdasti/surgical-training-lab/issues/new/choose |
| 🐛 Report Bug (Production) | https://github.com/mohdasti/surgical-cognitive-dashboard/issues/new |

---

## ⚡ Quick Commands

### **Run Training Lab Locally:**
```bash
cd /Users/mohdasti/Documents/GitHub/surgical-training-lab
Rscript -e "shiny::runApp('app.R', port=3839, launch.browser=TRUE)"
```

### **Run Production Dashboard:**
```bash
cd /Users/mohdasti/Documents/GitHub/surgical-cognitive-dashboard/surgical-cognitive-dashboard-1/shiny_app
./run_app.sh
# Or:
Rscript -e "shiny::runApp('app_working.R', port=3838, launch.browser=FALSE)"
```

### **Update Training Lab from Git:**
```bash
cd /Users/mohdasti/Documents/GitHub/surgical-training-lab
git pull origin main
```

### **Update Production Dashboard:**
```bash
cd /Users/mohdasti/Documents/GitHub/surgical-cognitive-dashboard
git pull origin main
```

### **Push Training Lab Changes:**
```bash
cd /Users/mohdasti/Documents/GitHub/surgical-training-lab
git add .
git commit -m "Your message"
git push origin main
```

### **Push Production Changes:**
```bash
cd /Users/mohdasti/Documents/GitHub/surgical-cognitive-dashboard
git add .
git commit -m "Your message"
git push origin main
```

---

## 🆚 Which Repo?

### **Use Training Lab for:**
- ✅ New cognitive paradigms
- ✅ Teaching materials
- ✅ Research experiments
- ✅ Parameter exploration
- ✅ Theory prototyping

### **Use Production Dashboard for:**
- ✅ Clinical features
- ✅ Reliability improvements
- ✅ Performance optimization
- ✅ Hospital deployment
- ✅ Patient safety

---

## 🏷️ Label Quick Reference

| Label | When to Use | Color |
|-------|-------------|-------|
| `research` | Training Lab features | 🟣 Purple |
| `education` | Teaching materials | 🔵 Blue |
| `bug` | Something broken | 🔴 Red |
| `enhancement` | New feature | 🟢 Green |
| `critical` | Urgent/blocking | 🔴 Red |
| `good first issue` | Easy for newcomers | 🟢 Green |
| `help wanted` | Need assistance | 🔵 Blue |
| `theory` | Cognitive paradigm | 🟣 Purple |
| `paradigm` | Paradigm-specific | 🟣 Purple |

---

## 📋 Issue Templates

### **Training Lab:**
- 🐛 Bug Report
- ✨ Feature Request  
- 🎓 Educational Use Case

### **Production Dashboard:**
- 🐛 Bug Report (create manually)
- ✨ Feature Request (create manually)

---

## 🔄 Research → Production Flow

```
1. 🧪 Prototype in Training Lab
2. 🧪 Test with users/students
3. 🧪 Document findings
4. 🏥 Create production issue
5. 🏥 Port & harden code
6. 🏥 Test thoroughly
7. 🏥 Deploy ✅
```

---

## 🎯 Common Tasks

### **Add a New Paradigm (Training Lab):**

1. Create module: `R/mod_your_paradigm.R`
2. Add UI and server functions
3. Update `R/mod_controls_router.R`
4. Add to `R/mod_experimental_controls_tab.R`
5. Document in `README.md`
6. Commit and push

### **Fix a Bug:**

1. Open issue with bug template
2. Create branch: `git checkout -b fix/bug-name`
3. Make fixes
4. Test thoroughly
5. Commit: `git commit -m "Fix: description"`
6. Push: `git push origin fix/bug-name`
7. Open PR on GitHub

### **Add Documentation:**

1. Edit appropriate `.md` file
2. Commit: `git commit -m "Docs: what you added"`
3. Push directly to main (for docs)

---

## 🚨 Emergency Fixes

### **Production Dashboard Down:**
```bash
# Check if app is running
ps aux | grep "shiny.*app_working"

# Kill if stuck
pkill -f "shiny.*app_working"

# Restart
cd /Users/mohdasti/Documents/GitHub/surgical-cognitive-dashboard/surgical-cognitive-dashboard-1/shiny_app
./run_app.sh
```

### **Training Lab Not Loading:**
```bash
# Check R is working
R --version

# Try running directly
cd /Users/mohdasti/Documents/GitHub/surgical-training-lab
R
> shiny::runApp('app.R')
```

### **Git Issues:**
```bash
# Undo last commit (keep changes)
git reset HEAD~1

# Discard all local changes
git reset --hard origin/main

# See what changed
git status
git diff
```

---

## 📊 GitHub Project Views

### **Quick Filters:**

In project search bar:

- `repo:surgical-training-lab` → Training Lab only
- `repo:surgical-cognitive-dashboard` → Production only
- `label:critical` → Critical items
- `label:research` → Research features
- `is:open` → Open items
- `is:closed` → Completed items
- `assignee:@me` → Your assignments

### **Recommended Views:**

1. **All Items** - See everything
2. **By Repository** - Separate by repo
3. **Production Only** - Clinical focus
4. **Research Only** - Experimental focus
5. **Roadmap** - Timeline view

---

## 🎓 For Teaching

### **Demo Setup:**

```bash
# Terminal 1: Run Training Lab
cd /path/to/surgical-training-lab
Rscript -e "shiny::runApp('app.R', port=3839, launch.browser=FALSE)"

# Terminal 2: Run Production Dashboard (for comparison)
cd /path/to/surgical-cognitive-dashboard/surgical-cognitive-dashboard-1/shiny_app
./run_app.sh

# Open in browser:
# Training Lab: http://localhost:3839
# Production: http://localhost:3838
```

### **Key Files for Students:**

- `README.md` - Theory background
- `COMPARISON.md` - When to use what
- `R/mod_inverted_u_adjuster.R` - AGT example
- `R/mod_unified_sensitivity.R` - Resource model
- `R/mod_fatigue_adaptive.R` - Vigilance example

---

## 🔧 Maintenance Tasks

### **Weekly:**
- Check open issues
- Respond to questions
- Review PRs
- Update project board

### **Monthly:**
- Review milestone progress
- Update documentation
- Check for dependency updates
- Plan next features

### **Quarterly:**
- Major feature planning
- Publication updates
- Educational materials review
- Community engagement assessment

---

## 📞 Getting Help

### **Technical Issues:**
- Check `README.md` first
- Search existing issues
- Open new issue with template
- Ask in Discussions

### **Theory Questions:**
- Check theory docs in `README.md`
- Review research citations
- Open discussion
- Contact via GitHub profile

### **Educational Support:**
- Share your use case
- Open educational issue
- Join discussions
- Contribute materials

---

## 🎯 Goals & Metrics

### **Training Lab:**
- 📚 Number of educators using it
- 🔬 Research papers citing it
- 🎓 Student feedback
- 🌍 Community contributions

### **Production Dashboard:**
- 🏥 Hospital deployments
- 📊 Uptime percentage
- ✅ Features validated
- 👥 User satisfaction

---

## 💡 Tips & Tricks

### **Keyboard Shortcuts (GitHub):**
- `t` - File finder
- `l` - Go to line
- `w` - Switch branches
- `b` - Blame view
- `?` - See all shortcuts

### **Efficient Workflow:**
1. Star both repos for quick access
2. Watch repos for notifications
3. Use project board daily
4. Link issues across repos
5. Document decisions in issues

### **Best Practices:**
- Commit often with clear messages
- Test before pushing
- Update docs with code changes
- Respond to issues promptly
- Acknowledge contributors

---

## 📚 Key Documentation

| Document | Purpose | Location |
|----------|---------|----------|
| README | Main docs | Both repos |
| COMPARISON | Decision guide | Both repos |
| SETUP | Quick start | Training Lab |
| CONTRIBUTING | How to contribute | Training Lab |
| PROJECT_MANAGEMENT | Project guide | Training Lab |
| GITHUB_PROJECT_SETUP | Project setup | Training Lab |
| PROJECT_ECOSYSTEM | Architecture | Production |

---

## 🚀 Deployment Checklist

### **Before Pushing:**
- [ ] Code tested locally
- [ ] No console errors
- [ ] Documentation updated
- [ ] Commit message clear
- [ ] Related issues linked

### **After Pushing:**
- [ ] GitHub Actions passed
- [ ] README displays correctly
- [ ] Links work
- [ ] Project board updated

---

## 🎉 Success!

You now have everything you need to manage both repositories effectively!

**Remember:**
- 🧪 Training Lab = Research & Education
- 🏥 Production = Clinical & Reliability
- 📊 Project = Unified Roadmap

**Questions?** Check docs or open a discussion!

---

*Bookmark this page for quick reference!* 🔖


# GitHub Project Setup Guide

This guide explains how to create a unified GitHub Project to manage both the **Surgical Cognitive Dashboard** (production) and **Surgical Training Lab** (research) repositories.

---

## 📋 Overview

**GitHub Projects** provide a unified board to track issues, pull requests, and tasks across multiple repositories. This is perfect for managing related projects with different purposes.

**Our Setup:**
- **surgical-cognitive-dashboard** (Production/Clinical)
- **surgical-training-lab** (Research/Education)
- **GitHub Project** (Unified Roadmap)

---

## 🚀 Step-by-Step Setup

### **1. Create the GitHub Project**

1. Go to your GitHub profile: https://github.com/mohdasti
2. Click on **"Projects"** tab
3. Click **"New project"**
4. Choose **"Board"** layout
5. Name it: **"Surgical Cognitive Monitoring Suite"**
6. Description: *"Unified roadmap for production dashboard and research training lab"*
7. Click **"Create project"**

---

### **2. Configure Project Columns**

Default columns are fine, but you can customize:

**Recommended Columns:**
- 📥 **Backlog** - Ideas and future work
- 🔬 **Research (Training Lab)** - Experimental features
- 🏥 **Production (Dashboard)** - Clinical-grade features
- 🏗️ **In Progress** - Currently working
- 🧪 **Testing** - Ready for validation
- ✅ **Done** - Completed

**To customize:**
1. Click **"..."** on any column
2. Select **"Manage columns"**
3. Add/remove/rename as needed

---

### **3. Link Both Repositories**

#### **Add surgical-cognitive-dashboard:**
1. In your project, click **"+ Add item"**
2. Type `#` to search repositories
3. Select `mohdasti/surgical-cognitive-dashboard`
4. All existing issues/PRs will be available

#### **Add surgical-training-lab:**
1. First, create the GitHub repo (see below)
2. In project, click **"+ Add item"**
3. Select `mohdasti/surgical-training-lab`

---

### **4. Create surgical-training-lab GitHub Repo**

**From your local machine:**

```bash
# Navigate to training lab directory
cd /Users/mohdasti/Documents/GitHub/surgical-training-lab

# Initial commit
git add .
git commit -m "Initial commit: Surgical Training Lab with three cognitive paradigms"

# Create repo on GitHub (via web or CLI)
# Option A: GitHub Web Interface
# 1. Go to https://github.com/new
# 2. Name: surgical-training-lab
# 3. Description: Interactive research tool for exploring cognitive theory paradigms
# 4. Public repository
# 5. DO NOT initialize with README (we already have one)
# 6. Click "Create repository"

# Option B: GitHub CLI (if installed)
gh repo create surgical-training-lab --public --source=. --remote=origin --description="Interactive research tool for exploring cognitive theory paradigms"

# Push to GitHub
git remote add origin https://github.com/mohdasti/surgical-training-lab.git
git branch -M main
git push -u origin main
```

---

### **5. Set Up Project Automation**

**Auto-move cards:**

1. In your project, click **"..."** → **"Workflows"**
2. Enable these automations:
   - **Item added to project** → Move to "Backlog"
   - **Item reopened** → Move to "In Progress"
   - **Item closed** → Move to "Done"
   - **Pull request merged** → Move to "Done"

**Custom automation example:**
```yaml
# .github/workflows/project-automation.yml
name: Project Automation
on:
  issues:
    types: [opened, labeled]
  pull_request:
    types: [opened, labeled]

jobs:
  auto-assign:
    runs-on: ubuntu-latest
    steps:
      - name: Assign to project column
        uses: actions/add-to-project@v0.3.0
        with:
          project-url: https://github.com/users/mohdasti/projects/YOUR_PROJECT_NUMBER
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

---

### **6. Add Project Views**

**Create custom views for different perspectives:**

#### **View 1: By Repository**
- Group by: **Repository**
- Filter: None
- Sort: Priority

#### **View 2: By Type (Production vs Research)**
- Group by: **Labels**
- Labels: `production`, `research`, `education`
- Sort: Due date

#### **View 3: Timeline (Roadmap)**
- Layout: **Roadmap** (timeline view)
- Show milestones
- Group by: Sprint/Quarter

**To create views:**
1. Click **"+ New view"** in project
2. Choose layout (Board, Table, or Roadmap)
3. Apply filters and grouping
4. Name the view

---

### **7. Label Strategy**

**Create consistent labels across both repos:**

**Repository Labels:**
- 🏥 `production` - For surgical-cognitive-dashboard
- 🧪 `research` - For surgical-training-lab
- 📚 `education` - Teaching features

**Type Labels:**
- 🐛 `bug` - Something isn't working
- ✨ `enhancement` - New feature
- 📖 `documentation` - Documentation improvements
- 🔬 `theory` - Cognitive theory implementation

**Priority Labels:**
- 🔴 `critical` - Blocks production use
- 🟠 `high` - Important for next release
- 🟡 `medium` - Nice to have
- 🟢 `low` - Future consideration

**Apply to both repos:**
```bash
# For surgical-cognitive-dashboard
cd /Users/mohdasti/Documents/GitHub/surgical-cognitive-dashboard
# Add labels in GitHub Settings → Labels

# For surgical-training-lab
cd /Users/mohdasti/Documents/GitHub/surgical-training-lab
# Add labels in GitHub Settings → Labels
```

---

### **8. Create Milestones**

**Suggested milestones:**

**surgical-cognitive-dashboard:**
- v1.0 - Clinical Deployment Ready
- v1.1 - Hospital Pilot
- v2.0 - Multi-site Validation

**surgical-training-lab:**
- v0.1 - Initial Release
- v0.5 - Educational Package Complete
- v1.0 - Paper Submission Ready

**To create:**
1. Go to repo → Issues → Milestones
2. Click "New milestone"
3. Set title, due date, description
4. Assign issues to milestones

---

### **9. Project README**

Add a README to your project:

1. In project view, click **"..."** → **"Settings"**
2. Enable **"README"**
3. Add content:

```markdown
# Surgical Cognitive Monitoring Suite

This project tracks development for two related tools:

## 🏥 [Surgical Cognitive Dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard)
Production-ready real-time monitoring for clinical use.

**Status:** Production Ready  
**Focus:** Reliability, patient safety, zero errors

## 🧪 [Surgical Training Lab](https://github.com/mohdasti/surgical-training-lab)
Interactive research tool for exploring cognitive theories.

**Status:** Experimental  
**Focus:** Education, research, theory exploration

## Quick Links
- [Production Issues](link-to-filtered-view)
- [Research Issues](link-to-filtered-view)
- [Current Sprint](link-to-milestone)
- [Roadmap](link-to-roadmap-view)
```

---

### **10. Communication & Workflow**

**Issue workflow:**

1. **New Feature Idea:**
   - Open issue in appropriate repo
   - Tag with `research` or `production`
   - Add to project (auto-added)
   - Discuss in issue comments

2. **Research → Production Flow:**
   - Prototype in Training Lab
   - Validate with users
   - Create issue in Dashboard repo: "Port [feature] from Training Lab"
   - Link issues: "Closes mohdasti/surgical-training-lab#XX"

3. **Documentation:**
   - Keep READMEs in sync
   - Cross-reference between repos
   - Update project README when architecture changes

---

## 📊 Example Project Structure

```
Surgical Cognitive Monitoring Suite (Project)
│
├── 🏥 surgical-cognitive-dashboard (Repo)
│   ├── Issues
│   │   ├── #1 Deploy to hospital server
│   │   ├── #2 Add authentication system
│   │   └── #3 Validate HRV algorithm
│   └── PRs
│       └── #4 Fix GT table opacity
│
├── 🧪 surgical-training-lab (Repo)
│   ├── Issues
│   │   ├── #1 Add AGT parameter presets
│   │   ├── #2 Create lesson plan module
│   │   └── #3 Export threshold history
│   └── PRs
│       └── #4 Implement comparison mode
│
└── Views
    ├── 📋 All Items (Board)
    ├── 🏥 Production Only (Filtered Board)
    ├── 🧪 Research Only (Filtered Board)
    └── 📅 Roadmap (Timeline)
```

---

## 🎯 Best Practices

### **When to use Training Lab:**
- Prototyping new cognitive paradigms
- Testing experimental features
- Teaching and demonstrations
- Research hypothesis validation

### **When to promote to Dashboard:**
- Feature is stable and tested
- Clinical value is validated
- Code is production-quality
- Documentation is complete

### **Issue linking:**
```markdown
# In Training Lab issue:
"This is a prototype. If successful, will be promoted to production dashboard."

# In Dashboard issue:
"Based on successful prototype in mohdasti/surgical-training-lab#5"
```

---

## 🔗 Quick Links Template

Add this to your GitHub profile README:

```markdown
## Surgical Cognitive Monitoring

I'm developing a suite of tools for surgical cognitive monitoring:

- **[Production Dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard)** 🏥  
  Clinical-grade real-time monitoring
  
- **[Training Lab](https://github.com/mohdasti/surgical-training-lab)** 🧪  
  Interactive research tool
  
- **[Unified Project](https://github.com/users/mohdasti/projects/YOUR_PROJECT_NUMBER)** 📊  
  Roadmap and planning

All projects are open source under AGPL v3.
```

---

## 📞 Support

- **Production Dashboard Issues:** [Report here](https://github.com/mohdasti/surgical-cognitive-dashboard/issues)
- **Training Lab Issues:** [Report here](https://github.com/mohdasti/surgical-training-lab/issues)
- **General Questions:** Open a discussion in either repo

---

## 🎓 Resources

- [GitHub Projects Docs](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [Project Automation](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project)
- [Linking Issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue)

---

*This setup ensures both tools can evolve independently while maintaining a unified vision and roadmap.*


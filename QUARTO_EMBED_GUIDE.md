# 🌐 Embedding Surgical Training Lab in Quarto (Netlify)

This guide shows you how to embed the **Surgical Training Lab** interactive Shiny app into your Quarto case study hosted on Netlify.

---

## 🎯 Three Embedding Options

### **Option 1: ShinyApps.io Iframe** (⭐ Recommended for Case Studies)

**Best for:** Portfolio case studies, academic presentations, demos

**Pros:**
- ✅ Free tier available (25 active hours/month)
- ✅ Easy deployment
- ✅ Works perfectly with Netlify
- ✅ No server management

**Cons:**
- ⚠️ Apps sleep after inactivity (3-5 second wake-up)
- ⚠️ Limited to 1 GB RAM on free tier

#### **Step 1: Deploy to ShinyApps.io**

```r
# Install rsconnect
install.packages("rsconnect")

# Get credentials from: https://www.shinyapps.io/admin/#/tokens
rsconnect::setAccountInfo(
  name = "your-shinyapps-username",
  token = "YOUR_TOKEN_HERE",
  secret = "YOUR_SECRET_HERE"
)

# Deploy from your surgical-training-lab directory
setwd("/Users/mohdasti/Documents/GitHub/surgical-training-lab/surgical-training-lab")
rsconnect::deployApp(
  appName = "surgical-training-lab",
  appTitle = "Surgical Training Lab - Cognitive Theory Explorer"
)
```

After deployment, you'll get a URL like:  
`https://your-username.shinyapps.io/surgical-training-lab/`

#### **Step 2: Embed in Quarto Document**

In your `.qmd` file:

```markdown
## Interactive Theory Explorer

Explore three cognitive theory paradigms for adaptive threshold control in surgical monitoring. 
Adjust parameters in real-time to see how different theoretical frameworks affect alert behavior.

<iframe 
  src="https://your-username.shinyapps.io/surgical-training-lab/" 
  width="100%" 
  height="900px" 
  style="border:1px solid #ddd; border-radius:12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);"
  loading="lazy"
  title="Surgical Training Lab - Interactive Theory Explorer">
</iframe>

<p style="text-align: center; margin-top: 10px; color: #666; font-size: 0.9em;">
  <em>Interactive demo powered by Shiny. May take 3-5 seconds to wake up if inactive.</em>
</p>
```

---

### **Option 2: Shinylive (WebAssembly)** (🚀 Cutting Edge)

**Best for:** Fully static sites, no server costs, instant loading

**Pros:**
- ✅ Runs entirely in browser (WebAssembly)
- ✅ No server needed
- ✅ Instant loading (no sleep)
- ✅ Perfect for Netlify static hosting

**Cons:**
- ⚠️ Still experimental (as of 2025)
- ⚠️ Limited package support
- ⚠️ Larger initial download (~10-20 MB)

#### **Step 1: Convert App to Shinylive**

```r
# Install shinylive
install.packages("shinylive")

# Export app to WebAssembly
shinylive::export(
  appdir = "/Users/mohdasti/Documents/GitHub/surgical-training-lab/surgical-training-lab",
  destdir = "/path/to/your/quarto-site/shinylive-apps/training-lab"
)
```

#### **Step 2: Add to Quarto Site**

In your `_quarto.yml`:

```yaml
project:
  type: website
  resources:
    - shinylive-apps/
```

In your `.qmd` file:

```markdown
## Interactive Theory Explorer

{{< shinylive-iframe app=shinylive-apps/training-lab height=900 >}}
```

---

### **Option 3: Static Screenshots + Link** (📸 Fallback)

**Best for:** When you want to keep the case study lightweight

**Pros:**
- ✅ Fast page load
- ✅ No external dependencies
- ✅ Works on all devices

**Cons:**
- ⚠️ Not interactive in the case study
- ⚠️ Requires users to click through

#### **Create Screenshots**

```r
# In R, load the app and capture screenshots
library(webshot2)

# Screenshot of each paradigm
webshot2::webshot(
  "http://127.0.0.1:3839",
  file = "case_study/images/training-lab-inverted-u.png",
  vwidth = 1400,
  vheight = 900
)
```

#### **Embed in Quarto**

```markdown
## Theoretical Exploration Tool

I developed an interactive Shiny app for exploring three cognitive theory paradigms:

![Inverted-U Zone Adjuster](images/training-lab-inverted-u.png)

### Try It Yourself

[🧪 Launch Interactive Training Lab](https://your-username.shinyapps.io/surgical-training-lab/)

The tool allows you to:
- Adjust arousal zones in real-time
- Compare different cognitive theories
- Explore threshold behavior under various scenarios
```

---

## 📝 Recommended Quarto Structure

```markdown
---
title: "Surgical Cognitive Monitoring: A Case Study"
author: "Mohammad Dastgheib"
format:
  html:
    toc: true
    code-fold: true
    theme: cosmo
---

## Overview

This case study presents an end-to-end machine learning system for real-time 
cognitive state monitoring during surgery...

## The Problem

Attentional lapses during surgery are rare but critical events...

## Solution Architecture

### 1. Live Monitoring Dashboard

For production use, I developed the **Surgical Cognitive Dashboard** with:
- Real-time biosignal processing at 5 Hz
- XGBoost multi-class classifier
- SHAP explainability
- Calibrated probability estimates

[View Production Dashboard →](https://github.com/mohdasti/surgical-cognitive-dashboard)

### 2. **Theoretical Exploration Tool** ⬅️ EMBED HERE

Beyond monitoring, I created a research tool for exploring **cognitive theory paradigms**:

<iframe 
  src="https://your-username.shinyapps.io/surgical-training-lab/" 
  width="100%" 
  height="900px" 
  style="border:1px solid #ddd; border-radius:12px;"
  loading="lazy">
</iframe>

#### What This Tool Does

This interactive app demonstrates three cognitive theories:

1. **🎯 Inverted-U Zone Adjuster** (Adaptive Gain Theory)
   - Based on Aston-Jones & Cohen (2005)
   - Adjusts thresholds based on arousal zones
   
2. **🔀 Unified Sensitivity** (Resource Competition)
   - Based on Norman & Bobrow (1975)
   - Single sensitivity slider controls detection trade-offs
   
3. **⏰ Fatigue-Adaptive** (Vigilance Decrement)
   - Based on Warm et al. (2008)
   - Compensates for time-on-task effects

## Model Performance

The production dashboard achieves:
- **PR-AUC**: 0.92 (LOSO cross-validation)
- **Calibration ECE**: 0.0003
- **Lapse Detection**: 95% recall at 90% precision

## Key Insights

1. **Theory Matters**: Different cognitive theories lead to different threshold behaviors
2. **Context Adaptation**: No single threshold fits all surgical scenarios
3. **Explainability**: SHAP values make the black box interpretable

## Future Work

- Real sensor integration
- Clinical validation studies
- Multi-surgeon team monitoring

## Links

- [Production Dashboard (GitHub)](https://github.com/mohdasti/surgical-cognitive-dashboard)
- [Training Lab (GitHub)](https://github.com/mohdasti/surgical-training-lab)
- [Live Demo](https://your-username.shinyapps.io/surgical-training-lab/)
```

---

## 🎨 Styling Tips for Quarto

### **Responsive Iframe**

```css
/* Add to your Quarto CSS file */
.shiny-embed {
  position: relative;
  width: 100%;
  height: 900px;
  border: 1px solid #ddd;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  overflow: hidden;
}

@media (max-width: 768px) {
  .shiny-embed {
    height: 600px;
  }
}
```

Then use:

```markdown
<div class="shiny-embed">
  <iframe src="..." width="100%" height="100%"></iframe>
</div>
```

### **Loading State**

```html
<div style="position: relative;">
  <div id="loading-overlay" style="position: absolute; top: 50%; left: 50%; 
       transform: translate(-50%, -50%); z-index: 10; text-align: center;">
    <p>⏳ Loading interactive demo...</p>
    <small style="color: #666;">May take 3-5 seconds if app is sleeping</small>
  </div>
  
  <iframe 
    src="https://your-username.shinyapps.io/surgical-training-lab/" 
    width="100%" 
    height="900px"
    onload="document.getElementById('loading-overlay').style.display='none'">
  </iframe>
</div>
```

---

## 🔧 Troubleshooting

### **Issue: Iframe not displaying**

**Solution:** Check Netlify headers. Create `_headers` file in your Quarto site:

```
/*
  X-Frame-Options: ALLOWALL
  Content-Security-Policy: frame-src 'self' https://*.shinyapps.io https://*.netlify.app
```

### **Issue: App sleeps too often**

**Solution:** Upgrade to ShinyApps.io paid tier ($9/month for 500 hours) or use Shinylive.

### **Issue: Slow loading**

**Solution:** Add `loading="lazy"` to iframe and only load on scroll:

```html
<iframe loading="lazy" ...></iframe>
```

---

## 📊 Analytics Tracking

Track engagement with embedded app:

```html
<iframe 
  src="https://your-username.shinyapps.io/surgical-training-lab/" 
  onload="gtag('event', 'shiny_app_loaded', {'app_name': 'training_lab'})">
</iframe>
```

---

## 🚀 Deployment Checklist

- [ ] Deploy Shiny app to ShinyApps.io
- [ ] Test iframe in local Quarto preview
- [ ] Add responsive CSS for mobile
- [ ] Add loading state indicator
- [ ] Configure Netlify headers if needed
- [ ] Test on multiple browsers
- [ ] Add fallback link for mobile users
- [ ] Track analytics events

---

## 📞 Support

**Shiny App Issues:**  
GitHub: [surgical-training-lab/issues](https://github.com/mohdasti/surgical-training-lab/issues)

**Quarto Embedding Issues:**  
Docs: [Quarto HTML Basics](https://quarto.org/docs/output-formats/html-basics.html)

---

**Next Steps:** Deploy your app and embed it! 🚀


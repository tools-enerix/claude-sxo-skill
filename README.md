# SXO Skills for Claude Code

Two Claude Code skills for **Search Experience Optimization (SXO)** -- combining SEO with UX to align your pages with what Google's SERPs actually reward.

## Core Thesis

> Google's SERPs already show the optimal answer to the User Story -- you just need to read them backwards.

**Logic:** User Story &rarr; SERP layout &rarr; Your page must mirror the User Story.

**Goal:** Sustainably improve rankings **and** conversions by aligning your page with the search experience Google already rewards.

## Skills Overview

| Skill | Command | Purpose |
|-------|---------|---------|
| **SXO Analyzer** | `/sxo-analyzer <keyword> <url>` | SERP analysis, User Story derivation, gap analysis, HTML report |
| **SXO Builder** | `/sxo-builder <report.html>` | Before/after wireframe from SXO report with concrete placeholders |

### Recommended Workflow

```
1. /sxo-analyzer "your keyword" https://your-page.com
   → Generates sxo-report-keyword.html

2. /sxo-builder sxo-report-keyword.html
   → Generates sxo-wireframe-keyword.html
```

SXO Analyzer tells you **what's wrong**. SXO Builder shows you **how to fix it**.

---

## SXO Analyzer

### How It Works

```
/sxo-analyzer "your keyword" https://your-target-page.com
```

The skill runs a 6-step analysis:

| Step | What Happens |
|------|-------------|
| **0. Inputs** | Keyword, target URL, market/language, device |
| **1. Data Collection** | Live SERP data via DataForSEO MCP (autocomplete, ads, featured snippets, PAA, images, top-10 organic results). Falls back to manual input if API unavailable. |
| **2. SERP Analysis** | Systematic analysis of 7 SERP elements with observation + interpretation for each |
| **3. User Story** | Synthesizes all SERP signals into a User Story covering knowledge level, journey phase, emotional state, goals, and barriers |
| **4. Page Comparison** | 3-second first-screen test + gap analysis between SERP signals and target page content |
| **5. Recommendations** | Max 2 strategic options with effort/impact ratings and a clear recommendation |
| **6. Checklists** | Layout basics, on-page SEO hygiene, domain-level SEO hygiene |

### Output

A self-contained **HTML report** (`sxo-report-<keyword>.html`) with:
- Dark header gradient on light body for visual hierarchy
- Color-coded badges (pass/fail/warn) for all checks
- Gap analysis cards with priority ratings
- Recommendation cards with "EMPFOHLEN" banner
- Print-friendly stylesheet

---

## SXO Builder

### How It Works

```
/sxo-builder sxo-report-keyword.html
```

The skill reads an SXO Analyzer report and generates a visual page structure comparison:

| Step | What Happens |
|------|-------------|
| **1. Data Extraction** | Reads keyword, URL, User Story, gaps, recommendations, and checklist results from the SXO report |
| **2. Page Type Analysis** | Evaluates SERP signals to recommend a page type (Blog, Landing Page, Product Page, or Hybrid) |
| **3. IST Structure** | Derives current page structure via DataForSEO content parsing, maps problems from gap analysis |
| **4. SOLL Structure** | Builds optimized structure with ultra-concrete placeholders (what, how, why) |
| **5. Meta Optimizations** | Title, Description, Schema, E-E-A-T recommendations as HTML comments |
| **6. HTML Generation** | Produces a standalone HTML wireframe with stacked before/after layout |

### Key Features

- **Page Type Recommendation**: Evaluates 4 page types (Landing Page, Blog/Guide, Product Page, Hybrid) against SERP signals with decision matrix
- **Ultra-Concrete Placeholders**: Every placeholder contains exact text, design specs (colors, sizes, formats), and User Story reference -- a designer can implement without questions
- **Stacked Layout**: IST (before) shown full-width, SOLL (after) below -- no side-by-side comparison that compresses content
- **Priority Indicators**: High (red), medium (yellow), low (green), new section (blue)
- **Automatic Language Detection**: German or English based on report language, URL TLD, or keyword

### Output

A self-contained **HTML wireframe** (`sxo-wireframe-<keyword>.html`) with:
- IST column: Current page structure with color-coded problem annotations
- SOLL column: Optimized structure with actionable, concrete placeholders
- Page type recommendation cards with reasoning
- Meta optimization comments for the HTML head
- Gap references linking each placeholder to User Story elements

---

## Installation

### Option A: Install Both Skills

```bash
# Clone the repository
git clone https://github.com/tools-enerix/claude-sxo-skill.git
cd claude-sxo-skill

# Copy SXO Analyzer (root-level files)
mkdir -p ~/.claude/skills/sxo-analyzer/assets ~/.claude/skills/sxo-analyzer/references
cp SKILL.md ~/.claude/skills/sxo-analyzer/
cp assets/report-template*.html ~/.claude/skills/sxo-analyzer/assets/
cp references/*.md ~/.claude/skills/sxo-analyzer/references/

# Copy SXO Builder
cp -r sxo-builder ~/.claude/skills/sxo-builder
```

### Option B: Install Only SXO Analyzer

```bash
git clone https://github.com/tools-enerix/claude-sxo-skill.git
cd claude-sxo-skill
mkdir -p ~/.claude/skills/sxo-analyzer/assets ~/.claude/skills/sxo-analyzer/references
cp SKILL.md ~/.claude/skills/sxo-analyzer/
cp assets/report-template*.html ~/.claude/skills/sxo-analyzer/assets/
cp references/*.md ~/.claude/skills/sxo-analyzer/references/
```

### File Structure

```
claude-sxo-skill/
├── README.md
├── SKILL.md                              # SXO Analyzer skill
├── assets/
│   ├── report-template.html              # German report template
│   └── report-template-en.html           # English report template
├── references/
│   ├── dataforseo-api.md                 # MCP endpoint reference
│   └── output-format.md                  # Markdown fallback format
├── sxo-builder/                          # SXO Builder skill
│   ├── SKILL.md                          # Builder skill instructions
│   ├── assets/
│   │   ├── wireframe-template.html       # German wireframe template
│   │   └── wireframe-template-en.html    # English wireframe template
│   └── references/
│       └── section-mapping.md            # Gap-to-section mapping
└── examples/
    ├── sxo-report-content-marketing-roi-calculator.html     # Analyzer example
    └── sxo-wireframe-content-marketing-roi-calculator.html  # Builder example
```

### Requirements

- **Claude Code** with skill support
- **DataForSEO MCP server** (optional but recommended -- SXO Analyzer falls back to manual SERP input, SXO Builder uses it for content parsing)

## Examples

- **Analyzer**: [`examples/sxo-report-content-marketing-roi-calculator.html`](examples/sxo-report-content-marketing-roi-calculator.html) -- Full SXO analysis for "Content Marketing ROI Calculator"
- **Builder**: [`examples/sxo-wireframe-content-marketing-roi-calculator.html`](examples/sxo-wireframe-content-marketing-roi-calculator.html) -- Before/after wireframe for "Content Marketing ROI Calculator"

---

## SXO Analyzer vs. Blog Analyze -- When to Use Which

Both skills improve content performance, but they approach it from opposite directions and answer fundamentally different questions.

### The Key Difference

| | SXO Analyzer | Blog Analyze |
|---|---|---|
| **Direction** | Outside-in (SERP &rarr; Page) | Inside-out (Page &rarr; Score) |
| **Core question** | "Does my page match what Google rewards for this keyword?" | "How good is this blog post by objective quality standards?" |
| **Input** | Keyword + target URL | Blog post file or URL |
| **Data source** | Live Google SERPs via DataForSEO | The page content itself |

### SXO Analyzer: "What does the market want?"

SXO Analyzer starts from the **search results page** and works backwards. It asks:

- What does Google's SERP layout reveal about the searcher's intent?
- What emotional state, knowledge level, and journey phase does the searcher have?
- Does your page deliver what the SERPs signal as the ideal answer?
- Where are the gaps between search intent and page experience?

**Use SXO Analyzer when you want to understand:**
- Why your page isn't ranking despite good content
- What user needs the SERPs reveal that your page doesn't address
- Whether your page type (guide, tool, shop) matches what Google favors
- How to bridge the gap between information and conversion
- What your competitors' meta descriptions and SERP presence signal

**What you get:**
- SERP feature analysis (7 dimensions)
- A synthesized User Story with 8 elements (knowledge level, journey phase, emotional state, goals, barriers...)
- Gap analysis between SERP signals and your page
- 2 strategic recommendations with effort/impact ratings
- SEO hygiene checklists
- A visual HTML report

### SXO Builder: "How should I restructure my page?"

SXO Builder takes an SXO Analyzer report and transforms the findings into a **visual wireframe**. It asks:

- What page type fits the SERP signals best?
- What sections should the page have, and in what order?
- What exact content, CTAs, and trust signals go where?
- What's missing that needs to be added?

**Use SXO Builder when you want to:**
- Get a concrete restructuring plan for your page
- See before/after comparison of page sections
- Hand a designer or developer exact specifications
- Understand which page type (Blog, Landing Page, Hybrid) fits your keyword
- Prioritize which changes have the highest impact

**What you get:**
- Page type recommendation with reasoning (4 types evaluated)
- IST (before) structure with annotated problems
- SOLL (after) structure with ultra-concrete placeholders
- Meta optimization checklist (Title, Description, Schema, E-E-A-T)
- A visual HTML wireframe

### Blog Analyze: "How good is this content?"

Blog Analyze starts from the **content itself** and scores it against a fixed quality framework. It asks:

- Is the writing clear, well-structured, and engaging?
- Are SEO elements (title, headings, meta, links) properly configured?
- Does the post demonstrate E-E-A-T (Experience, Expertise, Authority, Trust)?
- Will AI systems (ChatGPT, Perplexity) be able to cite this content?
- Does the writing show signs of AI generation?

**Use Blog Analyze when you want to:**
- Score a blog post on a 0-100 scale before publishing
- Find specific technical issues (missing alt tags, heading hierarchy problems, broken links)
- Detect AI-generated content patterns (burstiness, phrase flagging, vocabulary diversity)
- Audit an entire blog directory in batch mode
- Get a prioritized fix list (Critical &rarr; High &rarr; Medium &rarr; Low)

**What you get:**
- 100-point score across 5 categories (Content Quality, SEO, E-E-A-T, Technical, AI Citation Readiness)
- AI content detection analysis
- Prioritized issue list with specific fixes
- Export in Markdown, JSON, or table format
- Batch mode for multi-post audits

### Decision Matrix

| Scenario | Use |
|----------|-----|
| "I have great content but don't rank" | **SXO Analyzer** |
| "Show me how to restructure the page" | **SXO Builder** |
| "Is this blog post ready to publish?" | **Blog Analyze** |
| "What does the searcher actually want for this keyword?" | **SXO Analyzer** |
| "What page type should I use?" | **SXO Builder** |
| "Score all 50 blog posts and find the weakest ones" | **Blog Analyze** |
| "Why do competitors rank above me?" | **SXO Analyzer** |
| "Give my designer a concrete restructuring plan" | **SXO Builder** |
| "Does this post have AI content detection issues?" | **Blog Analyze** |
| "Should my page be a guide, a tool, or a shop page?" | **SXO Analyzer** + **SXO Builder** |

### Using All Three Together

The skills complement each other in sequence:

1. **SXO Analyzer first** -- understand what the market wants for your target keyword
2. **SXO Builder second** -- get a concrete restructuring plan with page type recommendation
3. **Write or rewrite** your content based on the wireframe and User Story
4. **Blog Analyze last** -- verify the content meets quality standards before publishing

SXO Analyzer tells you *what's wrong*. SXO Builder shows you *how to fix it*. Blog Analyze tells you *if you fixed it well*.

---

## License

Internal skill -- not for redistribution.

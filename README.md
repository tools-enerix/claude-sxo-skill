# SXO Skills for Claude Code

Four Claude Code skills for **Search Experience Optimization (SXO)** -- combining SEO with UX to align your pages with what Google's SERPs actually reward.

## What is SXO?

**Search Experience Optimization (SXO)** combines SEO with UX. The core idea: Google's SERPs already show the optimal answer to the User Story -- you just need to read them backwards.

Traditional SEO asks: *"How do I rank higher?"*
SXO asks: *"What experience does the searcher expect, and does my page deliver it?"*

### How It Works -- A Concrete Example

You run a phone repair shop and want to rank for **"iPhone 13 screen repair"**. You start by creating a great blog post:

**The starting point: A perfect blog post**

You use `/blog-write` and get an excellent guide: "iPhone 13 Screen Repair -- Everything You Need to Know". It scores 90+ on Blog Analyze -- well-researched statistics, Answer-First structure, proper E-E-A-T signals, clean readability. By every content quality metric, it's a great piece.

But it doesn't rank. Why?

**Step 1: Read the SERPs backwards** (`/sxo-analyzer`)

You run an SXO analysis on your keyword. The skill pulls live Google data and discovers something your blog post missed entirely -- the **page type is wrong**:

- **Google Ads** dominate the top of the page with prices ($50-$150) and "same-day repair" -- searchers want to **book**, not read
- **Top-10 results**: 7 out of 10 are service/shop pages with booking forms, not blog posts -- Google has already decided this is a transactional keyword
- **PAA questions**: "How much does iPhone 13 screen repair cost?", "How long does it take?", "Where can I get it repaired near me?" -- the intent is action, not education
- **Featured Snippet**: A price comparison table -- Google rewards structured, scannable data here

From all these signals, the skill derives a **User Story**:
> *"Someone with a cracked iPhone 13 screen who wants to book a repair quickly. They're price-sensitive, slightly stressed, comparing options, and ready to act -- not looking for a 2,000-word guide."*

**This is the gap that content quality alone can't fix.** Your blog post is flawless content on the wrong page type. The SERPs want a service page with prices, a booking CTA, and trust signals -- not an informational guide.

**Step 2: Build the wireframe** (`/sxo-builder`)

The Builder takes that report and recommends a **Service Page** type. It creates a wireframe with:
- Hero with price range and "same-day repair" promise + booking CTA above the fold
- Trust bar: "2,500+ repairs completed" + Google rating + warranty badge
- Price/service table (because the Featured Snippet rewards structured data)
- Short explainer sections (not a full guide -- just enough to build confidence)
- FAQ from the PAA questions
- Prominent CTA: "Book your repair -- get a free quote in 30 seconds"

**Step 3: Produce the finished page** (`/sxo-page`)

SXO Page takes the wireframe, the report, and your existing blog post, then **merges them**: it keeps the best parts of your well-researched content (statistics, E-E-A-T signals, FAQ answers) but restructures everything into the service-page layout the SERPs demand. The result is a production-ready HTML page with schema markup, meta tags, and quality verification.

**The result:** Your page now matches what Google actually rewards for this keyword. The content quality from your blog post is preserved, but the page type, structure, and UX now mirror the search experience. You rank **and** convert -- because visitors land on a page that lets them do what they came to do: book a repair.

## Skills Overview

| Skill | Command | Purpose |
|-------|---------|---------|
| **SXO Analyzer** | `/sxo-analyzer <keyword> <url>` | SERP analysis, User Story derivation, gap analysis, HTML report |
| **SXO Builder** | `/sxo-builder <report.html>` | Before/after wireframe from SXO report with concrete placeholders |
| **SXO Page** | `/sxo-page` | Production-ready HTML/MD page from SXO report + wireframe |
| **SXO Persona** | `/sxo-persona` | Persona-Feedback-Dashboard from SXO report (+ optional SXO page) |

### Recommended Workflow

```
1. /sxo-analyzer "your keyword" https://your-page.com
   → Generates sxo-report-keyword.html

2. /sxo-builder sxo-report-keyword.html
   → Generates sxo-wireframe-keyword.html

3. /sxo-page
   → Generates sxo-page-keyword.html (production-ready page)

4. /sxo-persona
   → Generates sxo-persona-keyword.html (persona feedback dashboard)
```

SXO Analyzer tells you **what's wrong**. SXO Builder shows you **how to fix it**. SXO Page **builds the finished page**. SXO Persona shows you **who you're building it for**.

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
| **2. Page Type Analysis** | Evaluates SERP signals to recommend one of 8 page types (Landing Page, Blog/Guide, Product Page, Hybrid, Service Page, Comparison Page, Local Page, Tool Page) |
| **3. IST Structure** | Derives current page structure via DataForSEO content parsing, maps problems from gap analysis |
| **4. SOLL Structure** | Builds optimized structure with ultra-concrete placeholders (what, how, why) |
| **5. Meta Optimizations** | Title, Description, Schema, E-E-A-T recommendations as HTML comments |
| **6. HTML Generation** | Produces a standalone HTML wireframe with stacked before/after layout |

### Key Features

- **Page Type Recommendation**: Evaluates 8 page types against SERP signals with decision matrix
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

## SXO Page

### The Problem It Solves

You have two things that are each good on their own but better together:

1. **Great content** -- a well-written blog post (from `/blog-write` or your CMS) with researched statistics, proper structure, and good readability
2. **SXO intelligence** -- an SXO report and wireframe that know exactly what the search experience demands: which sections, which CTAs, which trust signals, in which order

SXO Page **merges both**. It takes your existing content and restructures it according to the wireframe's SOLL structure, filling gaps identified by the SXO analysis. If you don't have existing content, it produces everything from scratch using blog-write quality standards.

### How It Works

```
/sxo-page
```

The skill auto-detects files in the current working directory:

| Input | Source | Required? |
|-------|--------|-----------|
| `sxo-report-*.html` | From `/sxo-analyzer` | Yes (keyword, User Story, gaps, PAA questions) |
| `sxo-wireframe-*.html` | From `/sxo-builder` | Yes (SOLL structure, placeholders, page type) |
| Existing content (`.html` / `.md`) | From `/blog-write`, your CMS, or any source | Optional (reusable text, images, links) |

Place all files in the same directory and run `/sxo-page`. The skill then:

| Step | What Happens |
|------|-------------|
| **0. Input Detection** | Finds report, wireframe, and optional existing content. Detects language (DE/EN). |
| **1. Data Extraction** | Parses the wireframe's SOLL sections (structure, placeholders, gap references) and the report's SERP data (keyword, User Story, PAA questions, top-10). If existing content is present, extracts reusable text, images, and links. |
| **2. Content Research** | Spawns a blog-researcher agent for current statistics (Tier 1-3 sources only), royalty-free images, and competitive gaps |
| **3. Content Production** | For each wireframe section: writes new content or adapts existing content following Answer-First, E-E-A-T, readability targets (Flesch 60-70), and Citation Capsules. The wireframe structure is authoritative -- content is shaped to fit it, not the other way around. |
| **4. Page Assembly** | Generates HTML (with schema markup, OG tags, meta tags) or Markdown (with YAML frontmatter) |
| **5. Quality Check** | Verifies all wireframe sections covered, all placeholders resolved, all high-priority gaps addressed, and technical requirements met |

### Two Typical Workflows

**Workflow A: Content-first** (you already have a blog post)

```
1. /blog-write "iPhone 13 screen repair guide"
   → blog-post.html (well-written content)

2. /sxo-analyzer "iphone 13 screen repair" https://your-site.com/repair
   → sxo-report-iphone-13-screen-repair.html

3. /sxo-builder sxo-report-iphone-13-screen-repair.html
   → sxo-wireframe-iphone-13-screen-repair.html

4. /sxo-page
   → sxo-page-iphone-13-screen-repair.html
   (merges your blog content into the SXO-optimized structure)
```

**Workflow B: Analysis-first** (no existing content)

```
1. /sxo-analyzer "content marketing roi calculator" https://competitor.com/roi
   → sxo-report-content-marketing-roi-calculator.html

2. /sxo-builder sxo-report-content-marketing-roi-calculator.html
   → sxo-wireframe-content-marketing-roi-calculator.html

3. /sxo-page
   → sxo-page-content-marketing-roi-calculator.html
   (produces everything from scratch with blog-write quality)
```

### Key Features

- **Content Merging**: Takes existing blog content and restructures it into the SXO wireframe's optimal layout -- no content wasted, no gaps left open
- **Wireframe-Driven**: The SOLL structure from SXO Builder defines the page architecture. Content is shaped to fit, never the other way around.
- **Blog-Quality Content**: Applies blog-write techniques (Answer-First, statistics with sources, Citation Capsules, visual pacing) whether writing from scratch or adapting existing text
- **Placeholder Resolution**: Every wireframe placeholder (`[CTA]`, `[FAQ]`, `[KEYWORD]`) becomes real, production-ready HTML
- **User Story Tone**: Content tone adapts to knowledge level, emotional state, and journey phase from the User Story
- **Dual Format**: Output as HTML (with schema markup, OG tags) or Markdown (with YAML frontmatter)
- **Automatic Language Detection**: German or English based on report/wireframe language

### Output

A production-ready **HTML page** (`sxo-page-<keyword>.html`) or **Markdown file** with:
- Answer-First content with researched statistics and source citations
- FAQ section from PAA questions with FAQPage schema
- Page-type-specific schema markup (WebPage, BlogPosting, Service, LocalBusiness, WebApplication, FAQ, Breadcrumb)
- Meta tags (title, description, OG, Twitter Card)
- Citation Capsules for AI citability (ChatGPT, Perplexity, AI Overviews)
- Page-type-specific quality verification (e.g., pricing transparency for Service Pages, comparison matrix for Comparison Pages)

---

## SXO Persona

### The Problem It Solves

After analyzing the SERPs (Analyzer), restructuring the page (Builder), and producing the content (Page), one question remains: **Who exactly are you building this for -- and how well does your page serve each type of searcher?**

A single keyword attracts very different people. "Photovoltaik mit Warmepumpe kombinieren" brings the cost-conscious planner, the winter skeptic, the Altbau owner, and the experience seeker -- each with different expectations, barriers, and scoring criteria. SXO Persona makes these invisible audiences visible.

### How It Works

```
/sxo-persona
```

The skill auto-detects files in the current working directory:

| Input | Source | Required? |
|-------|--------|-----------|
| `sxo-report-*.html` | From `/sxo-analyzer` | Yes (SERP signals, User Story, gaps) |
| `sxo-page-*.html` | From `/sxo-page` | Optional (enables precise scoring against actual content) |
| URL argument | Provided by user | Optional (alternative to SXO page) |

| Step | What Happens |
|------|-------------|
| **0. Inputs** | Finds SXO report and optional SXO page. Detects language (DE/EN). |
| **1. Data Extraction** | Parses Related Searches, PAA questions, Google Ads signals, User Story elements, Gap Analysis, and First Screen Check from the report. |
| **2. Persona Derivation** | Clusters intent signals into 4-7 distinct personas using a rules-based taxonomy (10 primary + 5 secondary intent clusters). Each persona gets a name, demographics, search motive, and page expectations. |
| **3. Scoring** | Scores each persona on 4 dimensions (First Screen 0-25, Expectation 0-35, Barrier Reduction 0-25, Trust 0-15 = max 100). Scoring source: SXO page content > live URL > projected from report gaps. |
| **4. Dashboard** | Generates a visual HTML dashboard with summary, User Story, persona cards (sorted weakest-first), and aggregated action items. |

### Key Features

- **SERP-Driven Personas**: Not fictional marketing personas -- derived from actual search signals (Related Searches, PAA, Ads, User Story)
- **4-Dimension Scoring**: Each persona scored independently on First Screen relevance, expectation fulfillment, barrier reduction, and trust signals
- **Three Scoring Modes**: "Based on SXO Page" (most precise), "Based on Live URL", or "Projected from SXO Report" (when no page is available)
- **Aggregated Action Items**: Cross-persona improvements ranked by number of affected personas
- **Visual Dashboard**: Score circles, breakdown bars, color-coded cards (red/orange/amber/blue/green), print-friendly
- **Automatic Language Detection**: German or English based on report language

### Output

A self-contained **HTML dashboard** (`sxo-persona-<keyword>.html`) with:
- Summary card with average score, weakest/strongest persona, and scoring mode
- User Story from the SXO report
- 4-7 persona cards with score circle, intent badge, search motive, expectations, score breakdown bars, and improvement suggestions
- Top 5 action items with affected-persona tags
- Responsive layout (2-column desktop, 1-column mobile) and print styles

---

## Supported Page Types

SXO Builder and SXO Page support 8 page types. The Builder recommends the best fit based on SERP signals; SXO Page produces the corresponding layout with type-specific sections and schema.

| Page Type | When SERPs Show | Key Sections | Schema |
|-----------|----------------|--------------|--------|
| **Landing Page** | Strong transactional intent, CTAs, converters | Hero + CTA, trust bar, social proof | WebPage |
| **Blog / Guide** | Informational intent, how-tos, listicles | Content-heavy, images, FAQ, internal links | BlogPosting |
| **Product Page** | Commercial intent, prices, reviews | Product hero, features, pricing, reviews | Product, AggregateRating |
| **Hybrid** | Mixed intent (info + action) | CTA above fold + guide content below | WebPage |
| **Service Page** | Booking ads, service providers, price ranges | Service overview, pricing, process steps, booking CTA | Service |
| **Comparison Page** | "vs" queries, "best X", comparison tables | Feature matrix, pros/cons, recommendation | ItemPage |
| **Local Page** | Map pack, "near me", opening hours | Address, map, hours, local reviews, contact form | LocalBusiness |
| **Tool Page** | Calculator in Featured Snippet, "X calculator" | Tool (primary), result explanation, methodology | WebApplication |

---

## Installation

### Option A: Install All Four Skills

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

# Copy SXO Page
cp -r sxo-page ~/.claude/skills/sxo-page

# Copy SXO Persona
cp -r sxo-persona ~/.claude/skills/sxo-persona
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
├── sxo-page/                             # SXO Page skill
│   ├── SKILL.md                          # Page builder skill instructions
│   ├── assets/
│   │   ├── page-template.html            # German page template (CSS)
│   │   └── page-template-en.html         # English page template (CSS)
│   └── references/
│       ├── content-production.md          # Wireframe-to-content conversion rules
│       └── quality-gates.md              # Combined quality criteria
├── sxo-persona/                          # SXO Persona skill
│   ├── SKILL.md                          # Persona dashboard skill instructions
│   ├── assets/
│   │   ├── persona-template.html         # German persona dashboard template (CSS)
│   │   └── persona-template-en.html      # English persona dashboard template (CSS)
│   └── references/
│       └── persona-derivation.md         # Intent cluster taxonomy and derivation rules
└── examples/
    ├── sxo-report-content-marketing-roi-calculator.html     # Analyzer example
    ├── sxo-wireframe-content-marketing-roi-calculator.html  # Builder example
    └── sxo-page-content-marketing-roi-calculator.html       # Page example
```

### Requirements

- **Claude Code** with skill support
- **DataForSEO MCP server** (optional but recommended -- SXO Analyzer falls back to manual SERP input, SXO Builder uses it for content parsing)

## Examples

- **Analyzer**: [`examples/sxo-report-content-marketing-roi-calculator.html`](examples/sxo-report-content-marketing-roi-calculator.html) -- Full SXO analysis for "Content Marketing ROI Calculator"
- **Builder**: [`examples/sxo-wireframe-content-marketing-roi-calculator.html`](examples/sxo-wireframe-content-marketing-roi-calculator.html) -- Before/after wireframe for "Content Marketing ROI Calculator"
- **Page**: [`examples/sxo-page-content-marketing-roi-calculator.html`](examples/sxo-page-content-marketing-roi-calculator.html) -- Production-ready page for "Content Marketing ROI Calculator"

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
- Understand which page type fits your keyword (8 types available)
- Prioritize which changes have the highest impact

**What you get:**
- Page type recommendation with reasoning (8 types evaluated)
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
| "Build the finished page from my wireframe" | **SXO Page** |
| "Who exactly searches this keyword and what do they expect?" | **SXO Persona** |
| "Does my page serve all searcher types equally well?" | **SXO Persona** |
| "Does this post have AI content detection issues?" | **Blog Analyze** |
| "Should my page be a guide, a tool, or a shop page?" | **SXO Analyzer** + **SXO Builder** |
| "End-to-end: analyze, plan, produce, and validate" | **SXO Analyzer** + **SXO Builder** + **SXO Page** + **SXO Persona** |

### Using All Together

The skills complement each other. Two common sequences:

**Starting from scratch:**

1. **SXO Analyzer** -- understand what the market wants for your target keyword
2. **SXO Builder** -- get a concrete restructuring plan with page type recommendation
3. **SXO Page** -- produce the finished page with researched content, schema, and meta tags
4. **SXO Persona** -- validate the page against all searcher types with persona scoring
5. **Blog Analyze** -- verify the content meets quality standards before publishing

**Starting with existing content:**

1. **Blog Write** -- create a high-quality blog post with statistics, E-E-A-T, and proper structure
2. **SXO Analyzer** -- analyze the SERP to find what's missing for ranking
3. **SXO Builder** -- get the wireframe showing the optimal page structure
4. **SXO Page** -- merge your blog content into the SXO-optimized structure
5. **SXO Persona** -- check if the page serves all audience segments (cost-conscious, anxious, technical, local...)
6. **Blog Analyze** -- verify the final page meets quality standards

SXO Analyzer tells you *what's wrong*. SXO Builder shows you *how to fix it*. SXO Page *builds the finished page*. SXO Persona shows you *who you're building it for*. Blog Analyze tells you *if you built it well*.

---

## License

Internal skill -- not for redistribution.

# SXO Skills for Claude Code

Four Claude Code skills for **Search Experience Optimization (SXO)** -- combining SEO with UX to align your pages with what Google's SERPs actually reward.

## What is SXO?

**Search Experience Optimization (SXO)** combines SEO with UX. The core idea: Google's SERPs already show the optimal answer to the User Story -- you just need to read them backwards.

Traditional SEO asks: *"How do I rank higher?"*
SXO asks: *"What experience does the searcher expect, and does my page deliver it?"*

---

## Skills Overview

| Skill | Command | Purpose |
|-------|---------|---------|
| **SXO Analyzer** | `/sxo-analyze <keyword> <url>` | SERP analysis, User Story derivation, gap analysis, HTML report |
| **SXO Wireframe** | `/sxo-wireframe <report.html>` | Before/after wireframe from SXO report with concrete placeholders |
| **SXO Prototype** | `/sxo-prototype` | Production-ready HTML/MD page from SXO report + wireframe |
| **SXO Persona** | `/sxo-persona` | Persona feedback dashboard with scoring per searcher type |

### Recommended Workflow

```
1. /sxo-analyze "your keyword" https://your-page.com
   -> Generates sxo-report-keyword.html

2. /sxo-wireframe sxo-report-keyword.html
   -> Generates sxo-wireframe-keyword.html

3. /sxo-prototype
   -> Generates sxo-page-keyword.html (production-ready page)

4. /sxo-persona
   -> Generates sxo-persona-keyword.html (persona feedback dashboard)
```

SXO Analyzer tells you **what's wrong**. SXO Wireframe shows you **how to fix it**. SXO Prototype **builds the finished page**. SXO Persona shows you **who you're building it for**.

---

## How It Works -- A Concrete Example

You run a phone repair shop and want to rank for **"iPhone 13 screen repair"**. You start by creating a great blog post:

**The starting point: A perfect blog post**

You use `/blog-write` and get an excellent guide: "iPhone 13 Screen Repair -- Everything You Need to Know". It scores 90+ on Blog Analyze -- well-researched statistics, Answer-First structure, proper E-E-A-T signals, clean readability.

But it doesn't rank. Why?

**Step 1: Read the SERPs backwards** (`/sxo-analyze`)

You run an SXO analysis on your keyword. The skill pulls live Google data and discovers the **page type is wrong**:

- **Google Ads** dominate with prices ($50-$150) and "same-day repair" -- searchers want to **book**, not read
- **Top-10 results**: 7 out of 10 are service/shop pages with booking forms, not blog posts
- **PAA questions**: "How much does it cost?", "How long does it take?", "Where near me?" -- the intent is action, not education
- **Featured Snippet**: A price comparison table -- Google rewards structured, scannable data

From all these signals, the skill derives a **User Story**:
> *"Someone with a cracked iPhone 13 screen who wants to book a repair quickly. They're price-sensitive, slightly stressed, comparing options, and ready to act."*

**Step 2: Build the wireframe** (`/sxo-wireframe`)

The Wireframe recommends a **Service Page** type and creates a wireframe with:
- Hero with price range and "same-day repair" promise + booking CTA above the fold
- Trust bar: "2,500+ repairs completed" + Google rating + warranty badge
- Price/service table (because the Featured Snippet rewards structured data)
- FAQ from the PAA questions
- Prominent CTA: "Book your repair -- get a free quote in 30 seconds"

**Step 3: Produce the finished page** (`/sxo-prototype`)

SXO Prototype takes the wireframe, the report, and your existing blog post, then **merges them**: it keeps the best parts of your well-researched content but restructures everything into the service-page layout the SERPs demand.

**The result:** Your page now matches what Google actually rewards for this keyword. You rank **and** convert.

---

## SXO Analyzer

```
/sxo-analyze "your keyword" https://your-target-page.com
```

Runs a 6-step analysis:

| Step | What Happens |
|------|-------------|
| **0. Inputs** | Keyword, target URL, market/language, device |
| **1. Data Collection** | Live SERP data via DataForSEO MCP (autocomplete, ads, featured snippets, PAA, images, top-10). Falls back to manual input if API unavailable. |
| **2. SERP Analysis** | Systematic analysis of 7 SERP elements with observation + interpretation |
| **3. User Story** | Synthesizes all SERP signals into a User Story (knowledge level, journey phase, emotional state, goals, barriers) |
| **4. Page Comparison** | 3-second first-screen test + gap analysis between SERP signals and target page |
| **5. Recommendations** | Max 2 strategic options with effort/impact ratings and a clear recommendation |
| **6. Checklists** | Layout basics, on-page SEO hygiene, Core Web Vitals, domain-level SEO hygiene |

**Output:** Self-contained HTML report (`sxo-report-<keyword>.html`) with color-coded badges, gap analysis cards, recommendation cards, and print-friendly stylesheet.

---

## SXO Wireframe

```
/sxo-wireframe sxo-report-keyword.html
```

Reads an SXO Analyzer report and generates a visual page structure comparison:

| Step | What Happens |
|------|-------------|
| **1. Data Extraction** | Reads keyword, URL, User Story, gaps, recommendations from the SXO report |
| **2. Page Type Analysis** | Evaluates SERP signals to recommend one of 8 page types |
| **3. IST Structure** | Derives current page structure via DataForSEO content parsing |
| **4. SOLL Structure** | Builds optimized structure with ultra-concrete placeholders (what, how, why) |
| **5. Meta Optimizations** | Title, Description, Schema, E-E-A-T recommendations |
| **6. HTML Generation** | Produces a standalone HTML wireframe with stacked before/after layout |

**Key Features:**
- **8 Page Types**: Landing Page, Blog/Guide, Product, Hybrid, Service, Comparison, Local, Tool
- **Ultra-Concrete Placeholders**: Every placeholder contains exact text, design specs, and User Story reference -- a designer can implement without questions
- **Priority Indicators**: High (red), medium (yellow), low (green), new section (blue)

**Output:** Self-contained HTML wireframe (`sxo-wireframe-<keyword>.html`) with IST (before) and SOLL (after) structures.

---

## SXO Prototype

```
/sxo-prototype
```

Auto-detects SXO report + wireframe in the current directory and produces a finished page:

| Step | What Happens |
|------|-------------|
| **0. Input Detection** | Finds report, wireframe, and optional existing content. Detects language. |
| **1. Data Extraction** | Parses wireframe SOLL sections and report SERP data |
| **2. Content Research** | Spawns a blog-researcher agent for current statistics, images, and competitive gaps |
| **3. Content Production** | Writes content following Answer-First, E-E-A-T, readability targets (Flesch 60-70) |
| **4. Page Assembly** | Generates HTML (with schema markup, OG tags) or Markdown (with YAML frontmatter) |
| **5. Quality Check** | Verifies wireframe coverage, placeholder resolution, and gap addressal |

**Key Features:**
- **Content Merging**: Restructures existing blog content into the SXO wireframe's optimal layout
- **Wireframe-Driven**: The SOLL structure defines the architecture. Content is shaped to fit.
- **Hybrid Two-Zone Architecture**: Zone 1 (Conversion) above the fold + Zone 2 (SEO/Content) below
- **Dual Format**: Output as HTML or Markdown

**Output:** Production-ready HTML page (`sxo-page-<keyword>.html`) or Markdown file with schema markup, meta tags, and Citation Capsules for AI citability.

---

## SXO Persona

```
/sxo-persona
```

Can run with an SXO report, standalone with URL + keyword, or with an SXO page for precise scoring:

| Step | What Happens |
|------|-------------|
| **0. Inputs** | Finds SXO report and optional SXO page. Also works standalone with URL + keyword. |
| **1. Data Extraction** | Parses Related Searches, PAA, Google Ads signals, User Story, Gap Analysis |
| **2. Persona Derivation** | Clusters intent signals into 4-7 distinct personas with name, demographics, search motive |
| **3. Scoring** | Scores each persona on 4 dimensions (max 100): First Screen, Expectation, Barrier Reduction, Trust |
| **4. Dashboard** | Generates visual HTML dashboard with persona cards, score breakdowns, and action items |

**Key Features:**
- **SERP-Driven Personas**: Derived from actual search signals, not fictional marketing personas
- **4-Dimension Scoring**: First Screen (0-25), Expectation (0-35), Barrier Reduction (0-25), Trust (0-15)
- **Three Scoring Modes**: Based on SXO Page (most precise), Live URL, or projected from report
- **Standalone Mode**: Works with just URL + keyword (no SXO report required)
- **Avatar Generation**: Optional flat-illustration avatar images via Nano Banana MCP

**Output:** Self-contained HTML dashboard (`sxo-persona-<keyword>.html`) with summary, persona cards (sorted weakest-first), and top 5 action items.

---

## Supported Page Types

| Page Type | When SERPs Show | Schema |
|-----------|----------------|--------|
| **Landing Page** | Strong transactional intent, CTAs | WebPage |
| **Blog / Guide** | Informational intent, how-tos | BlogPosting |
| **Product Page** | Commercial intent, prices, reviews | Product, AggregateRating |
| **Hybrid** | Mixed intent (info + action), two-zone layout | WebPage |
| **Service Page** | Booking ads, service providers, price ranges | Service |
| **Comparison Page** | "vs" queries, "best X", comparison tables | ItemPage |
| **Local Page** | Map pack, "near me", opening hours | LocalBusiness |
| **Tool Page** | Calculator in Featured Snippet, "X calculator" | WebApplication |

---

## Installation

```bash
git clone https://github.com/tools-enerix/claude-sxo-skill.git
cd claude-sxo-skill
bash install.sh
```

To uninstall:

```bash
bash uninstall.sh
```

### Requirements

- **Claude Code** with skill support
- **DataForSEO MCP server** (optional but recommended -- falls back to manual SERP input)

### File Structure

```
claude-sxo-skill/
|-- install.sh / uninstall.sh
|-- SKILL.md                          # sxo-analyze
|-- assets/                           # Report templates (DE/EN)
|-- references/                       # API reference, output format, CWV thresholds, fallback mode
|-- sxo-wireframe/                    # sxo-wireframe + assets + references
|-- sxo-prototype/                    # sxo-prototype + assets + references
|-- sxo-persona/                      # sxo-persona + assets + references
|-- examples/                         # Full example outputs (Analyzer, Wireframe, Prototype)
```

## Examples

- **Analyzer**: [`examples/sxo-report-content-marketing-roi-calculator.html`](examples/sxo-report-content-marketing-roi-calculator.html)
- **Wireframe**: [`examples/sxo-wireframe-content-marketing-roi-calculator.html`](examples/sxo-wireframe-content-marketing-roi-calculator.html)
- **Prototype**: [`examples/sxo-page-content-marketing-roi-calculator.html`](examples/sxo-page-content-marketing-roi-calculator.html)

---

## Bilingual Support

All four skills auto-detect language from keyword, URL TLD, and market:
- **German**: `.de`, `.at`, `.ch` domains or German keywords
- **English**: `.com`, `.co.uk`, `.io` domains or English keywords

Each skill has dedicated templates for both languages (DE/EN).

---

## License

MIT

# SXO Analyzer -- Claude Code Skill

A Claude Code skill for **Search Experience Optimization (SXO)** analysis. SXO combines SEO with UX by reverse-engineering Google SERPs to derive the real User Story behind a search query, then comparing your target page against it.

## Core Thesis

> Google's SERPs already show the optimal answer to the User Story -- you just need to read them backwards.

**Logic:** User Story → SERP layout → Your page must mirror the User Story.

**Goal:** Sustainably improve rankings **and** conversions by aligning your page with the search experience Google already rewards.

## How It Works

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

A self-contained **HTML report** with:
- Dark header gradient on light body for visual hierarchy
- Color-coded badges (pass/fail/warn) for all checks
- Gap analysis cards with priority ratings
- Recommendation cards with "EMPFOHLEN" banner
- Print-friendly stylesheet

## Installation

Copy the skill folder to your Claude Code skills directory:

```bash
# The skill goes here:
~/.claude/skills/sxo-analyzer/
```

### File Structure

```
sxo-analyzer/
├── SKILL.md                        # Main skill instructions
├── assets/
│   └── report-template.html        # HTML report template
└── references/
    ├── dataforseo-api.md           # MCP endpoint reference
    └── output-format.md            # Markdown fallback format
```

### Requirements

- **Claude Code** with skill support
- **DataForSEO MCP server** (optional but recommended -- the skill falls back to manual SERP input)

## Example

See [`examples/sxo-report-bifaziale-pv-module.html`](examples/sxo-report-bifaziale-pv-module.html) for a complete analysis of the keyword "Bifaziale PV Module" against an enerix.de landing page.

---

## SXO Analyzer vs. Blog Analyze -- When to Use Which

Both skills improve content performance, but they approach it from opposite directions and answer fundamentally different questions.

### The Key Difference

| | SXO Analyzer | Blog Analyze |
|---|---|---|
| **Direction** | Outside-in (SERP → Page) | Inside-out (Page → Score) |
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
- Get a prioritized fix list (Critical → High → Medium → Low)

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
| "Is this blog post ready to publish?" | **Blog Analyze** |
| "What does the searcher actually want for this keyword?" | **SXO Analyzer** |
| "Score all 50 blog posts and find the weakest ones" | **Blog Analyze** |
| "Why do competitors rank above me?" | **SXO Analyzer** |
| "Does this post have AI content detection issues?" | **Blog Analyze** |
| "Should my page be a guide, a tool, or a shop page?" | **SXO Analyzer** |
| "Are my heading hierarchy and meta tags correct?" | **Blog Analyze** |
| "What User Story does Google's SERP reveal?" | **SXO Analyzer** |
| "Does this post meet E-E-A-T standards?" | **Blog Analyze** |

### Using Both Together

The skills complement each other well in sequence:

1. **SXO Analyzer first** -- understand what the market wants for your target keyword
2. **Write or rewrite** your content based on the User Story and gap analysis
3. **Blog Analyze second** -- verify the content meets quality standards before publishing

SXO tells you *what to build*. Blog Analyze tells you *if you built it well*.

---

## License

Internal skill -- not for redistribution.

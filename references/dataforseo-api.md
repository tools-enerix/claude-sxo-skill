# DataForSEO MCP-Endpunkte fuer SXO-Analyse

## SERP Organic (Pflicht)

Tool: `mcp__dataforseo__serp_organic_live_advanced`

Parameter:
- `keyword`: Das Ziel-Keyword
- `language_code`: "de"
- `location_code`: 2276 (Deutschland)
- `device`: "desktop" oder "mobile"
- `depth`: 10

Liefert: Top-10 organische Ergebnisse mit URL, Title, Description, Position.
Enthaelt auch SERP-Features wie Featured Snippets, PAA, Ads, Images, Local Pack.

## On-Page Content Parsing (Optional)

Tool: `mcp__dataforseo__on_page_content_parsing`

Parameter:
- `url`: Die Zielseiten-URL

Liefert: Geparstes HTML der Zielseite (H1, H2, Meta-Tags, Content).

## On-Page Lighthouse (Optional)

Tool: `mcp__dataforseo__on_page_lighthouse`

Parameter:
- `url`: Die Zielseiten-URL

Liefert: Core Web Vitals und Performance-Metriken.

## Backlinks Summary (Optional)

Tool: `mcp__dataforseo__backlinks_summary`

Parameter:
- `target`: Die Domain oder URL

Liefert: Backlink-Profil fuer SEO-Hygiene-Check.

## Hinweise

- `serp_organic_live_advanced` liefert in der Regel alle SERP-Features
  (Ads, Featured Snippets, PAA, Images, Related Searches) in einer Abfrage
- Separate Endpunkte fuer Autocomplete, PAA etc. nur nutzen wenn die
  Haupt-SERP-Abfrage diese Daten nicht enthaelt
- Location Code 2276 = Deutschland, 2040 = Oesterreich, 2756 = Schweiz

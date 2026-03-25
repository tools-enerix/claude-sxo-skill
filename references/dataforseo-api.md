# DataForSEO MCP-Endpunkte fuer SXO-Analyse

## SERP Organic (Pflicht)

Tool: `mcp__dataforseo__serp_organic_live_advanced`

Parameter:
- `keyword`: Das Ziel-Keyword
- `language_code`: "de" (oder "en")
- `location_name`: "Germany" (oder "United States", "Austria", etc.)
- `device`: "desktop" oder "mobile"
- `depth`: 10
- `people_also_ask_click_depth`: 2

Liefert: Top-10 organische Ergebnisse mit URL, Title, Description, Position.
Enthaelt auch SERP-Features wie Featured Snippets, PAA, Images, Local Pack.

**Hinweis zu Ads:** `paid`-Items werden selten zurueckgeliefert, da Google Anzeigen fuer Datacenter-IPs haeufig unterdrueckt. Nutze `kw_data_google_ads_search_volume` als zuverlaessige Alternative.

## Google Ads Keyword-Daten (Pflicht)

Tool: `mcp__dataforseo__kw_data_google_ads_search_volume`

Parameter:
- `keywords`: [Das Ziel-Keyword] (Array, max 1000)
- `language_code`: "de" (oder "en")
- `location_name`: "Germany" (oder je nach Markt)

Liefert:
- `cpc`: Cost Per Click in USD — zeigt kommerziellen Wert des Keywords
- `competition`: "Low" / "Medium" / "High" — Wettbewerbsintensitaet bei Ads
- `competition_index`: 0-100 — numerischer Wettbewerbswert
- `search_volume`: Monatliches Suchvolumen (Google Ads Daten)

**Wichtig:** Diese Daten kommen direkt aus der Google Ads API, nicht aus SERP-Crawling.
CPC > 0 beweist zuverlaessig, dass Werbetreibende aktiv auf dieses Keyword bieten.

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

- `serp_organic_live_advanced` liefert SERP-Features (Featured Snippets, PAA, Images,
  Related Searches) in einer Abfrage. Ads (`paid`) werden selten geliefert (Datacenter-IP-Limitation).
- `kw_data_google_ads_search_volume` immer parallel zur SERP-Abfrage aufrufen —
  liefert zuverlaessige Ads-Daten (CPC, Competition) direkt aus der Google Ads API.
- Separate Endpunkte fuer Autocomplete, PAA etc. nur nutzen wenn die
  Haupt-SERP-Abfrage diese Daten nicht enthaelt
- Location-Parameter: `location_name` verwenden (z.B. "Germany", "Austria", "Switzerland"),
  nicht `location_code`

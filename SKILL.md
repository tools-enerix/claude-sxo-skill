---
name: sxo-analyze
description: >
  Vollstaendige SXO-Analyse (Search Experience Optimization) fuer ein gegebenes
  Keyword und eine Zielseite. Analysiert SERPs via DataForSEO MCP (Autocomplete,
  Ads, Featured Snippets, PAA, Bilder, Top-10), leitet die User Story ab und
  gleicht sie mit der Zielseite ab. Gibt konkrete Optimierungsempfehlungen und
  SEO-Hygiene-Checklisten aus. Fallback auf manuelle SERP-Eingabe wenn DataForSEO
  nicht verfuegbar. Supports German and English -- auto-detects language from
  keyword, URL TLD, and market. Use when user says "SXO-Analyse", "SXO analysis",
  "Search Experience Optimization", "analysiere die Search Experience",
  "analyze search experience", "was zeigen die SERPs", "what do the SERPs show",
  "SXO-Report", "SXO report", "SERP-Analyse fuer", "SERP analysis for",
  "User Story aus SERPs", "user story from SERPs", "Zielseiten-Abgleich",
  "target page comparison", or "SXO Check".
  Do NOT use for: general SEO audits (use seo-audit), technical SEO checks
  (use seo-technical), or blog content scoring (use blog-analyze).
argument-hint: "[keyword] [zielseite-url]"
allowed-tools:
  - Read
  - Write
  - Bash
  - WebFetch
  - Glob
  - Grep
  - Agent
  - "mcp__dataforseo__*"
---

# SXO-Analyzer -- Vollstaendige Search Experience Optimization

SXO kombiniert SEO mit UX. Die zentrale These:

> **Google zeigt in den SERPs bereits die optimale Antwort auf die User Story -- man muss sie nur rueckwaerts ablesen.**

Logik: **User Story -> SERP-Ausspielung -> Zielseite muss User Story widerspiegeln.**

Ziel: Durch die auf die User Story abgestimmte Zielseite Rankings nachhaltig verbessern **und** Conversions steigern.

---

## Schritt 0: Inputs klaeren

Bevor die Analyse beginnt, stelle sicher, dass folgende Inputs vorliegen. Falls nicht, frag nach:

```
KEYWORD:          [z.B. "PV Ausrichtung Rechner"]
ZIELSEITE-URL:    [z.B. "https://www.enerix.de/photovoltaik-rechner/"]
MARKT/SPRACHE:    [z.B. Deutschland / de]  <- Standard: Deutschland
DEVICE:           [Desktop / Mobile]       <- Standard: Desktop
```

### Spracherkennung / Language Detection

Erkenne die Report-Sprache automatisch anhand folgender Signale (in Prioritaetsreihenfolge):

1. **Explizite Angabe:** User gibt Sprache/Markt vor (z.B. "US / en", "UK / en")
2. **URL-TLD:** `.com`, `.co.uk`, `.io`, `.org` -> Englisch; `.de`, `.at`, `.ch` -> Deutsch
3. **Keyword-Sprache:** Englische Keywords -> Englischer Report; deutsche Keywords -> Deutscher Report
4. **Location Code:** 2840 (USA), 2826 (UK), 2036 (Australien) -> Englisch; 2276 (DE), 2040 (AT), 2756 (CH) -> Deutsch

```
IF Sprache = Englisch:
  -> Verwende Template `assets/report-template-en.html`
  -> Schreibe ALLE Analysetexte auf Englisch
  -> Verwende englische SERP-Typ-Labels: Guide, Shop, Feature, Video, Comparison, Forum, Tool, News
  -> Verwende englische Platzhalter-Namen (siehe EN-Platzhalter-Referenz unten)
  -> DataForSEO: language_code = "en", location_code je nach Markt
ELSE:
  -> Verwende Template `assets/report-template.html` (Deutsch)
  -> Standardverhalten wie bisher
```

---

## Schritt 1: Datenbeschaffung via DataForSEO MCP

### 1a -- MCP-Verfuegbarkeit pruefen

```
IF DataForSEO MCP verfuegbar:
  -> Fuehre automatische SERP-Abfrage durch (siehe 1b)
ELSE:
  -> Aktiviere Fallback-Modus (siehe 1c)
```

### 1b -- Automatische Datenbeschaffung (MCP aktiv)

**WICHTIG: Eine einzige SERP-Abfrage liefert ALLE Daten.**

Rufe `serp_organic_live_advanced` mit diesen Parametern auf:

```
keyword:                      Das Ziel-Keyword
language_code:                "de" (oder "en" je nach Sprache)
location_name:                "Germany" (oder je nach Markt)
device:                       "desktop" (oder "mobile")
depth:                        10
people_also_ask_click_depth:  2    <- WICHTIG: liefert mehr PAA-Fragen
```

Diese EINE Abfrage liefert alle folgenden SERP-Elemente (als `type`-Feld in der Response):

| Response-Typ | Analyse-Bereich | Immer vorhanden? |
|---|---|---|
| `organic` | Top-10 Ergebnisse | Ja |
| `related_searches` | Verwandte Suchanfragen (nutze fuer "Autocomplete/Related") | Ja |
| `people_also_ask` | Aehnliche Fragen / PAA-Box | Meist |
| `people_also_search` | Aehnliche Suchanfragen nach Klick | Manchmal |
| `paid` | Google Ads (Headline, Description) — selten bei API-Crawlern, Fallback: Google Ads Keyword-Daten | Selten |
| `featured_snippet` | Featured Snippet Inhalt | Manchmal |
| `knowledge_graph` | Knowledge Graph / Wikipedia-Definition | Manchmal |
| `popular_products` | Google Shopping Produkte mit Preisen | Manchmal |
| `compare_sites` | Vergleichsseiten (idealo, Check24 etc.) | Manchmal |
| `local_pack` | Lokale Ergebnisse mit Bewertungen | Manchmal |
| `images` | Top-Bilder mit Quelldomain | Manchmal |

**Zusaetzlich (parallel):**

Rufe diese Tools **parallel** zur SERP-Abfrage auf, um Wartezeit zu minimieren:

1. `kw_data_google_ads_search_volume` -> Google Ads Keyword-Daten (fuer Schritt 2b)
   - Parameter: `keywords` = [Das Ziel-Keyword], `language_code` = "de"/"en", `location_name` = "Germany" (oder je nach Markt)
   - Liefert: CPC, Competition (Low/Medium/High), Competition Index (0-100), Search Volume
   - **WICHTIG:** Diese Daten kommen direkt aus der Google Ads API und sind unabhaengig vom SERP-Crawling. Sie beweisen zuverlaessig, ob fuer das Keyword Ads geschaltet werden.

**Zusaetzlich (parallel, wenn Zielseite angegeben):**

2. `on_page_content_parsing` -> Zielseiten-Inhalt parsen (fuer Schritt 4)
3. `on_page_lighthouse` -> Core Web Vitals + Accessibility inkl. Bilder-Alt-Check (fuer Schritt 6)
   - Parameter: `url` = Zielseite, `full_data` = true
4. `on_page_instant_pages` -> Detaillierte On-Page-Daten inkl. Bilder-Zaehlung (fuer Schritt 6)
   - Parameter: `url` = Zielseite, `enable_javascript` = true

**Handling grosser Zielseiten-Inhalte:** Wenn `on_page_content_parsing` grosse Ergebnisse liefert (>20KB), fokussiere auf: H1, H2-Struktur, erste 3 Absaetze, Tabellen, CTAs, interne Links. Ignoriere Footer-Navigation, Sidebar-Widgets und repetitive Boilerplate.

### 1c -- Fallback-Modus (MCP nicht verfuegbar)

Lies `references/fallback-mode.md` fuer die vollstaendigen Fallback-Nachrichten (DE/EN). Bitte den User um manuelle SERP-Daten (Autocomplete, Ads, PAA, Top-5, Features, First Screen). Screenshots werden ebenfalls akzeptiert.

### 1d -- Lighthouse- und Instant-Pages-Daten aufbereiten

Aus den Lighthouse- und Instant-Pages-Responses extrahiere Core Web Vitals, Performance Scores und Bilder-Accessibility-Daten.

Lies `references/cwv-thresholds.md` fuer die vollstaendigen Schwellwerte, Feld-Pfade und Scoring-Logik.

Lies `references/dataforseo-api.md` fuer weitere optionale Endpunkte (Backlinks).

### 1e -- Above-the-Fold Screenshot (parallel)

Erstelle einen Screenshot des sichtbaren Bereichs (Above-the-Fold) der Zielseite. Dieser wird als visueller Kontext im HTML-Report eingebettet.

Lies `references/screenshot-capture.md` fuer Capture-Befehl, Base64-Konvertierung und Fehlerbehandlung.

```
IF Zielseite-URL vorhanden:
  -> Fuehre parallel zu den anderen Datenbeschaffungs-Schritten aus:
     npx playwright screenshot "{{URL}}" /tmp/sxo-screenshot.png --viewport-size "1280,800" --timeout 15000
  -> Konvertiere zu Base64:
     SCREENSHOT_BASE64=$(base64 -w 0 /tmp/sxo-screenshot.png 2>/dev/null || openssl base64 -A -in /tmp/sxo-screenshot.png)
  -> Loesche temporaere Datei: rm -f /tmp/sxo-screenshot.png
  -> Speichere SCREENSHOT_BASE64 fuer die HTML-Ausgabe

IF Screenshot fehlschlaegt:
  -> Screenshot-Sektion im Report weglassen
  -> Hinweis an User ausgeben
  -> Workflow NICHT abbrechen
```

---

## Schritt 2: SERP-Analyse

Analysiere jeden Datenpunkt systematisch. Extrahiere fuer jeden Bereich:
- **Was ist zu sehen?** (faktische Beobachtung)
- **Was bedeutet das?** (Interpretation fuer User Story)

**Hinweis:** Die SERP-Response enthaelt verschiedene `type`-Felder. Ordne sie wie folgt zu:
- `related_searches` + `people_also_search` -> Abschnitt 2a (Autocomplete/Related)
- `paid` -> Abschnitt 2b (Google Ads)
- `popular_products` + `compare_sites` -> Abschnitt 2b (als Shopping-Signale)
- `featured_snippet` + `knowledge_graph` -> Abschnitt 2c (Snippet/AI Overview)
- `people_also_ask` -> Abschnitt 2d (PAA)
- `images` -> Abschnitt 2e (Bilder)
- `organic` -> Abschnitt 2f (Top-10)
- `local_pack` -> erwaehne in 2f falls vorhanden (lokale Intent-Signal)

### 2a -- Related Searches / Autocomplete

Beobachtung: Welche verwandten Suchbegriffe zeigt Google?
Interpretation: Welche Absichten und Themen-Cluster stehen dahinter?

Nutze: `related_searches` Items + `people_also_search` Items aus der SERP-Response.

**Leitfragen:** Informational vs. transaktional? Tool-/Rechner-Terme? Lokale Modifikatoren?

### 2b -- Google Ads / Shopping-Signale

Beobachtung: Welche Botschaften und USPs bewerben Anzeigenschaltende?
Interpretation: Was haben A/B-Tests als konvertierend bewiesen?

Nutze: `paid` Items (Textanzeigen) + `popular_products` (Shopping-Produkte mit Preisen) + `compare_sites` (Vergleichsportale wie idealo, Check24) + Google Ads Keyword-Daten aus Schritt 1b.

**Primaere Analyse (wenn `paid`-Items vorhanden):**
Analysiere Headline, Description und angezeigte URLs der Textanzeigen. Diese Daten sind goldwert -- sie zeigen, was A/B-getestet konvertiert.

**Fallback (wenn keine `paid`-Items im SERP):**

> **Hinweis:** SERP-API-Crawler nutzen Datacenter-IPs. Google unterdrueckt haeufig Anzeigen fuer nicht-residential Traffic. Das Fehlen von `paid`-Items bedeutet **nicht**, dass keine Ads geschaltet werden.

Nutze stattdessen die **Google Ads Keyword-Daten** aus `kw_data_google_ads_search_volume`:

```
IF CPC > 0 UND Competition != null:
  -> Ads werden aktiv geschaltet (auch wenn der SERP-Crawler sie nicht sieht)
  -> Zeige im Report:
     - CPC: [Wert] EUR/USD -> signalisiert kommerziellen Wert des Keywords
     - Competition: [Low/Medium/High] -> Wettbewerbsintensitaet bei Ads
     - Competition Index: [0-100] -> numerische Einordnung
     - Search Volume: [Wert] -> monatliches Suchvolumen
  -> Interpretation: Hohes CPC = hoher kommerzieller Wert, Werbetreibende investieren
     in dieses Keyword. Competition High = viele Anbieter kaempfen um diese Suchanfrage.
  -> Hinweis im Report: "Keine Anzeigen im SERP-Crawl erfasst (API-Limitation).
     Google Ads Daten zeigen jedoch aktive Werbeschaltung (CPC: X, Competition: Y)."

IF CPC = 0 UND Competition = null:
  -> Tatsaechlich keine Ads fuer dieses Keyword
  -> Vermerke: "Keine Google Ads aktiv -- rein organischer Wettbewerb"
```

**Wenn `popular_products` / `compare_sites` vorhanden (zusaetzlich oder als Fallback):**
Analysiere diese als Shopping-Signale. Sie zeigen, dass Google eine transaktionale Intention erkennt.
- Welche Preispunkte werden gezeigt? (Preisspanne signalisiert Produktvielfalt)
- Welche Plattformen dominieren? (idealo = Preisvergleich, Amazon = Convenience)
- Gibt es Bewertungen/Sterne? (Trust-Signal)

**Leitfragen:** Welche Versprechen dominieren? Werden Aengste adressiert? Was signalisiert der CPC ueber den kommerziellen Wert?

### 2c -- Featured Snippet / AI Overview / Knowledge Graph

Beobachtung: Welche Antwort liefert Google direkt?
Interpretation: Das ist Googles Definition der "besten Antwort" auf dieses Keyword.

Nutze: `featured_snippet` Items + `knowledge_graph` Items. Pruefe auch, ob PAA-Antworten als `people_also_ask_ai_overview_expanded_element` markiert sind (= AI Overview).

**Bei `knowledge_graph`:** Google zeigt eine Definition/Zusammenfassung rechts neben den Ergebnissen -- das signalisiert, dass das Keyword auch eine informationelle Komponente hat.

**Bei AI Overviews in PAA:** Google beantwortet bestimmte Fragen direkt per AI -- das zeigt, welche Teilfragen Google als "beantwortet" betrachtet (weniger Click-Potential fuer diese Fragen).

**Leitfragen:** Format (Text/Liste/Tabelle/Video)? Antworttiefe? Welche Domain rankt und warum?

### 2d -- People Also Ask (Aehnliche Fragen)

Beobachtung: Welche Folgefragen stellt die Zielgruppe?
Interpretation: Wissensstand und Detailtiefe der Suchenden.

**Leitfragen:** Allgemein vs. spezifisch (Informiertheit)? Aengste/Unsicherheiten? Frueh/spaet in der Journey?

### 2e -- Bilder-Integration

Beobachtung: Welche Bildtypen dominieren die Google Bilder-Box?
Interpretation: Visuelle Erwartungshaltung der Zielgruppe.

**Leitfragen:** Bildtypen (Fotos/Infografiken/Diagramme)? Domain-Ueberschneidung mit Top-10? Erwartetes visuelles Format?

### 2f -- Top-10 organische Ergebnisse

Beobachtung: Welche Seitentypen und Domains dominieren?
Interpretation: Was Google als "beste Antwort" einstuft.

**Kategorisiere jedes Ergebnis nach den 8 Seitentypen:**
```
[ ] Landing Page      — Conversion-fokussiert, ein klarer CTA, Hero + Trust + CTA
[ ] Blog / Guide      — Informationsartikel, Ratgeber, How-to, Erklaertext
[ ] Product Page      — E-Commerce Produktseite mit Preis, Warenkorb, Specs
[ ] Hybrid            — Mischform (z.B. Ratgeber + Tool, Blog + Shop-Element)
[ ] Service Page      — Dienstleistungsseite mit Buchung/Anfrage, Prozess, Preise
[ ] Comparison Page   — Vergleichsportal, Feature-Matrix, vs-Seite
[ ] Local Page        — Standortseite mit Adresse, Oeffnungszeiten, Karte
[ ] Tool Page         — Rechner, Konfigurator, interaktives Online-Tool
```

Zusaetzlich notiere Sondertypen (kein Seitentyp-Match):
```
[ ] Forum / Community (Reddit, gutefrage, Quora)
[ ] Video (YouTube)
[ ] News / Magazin
```

**Zaehle die Seitentyp-Verteilung der Top-10** (z.B. "5x Blog/Guide, 2x Tool Page, 2x Service Page, 1x Forum").

**Leitfragen:** Dominierender Seitentyp in Top-3? Titel-Muster? Portale vs. Nischen-Anbieter?

### 2g -- Meta-Descriptions Muster

Beobachtung: Welche Versprechen machen die Rankings in ihrer Description?
Interpretation: Was klickt die Zielgruppe an -- und warum.

**Destilliere die 3-5 haeufigsten Muster:** Sicherheits-/Risiko-, Schnelligkeits-/Einfachheits-, Individualitaetsversprechen, CTA-Typen.

### 2h -- Page-Type-Mismatch Erkennung

**Dies ist die wichtigste strategische Erkenntnis der SERP-Analyse.**

Vergleiche den **dominierenden Seitentyp der Top-10** (aus 2f) mit dem **aktuellen Typ der Zielseite**.

```
DOMINANT IN TOP-10:  [z.B. Service Page — 6 von 10 Ergebnisse]
ZIELSEITE AKTUELL:   [z.B. Blog / Guide]
MISMATCH:            [Ja / Nein]
```

**Wenn MISMATCH = Ja:**

```
-> Flagge als HIGH-PRIORITY GAP in Schritt 4b:
   "Page-Type-Mismatch: Die Zielseite ist ein [IST-Typ], aber Google bevorzugt
   [SOLL-Typ] fuer dieses Keyword (X von 10 Top-Ergebnisse). Selbst perfekter
   Content im falschen Seitentyp wird langfristig nicht ranken."

-> Empfehlung in Schritt 5 muss den Seitentyp-Wechsel als primaere Massnahme enthalten
-> Der empfohlene Seitentyp wird im Report prominent ausgegeben
```

**Wenn MISMATCH = Nein:**
```
-> Vermerke: "Seitentyp stimmt mit SERP-Erwartung ueberein"
-> Fokus in Schritt 4b auf Content- und UX-Gaps
```

**Seitentyp der Zielseite bestimmen:**

Nutze die Content-Parsing-Daten aus Schritt 1b (`on_page_content_parsing`). Klassifiziere anhand:
- Vorhandensein von Formularen / Buchungs-CTAs -> Service Page / Landing Page
- Warenkorb / Preis / "In den Warenkorb" -> Product Page
- Rechner / Konfigurator / interaktives Element -> Tool Page
- Adresse / Oeffnungszeiten / Karte -> Local Page
- Vergleichstabelle / vs-Struktur -> Comparison Page
- Langer Fliesstext / Inhaltsverzeichnis / Lesezeit -> Blog / Guide
- Kurze Hero-Section + mehrere CTAs -> Landing Page
- Mischform -> Hybrid

---

## Schritt 3: User Story ableiten

Synthetisiere alle SERP-Signale zu einer User Story. Diese beschreibt nicht nur die Suchintention, sondern auch **Emotionen, Wissensstand und den Moment in der Customer Journey**.

### 3a -- User Story Elemente identifizieren

Fuelle diese Tabelle aus den SERP-Daten:

| Element | Aus den SERPs abgeleitet |
|---|---|
| **Search Intent** | Informational / Transactional / Commercial / Navigational / Mixed |
| **Empfohlener Seitentyp** | Aus 2h: Landing Page / Blog / Product / Hybrid / Service / Comparison / Local / Tool |
| **Wissensstand** | Anfaenger / bereits informiert / Experte |
| **Benoetigter Inhaltstyp** | Rechner / Tabelle / Erklaertext / Vergleich / Service-Beschreibung / Produktliste |
| **Individualitaetsbedarf** | Generische Info / Lokale/persoenliche Berechnung |
| **Journey-Phase** | Awareness / Consideration / Decision |
| **Emotionale Lage** | z.B. Unsicherheit bei Investitionsentscheidung |
| **Primaeres Ziel** | z.B. "Lohnt sich das fuer mich konkret?" |
| **Sekundaeres Ziel** | z.B. "Danach ggf. konkretes Angebot einholen" |
| **Barrieren** | Was haelt den User zurueck? (Risiko, Komplexitaet, Zeit) |

**Intent-Klassifikation:** Informational (PAA, Knowledge Graph, Blog in Top-3), Transactional (Shopping, Preis-Terme, Product Pages), Commercial (Vergleiche, Reviews, Ads), Navigational (Brand-Keyword, eine Domain dominiert), Mixed (2 staerkste Signale nennen).

### 3b -- User Story Statement formulieren

Formuliere ein klares Statement nach diesem Muster:

**Deutsch:**
```
Ich sehe [KONKRETE HERAUSFORDERUNG] als grosse Herausforderung
und wuensche mir [ART DER UNTERSTUETZUNG],
um [PRIMAERES ZIEL] zu erreichen
und [EMOTIONALES BEDUERFNIS] dabei zu haben.
```

**English:**
```
I see [SPECIFIC CHALLENGE] as a major challenge
and want [TYPE OF SUPPORT],
to achieve [PRIMARY GOAL]
and feel [EMOTIONAL NEED] while doing so.
```

**Beispiel (DE):**
> *"Ich sehe die konkrete Berechnung des individuellen Ertrags als grosse Herausforderung und wuensche mir datenbasierte Unterstuetzung, um die richtige Entscheidung zu treffen und ein beruhigendes Gefuehl dabei zu haben."*

**Example (EN):**
> *"I see finding reliable performance data for my specific setup as a major challenge and want data-driven guidance, to make the right purchasing decision and feel confident I'm not overpaying or underperforming."*

---

## Schritt 4: Zielseiten-Abgleich

### 4a -- First Screen Check (3-Sekunden-Test)

Pruefe den sichtbaren Bereich ohne Scrollen:

| User Story Element | Vorhanden? | Bewertung |
|---|---|---|
| Headline adressiert das Keyword / die Intention | ja / nein | |
| Primaeres Tool / Inhalt sofort zugaenglich | ja / nein | |
| Vertrauenssignale sichtbar | ja / nein | |
| CTA klar und prominent | ja / nein | |
| Keine Hemmschwellen (Login, lange Formulare) | ja / nein | |

### 4b -- User Story Coverage

Fuer jedes identifizierte User Story Element aus Schritt 3a:

```
Element: [Name]
SERP-Signal: [Was die SERPs signalisieren]
Zielseite: [Was die Zielseite aktuell liefert]
Gap: [Was fehlt oder nicht passt]
Prioritaet: [Hoch / Mittel / Niedrig]
```

### 4c -- Gesamturteil

```
[ ] Search Experience wird erfuellt -> kleine Optimierungen
[ ] Search Experience wird teilweise erfuellt -> gezielte Anpassungen noetig
[ ] Search Experience wird nicht erfuellt -> strukturelle Ueberarbeitung noetig
```

---

## Schritt 5: Optimierungsempfehlungen

Formuliere **maximal 2 strategische Optionen** (nicht mehr -- Entscheidungsparalyse vermeiden):

### Option A: [Kurztitel]
- Was wird veraendert?
- Welche User Story Elemente werden dadurch adressiert?
- Aufwand: [Gering / Mittel / Hoch]
- Erwarteter Impact: [Gering / Mittel / Hoch]

### Option B: [Kurztitel]
- Was wird veraendert?
- Welche User Story Elemente werden dadurch adressiert?
- Aufwand: [Gering / Mittel / Hoch]
- Erwarteter Impact: [Gering / Mittel / Hoch]

**Empfehlung:** Begruendete Empfehlung fuer eine der Optionen.

---

## Schritt 6: SEO-Hygiene & Layout-Checkliste

Diese Checklisten werden **immer** am Ende ausgegeben, unabhaengig vom User Story Abgleich.

### Layout Basics

```
[ ] Relevante Elemente (Logo, H1, Produktbild, CTA) in 3 Sekunden erfassbar?
[ ] Sinneinheiten klar voneinander abgegrenzt (Whitespace)?
[ ] Reihenfolge der Elemente logisch (Nutzer wird durch die Seite gefuehrt)?
[ ] Layout konsistent (Buttons, Headlines, Links einheitlich)?
[ ] Wichtige CTAs kontrastreich und auffaellig?
[ ] Seite abwechslungsreich gestaltet (kein Textwand)?
[ ] Mobile-Darstellung geprueft?
```

### SEO-Hygiene -- Auf der Ziel-URL

```
[ ] H1 enthaelt das Haupt-Keyword?
[ ] Title Tag optimiert (55-60 Zeichen, Keyword enthalten)?
[ ] Meta Description optimiert (150-160 Zeichen, CTA enthalten)?
[ ] Strukturierte Daten vorhanden (Schema.org -- FAQPage, HowTo, etc.)?
[ ] Interne Verlinkung zu thematisch relevanten Seiten?
[ ] JavaScript-Inhalte fuer Crawler indexierbar?
```

### Bilder-Alt-Tags (aus Lighthouse + Instant Pages)

Nutze reale Daten aus `on_page_instant_pages` und `on_page_lighthouse`. Zeige Gesamtzahl Bilder, Bilder ohne Alt-Tag, betroffene Elemente (max. 10). Pruefe stichprobenartig Keyword-Relevanz der Alt-Tags. Wenn Daten nicht verfuegbar: `check-na` mit Verweis auf manuelle Pruefung.

Lies `references/cwv-thresholds.md` fuer Scoring-Logik (check-pass/warn/fail Schwellwerte).

### Core Web Vitals (aus Lighthouse)

Nutze reale Daten aus `on_page_lighthouse`. Zeige als Tabelle mit Farbkodierung (`badge-pass`/`badge-warn`/`badge-fail`). Bei roten Metriken 1-2 konkrete Optimierungshinweise geben. Wenn Daten nicht verfuegbar: `check-na` mit Verweis auf pagespeed.web.dev.

Lies `references/cwv-thresholds.md` fuer alle Schwellwerte, Feld-Pfade und Optimierungshinweise.

### SEO-Hygiene -- Domainuebergreifend

```
[ ] Domainstaerke im Vergleich zu Top-3-Wettbewerbern einschaetzbar?
[ ] Externe Backlinks auf die Zielseite vorhanden?
[ ] Crawlability gegeben (keine Noindex, keine Blockierungen)?
[ ] E-E-A-T: Autorenschaft, Quellenangaben, Trust-Signale vorhanden?
[ ] Mobile-Friendliness domainweit gegeben?
```

---

## Output-Format: HTML-Report

Der finale Report wird als **selbststaendige HTML-Datei** gespeichert.

### Ablauf

1. Bestimme die Report-Sprache (Schritt 0) und lies das passende Template: `assets/report-template.html` (DE) oder `assets/report-template-en.html` (EN)
2. Kopiere den `<style>` Block (CSS) aus dem Template woertlich
3. Generiere den `<body>` Inhalt direkt als HTML aus den Analyseergebnissen -- **NICHT** die `{{PLATZHALTER}}` im Template ersetzen
4. **Screenshot einbetten** (wenn SCREENSHOT_BASE64 vorhanden): Direkt nach dem `</header>` Block, vor Sektion 1, fuege ein:
   ```html
   <div class="screenshot-card">
     <div class="sub-label">Above-the-Fold Ansicht</div>  <!-- bzw. "Above-the-Fold View" EN -->
     <img class="screenshot-img" src="data:image/png;base64,{{SCREENSHOT_BASE64}}" alt="Above-the-Fold Screenshot: {{URL}}">
     <p class="fs-13 text-muted mt-8">Viewport: 1280 &times; 800px (Desktop)</p>
   </div>
   ```
5. Speichere als `sxo-report-[KEYWORD-SLUG].html` im aktuellen Arbeitsverzeichnis

Lies `references/output-format.md` fuer CSS-Klassen Referenz, HTML-Struktur Kurzreferenz und sprachspezifische Labels (DE/EN).

## Fehlerbehandlung

- **API-Fehler:** Logge Fehlertyp, wechsle in Fallback-Modus (Schritt 1c), informiere User.
- **Keyword ohne Ergebnisse:** Pruefe Schreibweise/Sprache/Location, schlage Alternativen vor.
- **Zielseite nicht erreichbar:** Schritt 4 ueberspringen, Report ohne Zielseiten-Analyse ausgeben.

## Qualitaetsstandards

- Interpretationen immer aus den Daten ableiten, nie erfinden
- Bei widerspruelichen SERP-Signalen beide Perspektiven nennen
- User Story Statement ist **eine** praezise Aussage -- kein Kompromiss-Brei
- Optimierungsempfehlungen: maximal 2 Optionen, klare Empfehlung
- Checklisten: erfuellt / nicht erfuellt / teilweise-unklar

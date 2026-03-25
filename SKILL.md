---
name: sxo-analyzer
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

Informiere den User klar:

```
DataForSEO MCP ist nicht erreichbar.
Ich fuehre die Analyse im manuellen Modus durch.

Bitte gib mir folgende Informationen (so viele wie moeglich):

1. AUTOCOMPLETE: Welche Vorschlaege erscheinen, wenn du das Keyword in Google eingibst?
   (Screenshot oder Liste)

2. GOOGLE ADS: Welche gesponserten Anzeigen erscheinen oben?
   (Headline + kurze Description reicht)

3. AEHNLICHE FRAGEN (PAA): Welche Fragen zeigt die "Aehnliche Fragen"-Box?
   (Liste der Fragen)

4. TOP-5-ERGEBNISSE: Titel + Meta-Description der ersten 5 organischen Ergebnisse?
   (Screenshot oder manuell abtippen)

5. SERP-FEATURES: Gibt es Featured Snippets, Bilder-Integration, lokale Ergebnisse,
   AI Overviews? (ja/nein + kurze Beschreibung)

6. ZIELSEITE: Beschreibe kurz den First Screen der Zielseite
   (Was sieht man ohne zu scrollen? Headline, CTA, wichtigste Elemente)

Alternativ: Fuege Screenshots als Bilder ein -- ich analysiere sie direkt.
```

**English fallback (if language = English):**

```
DataForSEO MCP is not available.
I'll run the analysis in manual mode.

Please provide the following information (as much as possible):

1. AUTOCOMPLETE: What suggestions appear when you type the keyword into Google?
2. GOOGLE ADS: What sponsored ads appear at the top? (headline + short description)
3. PEOPLE ALSO ASK: What questions does the "People also ask" box show?
4. TOP-5 RESULTS: Title + meta description of the first 5 organic results?
5. SERP FEATURES: Any featured snippets, image packs, local results, AI Overviews?
6. TARGET PAGE: Briefly describe the first screen of the target page.

Alternatively: Paste screenshots -- I'll analyze them directly.
```

### 1d -- Lighthouse- und Instant-Pages-Daten aufbereiten

Aus den Lighthouse- und Instant-Pages-Responses extrahiere Core Web Vitals, Performance Scores und Bilder-Accessibility-Daten.

Lies `references/cwv-thresholds.md` fuer die vollstaendigen Schwellwerte, Feld-Pfade und Scoring-Logik.

Lies `references/dataforseo-api.md` fuer weitere optionale Endpunkte (Backlinks).

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

**Leitfragen:**
- Dominieren informationale Terme (was, wie, warum) oder transaktionale (kaufen, Preis, Angebot)?
- Gibt es Tool-/Rechner-Terme ("berechnen", "Rechner", "Tabelle", "online")?
- Gibt es lokale Modifikatoren ("in meiner Naehe", PLZ)?

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

**Leitfragen:**
- Welche Versprechen dominieren (Schnelligkeit / Sicherheit / Preis / Qualitaet)?
- Werden Aengste adressiert ("risikolos", "kostenlos", "unverbindlich")?
- Gibt es implizite Hinweise auf Kaufhuerden, die Ads gezielt abbauen?
- Was signalisiert der CPC ueber den kommerziellen Wert der Suchanfrage?

### 2c -- Featured Snippet / AI Overview / Knowledge Graph

Beobachtung: Welche Antwort liefert Google direkt?
Interpretation: Das ist Googles Definition der "besten Antwort" auf dieses Keyword.

Nutze: `featured_snippet` Items + `knowledge_graph` Items. Pruefe auch, ob PAA-Antworten als `people_also_ask_ai_overview_expanded_element` markiert sind (= AI Overview).

**Bei `knowledge_graph`:** Google zeigt eine Definition/Zusammenfassung rechts neben den Ergebnissen -- das signalisiert, dass das Keyword auch eine informationelle Komponente hat.

**Bei AI Overviews in PAA:** Google beantwortet bestimmte Fragen direkt per AI -- das zeigt, welche Teilfragen Google als "beantwortet" betrachtet (weniger Click-Potential fuer diese Fragen).

**Leitfragen:**
- In welchem Format (Text / Liste / Tabelle / Video)?
- Wie tief ist die Antwort (oberflaechlich / detailliert)?
- Welche Domain rankt hier -- und warum vermutlich?

### 2d -- People Also Ask (Aehnliche Fragen)

Beobachtung: Welche Folgefragen stellt die Zielgruppe?
Interpretation: Wissensstand und Detailtiefe der Suchenden.

**Leitfragen:**
- Sind die Fragen eher allgemein oder sehr spezifisch (-> Informiertheit der Zielgruppe)?
- Gibt es Fragen, die auf spezifische Aengste oder Unsicherheiten hinweisen?
- Zeigen die Fragen, ob Nutzer frueh oder spaet in ihrer Customer Journey sind?

### 2e -- Bilder-Integration

Beobachtung: Welche Bildtypen dominieren die Google Bilder-Box?
Interpretation: Visuelle Erwartungshaltung der Zielgruppe.

**Leitfragen:**
- Fotos / Infografiken / Diagramme / Tabellen / Screenshots?
- Welche Domains ranken in den Bildern -- stimmt das mit der organischen Top-10 ueberein?
- Gibt es ein klares visuelles Format, das die Zielgruppe erwartet?

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

**Leitfragen:**
- Welcher Seitentyp dominiert die Top-3? (-> Das ist der Seitentyp, den Google fuer dieses Keyword bevorzugt)
- Gibt es auffaellige Muster in den Titeln (Woerter, die immer wieder auftauchen)?
- Ranken grosse Portale oder Nischen-Anbieter? (-> Wettbewerbsintensitaet)

### 2g -- Meta-Descriptions Muster

Beobachtung: Welche Versprechen machen die Rankings in ihrer Description?
Interpretation: Was klickt die Zielgruppe an -- und warum.

**Destilliere die 3-5 haeufigsten Muster:**
- Sicherheits-/Risikoversprechen
- Schnelligkeits-/Einfachheitsversprechen
- Individualitaets-/Praezisionsversprechen
- Call-to-Action Typen

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

**Intent-Klassifikation ableiten aus SERP-Signalen:**

```
Informational:   PAA dominiert, Wikipedia/Knowledge Graph, Blog/Guide in Top-3, keine Ads
Transactional:   Shopping-Produkte, Preis-Terme, Warenkorb-CTAs, Product Pages in Top-3
Commercial:      Vergleichsportale, "beste/bester", Reviews, Ads mit Preisen, Comparison/Service Pages
Navigational:    Markenname im Keyword, eine Domain dominiert, Knowledge Graph mit Brand
Mixed:           Mehrere Signale gleichzeitig (z.B. Ads + Blog + Tool) -> nenne die 2 staerksten
```

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
4. Speichere als `sxo-report-[KEYWORD-SLUG].html` im aktuellen Arbeitsverzeichnis

Lies `references/output-format.md` fuer CSS-Klassen Referenz, HTML-Struktur Kurzreferenz und sprachspezifische Labels (DE/EN).

## Fehlerbehandlung

```
IF API-Response leer oder Fehler:
  -> Logge den Fehlertyp
  -> Wechsle automatisch in Fallback-Modus (Schritt 1c)
  -> Informiere den User mit konkreter Fehlermeldung

IF Keyword keine Ergebnisse liefert:
  -> Pruefe Schreibweise / Sprache / Location
  -> Schlage alternative Keyword-Varianten vor

IF Zielseite nicht erreichbar:
  -> Zielseiten-Abgleich (Schritt 4) ueberspringen
  -> Report ohne Zielseiten-Analyse ausgeben
  -> Hinweis: "Zielseite nicht erreichbar -- Abgleich manuell durchfuehren"
```

## Qualitaetsstandards

- Interpretationen immer aus den Daten ableiten, nie erfinden
- Bei widerspruelichen SERP-Signalen beide Perspektiven nennen
- User Story Statement ist **eine** praezise Aussage -- kein Kompromiss-Brei
- Optimierungsempfehlungen: maximal 2 Optionen, klare Empfehlung
- Checklisten: erfuellt / nicht erfuellt / teilweise-unklar

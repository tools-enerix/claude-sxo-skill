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

Rufe folgende Datenpunkte ueber DataForSEO ab:

**SERP-Daten (Pflicht):**
- `serp_organic_live_advanced` -> Top-10 organische Ergebnisse (URL, Title, Description, Position)
- Autocomplete -> Suggest-Vorschlaege fuer das Keyword
- Related Searches -> Verwandte Suchanfragen
- People Also Ask -> "Aehnliche Fragen" / PAA-Box

**SERP-Features (wenn verfuegbar):**
- Paid/Ads -> Google Ads (Headline, Description, Display URL)
- Featured Snippet -> Featured Snippet Inhalt
- Images -> Top-Bilder mit Alt-Tags / Quelldomain
- Local Pack -> Lokale Ergebnisse (falls vorhanden)

**Zielseiten-Daten (optional, fuer Abgleich):**
- `on_page_content_parsing` -> Seiteninhalt der Zielseite parsen

Lies `references/dataforseo-api.md` fuer MCP-Endpunkte und Parameter.

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

---

## Schritt 2: SERP-Analyse

Analysiere jeden Datenpunkt systematisch. Extrahiere fuer jeden Bereich:
- **Was ist zu sehen?** (faktische Beobachtung)
- **Was bedeutet das?** (Interpretation fuer User Story)

### 2a -- Autocomplete / Suggest

Beobachtung: Welche Wortgruppen ergaenzen Nutzer?
Interpretation: Welche Absichten stehen dahinter?

**Leitfragen:**
- Dominieren informationale Terme (was, wie, warum) oder transaktionale (kaufen, Preis, Angebot)?
- Gibt es Tool-/Rechner-Terme ("berechnen", "Rechner", "Tabelle", "online")?
- Gibt es lokale Modifikatoren ("in meiner Naehe", PLZ)?

### 2b -- Google Ads

Beobachtung: Welche Botschaften und USPs bewerben Anzeigenschaltende?
Interpretation: Was haben A/B-Tests als konvertierend bewiesen?

**Leitfragen:**
- Welche Versprechen dominieren (Schnelligkeit / Sicherheit / Preis / Qualitaet)?
- Werden Aengste adressiert ("risikolos", "kostenlos", "unverbindlich")?
- Gibt es implizite Hinweise auf Kaufhuerden, die Ads gezielt abbauen?

### 2c -- Featured Snippet / AI Overview

Beobachtung: Welche Antwort liefert Google direkt?
Interpretation: Das ist Googles Definition der "besten Antwort" auf dieses Keyword.

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

**Kategorisiere jedes Ergebnis:**
```
[ ] Direkter Rechner / Tool
[ ] Ratgeber / Informationsartikel
[ ] Produktseite / Landingpage
[ ] Forum / Community (Reddit, gutefrage etc.)
[ ] Vergleichsportal
[ ] Video (YouTube)
[ ] Lokales Ergebnis
```

**Leitfragen:**
- Welcher Seitentyp dominiert die Top-3? (-> Das ist der Content-Typ, den Google bevorzugt)
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

---

## Schritt 3: User Story ableiten

Synthetisiere alle SERP-Signale zu einer User Story. Diese beschreibt nicht nur die Suchintention, sondern auch **Emotionen, Wissensstand und den Moment in der Customer Journey**.

### 3a -- User Story Elemente identifizieren

Fuelle diese Tabelle aus den SERP-Daten:

| Element | Aus den SERPs abgeleitet |
|---|---|
| **Wissensstand** | Anfaenger / bereits informiert / Experte |
| **Benoetigter Inhaltstyp** | Rechner / Tabelle / Erklaertext / Vergleich / ... |
| **Individualitaetsbedarf** | Generische Info / Lokale/persoenliche Berechnung |
| **Journey-Phase** | Awareness / Consideration / Decision |
| **Emotionale Lage** | z.B. Unsicherheit bei Investitionsentscheidung |
| **Primaeres Ziel** | z.B. "Lohnt sich das fuer mich konkret?" |
| **Sekundaeres Ziel** | z.B. "Danach ggf. konkretes Angebot einholen" |
| **Barrieren** | Was haelt den User zurueck? (Risiko, Komplexitaet, Zeit) |

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
[ ] Bilder mit Alt-Tags versehen (Keyword-relevant)?
[ ] JavaScript-Inhalte fuer Crawler indexierbar?
[ ] Pagespeed: Core Web Vitals im gruenen Bereich?
```

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

Der finale Report wird als **HTML-Datei** gespeichert. Ablauf:

1. Bestimme die Report-Sprache (siehe Spracherkennung in Schritt 0)
2. Lies das passende Template:
   - **Deutsch:** `assets/report-template.html`
   - **English:** `assets/report-template-en.html`
3. Ersetze alle `{{PLATZHALTER}}` durch die Analyseergebnisse
4. Speichere die Datei als `sxo-report-[KEYWORD-SLUG].html` im aktuellen Arbeitsverzeichnis
5. Informiere den User ueber den Dateipfad

### Platzhalter-Referenz

**Header:** `{{KEYWORD}}`, `{{URL}}`, `{{DATUM}}`, `{{MARKT}}`, `{{DATENQUELLE}}`

**SERP-Betrachtung:**
- Autocomplete: Ersetze `<!-- {{AUTOCOMPLETE_ROWS}} -->...<!-- {{/AUTOCOMPLETE_ROWS}} -->` durch echte `<tr>` Zeilen. `{{AUTOCOMPLETE_INTERPRETATION}}` mit Freitext.
- Ads: `{{ADS_BEOBACHTUNG}}`, `{{ADS_INTERPRETATION}}`
- Snippet: `{{SNIPPET_BEOBACHTUNG}}`, `{{SNIPPET_INTERPRETATION}}`
- PAA: Ersetze `<!-- {{PAA_ITEMS}} -->...<!-- {{/PAA_ITEMS}} -->` durch echte `<li>` Zeilen. `{{PAA_INTERPRETATION}}` mit Freitext.
- Bilder: `{{BILDER_BEOBACHTUNG}}`, `{{BILDER_INTERPRETATION}}`
- Top-10: Ersetze `<!-- {{TOP10_ROWS}} -->...<!-- {{/TOP10_ROWS}} -->` durch echte `<tr>` Zeilen. Nutze CSS-Klassen: `serp-type-ratgeber`, `serp-type-shop`, `serp-type-feature`, `serp-type-video`, `serp-type-vergleich`. `{{TOP10_INTERPRETATION}}` mit Freitext.
- Meta Patterns: Ersetze `<!-- {{META_PATTERNS}} -->...<!-- {{/META_PATTERNS}} -->` durch echte `<li>` Zeilen.

**User Story:**
- Ersetze `<!-- {{USERSTORY_ROWS}} -->...<!-- {{/USERSTORY_ROWS}} -->` durch echte `<tr>` Zeilen.
- `{{USER_STORY_STATEMENT}}` mit dem formulierten Statement.

**Zielseiten-Abgleich:**
- First Screen: Ersetze `<!-- {{FIRSTSCREEN_ROWS}} -->...<!-- {{/FIRSTSCREEN_ROWS}} -->` durch echte `<tr>` Zeilen. Badge-Klassen: `badge-pass`, `badge-fail`, `badge-warn`.
- Gaps: Ersetze `<!-- {{GAP_ITEMS}} -->...<!-- {{/GAP_ITEMS}} -->` durch echte `.gap-item` Divs. Klassen: `gap-high`, `gap-medium`, `gap-low`. Badge: `badge-fail` (Hoch), `badge-warn` (Mittel), `badge-pass` (Niedrig).
- Verdict: `{{VERDICT_CLASS}}` = `verdict-good` | `verdict-partial` | `verdict-bad`. `{{VERDICT_TITLE}}`, `{{VERDICT_TEXT}}`.

**Empfehlungen:**
- `{{RECO_A_CLASS}}` / `{{RECO_B_CLASS}}` = leer oder `recommended` (fuer die empfohlene Option).
- `{{RECO_A_TITLE}}`, `{{RECO_A_BESCHREIBUNG}}`, Items als `<li>`, Aufwand/Impact.
- Farb-Klassen: `text-accent` (Gering), `text-muted` (Mittel), `priority-high` (Hoch) -- fuer Aufwand umgekehrt.
- `{{EMPFEHLUNG_TEXT}}` mit begruendeter Empfehlung.

**Checklisten:**
- Ersetze `<!-- {{LAYOUT_CHECKS}} -->`, `<!-- {{SEO_URL_CHECKS}} -->`, `<!-- {{SEO_DOMAIN_CHECKS}} -->` durch echte `<li>` Zeilen.
- Check-Icons: `check-pass` + Haekchen, `check-fail` + X, `check-warn` + !, `check-na` + ?.

### EN-Platzhalter-Referenz (English Template)

Das englische Template (`report-template-en.html`) verwendet diese Platzhalter:

**Header:** `{{KEYWORD}}`, `{{URL}}`, `{{DATE}}`, `{{MARKET}}`, `{{DATA_SOURCE}}`

**SERP Analysis:**
- Autocomplete: `{{AUTOCOMPLETE_ROWS}}` (gleiche Struktur), `{{AUTOCOMPLETE_INTERPRETATION}}`
- Ads: `{{ADS_OBSERVATION}}`, `{{ADS_INTERPRETATION}}`
- Snippet: `{{SNIPPET_OBSERVATION}}`, `{{SNIPPET_INTERPRETATION}}`
- PAA: `{{PAA_ITEMS}}` (gleiche Struktur), `{{PAA_INTERPRETATION}}`
- Images: `{{IMAGES_OBSERVATION}}`, `{{IMAGES_INTERPRETATION}}`
- Top-10: `{{TOP10_ROWS}}` (gleiche Struktur, zusaetzliche CSS-Klassen: `serp-type-guide`, `serp-type-comparison`, `serp-type-forum`, `serp-type-tool`, `serp-type-news`), `{{TOP10_INTERPRETATION}}`
- Meta Patterns: `{{META_PATTERNS}}` (gleiche Struktur)

**User Story:**
- `{{USERSTORY_ROWS}}` mit `{{ELEMENT}}` und `{{VALUE}}`
- `{{USER_STORY_STATEMENT}}`
- EN-Elemente: Knowledge Level, Content Type Needed, Personalization Need, Journey Phase, Emotional State, Primary Goal, Secondary Goal, Barriers

**Target Page Comparison:**
- First Screen: `{{FIRSTSCREEN_ROWS}}` mit `{{FS_ELEMENT}}`, `{{FS_STATUS}}` (Pass/Fail/Partial), `{{FS_ASSESSMENT}}`
- Gaps: `{{GAP_ITEMS}}` mit `{{GAP_TARGET}}` und `{{GAP_DESCRIPTION}}`
- Verdict: `{{VERDICT_CLASS}}`, `{{VERDICT_TITLE}}`, `{{VERDICT_TEXT}}`

**Recommendations:**
- `{{RECO_A_DESCRIPTION}}` / `{{RECO_B_DESCRIPTION}}` (statt BESCHREIBUNG)
- `{{RECO_A_EFFORT}}` / `{{RECO_B_EFFORT}}` (statt AUFWAND), Farb-Klasse `{{RECO_A_EFFORT_COLOR}}`
- `{{RECOMMENDATION_TEXT}}` (statt EMPFEHLUNG_TEXT)
- Effort/Impact-Werte: Low / Medium / High

**Checklisten:** Gleiche Struktur, Check-Status auf Englisch: Pass / Fail / Partial / N/A

### Wichtig

- Entferne beim Befuellen ALLE Template-Kommentare (`<!-- {{...}} -->`)
- Schreibe echtes HTML, keine Markdown-Reste
- Texte in der erkannten Sprache (Deutsch oder Englisch)
- Der Report wird ZUSAETZLICH zur Textausgabe als Datei geschrieben -- der User sieht beides

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

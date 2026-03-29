# SXO-Report Output-Format: HTML

Der finale Report wird als **selbststaendige HTML-Datei** gespeichert.

## Ablauf

1. Bestimme die Report-Sprache (siehe Spracherkennung in Schritt 0)
2. Lies das passende Template fuer den **CSS-Block** (`<style>...</style>`):
   - **Deutsch:** `assets/report-template.html`
   - **English:** `assets/report-template-en.html`
3. Kopiere den `<style>` Block (CSS) aus dem Template woertlich
4. Generiere den `<body>` Inhalt direkt als HTML aus den Analyseergebnissen
5. Speichere als `sxo-report-[KEYWORD-SLUG].html` im aktuellen Arbeitsverzeichnis

**WICHTIG:** Versuche NICHT, die `{{PLATZHALTER}}` im Template zu ersetzen. Kopiere nur das CSS und generiere den Body-Inhalt direkt.

## CSS-Klassen Referenz

**SERP-Typ Tags (8 Seitentypen):** `serp-type-landing`, `serp-type-blog`, `serp-type-product`, `serp-type-hybrid`, `serp-type-service`, `serp-type-comparison`, `serp-type-local`, `serp-type-tool`

**SERP-Typ Tags (Sondertypen):** `serp-type-forum`, `serp-type-video`, `serp-type-news`

**Intent Tags:** `intent-informational`, `intent-transactional`, `intent-commercial`, `intent-navigational`, `intent-mixed`

**Page-Type-Mismatch:** `mismatch-alert` (rote Box mit Warnung wenn Seitentyp nicht passt)

**Status Badges:** `badge-pass` (gruen), `badge-fail` (rot), `badge-warn` (gelb), `badge-info` (blau)

**Gap Prioritaet:** `gap-high` (rote Linie), `gap-medium` (gelbe Linie), `gap-low` (gruene Linie)

**Verdict:** `verdict-good`, `verdict-partial`, `verdict-bad`

**Empfehlungen:** `recommended` Klasse auf `.reco-card` fuer EMPFOHLEN-Banner (DE) / RECOMMENDED (EN)

**Checkliste:** `check-pass` (Haekchen), `check-fail` (X), `check-warn` (!), `check-na` (?)

**Screenshot:** `screenshot-card` (Container), `screenshot-img` (responsive Bild mit Border und Shadow)

**Aufwand/Impact Farben:** `text-accent` (Gering/Low), `text-muted` (Mittel/Medium), `priority-high` (Hoch/High)

## HTML-Struktur Kurzreferenz

```html
<!-- Header: .report-header mit .label, h1, .meta-grid -->
<!-- Screenshot: .screenshot-card > .sub-label + img.screenshot-img + p (nach Header, vor Sektion 1) -->
<!-- Sektionen: .section > .section-header + .card(s) -->
<!-- Tabellen: .card > .table-wrap > table -->
<!-- Gap-Items: .gap-item.gap-{priority} > h4 + .gap-detail > 3x div -->
<!-- Empfehlungen: .reco-grid > 2x .reco-card(.recommended) -->
<!-- Checkliste: .checklist > li > .check-icon.check-{status} + span -->
<!-- Bilder-Audit: .card > .img-audit-summary > .img-audit-stat(s) + .img-audit-items > code(s) -->
<!-- CWV: .card > .score-row > .score-item(s) + table.cwv-table > tr > td + .badge.badge-{pass/warn/fail} -->
<!-- Score-Farben: .cwv-good (gruen), .cwv-warn (gelb), .cwv-poor (rot) -->
```

## Sprachspezifische Labels

| Bereich | Deutsch | English |
|---|---|---|
| Header-Label | SXO-Analyse | SXO Analysis |
| Datum | Datum | Date |
| Datenquelle | Datenquelle | Data Source |
| Sektions-Titel 1 | SERP-Betrachtung | SERP Analysis |
| Beobachtung/Interpretation | Beobachtung / Interpretation | Observation / Interpretation |
| Page-Type-Analyse | Seitentyp-Analyse | Page Type Analysis |
| Page-Type-Mismatch | Seitentyp-Mismatch | Page Type Mismatch |
| Empfohlener Seitentyp | Empfohlener Seitentyp | Recommended Page Type |
| Search Intent | Search Intent | Search Intent |
| Sektions-Titel 2 | User Story | User Story |
| Sektions-Titel 3 | Zielseiten-Abgleich | Target Page Comparison |
| Sektions-Titel 4 | Optimierungsempfehlungen | Optimization Recommendations |
| Sektions-Titel 5 | Checklisten | Checklists |
| Empfohlen-Banner | EMPFOHLEN | RECOMMENDED |
| Aufwand | Aufwand | Effort |
| Gesamturteil | Gesamturteil | Overall Verdict |

## Wichtig

- Schreibe echtes HTML, keine Markdown-Reste
- Alle Texte in der erkannten Sprache (Deutsch oder Englisch)
- Der Report wird ZUSAETZLICH zur Textausgabe als Datei geschrieben
- Verwende `&mdash;` fuer Gedankenstriche, `&euro;` fuer Euro, `&amp;` fuer &
- Nutze `&auml;` etc. fuer Umlaute im HTML (oder UTF-8 direkt)

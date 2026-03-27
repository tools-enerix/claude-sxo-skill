# Section Mapping: SXO-Gap → Wireframe-Sektion

## Mapping-Tabelle

Diese Referenz definiert, wie SXO-Report-Gaps auf Wireframe-Sektionen abgebildet werden.

### Primaere Mappings (aus Gap-Analyse Schritt 4b)

| SXO-Gap Kategorie | Wireframe-Sektion | Platzhalter-Typ (DE) | Platzhalter-Typ (EN) |
|---|---|---|---|
| H1 / Keyword fehlt oder unpassend | `hero` | `[KEYWORD: "..." in H1 einbauen]` | `[KEYWORD: Include "..." in H1]` |
| CTA fehlt oder unklar | `hero` oder `cta-section` | `[CTA: "..." — kontrastreich, above-the-fold]` | `[CTA: "..." — high contrast, above the fold]` |
| Trust-Signale fehlen | `trust-bar` oder `hero` | `[TRUST: Siegel, Bewertungen, Kundenanzahl]` | `[TRUST: Badges, reviews, customer count]` |
| PAA-Fragen nicht abgedeckt | `faq-section` | `[FAQ: PAA-Fragen als Accordion + FAQPage Schema]` | `[FAQ: PAA questions as accordion + FAQPage Schema]` |
| Barriere: Komplexitaet | `explainer-block` | `[ERKLAERUNG: Vereinfachung von "..."]` | `[EXPLAINER: Simplify "..."]` |
| Barriere: Risiko/Unsicherheit | `trust-block` | `[RISIKO-REDUKTION: Garantie, Testimonials, Fallstudien]` | `[RISK REDUCTION: Guarantee, testimonials, case studies]` |
| Barriere: Zeitaufwand | `hero` oder `tool-section` | `[QUICK-WIN: Sofortergebnis in X Sekunden]` | `[QUICK WIN: Instant result in X seconds]` |
| Content-Typ fehlt (Rechner/Tabelle/Vergleich) | `tool-section` oder `content-block` | `[CONTENT-TYP: Tabelle/Rechner/Vergleich zu "..."]` | `[CONTENT TYPE: Table/calculator/comparison for "..."]` |
| Bilder/Infografiken fehlen | `image-placeholder` | `[BILD: Infografik zu "...", alt="..."]` | `[IMAGE: Infographic about "...", alt="..."]` |
| Interne Links fehlen | `internal-links` oder `footer` | `[INTERNAL LINKS: Verlinke zu "..."]` | `[INTERNAL LINKS: Link to "..."]` |
| Meta/Title nicht optimiert | `head-meta` (HTML-Kommentar) | `<!-- META: Title "..." (55-60 Zeichen) -->` | `<!-- META: Title "..." (55-60 chars) -->` |
| Meta Description fehlt/schlecht | `head-meta` (HTML-Kommentar) | `<!-- META-DESC: "..." (150-160 Zeichen, CTA) -->` | `<!-- META-DESC: "..." (150-160 chars, CTA) -->` |
| Schema.org fehlt | `head-meta` (HTML-Kommentar) | `<!-- SCHEMA: FAQPage / HowTo einbauen -->` | `<!-- SCHEMA: Add FAQPage / HowTo -->` |
| Strukturierte Daten fehlen | `head-meta` (HTML-Kommentar) | `<!-- STRUCTURED DATA: "..." Schema hinzufuegen -->` | `<!-- STRUCTURED DATA: Add "..." schema -->` |

### Sekundaere Mappings (aus Checklisten Schritt 6)

| Checklist-Item | Wireframe-Sektion | Annotation |
|---|---|---|
| H1 fehlt Keyword | `hero` | Roter Rand + Hinweis |
| Title Tag nicht optimiert | `head-meta` | Kommentar im HTML-Head |
| Meta Description fehlt CTA | `head-meta` | Kommentar im HTML-Head |
| Bilder ohne Alt-Tags | Naechster `image-placeholder` | Alt-Text-Vorschlag |
| Keine internen Links | `internal-links` (neu) | Verlinkungsvorschlaege |
| Kein Schema.org | `head-meta` | Schema-Typ-Empfehlung |
| CWV rot (LCP) | `hero` | Hinweis: Bild optimieren |
| CWV rot (CLS) | Alle Bild-Sektionen | Hinweis: width/height setzen |

## Wireframe-Sektionen (Baukasten)

Jede Wireframe-Sektion hat folgende Eigenschaften:

```
Sektion:
  id:          Eindeutige Kennung (z.B. "hero", "trust-bar")
  label:       Anzeigename (z.B. "Hero-Bereich", "Hero Section")
  position:    Reihenfolge auf der Seite (1-N)
  ist_status:  vorhanden | fehlt | unzureichend
  soll_inhalt: Platzhalter-Text mit konkreten Handlungsanweisungen
  gap_ref:     Referenz zum User Story Element
  prioritaet:  hoch | mittel | niedrig
```

### Standard-Sektionsreihenfolge (SOLL)

1. `head-meta` — Title, Meta Description, Schema (nur als HTML-Kommentare)
2. `header` — Logo, Navigation, Kontakt/Trust
3. `hero` — H1, Subheadline, primaerer CTA, Hero-Bild
4. `trust-bar` — Trust-Signale (Siegel, Bewertungen, Partner)
5. `tool-section` — Rechner, Konfigurator, interaktives Tool (wenn SERP-Signal)
6. `content-main` — Hauptinhalt (Erklaertext, Tabelle, Vergleich)
7. `image-section` — Infografik, Diagramm, Produktbild
8. `social-proof` — Testimonials, Fallstudien, Referenzen
9. `faq-section` — PAA-Fragen als FAQ-Accordion
10. `cta-section` — Sekundaerer CTA / Conversion-Element
11. `internal-links` — Verwandte Inhalte, Themen-Cluster-Links
12. `footer` — Navigation, Kontakt, rechtliche Links

### Zusaetzliche Sektionen (fuer erweiterte Seitentypen)

13. `service-overview` — Leistungsbeschreibungen mit Icons/Karten (Service-Seite)
14. `pricing-table` — Preis-/Paketvergleich als Tabelle oder Karten (Service-Seite, Produkt-Seite)
15. `process-steps` — Ablauf in nummerierten Schritten mit Icons (Service-Seite)
16. `booking-cta` — Buchungs-/Anfrageformular oder Terminbuchung (Service-Seite, Standortseite)
17. `comparison-matrix` — Feature-Vergleichstabelle mit Haekchen/Kreuzen (Vergleichsseite)
18. `detailed-comparison` — Ausfuehrlicher Textvergleich pro Kriterium (Vergleichsseite)
19. `pros-cons` — Vor-/Nachteile pro Option als Listen (Vergleichsseite)
20. `recommendation` — Klare Empfehlung mit Begruendung (Vergleichsseite)
21. `location-info` — Adresse, Oeffnungszeiten, Kontaktdaten (Standortseite)
22. `map-embed` — Google Maps Embed oder statische Karte (Standortseite)
23. `contact-cta` — Kontaktformular, Telefon, E-Mail prominent (Standortseite)
24. `result-explanation` — Erklaerung des Tool-Ergebnisses mit Kontext (Tool-Seite)
25. `methodology` — Berechnungsgrundlage, Datenquellen, Formeln (Tool-Seite)
26. `related-tools` — Verwandte Rechner/Tools als Karten verlinkt (Tool-Seite)

### Hybrid-spezifische Sektionen (Zwei-Zonen-Architektur)

Bei Hybrid-Seiten (Landing + Blog) werden zusaetzliche Sektionen fuer Zone 1 (Conversion) eingefuegt:

27. `value-props` — 3 Kern-USPs mit Metriken im Hero-Bereich (Hybrid)
28. `benefits-grid` — 3-4 Vorteil-Karten mit Icons und Metriken (Hybrid)
29. `feature-showcase` — Alternierende Bild/Text-Bloecke fuer Features (Hybrid, bedingt)
30. `solution-overview` — Oekosystem-/Komplettloesung als Icon-Grid (Hybrid, optional)
31. `trust-carousel` — 4-6 Alpine.js Trust-Slides mit Details (Hybrid, bedingt)
32. `awards-bar` — 3-5 Award-Badges/Zertifizierungen horizontal (Hybrid, bedingt)

**Hybrid-Sektionsreihenfolge (SOLL):**

Zone 1 (Conversion):
1. `head-meta`
2. `header`
3. `hero` (erweitert mit `value-props` + Dual-CTA + Trust-Siegel)
4. `trust-bar`
5. `benefits-grid`
6. `feature-showcase` (bedingt: nur wenn konkrete Features vorhanden)
7. `solution-overview` (optional: nur wenn 4+ Komponenten)
8. `trust-carousel` (bedingt: nur wenn 4+ Trust-Dimensionen)
9. `process-steps`
10. `awards-bar` (bedingt: nur wenn echte Awards existieren)

Zone 2 (SEO/Content):
11. `key-takeaways`
12. `content-main`
13. `image-section`
14. `faq-section`
15. `cta-section`
16. `internal-links`
17. `footer`

### Regeln fuer IST-Ableitung

Wenn Content-Parsing-Daten verfuegbar:
- H1 -> `hero` Sektion (IST)
- H2-Elemente -> je eine `content-block` Sektion
- Formulare -> `tool-section`
- Listen mit Links -> `internal-links`
- Bilder -> `image-section`
- Footer-Navigation -> `footer`

Wenn nur SXO-Report verfuegbar (kein Content-Parsing):
- First-Screen-Check -> `hero` + `header` IST-Zustand
- Gap-Analyse -> fehlende Sektionen identifizieren
- Gesamturteil -> Umfang der SOLL-Aenderungen bestimmen

## Prioritaetsregeln

```
Hoch (rot):    Gaps die das primaere User Story Ziel betreffen
               + Alle "check-fail" Items aus der Checkliste
Mittel (gelb): Gaps die sekundaere Ziele oder Barrieren betreffen
               + Alle "check-warn" Items
Niedrig (gruen): Nice-to-have Optimierungen
                 + Domain-uebergreifende SEO-Punkte
```

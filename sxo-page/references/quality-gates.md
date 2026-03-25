# Quality Gates: SXO-Page Verifikation

## Pflicht-Gates (alle muessen bestanden werden)

### Gate 1: Wireframe-Abdeckung

| Pruefpunkt | Kriterium | Fail-Bedingung |
|---|---|---|
| Sektions-Vollstaendigkeit | Alle SOLL-Sektionen umgesetzt | Eine SOLL-Sektion fehlt komplett |
| Placeholder-Aufloesung | 0 unaufgeloeste Platzhalter | `[PLACEHOLDER]` im Output |
| Sektionsreihenfolge | Entspricht Wireframe-Reihenfolge | Sektionen vertauscht oder umgestellt |
| Seitentyp | Empfohlener Typ umgesetzt | Falscher Seitentyp (z.B. Blog statt Landing) |
| Meta-Tags | Title + Description aus Wireframe-Kommentaren | Meta-Tags fehlen oder generisch |

### Gate 2: Gap-Abdeckung

| Pruefpunkt | Kriterium | Fail-Bedingung |
|---|---|---|
| High-Priority Gaps | 100% adressiert | Ein High-Priority Gap nicht adressiert |
| Medium-Priority Gaps | >= 80% adressiert | Weniger als 80% adressiert |
| User Story | Primaeres + Sekundaeres Ziel bedient | Primaeres Ziel nicht erkennbar |
| PAA-Fragen | Mind. 3 in FAQ aufgenommen | Keine FAQ-Sektion trotz PAA-Daten |

### Gate 3: Content-Qualitaet

| Pruefpunkt | Kriterium | Fail-Bedingung |
|---|---|---|
| Answer-First | Jede H2 beginnt mit Antwort | H2 beginnt mit Frage oder Einleitung |
| Statistiken | Mind. 8 mit Quellenangabe | Weniger als 6 Statistiken |
| Quellen-Tier | Nur Tier 1-3 | Wikipedia, Reddit, oder unbekannte Quelle |
| Citation Capsules | Mind. 1 pro H2-Sektion | H2-Sektion ohne zitierfaehige Passage |
| Erfundene Daten | 0 | Statistik ohne Quellenangabe |
| Readability | Flesch 60-70 (geschaetzt) | Geschaetzter Flesch < 50 oder > 80 |

### Gate 4: Technisch

| Pruefpunkt | Kriterium | Fail-Bedingung |
|---|---|---|
| Schema-Markup | Mind. WebPage + FAQ (wenn vorhanden) | Kein Schema im Output |
| Title Tag | 40-60 Zeichen, Keyword vorne | Title > 70 Zeichen oder ohne Keyword |
| Meta Description | 150-160 Zeichen, mit CTA | Description > 170 Zeichen oder generisch |
| Bilder | Alt-Text bei jedem Bild | Bild ohne alt-Attribut |
| Bilder CLS | width + height gesetzt | Bild ohne Dimensionen |
| LCP-Bild | Kein lazy-loading auf Hero-Bild | Hero-Bild mit loading="lazy" |
| HTML-Validitaet | Keine offenen Tags, korrekte Verschachtelung | Invalides HTML |
| Heading-Hierarchie | H1 > H2 > H3, keine Spruenge | H3 ohne vorheriges H2, mehrere H1 |

---

## Warn-Gates (Empfehlungen, kein Fail)

| Pruefpunkt | Empfehlung | Warn-Bedingung |
|---|---|---|
| Visuelles Pacing | 1 Element pro 300-500 Woerter | > 500 Woerter ohne visuelles Element |
| Interne Links | 5-10 pro 2000 Woerter | Weniger als 3 interne Links |
| Satzlaenge-Varianz | SD >= 6 Woerter | Alle Saetze aehnlich lang |
| Passiv-Anteil | <= 10% | > 15% passive Saetze |
| Absatzlaenge | 40-80 Woerter | Absatz > 150 Woerter |
| OG-Tags | Vollstaendig (title, desc, image, type) | Fehlende OG-Tags |
| Twitter Card | Summary Large Image | Keine Twitter Card Tags |
| Canonical | URL gesetzt | Kein Canonical Tag |

---

## Quellen-Tier Klassifizierung

### Tier 1: Primaere Autoritaeten (bevorzugt)
- Regierungsbehoerden (Statistisches Bundesamt, BLS, Eurostat)
- Branchenverbaende (BITKOM, IAB, Statista als Aggregator)
- Peer-reviewed Studien / Universitaeten
- Offizielle Unternehmensberichte (Geschaeftsberichte)

### Tier 2: Anerkannte Datenanbieter
- Forschungsinstitute (McKinsey, BCG, Gartner, Forrester)
- Grosse Nachrichtenagenturen (Reuters, AP, dpa)
- Fachpublikationen (Harvard Business Review, MIT Sloan)
- Anerkannte Branchenmedien

### Tier 3: Qualitaetsjournalismus
- Ueberregionale Tageszeitungen (FAZ, SZ, NYT, Guardian)
- Leitmedien (Spiegel, Zeit, Economist, Bloomberg)
- Etablierte Tech-Medien (TechCrunch, Wired, Ars Technica)

### Nicht akzeptabel (Fail):
- Wikipedia (als alleinige Quelle)
- Reddit, Quora, Foren
- Unbekannte Blogs ohne Impressum
- Social-Media-Posts
- SEO-Affiliate-Seiten
- Quellen aelter als 3 Jahre (ausser historische Daten)

---

## Verifikations-Checkliste (zum Abgleich)

```
WIREFRAME:
  [ ] Alle SOLL-Sektionen im Output vorhanden
  [ ] Kein [PLACEHOLDER] oder [ERGAENZEN] im finalen Text
  [ ] H1 = exakter Text aus Wireframe-KEYWORD-Placeholder
  [ ] CTA-Texte = exakt aus Wireframe-CTA-Placeholdern
  [ ] FAQ-Fragen = exakte PAA-Texte aus Report

CONTENT:
  [ ] Erster Absatz jeder H2 = Answer-First (Statistik + Antwort)
  [ ] Mind. 8 Statistiken mit [Quelle](URL), Jahr
  [ ] Mind. 1 Citation Capsule (Blockquote) pro H2
  [ ] Absaetze max 150 Woerter
  [ ] Kein "In diesem Abschnitt", "Zusammenfassend laesst sich sagen"

TECHNISCH:
  [ ] <title> vorhanden und 40-60 Zeichen
  [ ] <meta name="description"> vorhanden und 150-160 Zeichen
  [ ] JSON-LD Schema vorhanden
  [ ] Alle <img> mit alt, width, height
  [ ] Hero-Bild OHNE loading="lazy"
  [ ] Heading-Hierarchie korrekt (H1 > H2 > H3)
  [ ] HTML valide (keine offenen Tags)
```

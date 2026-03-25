---
name: sxo-page
description: >
  Erstellt eine fertige HTML- oder Markdown-Seite auf Basis eines SXO-Analyzer Reports
  und eines SXO-Builder Wireframes. Kombiniert die UX-Strukturvorgaben aus dem Wireframe
  mit den Content-Qualitaetsstandards von blog-write (Statistik-Recherche, Answer-First,
  E-E-A-T, Readability). Liest Report, Wireframe und optionalen Beitrag aus dem aktuellen
  Arbeitsverzeichnis. Downstream-Skill von sxo-analyzer und sxo-builder.
  Supports German and English -- auto-detects language from SXO report/wireframe.
  Use when user says "Seite erstellen", "create the page", "build page from wireframe",
  "SXO Seite bauen", "Inhalt produzieren", "produce content", "wireframe to html",
  "wireframe to page", "sxo page", "Seite aus Wireframe", "page from wireframe",
  "fill wireframe", "Wireframe umsetzen", "content from SXO", or "Inhalt aus SXO".
  Do NOT use for: wireframe creation (use sxo-builder), SXO analysis (use sxo-analyzer),
  blog posts without SXO context (use blog-write), or pure design/mockup tasks.
argument-hint: "[output-format: html|md]"
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
  - Agent
  - WebFetch
  - WebSearch
---

# SXO-Page -- Fertige Seite aus SXO-Analyse + Wireframe

Dieses Skill erzeugt eine **produktionsreife Seite** (HTML oder Markdown), die zwei Staerken vereint:

> **SXO-Wireframe** liefert die optimale Seitenstruktur (WAS wohin gehoert und WARUM)
> **Blog-Write-Techniken** liefern die Content-Qualitaet (recherchierte Statistiken, Answer-First, E-E-A-T)

Ergebnis: Eine Seite, die sowohl fuer Rankings als auch fuer Conversions optimiert ist.

---

## Schritt 0: Inputs erkennen und validieren

### 0a -- Dateien im Arbeitsverzeichnis suchen

```
Suche mit Glob im aktuellen Arbeitsverzeichnis nach:

1. SXO-Report:    sxo-report-*.html     (aus /sxo-analyzer)
2. SXO-Wireframe: sxo-wireframe-*.html  (aus /sxo-builder)
3. Bestehender Beitrag (optional):
   - *.html (nicht sxo-report-* oder sxo-wireframe-*)
   - *.md (nicht README.md)

IF Report UND Wireframe gefunden:
  -> Zeige gefundene Dateien und frage: "Soll ich daraus die Seite erstellen?"
  -> Falls mehrere Report/Wireframe-Paare: User waehlen lassen

IF nur Report ODER nur Wireframe:
  -> Hinweis: "Fuer optimale Ergebnisse brauche ich beides."
  -> "Report fehlt? -> /sxo-analyzer [keyword] [url]"
  -> "Wireframe fehlt? -> /sxo-builder [report-datei]"
  -> Falls nur Wireframe: Fahre trotzdem fort (Wireframe enthaelt User Story + Gaps)
  -> Falls nur Report: Abbruch mit Empfehlung /sxo-builder zuerst

IF weder Report noch Wireframe:
  -> Frage nach Dateien oder empfehle /sxo-analyzer als Startpunkt
```

### 0b -- Output-Format bestimmen

```
IF User gibt Format an (html / md / markdown):
  -> Verwende angegebenes Format
ELSE:
  -> Standard: HTML
  -> Frage: "Output als HTML oder Markdown? (Standard: HTML)"
```

### 0c -- Spracherkennung

```
Erkenne Sprache aus dem Wireframe/Report:
1. HTML lang-Attribut (lang="de" vs lang="en")
2. Wireframe-Labels (IST-Zustand -> DE, Current State -> EN)
3. Keyword-Sprache als Fallback

IF Deutsch:
  -> Deutsche Inhalte, CSS aus assets/page-template.html
IF Englisch:
  -> Englische Inhalte, CSS aus assets/page-template-en.html
```

---

## Schritt 1: Daten extrahieren

### 1a -- Wireframe parsen (primaere Strukturquelle)

Lies die Wireframe-HTML-Datei und extrahiere:

```
SEITENTYP:       Aus .page-type-rec .pt-recommended .pt-name
                 (Landing-Page / Blog / Produkt / Hybrid /
                  Service-Seite / Vergleichsseite / Standortseite / Tool-Seite)

USER_STORY:      Aus .user-story-banner (woertlich uebernehmen)

META_KOMMENTARE: Aus .meta-comments code Zeilen
                 -> Title Tag, Meta Description, Schema-Empfehlungen

SOLL_SEKTIONEN:  Aus .col-soll .wf-block (IN REIHENFOLGE):
  Fuer jeden Block:
    - section_label:  .block-label Text (z.B. "HERO-BEREICH", "FAQ")
    - soll_content:   .block-content Text
    - placeholders:   Alle .placeholder Elemente:
        - ph_type:    .ph-type Text (z.B. "[CTA]", "[FAQ]", "[KEYWORD]")
        - ph_text:    Haupttext des Platzhalters
        - ph_detail:  .ph-detail Text (Begruendung)
    - gap_ref:        .gap-ref Text (User Story Referenz)
    - priority:       Klasse prio-high / prio-medium / prio-low / prio-new
```

### 1b -- Report parsen (Kontext + SERP-Daten)

Lies die Report-HTML-Datei und extrahiere:

```
KEYWORD:         Aus .report-header h1 oder .meta-value
URL:             Aus .meta-value mit Link
DATUM:           Heutiges Datum verwenden

GAP_ITEMS:       Aus .gap-item Elementen:
  - element:     h4 Text
  - serp_signal: Erster Unter-div Text
  - zielseite:   Zweiter Unter-div Text
  - gap:         Dritter Unter-div Text
  - priority:    Klasse gap-high / gap-medium / gap-low

PAA_FRAGEN:      Aus der PAA-Sektion (Aehnliche Fragen)
                 -> Werden fuer FAQ-Sektion verwendet

SERP_TOP10:      Aus der Top-10 Sektion
                 -> Content-Typen der Wettbewerber (zur Orientierung)

USER_STORY_ELEMENTE: Aus Schritt 3a Tabelle im Report
  - Wissensstand, Inhaltstyp, Journey-Phase, Emotionale Lage,
    Primaeres Ziel, Sekundaeres Ziel, Barrieren
```

### 1c -- Bestehenden Beitrag parsen (falls vorhanden)

```
IF bestehender Beitrag im CWD:
  -> Lies den Beitrag
  -> Extrahiere verwertbare Inhalte:
     - Texte die beibehalten werden koennen
     - Existierende Bilder/Medien
     - Interne Links
  -> Markiere als "vorhandener Content" fuer Wiederverwendung
```

---

## Schritt 2: Content-Recherche

### 2a -- Blog-Researcher Agent spawnen

Spawne einen **blog-researcher** Agent (aus dem Blog-Skill-Oekosystem) mit folgendem Auftrag:

```
Agent: blog-researcher
Aufgabe:
  Keyword: [KEYWORD aus Report]
  Themen: [Alle Sektions-Labels aus SOLL-Wireframe]
  PAA-Fragen: [PAA-Fragen aus Report]

  Liefere:
  1. STATISTIKEN: 8-12 aktuelle Statistiken (2025-2026 bevorzugt)
     - Nur Tier 1-3 Quellen (primaere Autoritaeten, Datenanbieter, Qualitaetsjournalismus)
     - Format: "[Zahl/Prozent] ([Quelle], [Jahr])"
     - Mindestens 1 Statistik pro H2-Sektion

  2. BILDER: 3-5 lizenzfreie Bilder
     - Pixabay (bevorzugt), Unsplash (Alternative), Pexels (Fallback)
     - Format: 1200x630 oder groesser
     - Alt-Text-Vorschlaege mit Keyword-Bezug
     - Typen: Hero-Bild, Infografik-Ersatz, Prozess-Illustration

  3. WETTBEWERBS-LUECKEN: Was decken die Top-10 NICHT ab?
     - Unique Angles die kein Wettbewerber behandelt
     - Daten/Perspektiven die differenzieren
```

### 2b -- Recherche-Ergebnisse zuordnen

Ordne die Recherche-Ergebnisse den Wireframe-Sektionen zu:

```
Fuer jede SOLL-Sektion:
  -> Welche Statistiken passen thematisch?
  -> Welches Bild passt?
  -> Welche Wettbewerbs-Luecke kann hier adressiert werden?

Ergebnis: Angereicherte Sektions-Liste mit konkreten Daten
```

---

## Schritt 3: Content produzieren

### 3a -- Blog-Referenzen laden

Lies folgende Referenz-Dateien fuer Content-Qualitaetsstandards (READ-ONLY, nicht veraendern):

```
PFLICHT (immer lesen):
  ~/.claude/skills/blog/references/content-rules.md
  ~/.claude/skills/blog/references/eeat-signals.md

BEI BEDARF (je nach Sektionstyp):
  ~/.claude/skills/blog/references/cta-placement.md        -> wenn CTA-Sektionen
  ~/.claude/skills/blog/references/visual-media.md          -> wenn Bild-Sektionen
  ~/.claude/skills/blog/references/schema-stack.md          -> fuer Schema-Markup
  ~/.claude/skills/blog/references/geo-optimization.md      -> fuer AI-Citability

EIGENE REFERENZEN (immer lesen):
  references/content-production.md   -> Wireframe-zu-Content Konvertierung
  references/quality-gates.md        -> Kombinierte Qualitaetskriterien
```

### 3b -- Content-Regeln anwenden

Fuer JEDE Wireframe-SOLL-Sektion schreibe den Content nach diesen Regeln:

**Answer-First (PFLICHT fuer jede H2-Sektion):**
- Erster Absatz: 40-60 Woerter mit konkreter Statistik + Quelle + direkter Antwort
- Nie mit einer Frage oder allgemeiner Aussage beginnen

**Readability-Ziele:**
- Flesch Reading Ease: 60-70 (optimal), 55-75 (akzeptabel)
- Satzlaenge: Durchschnitt 15-20 Woerter, Varianz SD >= 6
- Absatzlaenge: 40-80 Woerter (max 150)
- Passiv: <= 10% der Saetze
- Uebergangswoerter: 20-30% der Saetze

**Statistik-Dichte:**
- Mindestens 1 Statistik pro 200 Woerter
- Format: "[Zahl] ([Quellenname](URL), Jahr)"
- Nur Tier 1-3 Quellen verwenden

**E-E-A-T Signale:**
- Inline-Quellenangaben bei jeder Statistik
- Expertise-Signale wo passend
- Vertrauensindikatoren (Siegel, Bewertungen, Zertifizierungen)

**Citation Capsules (1 pro H2-Sektion):**
- 40-60 Woerter, selbststaendig zitierfaehig
- Enthaelt Kernaussage + Statistik
- Kann von AI-Systemen als Antwort extrahiert werden

**Visuelles Pacing:**
- 1 visuelles Element pro 300-500 Woerter
- Alterniere: Bild -> Tabelle/Chart -> Callout -> Bild
- Nie zwei gleiche Typen hintereinander

### 3c -- Sektions-spezifische Produktion

Lies `references/content-production.md` fuer die vollstaendigen Konvertierungsregeln.

**Zusammenfassung der Sektions-Typen:**

```
HERO-BEREICH:
  -> H1 mit Keyword (exakt aus Wireframe-Placeholder)
  -> Subheadline: 1 Satz mit Kernversprechen + Statistik
  -> CTA-Button (Text + Design aus Wireframe-Placeholder)
  -> Hero-Bild (aus Recherche oder Wireframe-Anweisung)

TRUST-SIGNALE:
  -> Konkrete Zahlen (aus Wireframe: "X Berechnungen", "Y Bewertungen")
  -> Siegel/Logos (als Platzhalter-Referenz)
  -> Horizontal nebeneinander

HAUPTINHALT (Content-Sektionen):
  -> Fuer jede H2-Sektion: Answer-First + Statistik + Citation Capsule
  -> Heading als Frage formulieren (60-70% der H2s)
  -> 300-400 Woerter pro H2-Sektion
  -> Interne Links natuerlich einbauen (5-10 pro 2000 Woerter)

FAQ (AUS PAA):
  -> PAA-Fragen aus Report als Fragen verwenden
  -> 40-60 Woerter Antwort pro Frage, mit Statistik
  -> Als <details>/<summary> Accordion oder Heading-basiert
  -> FAQPage JSON-LD Schema einbauen

BILD / INFOGRAFIK:
  -> Bild aus Recherche mit vollem alt-Text
  -> Beschreibender Figcaption-Text
  -> Lazy Loading (ausser LCP-Bild im Hero)

CALL-TO-ACTION:
  -> Text + Design aus Wireframe-Placeholder
  -> Kontextuell nach Wertlieferung
  -> First-Person-Copy ("Mein Angebot..." / "Start my...")

INTERNE VERLINKUNG:
  -> Links aus Wireframe-Anweisungen
  -> Beschreibende Anchor-Texte (nie "hier klicken")
  -> 3-5 Links in eigenem Block oder integriert

LEISTUNGSUEBERSICHT (Service-Seite):
  -> 3-6 Leistungen als Karten mit Icon, Titel, Kurzbeschreibung
  -> Jede Karte mit eigener Mini-CTA ("Mehr erfahren" / "Termin buchen")
  -> Keywords natuerlich in Leistungstitel einbauen

PREISE / PAKETE (Service-Seite, Produkt-Seite):
  -> Preistabelle oder Paketkarten (2-4 Optionen)
  -> "Beliebteste" Option hervorgehoben
  -> Transparente Preise (ab-Preise wenn noetig, nie verstecken)
  -> Pricing Schema (Offer) einbauen

ABLAUF / PROZESS (Service-Seite):
  -> 3-5 nummerierte Schritte mit Icons
  -> Zeitleiste oder vertikale Stepper-Darstellung
  -> Adressiert Barriere "Komplexitaet" aus User Story

BUCHUNG / ANFRAGE (Service-Seite, Standortseite):
  -> Prominentes Formular oder Calendly/Buchungs-Embed
  -> Wenige Felder (Name, Kontakt, Anliegen -- max 5)
  -> Trust-Hinweis direkt am Formular ("Kostenlos & unverbindlich")
  -> First-Person-Copy: "Meine Anfrage senden"

VERGLEICHSMATRIX (Vergleichsseite):
  -> Feature-Tabelle mit Haekchen/Kreuzen/Werten
  -> Spalten = Optionen, Zeilen = Kriterien
  -> Gewinner-Markierung bei klarer Empfehlung
  -> Responsive: Tabelle scrollbar auf Mobile

DETAILVERGLEICH (Vergleichsseite):
  -> Pro Kriterium eine H3-Sektion mit Erklaerung
  -> Answer-First pro Kriterium ("Option A gewinnt bei X weil...")
  -> Objektiver Ton, faktenbasiert

VOR- UND NACHTEILE (Vergleichsseite):
  -> Pro/Contra-Listen pro Option
  -> Gruene Haekchen / rote Kreuze
  -> Maximal 5 Punkte pro Seite

EMPFEHLUNG (Vergleichsseite):
  -> Klare Aussage: "Fuer [Zielgruppe] empfehlen wir [Option]"
  -> Begruendung in 2-3 Saetzen
  -> CTA zur empfohlenen Option

STANDORT-INFO (Standortseite):
  -> Adresse, Telefon, E-Mail als strukturierte Daten
  -> Oeffnungszeiten als Tabelle
  -> Anfahrtsbeschreibung (OEPNV + Auto + Parken)
  -> LocalBusiness Schema einbauen

KARTE / ANFAHRT (Standortseite):
  -> Google Maps Embed oder statische Karte
  -> Responsive (100% Breite, feste Hoehe 300-400px)
  -> Marker mit Firmenname

ERGEBNIS-ERKLAERUNG (Tool-Seite):
  -> Erklaert was das Ergebnis bedeutet
  -> Einordnung: "Gut / Mittel / Schlecht" mit Kontext
  -> Handlungsempfehlungen basierend auf Ergebnis
  -> Statistiken fuer Kontext ("Der Durchschnitt liegt bei...")

METHODIK / BERECHNUNG (Tool-Seite):
  -> Erklaert die Berechnungsgrundlage transparent
  -> Datenquellen nennen (Tier 1-3)
  -> Formel oder Logik vereinfacht darstellen
  -> Baut Vertrauen auf ("Basierend auf Daten von [Quelle]")

VERWANDTE TOOLS (Tool-Seite):
  -> 2-4 verwandte Rechner/Tools als Karten
  -> Kurzbeschreibung + Link
  -> Thematisch passend zum Haupt-Tool
```

---

## Schritt 4: Seite assemblieren

### 4a -- HTML-Output

```
IF Output = HTML:

1. Lies das passende Template:
   - Deutsch: assets/page-template.html
   - Englisch: assets/page-template-en.html

2. Kopiere den <style> Block (CSS) aus dem Template

3. Generiere den <body> Inhalt direkt aus den produzierten Sektionen
   WICHTIG: Schreibe echten HTML-Content, NICHT Template-Platzhalter ersetzen

4. Fuege im <head> ein:
   - <title> aus Wireframe Meta-Kommentar
   - <meta name="description"> aus Wireframe Meta-Kommentar
   - Open Graph Tags (og:title, og:description, og:image, og:type, og:url)
   - Twitter Card Tags (twitter:card, twitter:title, twitter:description)
   - Canonical URL
   - JSON-LD Schema (je nach Seitentyp):
     * WebPage/BlogPosting Schema (immer)
     * FAQPage Schema (wenn FAQ-Sektion vorhanden)
     * BreadcrumbList Schema (immer)
     * Organization/Person Schema (wenn Autor angegeben)
     * Service Schema (bei Service-Seite: serviceType, provider, areaServed)
     * LocalBusiness Schema (bei Standortseite: address, geo, openingHours)
     * WebApplication Schema (bei Tool-Seite: applicationCategory, offers)
     * Product Schema mit AggregateRating (bei Produkt-Seite)
     * ItemPage Schema (bei Vergleichsseite)

5. Speichere als: sxo-page-[KEYWORD-SLUG].html
```

### 4b -- Markdown-Output

```
IF Output = MD:

1. YAML Frontmatter generieren:
   ---
   title: "[Title aus Wireframe Meta-Kommentar]"
   description: "[Meta Description aus Wireframe]"
   date: "YYYY-MM-DD"
   lastUpdated: "YYYY-MM-DD"
   author: "[Falls bekannt]"
   coverImage: "[Bild-URL aus Recherche]"
   coverImageAlt: "[Beschreibender Alt-Text]"
   tags: ["keyword1", "keyword2", "keyword3"]
   schema:
     type: "[WebPage|BlogPosting]"
     faqPage: true/false
   ---

2. Content als Standard-Markdown:
   - H1 (# Title)
   - Key Takeaways als Blockquote
   - H2 Sektionen (## Frage-Format)
   - Bilder als ![alt](url)
   - Links als [Text](url)
   - FAQ als H2 + H3 oder <details>/<summary>

3. Schema-Markup als HTML-Block am Ende einbetten

4. Speichere als: sxo-page-[KEYWORD-SLUG].md
```

---

## Schritt 5: Qualitaetspruefung

### 5a -- Interne Verifikation (PFLICHT)

Pruefe JEDEN dieser Punkte und liste Ergebnisse auf:

```
WIREFRAME-ABDECKUNG:
  [ ] Alle SOLL-Sektionen aus Wireframe umgesetzt?
  [ ] Alle Platzhalter aufgeloest (kein [PLACEHOLDER] im Output)?
  [ ] Sektionsreihenfolge entspricht Wireframe?
  [ ] Empfohlener Seitentyp umgesetzt?

GAP-ABDECKUNG:
  [ ] Alle High-Priority Gaps aus Report adressiert?
  [ ] User Story vollstaendig bedient?
  [ ] PAA-Fragen in FAQ aufgenommen?

CONTENT-QUALITAET:
  [ ] Answer-First in jeder H2-Sektion?
  [ ] Mind. 8 Statistiken mit Quellenangabe?
  [ ] Mind. 1 Citation Capsule pro H2?
  [ ] Keine erfundenen Statistiken (alle aus Recherche)?
  [ ] Readability: Flesch 60-70 geschaetzt?

TECHNISCH:
  [ ] Schema-Markup vorhanden und valide?
  [ ] Meta-Tags vollstaendig (Title, Description, OG, Twitter)?
  [ ] Bilder mit alt-Text?
  [ ] Interne Links vorhanden?
  [ ] HTML/MD valide und korrekt formatiert?
```

### 5b -- Blog-Reviewer Agent (OPTIONAL)

```
IF User wuenscht Quality-Score ODER bei Unsicherheit:
  -> Spawne blog-reviewer Agent
  -> Uebergib den generierten Content
  -> Zeige 100-Punkte-Score und Verbesserungsvorschlaege
```

---

## Schritt 6: Zusammenfassung ausgeben

Gib nach dem Speichern eine Zusammenfassung aus:

```
SXO-Seite erstellt: sxo-page-[keyword-slug].[html|md]

Quellen:
  - Report: [report-dateiname]
  - Wireframe: [wireframe-dateiname]
  - Seitentyp: [empfohlener Typ]

Content-Ueberblick:
  - [Anzahl] H2-Sektionen produziert
  - [Anzahl] Statistiken mit Quellenangabe
  - [Anzahl] Bilder eingebunden
  - [Anzahl] PAA-Fragen als FAQ
  - [Anzahl] interne Links
  - Schema: [Liste der Schema-Typen]

Gap-Abdeckung:
  - [X/Y] High-Priority Gaps adressiert
  - [X/Y] Medium-Priority Gaps adressiert
  - User Story: vollstaendig/teilweise bedient

Naechste Schritte:
  - [ ] Bilder durch eigene ersetzen (falls Stockfotos)
  - [ ] Interne Links auf echte URLs anpassen
  - [ ] CTA-Links auf Conversion-Ziel setzen
  - [ ] Optional: /blog-analyze fuer detaillierten Quality-Score
```

---

## Fehlerbehandlung

```
IF Wireframe-Datei nicht parsbar:
  -> Fehlermeldung: "Die Wireframe-Datei konnte nicht gelesen werden."
  -> Pruefe ob es eine gueltige sxo-wireframe-*.html ist
  -> Biete an: "/sxo-builder [report] fuer einen neuen Wireframe"

IF Report-Datei nicht parsbar:
  -> Warnung: "Report konnte nicht gelesen werden. Nutze nur Wireframe-Daten."
  -> Fahre mit reduziertem Datenset fort (kein Gap-Matching)

IF Blog-Researcher nicht verfuegbar / keine Ergebnisse:
  -> Warnung: "Statistik-Recherche war nicht moeglich."
  -> Schreibe Content ohne Statistiken
  -> Markiere Stellen mit [STATISTIK ERGAENZEN: Thema "..."]
  -> Ziel: Seite ist trotzdem strukturell korrekt

IF Blog-Referenzen nicht gefunden:
  -> Verwende eigene references/content-production.md als Fallback
  -> Die wichtigsten Regeln (Answer-First, Readability) sind dort zusammengefasst

IF Bestehender Beitrag hat Konflikte mit Wireframe:
  -> Wireframe hat Prioritaet (UX-Optimierung)
  -> Bestehender Content wird nur uebernommen wenn er den Standards entspricht
```

## Qualitaetsstandards

- **Wireframe ist verbindlich:** Die SOLL-Struktur definiert die Seitenarchitektur. Kein Abweichen.
- **Platzhalter werden AUFGELOEST, nicht kopiert:** Aus `[CTA: "Jetzt berechnen"]` wird ein echter Button-HTML.
- **Keine erfundenen Daten:** Jede Statistik muss aus der Recherche stammen. Lieber eine Luecke markieren als Zahlen erfinden.
- **Answer-First ist nicht optional:** Jede H2-Sektion beginnt mit der Antwort, nicht mit einer Einleitung.
- **User Story steuert den Ton:** Der Content-Ton leitet sich aus der User Story ab (Wissensstand, emotionale Lage, Barrieren).
- **Blog-Skills werden nie veraendert:** Referenzen werden nur gelesen, Agents nur gespawnt. Kein Write-Zugriff auf Blog-Skill-Dateien.

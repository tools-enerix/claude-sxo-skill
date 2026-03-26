---
name: sxo-persona
description: >
  Erstellt ein Persona-Feedback-Dashboard als HTML-Datei auf Basis eines SXO-Analyzer
  Reports und/oder einer SXO Page. Kann auch standalone mit URL + Keyword arbeiten
  (fuehrt dann intern eine SERP-Analyse durch, ohne HTML-Report zu erzeugen).
  Leitet 4-7 Personas aus Intent-Signalen ab (Related Searches, PAA, User Story,
  Gap-Analyse), generiert Flat-Illustration-Avatare via Nano Banana MCP mit lokalem
  Bild-Cache, bewertet die Zielseite aus jeder Persona-Perspektive (Score 1-100)
  und gibt konkrete Verbesserungsvorschlaege. Supports German and English.
  Use when user says "SXO Persona", "Persona Dashboard", "Persona Analyse",
  "Persona erstellen", "create personas", "persona feedback", "Nutzer-Feedback",
  "user feedback dashboard", "Zielgruppen-Analyse", "audience analysis",
  "Persona aus Report", "personas from report", "wer sucht das",
  "who is searching for this", or "SXO Persona Dashboard".
  Do NOT use for: marketing personas without SXO context, buyer personas for ads,
  UX research interviews, or general user research.
argument-hint: "[keyword] [url] | [sxo-report-datei] [sxo-page-datei|url]"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - WebFetch
  - Agent
  - "mcp__dataforseo__*"
---

# SXO-Persona -- Persona-Feedback-Dashboard aus SXO-Report

Der SXO-Persona Skill erzeugt ein visuelles **Persona-Feedback-Dashboard**, das zeigt:

> **Wer sucht dieses Keyword, was erwartet jede Person -- und wie gut liefert die Seite?**

Logik: **SERP-Signale -> Intent-Cluster -> Personas -> Scoring gegen Zielseite -> Handlungsempfehlungen**

---

## Schritt 0: Inputs erkennen und validieren

### 0a -- Inputs erkennen (4 Modi)

```
Suche mit Glob im aktuellen Arbeitsverzeichnis nach:

1. SXO-Report:  sxo-report-*.html   (aus /sxo-analyzer)
2. SXO-Page:    sxo-page-*.html     (aus /sxo-page)
3. Argumente:   URL und/oder Keyword als Argument

Bestimme den Modus:

MODUS A -- Report gefunden:
  -> Zeige gefundene Datei(en)
  -> Falls mehrere Reports: User waehlen lassen
  -> Lies den Report mit Read-Tool
  -> IF zusaetzlich SXO-Page gefunden:
       -> Nutze die Page fuer praeziseres Scoring
       -> Hinweis: "SXO-Page gefunden -- Scoring basiert auf tatsaechlichem Seiteninhalt"
  -> Weiter mit Schritt 1 (Daten aus Report extrahieren)

MODUS B -- Kein Report, aber URL + Keyword als Argumente:
  -> Standalone-Modus: Fuehre interne SERP-Analyse durch (siehe Schritt 0c)
  -> Hinweis: "Standalone-Modus: Fuehre SERP-Analyse fuer '[KEYWORD]' durch..."
  -> Weiter mit Schritt 0c

MODUS C -- Kein Report, nur URL (ohne Keyword):
  -> Frage den User nach dem Fokus-Keyword:
     "Fuer die Persona-Analyse brauche ich ein Fokus-Keyword.
      Welches Keyword soll ich analysieren?"
  -> Warte auf Antwort
  -> Dann weiter wie Modus B (Standalone mit URL + Keyword)

MODUS D -- Weder Report noch URL:
  -> Fehler: "Ich brauche mindestens einen SXO-Report oder eine URL + Keyword."
  -> "Option 1: /sxo-analyzer [keyword] [url]  (vollstaendiger Report)"
  -> "Option 2: /sxo-persona [keyword] [url]   (Standalone-Analyse)"
```

### 0b -- Spracherkennung

Erkenne die Dashboard-Sprache automatisch:

1. **Aus SXO-Report:** `<html lang="de">` -> Deutsch, `<html lang="en">` -> Englisch
2. **Aus URL-TLD:** `.de/.at/.ch` -> Deutsch, `.com/.co.uk/.io` -> Englisch
3. **Aus Keyword:** Deutsche Begriffe -> Deutsch, englische -> Englisch

```
IF Sprache = Englisch:
  -> Verwende CSS aus assets/persona-template-en.html
  -> Schreibe ALLE Texte auf Englisch
  -> Englische Labels (Search Motive, Expectation, Improvements, etc.)
ELSE:
  -> Verwende CSS aus assets/persona-template.html
  -> Deutsche Labels (Suchmotiv, Erwartung, Verbesserungen, etc.)
```

### 0c -- Standalone-Modus (SERP-Analyse ohne Report)

Wenn Modus B oder C aktiv ist, fuehre die SERP-Analyse intern durch.
Ziel: Dieselben Datenfelder wie in Schritt 1 erzeugen, aber aus Live-SERP-Daten statt aus einem HTML-Report.

**WICHTIG:** Es wird KEIN HTML-Report erzeugt. Alle Daten bleiben im Arbeitskontext.

```
SCHRITT 0c-1: SERP-Daten holen (ein einzelner API-Call)

  Rufe auf: mcp__dataforseo__serp_organic_live_advanced
    keyword:       KEYWORD
    location_code: 2276 (Deutschland) bzw. passend zur Sprache
    language_code: "de" bzw. "en"
    depth:         30

  Dieser Call liefert:
    - Organic Top-10/30 Ergebnisse
    - Related Searches (item_types: "related_searches")
    - People Also Ask (item_types: "people_also_ask")
    - Featured Snippets (item_types: "featured_snippet")
    - Google Ads (item_types: "paid")
    - AI Overview (item_types: "ai_overview")

SCHRITT 0c-2: Daten in Report-Format mappen

  Aus den SERP-Daten extrahiere:

  RELATED_SEARCHES:
    -> Fuer jedes Related-Search-Item:
       SUCHBEGRIFF: title
       INTENT_BADGE: Leite Intent ab (Informational/Commercial/Transactional/Local/DIY)
       Nutze mcp__dataforseo__dataforseo_labs_search_intent fuer praezise Intent-Klassifikation

  PAA_FRAGEN:
    -> Fuer jedes People-Also-Ask-Item:
       PAA_FRAGE: title
       PAA_ANTWORT: description (falls vorhanden)

  ADS_SIGNALE:
    -> Fuer jedes Paid-Item:
       ADS_TITLE: title
       ADS_DESCRIPTION: description
       ADS_URL: url
    -> Interpretation: Welche Botschaften werden getestet? Preispunkte?

  TOP_10_ERGEBNISSE:
    -> Fuer jedes Organic-Item (Position 1-10):
       TITLE, URL, DESCRIPTION
    -> Analyse: Welche Themen dominieren? Content-Typen?

SCHRITT 0c-3: User Story ableiten

  Aus den gesammelten SERP-Signalen leite die User Story ab:

  1. WISSENSSTAND: Aus Komplexitaet der PAA-Fragen
     - Einfache Fragen ("Was ist...?") -> Einsteiger
     - Vergleichsfragen ("Was ist besser...?") -> Fortgeschritten
     - Detailfragen ("Wie konfiguriere ich...?") -> Experte

  2. JOURNEY_PHASE: Aus Intent-Verteilung
     - Ueberwiegend Informational -> Recherche
     - Gemischt Info+Commercial -> Vergleich
     - Ueberwiegend Commercial/Transactional -> Entscheidung

  3. EMOTIONALE_LAGE: Aus Tonalitaet der Suchanfragen
     - "Lohnt sich...?" -> Unsicherheit
     - "Beste/Top..." -> Optimismus
     - "Problem/Fehler..." -> Frustration

  4. BARRIEREN: Aus PAA-Fragen und Related Searches
     - Preisfragen -> Kostenbarriere
     - "Erfahrungen" -> Vertrauensbarriere
     - "Nachteile/Risiken" -> Risikobarriere

  5. PRIMAERES_ZIEL + SEKUNDAERES_ZIEL: Aus dominantem Intent

  6. USER_STORY_STATEMENT: Formuliere als:
     "Als [Rolle] mit [Wissensstand] moechte ich [Ziel],
      damit ich [Nutzen]. Meine groesste Sorge ist [Barriere]."

SCHRITT 0c-4: Seiteninhalte holen (fuer Scoring)

  -> Hole die Zielseite via WebFetch (URL aus Argument)
  -> Extrahiere: Headline, Meta-Description, Hauptinhalt, Trust-Signale
  -> Scoring-Modus: "Basierend auf Live-URL (Standalone)"

SCHRITT 0c-5: Gap-Analyse ableiten

  Vergleiche SERP-Erwartungen mit Seiteninhalt:
  -> Fuer jedes SERP-Signal (Related Search, PAA, Ads-Botschaft):
     Pruefe ob die Zielseite dieses Thema abdeckt
  -> Erstelle Gap-Items mit Prioritaet:
     - SERP-Signal stark + Seite fehlt = high
     - SERP-Signal mittel + Seite schwach = medium
     - SERP-Signal schwach + Seite fehlt = low

Danach: Weiter mit Schritt 2 (Personas ableiten).
Die Daten aus 0c-2/0c-3/0c-5 ersetzen die Report-Daten aus Schritt 1.
```

---

## Schritt 1: Daten aus SXO-Report extrahieren

Lies den SXO-Report und extrahiere diese Datenfelder. Die HTML-Struktur des Reports folgt einem festen Schema:

### 1a -- Metadaten

```
Aus dem <header class="report-header">:
  KEYWORD:    Text aus <h1> (nach "SXO-Analyse: " bzw. "SXO Analysis: ")
  URL:        href aus .meta-value a
  DATUM:      Text aus .meta-value (Datum/Date Feld)
```

### 1b -- Related Searches / Autocomplete (Section 1a)

```
Aus der Tabelle in "Autocomplete / Related Searches":
  Fuer jede <tr> in <tbody>:
    SUCHBEGRIFF:  Text aus erster <td>
    INTENT_BADGE: Text aus <span class="badge ...">

  -> Ergibt eine Liste von (Suchbegriff, Intent-Typ) Paaren
  -> Jeder Intent-Typ ist ein Persona-Kandidat

Aus dem Interpretations-Absatz (<p> nach "Interpretation"):
  AUTOCOMPLETE_INTERPRETATION: Freitext mit Cluster-Analyse
```

### 1c -- PAA-Fragen (Section 1d)

```
Aus der <ol> in "People Also Ask" / "Aehnliche Fragen":
  Fuer jedes <li>:
    PAA_FRAGE:  Text (inklusive Preise, Details)
    HAT_AI_OVERVIEW: true wenn <span class="badge badge-info">AI Overview</span>

Aus dem Interpretations-Absatz:
  PAA_INTERPRETATION: Freitext
```

### 1d -- Google Ads Signale (Section 1b)

```
Aus "Google Ads / Shopping-Signale" bzw. "Google Ads Messages":
  ADS_BEOBACHTUNG:    Freitext (Beobachtung/Observation)
  ADS_INTERPRETATION: Freitext
  -> Extrahiere: Preispunkte, A/B-getestete Botschaften, kommerzielle Signale
```

### 1e -- User Story (Section 2)

```
Aus der Tabelle "Identifizierte Elemente":
  Fuer jede <tr> in <tbody>:
    ELEMENT: Text aus erster <td> (z.B. "Wissensstand", "Journey-Phase", "Barrieren")
    WERT:    Text aus zweiter <td>

  -> Besonders wichtig fuer Persona-Ableitung:
     - Wissensstand / Knowledge Level
     - Journey-Phase / Journey Phase
     - Emotionale Lage / Emotional State
     - Barrieren / Barriers
     - Primaeres Ziel / Primary Goal
     - Sekundaeres Ziel / Secondary Goal

Aus .user-story-quote:
  USER_STORY_STATEMENT: Volltext
```

### 1f -- Gap-Analyse (Section 3b)

```
Aus "User Story Coverage (Gap-Analyse)":
  Fuer jedes <div class="gap-item gap-{priority}">:
    GAP_NAME:      Text aus <h4>
    GAP_PRIORITY:  high | medium | low (aus Klasse)
    GAP_SERP:      Text aus div mit .gd-label "SERP-Signal"
    GAP_ZIELSEITE: Text aus div mit .gd-label "Zielseite"
    GAP_TEXT:       Text aus div mit .gd-label "Gap"

  -> Jeder High-Priority-Gap kann eine eigene Persona rechtfertigen
```

### 1g -- First Screen Check (Section 3a)

```
Aus "First Screen Check":
  Fuer jede <tr> in <tbody>:
    ELEMENT:    Text aus erster <td>
    STATUS:     pass | warn | fail (aus badge-Klasse)
    BEWERTUNG:  Text aus dritter <td>
```

### 1h -- Gesamturteil (Section 3c)

```
Aus .verdict:
  VERDICT_CLASS: verdict-good | verdict-partial | verdict-bad
  VERDICT_TEXT:  Freitext
```

---

## Schritt 2: Personas ableiten

Lies die Referenzdatei `references/persona-derivation.md` fuer die vollstaendigen Ableitungsregeln.

### 2a -- Intent-Cluster bilden

```
1. Gruppiere alle Related Searches nach Intent-Badge:
   - Gleiche Badges = gleicher Cluster (z.B. alle "Preis" = 1 Cluster)
   - ABER: Unterscheide innerhalb eines Clusters, wenn der Kontext
     sich grundlegend unterscheidet (z.B. "Preis Anbieter A" vs. "Preis selber machen")

2. Ordne PAA-Fragen den Clustern zu:
   - Preisbezogene PAA -> Preis-Cluster
   - Qualitaetsfragen -> Qualitaets-Cluster
   - Grundsatzfragen ("Lohnt es sich?") -> eigener Cluster "Unsicherheit"

3. Pruefe Gap-Analyse auf unabgedeckte Cluster:
   - High-Priority-Gap ohne passenden Cluster -> neuer Cluster

4. User Story als Basis-Persona:
   - Die User Story beschreibt den "typischen" Suchenden
   - Daraus wird die Haupt-Persona abgeleitet
   - Weitere Personas sind Varianten mit anderem Fokus
```

### 2b -- Persona-Anzahl bestimmen

```
Ziel: 4-7 Personas

IF weniger als 4 unterscheidbare Cluster:
  -> Teile den groessten Cluster in Sub-Personas auf
  -> Z.B. "Preis" -> "Sparfuchs" (billigste Option) + "Qualitaetsbewusster" (bestes P/L)
  -> Minimum: 4 Personas

IF mehr als 7 Cluster:
  -> Merge die aehnlichsten Cluster
  -> Priorisiere Cluster mit High-Priority-Gaps
  -> Maximum: 7 Personas
```

### 2c -- Persona-Details ausarbeiten

Fuer JEDE Persona erstelle:

```
1. NAME + DEMOGRAFIE
   - Alliterativer Vorname + Nachname-Initial oder Spitzname
   - Alter, Beruf, 1 relevantes Detail
   - MUSS zur Branche passen (nicht generisch!)
   - Deutsch: "Preisbewusste Petra, 34, Studentin"
   - English: "Budget-Conscious Ben, 28, Graduate Student"

2. SUCHMOTIV & INTENT
   - Welche Suchphrase wuerde diese Persona tippen?
   - Was ist der konkrete Ausloser? (Event, Problem, Vergleich)
   - Intent-Typ: Informational / Transaktional / Commercial / Navigational / Lokal / DIY
   - Referenz auf den Related-Search-Eintrag oder PAA-Frage

3. ERWARTUNG AN DIE SEITE
   - 2-3 Saetze: Was will diese Person KONKRET finden?
   - Welche Fragen muessen beantwortet werden?
   - Welches Format erwartet sie? (Tabelle, Rechner, Text, Video)

4. SCORE (1-100) -- nur wenn Page/URL verfuegbar
   - Berechnung: siehe Schritt 3
   - ODER: "Projiziert" basierend auf Gap-Analyse

5. VERBESSERUNGSVORSCHLAEGE (2-4 Punkte)
   - Konkret und umsetzbar
   - Aus der Perspektive dieser Persona formuliert
   - Referenz auf Gap-Analyse oder First-Screen-Check

6. ARCHETYPE (fuer Avatar-Bild)
   - Ordne jeder Persona einen Archetype-Key zu (siehe references/persona-images.md)
   - Mapping: Intent-Cluster -> Archetype-Key
     Preis -> price-conscious | Qualitaet -> quality-focused
     Lokal -> local-seeker | DIY -> diy-maker
     Anbieter -> provider-comparer | Angst/Unsicherheit -> anxious-decider
     Spezialfall -> special-case | Dringlichkeit -> urgent-user
     Informational -> knowledge-seeker | Commercial -> ready-buyer
   - Die Hauptpersona (aus User Story) bekommt immer "main-planner"
   - WICHTIG: Keine zwei Personas duerfen denselben Archetype haben!
     Bei Kollision: sekundaeren Archetype verwenden (trust-seeker,
     expert-user, beginner, emotional-seeker, roi-calculator)
```

---

## Schritt 3: Scoring (wenn Seite verfuegbar)

### 3a -- Scoring-Quelle bestimmen

```
IF SXO-Page vorhanden (sxo-page-*.html):
  -> Lies die Page mit Read-Tool
  -> Score basiert auf tatsaechlichem Seiteninhalt
  -> Scoring-Modus: "Basierend auf SXO-Page"

ELIF URL als Argument UND Report vorhanden:
  -> Hole Seite via WebFetch
  -> Score basiert auf Live-Seite
  -> Scoring-Modus: "Basierend auf Live-URL"

ELIF nur Report vorhanden (kein Page, keine URL):
  -> Score basiert auf Gap-Analyse + First-Screen-Check aus dem Report
  -> Scoring-Modus: "Projiziert aus SXO-Report"
  -> Hinweis im Dashboard: "Scores sind projiziert -- fuer praezisere Bewertung
     SXO-Page erstellen oder URL angeben"
```

### 3b -- Scoring-Dimensionen (4 Dimensionen, je 25 Punkte)

Fuer JEDE Persona, bewerte:

```
DIMENSION 1: First-Screen-Relevanz (0-25 Punkte)
  "Wird das Suchmotiv dieser Persona im First Screen adressiert?"

  25: Headline + Hero sprechen genau diesen Intent an
  20: Intent ist erkennbar, aber nicht dominant
  15: Intent ist vorhanden, aber erst nach Scrollen
  10: Intent wird nur indirekt angesprochen
   5: Intent ist auf der Seite, aber versteckt
   0: Intent wird nicht adressiert

DIMENSION 2: Erwartungserfuellung (0-35 Punkte)
  "Findet diese Persona, was sie konkret sucht?"

  35: Alle erwarteten Inhalte in passendem Format vorhanden
  28: Meiste Inhalte da, aber Format nicht optimal
  21: Kerninhalte vorhanden, aber unvollstaendig
  14: Nur teilweise abgedeckt, wichtige Elemente fehlen
   7: Nur am Rande erwaehnt
   0: Nicht abgedeckt

DIMENSION 3: Barriereabbau (0-25 Punkte)
  "Werden die spezifischen Bedenken/Barrieren dieser Persona adressiert?"

  25: Alle Barrieren proaktiv entschaerft (Trust, Preis, Risiko)
  20: Meiste Barrieren adressiert
  15: Einige Barrieren adressiert, andere ignoriert
  10: Nur die offensichtlichsten Barrieren
   5: Minimal
   0: Keine Barrieren adressiert

DIMENSION 4: Trust-Signale (0-15 Punkte)
  "Gibt es passende Vertrauenssignale fuer diese Persona?"

  15: Bewertungen, Zertifikate, Social Proof -- passend zum Persona-Kontext
  12: Gute Trust-Signale, aber nicht persona-spezifisch
   9: Basis-Trust vorhanden (Impressum, SSL)
   6: Wenige Trust-Signale
   3: Kaum Trust
   0: Keine Trust-Signale

GESAMTSCORE = Dim1 + Dim2 + Dim3 + Dim4 (max. 100)
```

### 3c -- Scoring bei projiziertem Modus (nur Report)

```
IF Scoring-Modus = "Projiziert aus SXO-Report":

  Dim 1 (First-Screen): Leite aus First-Screen-Check ab
    - Alle 5 Checks "pass" -> 25
    - Gemischt -> anteilig
    - Passe an: Ist der Check fuer DIESE Persona relevant?

  Dim 2 (Erwartung): Leite aus Gap-Analyse ab
    - Persona hat relevanten Gap mit Prio "high" -> max 14
    - Persona hat relevanten Gap mit Prio "medium" -> max 21
    - Persona hat keinen relevanten Gap -> 28-35

  Dim 3 (Barrieren): Leite aus User Story "Barrieren" ab
    - Pruefe ob Gap-Analyse die Persona-spezifischen Barrieren adressiert

  Dim 4 (Trust): Leite aus First-Screen "Vertrauenssignale" ab
    - pass -> 12-15, warn -> 6-9, fail -> 0-3
```

---

## Schritt 4: Dashboard-Zusammenfassung berechnen

```
1. DURCHSCHNITT = Summe aller Persona-Scores / Anzahl Personas (gerundet)

2. SCHWAECHSTE_PERSONA = Persona mit niedrigstem Score
   -> Name + Score + 1-Satz-Erklaerung

3. STAERKSTE_PERSONA = Persona mit hoechstem Score
   -> Name + Score + 1-Satz-Erklaerung

4. TOP_HANDLUNGSFELDER (max 5):
   -> Sammle alle Verbesserungsvorschlaege aller Personas
   -> Dedupliziere aehnliche Vorschlaege
   -> Sortiere nach: Anzahl betroffener Personas (absteigend)
   -> Jedes Handlungsfeld zeigt: Beschreibung + betroffene Personas

5. SCORING_MODUS:
   -> "Basierend auf SXO-Page" | "Basierend auf Live-URL" | "Projiziert aus SXO-Report"
```

### 4b -- Persona-Bilder generieren (mit Cache)

Lies die Referenzdatei `references/persona-images.md` fuer Archetype-Prompts und Cache-Logik.

```
Fuer JEDE Persona:

1. ARCHETYPE_KEY = Persona.archetype (aus Schritt 2c)
2. LANG = "de" oder "en" (aus Schritt 0b)
3. CACHE_KEY = "{ARCHETYPE_KEY}-{LANG}.png"
4. CACHE_PATH = ~/.sxo-persona/image-cache/{CACHE_KEY}

5. Pruefe Cache:
   IF Datei existiert UND Dateigroesse > 0:
     -> Log: "Cache-Hit: {CACHE_KEY}"
     -> Lies Bild als base64 via Bash:
        base64_data=$(base64 -w 0 {CACHE_PATH})
     -> PERSONA_IMG_SRC = "data:image/png;base64,${base64_data}"

   ELSE (Cache-Miss):
     -> Log: "Cache-Miss: {CACHE_KEY} -- generiere Bild..."
     -> Erstelle Cache-Verzeichnis: mkdir -p ~/.sxo-persona/image-cache/
     -> Bestimme BG_COLOR aus Persona-Score:
        Score 0-29:  #fce4ec (soft coral)
        Score 30-49: #fff3e0 (soft peach)
        Score 50-69: #fffde7 (soft warm yellow)
        Score 70-89: #e3f2fd (soft sky blue)
        Score 90-100: #e8f5e9 (soft mint)
     -> Baue Prompt = BASIS_PROMPT + ARCHETYPE_ERWEITERUNG
        (siehe references/persona-images.md)
     -> Rufe gemini_generate_image auf (1:1, 512px)
     -> Kopiere generiertes Bild in Cache:
        cp ~/Documents/nanobanana_generated/<generated-file> {CACHE_PATH}
     -> Lies als base64
     -> PERSONA_IMG_SRC = "data:image/png;base64,${base64_data}"

6. Falls Bildgenerierung fehlschlaegt:
   -> Verwende Fallback: persona-avatar-placeholder (CSS-Klasse mit Emoji)
   -> Log: "Warnung: Bild fuer {CACHE_KEY} konnte nicht generiert werden"
   -> Dashboard trotzdem erstellen (Bild ist optional)
```

---

## Schritt 5: HTML-Dashboard generieren

### 5a -- CSS laden

```
1. Bestimme die Dashboard-Sprache (siehe Schritt 0b)
2. Lies das passende Template fuer den CSS-Block:
   - Deutsch:  assets/persona-template.html
   - English:  assets/persona-template-en.html
3. Kopiere den <style> Block woertlich
4. Generiere den <body> Inhalt direkt als HTML
```

### 5b -- HTML-Struktur generieren

Generiere den Body-Inhalt in dieser Reihenfolge:

```html
<!-- HEADER -->
<header class="report-header">
  <div class="label">SXO Persona-Dashboard</div>  <!-- bzw. "SXO Persona Dashboard" EN -->
  <h1>Persona-Feedback: <span>{{KEYWORD}}</span></h1>
  <div class="meta-grid">
    <!-- Zielseite, Datum, Scoring-Modus, Anzahl Personas -->
  </div>
</header>

<!-- SUMMARY -->
<div class="section">
  <div class="section-header">
    <div class="section-number">&#8984;</div>  <!-- oder Sigma-Zeichen -->
    <h2>Zusammenfassung</h2>  <!-- bzw. "Summary" EN -->
  </div>
  <div class="summary-card">
    <!-- Durchschnitts-Score (grosser SVG-Kreis) -->
    <!-- Schwaechste Persona + Staerkste Persona -->
    <!-- Scoring-Modus Hinweis -->
  </div>
</div>

<!-- USER STORY (aus Report uebernommen) -->
<div class="section">
  <div class="section-header">
    <div class="section-number">&#128100;</div>
    <h2>User Story</h2>
  </div>
  <div class="card">
    <div class="user-story-quote">{{USER_STORY_STATEMENT}}</div>
  </div>
</div>

<!-- PERSONA CARDS -->
<div class="section">
  <div class="section-header">
    <div class="section-number">&#128101;</div>
    <h2>Personas</h2>
  </div>
  <div class="persona-grid">
    <!-- 4-7 Persona-Cards, je eine pro Persona -->
    <!-- Reihenfolge: nach Score aufsteigend (schwaechste zuerst = groesster Handlungsbedarf) -->
  </div>
</div>

<!-- AGGREGIERTE HANDLUNGSFELDER -->
<div class="section">
  <div class="section-header">
    <div class="section-number">&#9889;</div>
    <h2>Top-Handlungsfelder</h2>  <!-- bzw. "Top Action Items" EN -->
  </div>
  <div class="card">
    <!-- Nummerierte Liste, max 5 Eintraege -->
    <!-- Jeder Eintrag: Beschreibung + betroffene Personas als Tags -->
  </div>
</div>

<!-- FOOTER -->
<footer class="report-footer">
  SXO Persona-Dashboard erstellt mit Claude Code &middot; sxo-persona Skill &middot; {{DATUM}}
</footer>
```

### 5c -- Persona-Card Struktur

Jede Persona-Card folgt diesem Schema:

```html
<div class="persona-card" style="--persona-color: {{COLOR}}">
  <div class="persona-header">
    <div class="score-circle" data-score="{{SCORE}}">
      <svg viewBox="0 0 120 120">
        <circle class="score-bg" cx="60" cy="60" r="54"/>
        <circle class="score-fill" cx="60" cy="60" r="54"
          stroke-dasharray="{{FILLED}} {{REMAINING}}"
          stroke-dashoffset="85"/>
      </svg>
      <div class="score-value">{{SCORE}}</div>
    </div>
    <!-- Avatar (aus Schritt 4b) -->
    <div class="persona-avatar-wrap">
      <!-- IF Bild vorhanden: -->
      <img class="persona-avatar" src="{{PERSONA_IMG_SRC}}" alt="{{PERSONA_NAME}}">
      <!-- ELSE (Fallback): -->
      <!-- <div class="persona-avatar-placeholder">&#128100;</div> -->
    </div>
    <div class="persona-identity">
      <h3>{{PERSONA_NAME}}</h3>
      <div class="persona-demo">{{DEMOGRAFIE}}</div>
      <span class="badge {{INTENT_BADGE_CLASS}}">{{INTENT_TYP}}</span>
    </div>
  </div>

  <div class="persona-field">
    <div class="pf-label">Suchmotiv</div>  <!-- bzw. "Search Motive" EN -->
    <p>{{SUCHMOTIV}}</p>
  </div>

  <div class="persona-field">
    <div class="pf-label">Erwartung an die Seite</div>  <!-- bzw. "Page Expectation" EN -->
    <p>{{ERWARTUNG}}</p>
  </div>

  <div class="persona-field">
    <div class="pf-label">Score-Begruendung</div>  <!-- bzw. "Score Reasoning" EN -->
    <div class="score-breakdown">
      <div class="sb-row">
        <span>First Screen</span>
        <div class="sb-bar"><div class="sb-fill" style="width: {{DIM1_PCT}}%"></div></div>
        <span>{{DIM1}}/25</span>
      </div>
      <div class="sb-row">
        <span>Erwartung</span>  <!-- bzw. "Expectation" EN -->
        <div class="sb-bar"><div class="sb-fill" style="width: {{DIM2_PCT}}%"></div></div>
        <span>{{DIM2}}/35</span>
      </div>
      <div class="sb-row">
        <span>Barrieren</span>  <!-- bzw. "Barriers" EN -->
        <div class="sb-bar"><div class="sb-fill" style="width: {{DIM3_PCT}}%"></div></div>
        <span>{{DIM3}}/25</span>
      </div>
      <div class="sb-row">
        <span>Trust</span>
        <div class="sb-bar"><div class="sb-fill" style="width: {{DIM4_PCT}}%"></div></div>
        <span>{{DIM4}}/15</span>
      </div>
    </div>
  </div>

  <div class="persona-field">
    <div class="pf-label">Verbesserungen</div>  <!-- bzw. "Improvements" EN -->
    <ul>
      <li>{{VERBESSERUNG_1}}</li>
      <li>{{VERBESSERUNG_2}}</li>
      <!-- 2-4 Punkte -->
    </ul>
  </div>
</div>
```

### 5d -- Score-Kreis berechnen (SVG)

```
Umfang = 2 * PI * 54 = 339.29
FILLED = (SCORE / 100) * 339.29
REMAINING = 339.29 - FILLED
```

### 5e -- Farbzuordnung

```
Score  0-29:  --persona-color: #dc2626  (Rot / Kritisch)
Score 30-49:  --persona-color: #ea580c  (Orange / Schwach)
Score 50-69:  --persona-color: #ca8a04  (Amber / Teilweise)
Score 70-89:  --persona-color: #2563eb  (Blau / Gut)
Score 90-100: --persona-color: #16a34a  (Gruen / Exzellent)
```

### 5f -- Dateiname

```
Dateiname: sxo-persona-[KEYWORD-SLUG].html

KEYWORD-SLUG: Keyword in Kleinbuchstaben, Leerzeichen -> Bindestriche, Umlaute -> ae/oe/ue/ss
Beispiel: "iPhone 13 Display Reparatur" -> "iphone-13-display-reparatur"
```

---

## Schritt 6: Ausgabe und Zusammenfassung

Nach dem Speichern der HTML-Datei, gib eine kurze Zusammenfassung aus:

```
Zeige:
1. Dateiname + Pfad
2. Anzahl Personas
3. Durchschnitts-Score
4. Schwaechste Persona (Name + Score)
5. Wichtigstes Handlungsfeld (1 Satz)
6. Scoring-Modus
```

---

## Qualitaetsregeln

### Persona-Qualitaet

```
REGEL 1: Jede Persona MUSS sich klar von den anderen unterscheiden
  -> Nicht: 2x "will guenstigen Preis" mit anderem Namen
  -> Sondern: "will billigsten Preis" vs. "will bestes Preis-Leistungs-Verhaeltnis"

REGEL 2: Namen muessen branchenspezifisch sein
  -> Nicht: "User A", "Persona 1", "Max Mustermann"
  -> Sondern: "Altbau-Andreas, 52" (Solarbranche), "Studentin Lena, 23" (Handy-Reparatur)

REGEL 3: Verbesserungsvorschlaege muessen umsetzbar sein
  -> Nicht: "Seite verbessern", "mehr Trust aufbauen"
  -> Sondern: "Preisvergleichstabelle (Anbieter vs. Apple vs. MediaMarkt) above-the-fold"

REGEL 4: Score-Begruendungen muessen nachvollziehbar sein
  -> Referenziere konkrete Seiteninhalte oder Gaps
  -> Nicht: "Die Seite ist mittelmassig"
  -> Sondern: "Preis sichtbar (119,90 EUR), aber ohne Einordnung gegenueber Apple (489 EUR)"

REGEL 5: Alliterative Namen sind OPTIONAL, nicht erzwungen
  -> Wenn ein passender alliterativer Name existiert: verwenden
  -> Wenn nicht: normaler Name ist besser als erzwungene Alliteration
```

### HTML-Qualitaet

```
REGEL 6: Selbststaendige Datei
  -> Kein externes CSS, kein externes JavaScript
  -> Alle Styles inline im <style> Block
  -> SVG direkt im HTML (kein externer Verweis)

REGEL 7: Responsive Design
  -> Persona-Grid: 2 Spalten Desktop, 1 Spalte Mobile
  -> Score-Kreise: min. 80px Durchmesser
  -> Lesbar auf 360px Breite

REGEL 8: Barrierefreiheit
  -> Farbkontrast: WCAG AA (4.5:1 fuer Text)
  -> Score-Kreise: Zahl ZUSAETZLICH zum Kreis (nicht nur visuell)
  -> Sinnvolle Ueberschriften-Hierarchie (h1 > h2 > h3)

REGEL 9: Print-Freundlich
  -> Print-Styles inkludieren (wie bei sxo-report Template)
  -> Score-Kreise muessen auch in Schwarz-Weiss lesbar sein
```

### Bild-Qualitaet

```
REGEL 10: Cache immer nutzen
  -> Niemals ein Bild generieren, wenn es bereits im Cache liegt
  -> Cache-Verzeichnis: ~/.sxo-persona/image-cache/
  -> Cache-Key: {archetype}-{lang}.png

REGEL 11: Bilder sind optional
  -> Dashboard MUSS auch ohne Bilder funktionieren
  -> Bei Fehler: persona-avatar-placeholder CSS-Klasse mit Emoji verwenden
  -> Niemals den gesamten Workflow abbrechen wegen eines Bildfehlers

REGEL 12: Archetype-Eindeutigkeit
  -> Keine zwei Personas im selben Dashboard duerfen denselben Archetype haben
  -> Bei Kollision: sekundaeren Archetype verwenden
  -> 16 Archetypes verfuegbar (siehe references/persona-images.md)

REGEL 13: Bildformat konsistent
  -> Alle Bilder als base64 inline im HTML (data:image/png;base64,...)
  -> Keine externen Bildverweise
  -> 56x56px Anzeige (CSS), 512px Quellaufloesung
```

---

## Sprachspezifische Labels

| Bereich | Deutsch | English |
|---|---|---|
| Header-Label | SXO Persona-Dashboard | SXO Persona Dashboard |
| Zusammenfassung | Zusammenfassung | Summary |
| Durchschnitts-Score | Durchschnitts-Score | Average Score |
| Schwaechste Persona | Schwaechste Persona | Weakest Persona |
| Staerkste Persona | Staerkste Persona | Strongest Persona |
| Scoring-Modus | Scoring-Modus | Scoring Mode |
| Suchmotiv | Suchmotiv & Intent | Search Motive & Intent |
| Erwartung | Erwartung an die Seite | Page Expectation |
| Score-Begruendung | Score-Begruendung | Score Reasoning |
| Verbesserungen | Verbesserungen | Improvements |
| Handlungsfelder | Top-Handlungsfelder | Top Action Items |
| Betrifft | Betrifft | Affects |
| Projiziert | Projiziert aus SXO-Report | Projected from SXO Report |
| First Screen | First Screen | First Screen |
| Erwartung (Dim) | Erwartung | Expectation |
| Barrieren (Dim) | Barrieren | Barriers |
| Trust | Trust | Trust |
| Footer | SXO Persona-Dashboard erstellt mit Claude Code | SXO Persona Dashboard generated with Claude Code |

---

## Wichtig

- Schreibe echtes HTML, keine Markdown-Reste
- Kopiere NUR das CSS aus dem Template -- generiere den Body direkt
- Versuche NICHT, die `{{PLATZHALTER}}` im Template zu ersetzen
- Alle Texte in der erkannten Sprache
- Verwende `&mdash;` fuer Gedankenstriche, `&euro;` fuer Euro, `&amp;` fuer &
- Nutze HTML-Entities fuer Umlaute im HTML oder UTF-8 direkt
- Score-Kreise: Verwende SVG `stroke-dasharray` fuer den Fortschrittskreis
- Persona-Cards sortieren: schwaechster Score zuerst (= groesster Handlungsbedarf oben)

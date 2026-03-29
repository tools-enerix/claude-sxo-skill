---
name: seo-sxo-builder
description: >
  Erstellt einen Vorher/Nachher-Wireframe als HTML-Datei auf Basis eines SXO-Analyzer
  Reports. Zeigt die aktuelle Seitenstruktur (IST) neben der optimierten Struktur (SOLL)
  mit konkreten Platzhaltern fuer Inhalte, CTAs, Trust-Signale und fehlende Sektionen.
  Downstream-Skill von seo-sxo-analyzer. Supports German and English -- auto-detects
  language from SXO report or keyword/URL. Use when user says "SXO Wireframe",
  "Wireframe erstellen", "Wireframe bauen", "build wireframe", "Seite umbauen",
  "Seitenstruktur optimieren", "Vorher Nachher", "before after wireframe",
  "page structure wireframe", "SXO Builder", "Wireframe aus Report",
  "wireframe from report", "Seitenstruktur aus SXO", or "page layout from SXO".
  Do NOT use for: general wireframing without SXO context, UI design, mockups,
  Figma export, or pixel-perfect design.
argument-hint: "[sxo-report-datei] oder [keyword] [url]"
allowed-tools:
  - Read
  - Write
  - Bash
  - WebFetch
  - Glob
  - Grep
  - "mcp__dataforseo__on_page_content_parsing"
---

# SXO-Builder -- Vorher/Nachher Wireframe aus SXO-Report

Der SXO-Builder erzeugt einen visuellen Seitenstruktur-Vergleich:
- **IST-Spalte:** Aktuelle Seitenstruktur mit markierten Problemen
- **SOLL-Spalte:** Optimierte Struktur mit konkreten Platzhaltern

> **Prinzip:** Kein Pixel-Design, sondern ein **Strukturplan** mit klaren Handlungsanweisungen. Platzhalter sagen dem User genau, WAS wo platziert werden soll und WARUM.

---

## Schritt 0: Inputs klaeren

### Variante A: SXO-Report vorhanden (Hauptflow)

```
IF User gibt SXO-Report-Datei an (z.B. "sxo-report-pv-ausrichtung-rechner.html"):
  -> Lies die Datei mit Read-Tool
  -> Extrahiere die Analyse-Daten (siehe Schritt 1)
  -> Fahre mit Schritt 1 fort

IF SXO-Analyse wurde gerade in dieser Konversation durchgefuehrt:
  -> Nutze die Analyse-Daten aus dem Konversationskontext
  -> Fahre mit Schritt 1 fort
```

### Variante B: Kein Report vorhanden (Fallback)

```
IF User gibt nur Keyword + URL an:
  -> Hinweis: "Fuer optimale Ergebnisse empfehle ich zuerst /seo-sxo-analyzer [keyword] [url]"
  -> Frage: "Soll ich trotzdem einen Basis-Wireframe erstellen?"
  -> Falls ja: Rufe on_page_content_parsing fuer die URL auf
  -> Erstelle vereinfachten Wireframe mit generischen Optimierungshinweisen
```

### Spracherkennung

Erkenne die Wireframe-Sprache automatisch:

1. **Aus SXO-Report:** Wenn der Report auf Deutsch ist -> Deutsch, auf Englisch -> Englisch
2. **Aus URL-TLD:** `.de/.at/.ch` -> Deutsch, `.com/.co.uk/.io` -> Englisch
3. **Aus Keyword:** Deutsche Begriffe -> Deutsch, englische -> Englisch

```
IF Sprache = Englisch:
  -> Verwende CSS aus assets/wireframe-template-en.html
  -> Englische Labels (Current State, Optimized State, etc.)
ELSE:
  -> Verwende CSS aus assets/wireframe-template.html
  -> Deutsche Labels (IST-Zustand, SOLL-Zustand, etc.)
```

---

## Schritt 1: Daten aus SXO-Report extrahieren

Lies den SXO-Report (HTML-Datei) und extrahiere folgende Datenpunkte:

### 1a -- Metadaten

```
KEYWORD:    Aus dem Report-Header (<h1> oder .meta-value)
URL:        Aus dem Report-Header (.meta-value mit Link)
DATUM:      Heutiges Datum (nicht das Report-Datum)
```

### 1b -- User Story

```
USER_STORY: Der Text aus dem .user-story-quote Block
            -> Wird woertlich in den Wireframe uebernommen
```

### 1c -- Gap-Analyse (Schritt 4b im SXO-Report)

Extrahiere ALLE Gap-Items. Jedes Gap hat:
```
Element:     Name des User Story Elements
SERP-Signal: Was die SERPs erwarten
Zielseite:   Was die Zielseite aktuell bietet
Gap:         Was fehlt
Prioritaet:  Hoch / Mittel / Niedrig
```

### 1d -- Optimierungsempfehlungen (Schritt 5 im SXO-Report)

```
EMPFOHLENE_OPTION: Die als "EMPFOHLEN" markierte Option (A oder B)
OPTION_TITEL:      Kurztitel der empfohlenen Option
OPTION_DETAILS:    Was wird veraendert? Welche Elemente adressiert?
```

### 1e -- Checklisten-Fails (Schritt 6 im SXO-Report)

Extrahiere alle Items mit `check-fail` oder `check-warn`:
```
FAILS:  Liste aller nicht-erfuellten Checklist-Items
WARNS:  Liste aller teilweise-erfuellten Items
```

### 1f -- First-Screen-Check (Schritt 4a im SXO-Report)

```
FIRST_SCREEN: Welche Elemente sind vorhanden/fehlen im First Screen?
              - Headline adressiert Keyword? ja/nein
              - Primaeres Tool/Inhalt zugaenglich? ja/nein
              - Vertrauenssignale sichtbar? ja/nein
              - CTA klar und prominent? ja/nein
              - Keine Hemmschwellen? ja/nein
```

### 1g -- Seitentyp-Analyse

Analysiere die SERP-Signale und den aktuellen Seitentyp, um eine Seitentyp-Empfehlung abzuleiten:

```
AKTUELLER_TYP: Was ist die Seite aktuell? (Blog, Landing-Page, Produktseite, Ratgeber, etc.)
SERP_SIGNALE:  Welche Content-Typen dominieren die Top-10?
               - Informational (Ratgeber, Erklaerungen, How-Tos)
               - Transactional (Rechner, Tools, CTAs, Formulare)
               - Commercial (Produktvergleiche, Preise, Bewertungen)
               - Navigational (Marken-Seiten)
```

Bestimme den empfohlenen Seitentyp nach dieser Matrix:

| SERP-Signal | User Story Ziel | Empfohlener Typ |
|---|---|---|
| Informational dominant + Tool/Rechner in Top-3 | Nutzer will verstehen UND handeln | **Hybrid** (Landing + Ratgeber) |
| Transactional dominant (Rechner, Konfiguratoren) | Nutzer will sofort Ergebnis | **Landing-Page** |
| Informational dominant (Ratgeber, Listen, How-To) | Nutzer will lernen/verstehen | **Blog-Beitrag / Ratgeber** |
| Commercial dominant (Vergleiche, Reviews, Preise) | Nutzer will kaufen/vergleichen | **Produkt-Seite** |
| Booking-Ads, Dienstleister-Listings, Preisranges | Nutzer will Dienstleistung buchen/anfragen | **Service-Seite** |
| "vs"-Queries, "beste X", Vergleichstabellen in SERPs | Nutzer will Optionen vergleichen und entscheiden | **Vergleichsseite** |
| Map Pack, "in der Naehe", Oeffnungszeiten in SERPs | Nutzer sucht lokalen Anbieter | **Standortseite** |
| Rechner/Tool in Featured Snippet, "X berechnen" | Nutzer will interaktives Ergebnis | **Tool-Seite** |
| Gemischt ohne klare Dominanz | Haengt von User Story ab | **Hybrid** (Landing + Ratgeber) |

Erstelle fuer jeden in Frage kommenden Typ eine Kurzbewertung:

```
Seitentyp-Option:
  name:        Landing-Page / Blog-Beitrag / Produkt-Seite / Hybrid /
               Service-Seite / Vergleichsseite / Standortseite / Tool-Seite
  passt_weil:  1-2 Saetze warum dieser Typ zu den SERP-Signalen passt
  risiko:      Was spricht dagegen (z.B. "zu wenig Info-Content fuer PAA-Abdeckung")
  empfohlen:   ja / nein (genau EINER ist empfohlen)
```

Die Seitentypen haben folgende Sektions-Schwerpunkte:

**Landing-Page:**
```
hero (CTA-fokussiert) -> trust-bar -> tool-section -> social-proof -> cta-section -> footer
Wenig Text, starker Conversion-Fokus, Trust above-the-fold
```

**Blog-Beitrag / Ratgeber:**
```
hero (informativ) -> content-main (ausfuehrlich) -> image-section -> faq-section -> internal-links -> footer
Viel Text, E-E-A-T-Signale, Inhaltsverzeichnis, keine CTA-Dominanz
```

**Produkt-Seite:**
```
hero (Produkt + Preis) -> trust-bar -> content-main (Features/Specs) -> social-proof -> cta-section -> faq-section -> footer
Preis/Leistung sichtbar, Vergleichstabellen, Bewertungen
```

**Hybrid (Landing + Ratgeber):**
```
hero (CTA + Keyword) -> trust-bar -> tool-section -> content-main (Ratgeber) -> image-section -> social-proof -> faq-section -> cta-section -> internal-links -> footer
Conversion-Elemente above-the-fold, informativer Ratgeber-Teil darunter
```

**Service-Seite:**
```
hero (Dienstleistung + CTA) -> trust-bar -> service-overview -> pricing-table -> process-steps -> social-proof -> faq-section -> booking-cta -> internal-links -> footer
Buchung/Anfrage above-the-fold, Preise transparent, Prozess erklaert, starke Trust-Signale (Bewertungen, Zertifizierungen, Garantien)
```

**Vergleichsseite:**
```
hero (Vergleichstitel) -> comparison-matrix -> detailed-comparison -> pros-cons -> recommendation -> faq-section -> cta-section -> internal-links -> footer
Feature-Vergleichstabelle als Kernelement, klare Empfehlung am Ende, objektiver Ton
```

**Standortseite:**
```
hero (Standort + CTA) -> trust-bar -> location-info -> service-overview -> map-embed -> social-proof -> faq-section -> contact-cta -> internal-links -> footer
Adresse/Karte prominent, Oeffnungszeiten, lokale Bewertungen, Kontaktformular, LocalBusiness Schema
```

**Tool-Seite:**
```
hero (Tool-Name + Kurzbeschreibung) -> tool-section (PRIMAER) -> result-explanation -> methodology -> faq-section -> related-tools -> internal-links -> footer
Das Tool IST die Seite (nicht Beiwerk). Erklaerung der Methodik, verwandte Tools verlinkt, WebApplication Schema
```

---

## Schritt 2: Aktuelle Seitenstruktur ableiten (IST)

### 2a -- Seitenstruktur via Content-Parsing

```
IF Zielseiten-URL verfuegbar UND on_page_content_parsing erreichbar:
  -> Rufe on_page_content_parsing auf
  -> Extrahiere die Seitenstruktur:
     - H1 -> hero Sektion
     - H2-Elemente -> je eine content-block Sektion
     - Formulare / interaktive Elemente -> tool-section
     - Listen mit Links am Ende -> internal-links
     - Bilder -> image-section
     - Footer-Navigation -> footer
ELSE:
  -> Leite IST-Struktur nur aus SXO-Report ab (First-Screen + Gaps)
```

### 2b -- IST-Bloecke erstellen

Fuer jede identifizierte Sektion:

```
IST-Block:
  section_label:  Header / Hero / Content / Tool / Footer / etc.
  ist_content:    Kurzbeschreibung was aktuell vorhanden ist
  problem_class:  problem-missing | problem-weak | problem-ok
  problem_text:   Was fehlt oder schwach ist (aus Gap-Analyse)
  prio_class:     prio-high | prio-medium | prio-low
```

**Regeln:**
- Zeige IST-Bloecke in der Reihenfolge, wie sie auf der Seite erscheinen
- Kennzeichne fehlende Elemente mit `problem-missing` (rot)
- Kennzeichne schwache Elemente mit `problem-weak` (gelb)
- Kennzeichne gute Elemente mit `problem-ok` (gruen) -- nur wenn relevant fuer Vergleich
- Maximal 8-10 IST-Bloecke (nicht jedes `<div>` abbilden)

---

## Schritt 3: Optimierte Seitenstruktur erstellen (SOLL)

### 3a -- SOLL-Sektionsreihenfolge bestimmen

Lies `references/section-mapping.md` fuer die Standard-Sektionsreihenfolge.

**Verwende die Sektionsreihenfolge des empfohlenen Seitentyps** (aus Schritt 1g) als Basis und passe sie an die konkreten SERP-Signale an:

```
IF Seitentyp = Landing-Page:
  hero (CTA) -> trust-bar -> tool-section -> social-proof -> cta-section -> footer

IF Seitentyp = Blog-Beitrag:
  hero (informativ) -> content-main -> image-section -> faq-section -> internal-links -> footer

IF Seitentyp = Produkt-Seite:
  hero (Produkt) -> trust-bar -> content-main (Features) -> social-proof -> cta-section -> faq-section -> footer

IF Seitentyp = Hybrid (Landing + Ratgeber):
  hero (CTA + Keyword) -> trust-bar -> tool-section -> content-main (Ratgeber) -> image-section -> social-proof -> faq-section -> cta-section -> internal-links -> footer

IF Seitentyp = Service-Seite:
  hero (Dienstleistung + CTA) -> trust-bar -> service-overview -> pricing-table -> process-steps -> social-proof -> faq-section -> booking-cta -> internal-links -> footer

IF Seitentyp = Vergleichsseite:
  hero (Vergleichstitel) -> comparison-matrix -> detailed-comparison -> pros-cons -> recommendation -> faq-section -> cta-section -> internal-links -> footer

IF Seitentyp = Standortseite:
  hero (Standort + CTA) -> trust-bar -> location-info -> service-overview -> map-embed -> social-proof -> faq-section -> contact-cta -> internal-links -> footer

IF Seitentyp = Tool-Seite:
  hero (Tool-Name) -> tool-section (PRIMAER) -> result-explanation -> methodology -> faq-section -> related-tools -> internal-links -> footer
```

**Regeln:**
- Ueberspringe Sektionen, die KEIN Gap haben UND kein SERP-Signal dafuer existiert
- Markiere neue Sektionen (die im IST nicht existieren) mit `prio-new`
- Maximal 10-12 SOLL-Bloecke

### 3b -- SOLL-Bloecke mit Platzhaltern fuellen

Fuer jede SOLL-Sektion erstelle einen Block:

```
SOLL-Block:
  section_label:    Header / Hero / Trust-Signale / etc.
  soll_content:     Kurzbeschreibung was hier stehen soll
  placeholder_type: KEYWORD / CTA / TRUST / FAQ / CONTENT-TYP / BILD / etc.
  placeholder_text: Konkrete Handlungsanweisung
  placeholder_detail: Begruendung (welches User Story Element wird adressiert)
  gap_ref:          Referenz zum Gap (z.B. "Primaeres Ziel", "Barriere: Risiko")
  prio_class:       prio-high | prio-medium | prio-low | prio-new
```

### 3c -- Platzhalter-Qualitaet

**KRITISCH: Platzhalter muessen ULTRA-KONKRET sein. Jeder Platzhalter muss 3 Dinge enthalten:**

1. **WAS genau** (konkreter Text, Zahl, Format -- nicht "Inhalt hier")
2. **WIE genau** (Designanweisung, Position, Format)
3. **WARUM** (welches User-Story-Element oder Gap wird adressiert)

**Qualitaetspruefung -- jeder Platzhalter muss ALLE bestehen:**
- [ ] Enthaelt er einen konkreten Textvorschlag in Anfuehrungszeichen?
- [ ] Nennt er Zahlen, Metriken oder spezifische Inhalte statt Kategorien?
- [ ] Referenziert er ein User-Story-Element oder eine Barriere namentlich?
- [ ] Koennte ein Webdesigner den Platzhalter OHNE Rueckfrage umsetzen?

**VERBOTEN (generisch -- loest sofort Ueberarbeitung aus):**
```
[CONTENT: Inhalt hier einfuegen]
[CTA: Button hinzufuegen]
[TRUST: Trust-Signale zeigen]
[BILD: Bild einfuegen]
[FAQ: FAQ ergaenzen]
[CONTENT-TYP: Tabelle einfuegen]
```

**RICHTIG (ultra-konkret):**
```
[KEYWORD: "PV Ausrichtung berechnen" als H1 -- Schriftgroesse 32px, zentriert. Aktuell fehlt das Keyword komplett in der Headline]
[CTA: "Jetzt kostenlos berechnen →" -- gruener Button (#16a34a) auf weissem Hintergrund, min. 48px Hoehe, above-the-fold. Adressiert Barriere "Komplexitaet" aus User Story]
[TRUST: "12.847 Berechnungen durchgefuehrt" + TUeV-Siegel (PNG, 60x60px) + "4,8 ★ bei Google (847 Bewertungen)" -- horizontal nebeneinander, direkt unter Hero]
[FAQ: "Welche Ausrichtung ist optimal fuer PV?" (exakter PAA-Text) -- Accordion-Element, <details>/<summary> oder JS-Toggle, mit FAQPage Schema JSON-LD]
[BILD: Infografik "Ertrag nach Himmelsrichtung" -- Balkendiagramm: Sued=100%, Suedwest=95%, West=85%, Ost=85%, Nord=60%. alt="PV Ertrag nach Himmelsrichtung Vergleich Infografik". Format: SVG oder PNG, min. 800px breit]
[CONTENT-TYP: Vergleichstabelle 3 Spalten -- Szenario A "Weiterbetrieb" (0€ Invest, 3.800 kWh/Jahr) vs. Szenario B "Repowering" (8.500€, 7.200 kWh/Jahr) vs. Szenario C "Neubau" (18.000€, 9.500 kWh/Jahr). Zeilen: Investition, Ertrag/Jahr, ROI, Foerderung]
[VIDEO: "PV Repowering 2026 erklaert" -- 2-3 Min., Kapitel: 1) Was ist Repowering? 2) Wann lohnt es sich? 3) Kosten & Foerderung. YouTube-Embed, 16:9, Untertitel. VideoObject Schema mit thumbnailUrl]
```

---

## Schritt 4: Meta-Optimierungen zusammenstellen

Sammle alle Head-bezogenen Optimierungen als HTML-Kommentare:

```
IF Title Tag nicht optimiert:
  -> <!-- META: Title "PV Ausrichtung Rechner | Kostenlos berechnen" (57 Zeichen) -->

IF Meta Description fehlt CTA:
  -> <!-- META-DESC: "Berechnen Sie den optimalen Ertrag Ihrer PV-Anlage..." (155 Zeichen) -->

IF Schema.org fehlt:
  -> <!-- SCHEMA: FAQPage + HowTo Schema einbauen -->

IF Alt-Tags fehlen:
  -> <!-- IMAGES: Alt-Tags mit Keyword-Bezug fuer alle Bilder setzen -->
```

---

## Schritt 5: HTML-Wireframe generieren

### 5a -- Template laden

```
IF Sprache = Deutsch:
  -> Lies assets/wireframe-template.html fuer den CSS-Block
ELSE:
  -> Lies assets/wireframe-template-en.html fuer den CSS-Block
```

### 5b -- HTML direkt generieren

**WICHTIG:** Genau wie beim sxo-analyzer: Kopiere den CSS-Block (`<style>...</style>`) aus dem Template und generiere den `<body>` Inhalt direkt. Versuche NICHT, die `{{PLATZHALTER}}` im Template zu ersetzen.

### 5c -- HTML-Struktur

**WICHTIG: Layout ist VERTIKAL (untereinander), nicht nebeneinander.**
IST-Zustand wird als volle Breite zuerst angezeigt, SOLL-Zustand darunter -- ebenfalls volle Breite.

```html
<!DOCTYPE html>
<html lang="de">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SXO Wireframe: [KEYWORD]</title>
  <style>/* CSS aus Template kopieren */</style>
</head>
<body>
<div class="wireframe-report">

  <!-- Header: .wf-header mit .label, h1, .meta-row -->
  <!-- User Story: .user-story-banner mit .us-label -->
  <!-- Seitentyp-Empfehlung: .page-type-rec (NEU) -->
  <!-- Legende: .legend mit .legend-item(s) -->
  <!-- Meta: .meta-comments mit code-Zeilen -->
  <!-- Vergleich: .comparison (VERTIKAL, volle Breite) -->
  <!--   IST: .col-ist > .col-header + .wf-block(s) -->
  <!--   SOLL: .col-soll > .col-header + .wf-block(s) -->
  <!-- Footer: .wf-footer -->

</div>
</body>
</html>
```

### 5c2 -- Seitentyp-Empfehlung HTML

Zwischen User Story und Legende die Seitentyp-Empfehlung einfuegen:

```html
<div class="page-type-rec">
  <div class="ptr-title">
    Empfohlener Seitentyp
    <span class="ptr-badge">[EMPFOHLENER_TYP]</span>
  </div>
  <p style="font-size: 13px; color: var(--text-muted); margin-bottom: 12px;">
    [BEGRUENDUNG: 1-2 Saetze warum dieser Typ am besten passt]
  </p>
  <div class="page-type-options">
    <!-- Fuer jeden evaluierten Seitentyp eine Karte -->
    <div class="pt-option pt-recommended">
      <div class="pt-name">[TYP-NAME]</div>
      <div class="pt-desc">[PASST_WEIL]</div>
      <span class="pt-tag pt-tag-rec">EMPFOHLEN</span>
    </div>
    <div class="pt-option">
      <div class="pt-name">[ALT-TYP-NAME]</div>
      <div class="pt-desc">[PASST_WEIL / RISIKO]</div>
      <span class="pt-tag pt-tag-alt">ALTERNATIVE</span>
    </div>
    <!-- Weitere Optionen wenn relevant -->
  </div>
</div>
```

### 5d -- CSS-Klassen Referenz

**Layout:** `.wireframe-report` mit `max-width: 1600px`. `.comparison` ist `grid-template-columns: 1fr` (volle Breite, untereinander).

**Bloecke:** `.wf-block` mit Prioritaet: `.prio-high` (rot), `.prio-medium` (gelb), `.prio-low` (gruen), `.prio-new` (blau)

**Block-Labels:** `.block-label` (Sektionsname wie "HERO", "TRUST-SIGNALE", "FAQ")

**Probleme (IST):** `.problem-tag` mit `.problem-missing` (rot), `.problem-weak` (gelb), `.problem-ok` (gruen)

**Platzhalter (SOLL):** `.placeholder` > `.ph-type` (fett, z.B. `[CTA]`) + Text + `.ph-detail` (kursiv, Begruendung)

**Gap-Referenz:** `.gap-ref` (violetter Tag, z.B. "-> Primaeres Ziel")

**Bild-Platzhalter:** `.img-placeholder` (gestrichelter Rahmen mit Text)

**Sektionen:** `.col-ist` (IST, volle Breite, zuerst) + `.col-soll` (SOLL, volle Breite, darunter) mit `.col-header`

**Seitentyp:** `.page-type-rec` > `.ptr-title` + `.ptr-badge` + `.page-type-options` > `.pt-option` (mit `.pt-recommended` fuer empfohlenen Typ)

### 5e -- Datei speichern

```
Dateiname: sxo-wireframe-[KEYWORD-SLUG].html
Speicherort: Aktuelles Arbeitsverzeichnis
```

Informiere den User ueber den Dateipfad.

---

## Schritt 6: Zusammenfassung ausgeben

Gib nach dem Speichern eine kurze Zusammenfassung als Text aus:

```
SXO Wireframe erstellt: sxo-wireframe-[keyword].html

Empfohlener Seitentyp: [Typ] (z.B. "Hybrid: Landing-Page + Ratgeber")
Begruendung: [1 Satz warum]

Aenderungen IST -> SOLL:
- [Anzahl] Sektionen mit hoher Prioritaet (rot)
- [Anzahl] Sektionen mit mittlerer Prioritaet (gelb)
- [Anzahl] neue Sektionen hinzugefuegt (blau)
- [Anzahl] Meta-Optimierungen im HTML-Head

Wichtigste Strukturaenderungen:
1. [Aenderung 1 -- z.B. "H1 mit Keyword ergaenzen"]
2. [Aenderung 2 -- z.B. "Trust-Bar nach Hero einfuegen"]
3. [Aenderung 3 -- z.B. "FAQ-Sektion mit PAA-Fragen ergaenzen"]
```

---

## Sprachspezifische Labels

| Bereich | Deutsch | English |
|---|---|---|
| Header-Label | SXO Wireframe | SXO Wireframe |
| IST-Spalte | IST-Zustand (Vorher) | Current State (Before) |
| SOLL-Spalte | SOLL-Zustand (Nachher) | Optimized State (After) |
| Legende: Hohe Prioritaet | Hohe Prioritaet | High Priority |
| Legende: Mittlere Prioritaet | Mittlere Prioritaet | Medium Priority |
| Legende: Neue Sektion | Neue Sektion | New Section |
| Meta-Block | HTML Head -- Meta-Optimierungen | HTML Head -- Meta Optimizations |
| Basis-Label | Basis: SXO-Report | Source: SXO Report |
| Footer | erstellt mit Claude Code | generated with Claude Code |

## Block-Labels (Sektionsnamen)

| Sektion | Deutsch | English |
|---|---|---|
| header | HEADER | HEADER |
| hero | HERO-BEREICH | HERO SECTION |
| trust-bar | TRUST-SIGNALE | TRUST SIGNALS |
| tool-section | TOOL / RECHNER | TOOL / CALCULATOR |
| content-main | HAUPTINHALT | MAIN CONTENT |
| image-section | BILD / INFOGRAFIK | IMAGE / INFOGRAPHIC |
| social-proof | SOCIAL PROOF | SOCIAL PROOF |
| faq-section | FAQ (AUS PAA) | FAQ (FROM PAA) |
| cta-section | CALL-TO-ACTION | CALL TO ACTION |
| internal-links | INTERNE VERLINKUNG | INTERNAL LINKS |
| service-overview | LEISTUNGSUEBERSICHT | SERVICE OVERVIEW |
| pricing-table | PREISE / PAKETE | PRICING / PACKAGES |
| process-steps | ABLAUF / PROZESS | PROCESS / STEPS |
| booking-cta | BUCHUNG / ANFRAGE | BOOKING / INQUIRY |
| comparison-matrix | VERGLEICHSMATRIX | COMPARISON MATRIX |
| detailed-comparison | DETAILVERGLEICH | DETAILED COMPARISON |
| pros-cons | VOR- UND NACHTEILE | PROS AND CONS |
| recommendation | EMPFEHLUNG | RECOMMENDATION |
| location-info | STANDORT-INFO | LOCATION INFO |
| map-embed | KARTE / ANFAHRT | MAP / DIRECTIONS |
| contact-cta | KONTAKT / ANFRAGE | CONTACT / INQUIRY |
| result-explanation | ERGEBNIS-ERKLAERUNG | RESULT EXPLANATION |
| methodology | METHODIK / BERECHNUNG | METHODOLOGY / CALCULATION |
| related-tools | VERWANDTE TOOLS | RELATED TOOLS |
| footer | FOOTER | FOOTER |

---

## Fehlerbehandlung

```
IF SXO-Report-Datei nicht gefunden:
  -> Suche mit Glob nach sxo-report-*.html im Arbeitsverzeichnis
  -> Falls gefunden: Frage ob diese Datei gemeint ist
  -> Falls nicht: Biete Fallback-Modus an (Variante B)

IF SXO-Report nicht parsbar (kein gueltiges HTML):
  -> Fehlermeldung: "Die Datei scheint kein gueltiger SXO-Report zu sein"
  -> Biete Fallback-Modus an

IF Content-Parsing fehlschlaegt:
  -> IST-Struktur nur aus Report-Daten ableiten
  -> Hinweis: "Seitenstruktur konnte nicht automatisch geladen werden"

IF Keine Gaps im Report:
  -> Hinweis: "Der SXO-Report zeigt keine signifikanten Gaps"
  -> Erstelle trotzdem Wireframe mit check-warn Items als Optimierungspotenzial
```

## Qualitaetsstandards

- **Platzhalter sind immer konkret** -- nie generisch (siehe Schritt 3c)
- **Jeder SOLL-Block referenziert ein User Story Element** via .gap-ref Tag
- **IST-Seite wird nicht erfunden** -- nur aus Daten abgeleitet
- **Maximal 10-12 Bloecke pro Spalte** -- Wireframe bleibt uebersichtlich
- **Neue Sektionen klar markiert** -- prio-new Klasse mit blauem Rand
- Schreibe echtes HTML, keine Markdown-Reste
- Verwende `&mdash;` fuer Gedankenstriche, `&auml;` etc. fuer Umlaute im HTML

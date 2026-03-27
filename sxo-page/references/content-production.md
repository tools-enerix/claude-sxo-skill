# Content-Produktion: Wireframe-Sektionen zu fertigem Content

## Grundprinzip

Jede SOLL-Sektion im Wireframe enthaelt:
1. **Strukturvorgabe:** Was diese Sektion leisten soll (block-label + block-content)
2. **Platzhalter:** Konkrete Inhaltsanweisungen (ph-type + ph-text + ph-detail)
3. **Gap-Referenz:** Welches User Story Element adressiert wird

Diese drei Datenpunkte werden zu echtem, optimiertem Content konvertiert.

---

## Sektions-Konvertierung

### HERO-BEREICH / HERO SECTION

**Input aus Wireframe:**
- `[KEYWORD: "..." als H1]` -> Exakter H1-Text
- `[CTA: "..." -- Farbe, Groesse, Position]` -> Button-Element
- Optionale Subheadline, Hero-Bild

**Output produzieren:**

```html
<section class="hero">
  <h1>[Exakter Keyword-Text aus Placeholder]</h1>
  <p class="hero-sub">[Subheadline: 1 Satz, Kernversprechen + Statistik aus Recherche]</p>
  <a href="#[conversion-ziel]" class="cta-primary">[CTA-Text aus Placeholder]</a>
  [Hero-Bild aus Recherche, wenn verfuegbar]
</section>
```

**Regeln:**
- H1 = Exakt der Text aus dem Wireframe-Placeholder (nicht umformulieren)
- Subheadline: Maximal 20 Woerter, eine konkrete Zahl einbauen
- CTA: Text, Farbe und Groesse aus Placeholder uebernehmen
- Hero-Bild: Kein lazy-loading (ist LCP-Element)

---

### TRUST-SIGNALE / TRUST SIGNALS

**Input aus Wireframe:**
- `[TRUST: "X Berechnungen" + Siegel + "Y Bewertungen"]`

**Output produzieren:**

```html
<section class="trust-bar">
  <div class="trust-item">[Konkrete Zahl aus Placeholder]</div>
  <div class="trust-item">[Siegel-Referenz]</div>
  <div class="trust-item">[Bewertungen mit Sternanzahl]</div>
</section>
```

**Regeln:**
- Zahlen exakt aus Wireframe-Placeholder uebernehmen
- Horizontal nebeneinander (flexbox)
- Kompakt, kein erklaerenderText

---

### HAUPTINHALT / MAIN CONTENT (H2-Sektionen)

**Input aus Wireframe:**
- Block-Label (z.B. "HAUPTINHALT", "ERKLAERUNG", "VERGLEICH")
- Platzhalter mit Thema und Begruendung
- Gap-Referenz (z.B. "-> Primaeres Ziel")

**Output produzieren (pro H2-Sektion):**

```
## [H2 als Frage, 60-70% der Headings]

[ANSWER-FIRST ABSATZ: 40-60 Woerter]
[Statistik] ([Quellenname](URL), Jahr). [Direkte Antwort auf die Heading-Frage].
[Weiterer Kontext in 1-2 Saetzen].

[ERKLAERUNG: 2-3 Absaetze, je 40-80 Woerter]
- Supporting Evidence mit weiteren Daten
- Praktische Beispiele oder Szenarien
- Bezug zur User Story

[CITATION CAPSULE: 40-60 Woerter]
> [Selbststaendig zitierfaehige Passage mit Kernaussage + Statistik.
   Muss ohne Kontext verstaendlich sein.]

[VISUELLES ELEMENT: Bild, Tabelle oder Chart]
[INTERNAL-LINK: Natuerlich eingebaut, beschreibender Anchor-Text]
```

**Regeln:**
- IMMER mit Answer-First beginnen (nie "In diesem Abschnitt...")
- Satzlaenge variieren: Kurz (5-10 Woerter) und lang (18-25 Woerter) mischen
- Mindestens 1 Statistik mit Quelle pro H2
- Mindestens 1 Citation Capsule pro H2
- 300-400 Woerter pro H2-Sektion (max 500)
- Passiv <= 10%, Uebergangswoerter 20-30%

---

### TOOL / RECHNER / CALCULATOR

**Input aus Wireframe:**
- `[CONTENT-TYP: Rechner/Konfigurator/Vergleichstabelle "..."]`

**Output produzieren:**

```html
<section class="tool-section">
  <h2>[Beschreibender Titel mit Keyword]</h2>
  <p>[Answer-First: Was der Rechner/das Tool leistet + eine Statistik]</p>
  <!-- Tool-Platzhalter: Hier wird das interaktive Element eingebaut -->
  <div class="tool-placeholder">
    [Beschreibung was implementiert werden muss]
    [Input-Felder und erwartete Outputs spezifizieren]
  </div>
  <p class="tool-note">[Erklaerung der Berechnungsgrundlage]</p>
</section>
```

**Regeln:**
- Tools koennen nicht als statischer Content erzeugt werden
- Stattdessen: Beschreibung + Platzhalter + erklaerenden Content drumherum
- Statische Alternative: Vergleichstabelle mit konkreten Szenarien

---

### FAQ (AUS PAA) / FAQ (FROM PAA)

**Input aus Wireframe:**
- `[FAQ: PAA-Fragen + FAQPage Schema]`
- PAA-Fragen aus SXO-Report

**Output produzieren:**

```html
<section class="faq-section">
  <h2>[FAQ-Ueberschrift, z.B. "Haeufige Fragen zu [Keyword]"]</h2>

  <details>
    <summary>[Exakte PAA-Frage 1]</summary>
    <p>[Antwort: 40-60 Woerter, mit Statistik wenn passend]</p>
  </details>

  <details>
    <summary>[Exakte PAA-Frage 2]</summary>
    <p>[Antwort: 40-60 Woerter]</p>
  </details>

  [... 3-5 Fragen total ...]
</section>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "[Frage 1]",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "[Antwort 1]"
      }
    }
  ]
}
</script>
```

**Regeln:**
- PAA-Fragen exakt uebernehmen (nicht umformulieren)
- Antworten: 40-60 Woerter, direkt und konkret
- Wo moeglich eine Statistik einbauen
- FAQPage Schema JSON-LD IMMER mitliefern
- 3-5 Fragen (nicht mehr)

---

### BILD / INFOGRAFIK / IMAGE

**Input aus Wireframe:**
- `[BILD: Infografik "...", alt="...", Format, Mindestgroesse]`

**Output produzieren:**

```html
<figure class="content-image">
  <img src="[URL aus Recherche]"
       alt="[Voller beschreibender Alt-Text mit Keyword-Bezug]"
       width="[Breite]" height="[Hoehe]"
       loading="lazy">
  <figcaption>[Beschreibender Text, 1 Satz]</figcaption>
</figure>
```

**Regeln:**
- Alt-Text: Voller Satz, beschreibt Bild UND Relevanz
- width + height immer setzen (CLS vermeiden)
- loading="lazy" AUSSER fuer Hero-Bild (LCP)
- Figcaption: Kurz, informativ, nicht redundant zum Alt-Text

---

### CALL-TO-ACTION / CTA

**Input aus Wireframe:**
- `[CTA: "..." -- Farbe, Position, Kontext]`

**Output produzieren:**

```html
<section class="cta-section">
  <h2>[Kontextuelle Ueberschrift, kein "Jetzt kaufen"]</h2>
  <p>[1-2 Saetze: Wert rekapitulieren, dann CTA]</p>
  <a href="#[conversion-ziel]" class="cta-primary">[CTA-Text aus Placeholder]</a>
</section>
```

**Regeln:**
- CTA kommt NACH Wertlieferung (nie am Anfang allein)
- First-Person-Copy: "Mein Angebot anfordern" statt "Ihr Angebot"
- Ein CTA pro Block (nicht mehrere)
- Farbe/Design aus Wireframe-Placeholder

---

### INTERNE VERLINKUNG / INTERNAL LINKS

**Input aus Wireframe:**
- `[INTERNAL LINKS: Verlinke zu "Thema A", "Thema B", "Thema C"]`

**Output produzieren:**

```html
<section class="related-content">
  <h2>[z.B. "Weiterfuehrende Ratgeber" / "Related Resources"]</h2>
  <ul>
    <li><a href="[URL]">[Beschreibender Anchor-Text zu Thema A]</a></li>
    <li><a href="[URL]">[Beschreibender Anchor-Text zu Thema B]</a></li>
    <li><a href="[URL]">[Beschreibender Anchor-Text zu Thema C]</a></li>
  </ul>
</section>
```

**Regeln:**
- URLs als Platzhalter wenn echte URLs nicht bekannt
- Anchor-Text: Beschreibend, nie "hier klicken" oder "mehr lesen"
- 3-5 Links pro Block

---

### LEISTUNGSUEBERSICHT / SERVICE OVERVIEW (Service-Seite)

**Input aus Wireframe:**
- `[SERVICE: Leistungen mit Icons und Kurzbeschreibungen]`

**Output produzieren:**

```html
<section class="service-overview">
  <h2>[Keyword-bezogene Ueberschrift, z.B. "Unsere Reparatur-Services"]</h2>
  <div class="service-grid">
    <div class="service-card">
      <div class="service-icon">[Icon/Emoji]</div>
      <h3>[Leistungsname]</h3>
      <p>[Kurzbeschreibung: 20-30 Woerter, Nutzen betonen]</p>
      <a href="#[ziel]" class="service-link">[Mini-CTA]</a>
    </div>
    [... 3-6 Karten ...]
  </div>
</section>
```

**Regeln:**
- 3-6 Leistungen als Grid (2-3 Spalten Desktop, 1 Spalte Mobile)
- Jede Karte: Icon + Titel + 1-2 Saetze + optionaler Link
- Keywords natuerlich in Leistungstitel einbauen
- Nutzen statt Features ("Reparatur in 30 Min" statt "Display-Tausch")

---

### PREISE / PAKETE / PRICING (Service-Seite, Produkt-Seite)

**Input aus Wireframe:**
- `[PRICING: Preistabelle/Pakete mit Preisen und Leistungen]`

**Output produzieren:**

```html
<section class="pricing-section">
  <h2>[z.B. "Transparente Preise fuer Ihre Reparatur"]</h2>
  <p>[Answer-First: Preisrange + Statistik wenn verfuegbar]</p>
  <div class="pricing-grid">
    <div class="pricing-card">
      <h3>[Paketname / Service]</h3>
      <div class="price">[Preis / ab-Preis]</div>
      <ul>
        <li>[Enthaltene Leistung 1]</li>
        <li>[Enthaltene Leistung 2]</li>
      </ul>
      <a href="#[buchung]" class="cta-primary">[CTA-Text]</a>
    </div>
    <div class="pricing-card pricing-popular">
      <span class="popular-badge">[Beliebteste Option]</span>
      [... gleiche Struktur, hervorgehoben ...]
    </div>
  </div>
</section>
```

**Regeln:**
- 2-4 Preis-Optionen (nicht mehr, Paradox of Choice)
- Beliebteste Option visuell hervorheben
- Preise transparent, keine versteckten Kosten
- Offer Schema (JSON-LD) einbauen
- "Ab"-Preise wenn exakte Preise nicht moeglich

---

### ABLAUF / PROZESS / PROCESS STEPS (Service-Seite)

**Input aus Wireframe:**
- `[PROZESS: Schritte des Ablaufs mit Zeitleiste]`

**Output produzieren:**

```html
<section class="process-section">
  <h2>[z.B. "So funktioniert Ihre Reparatur"]</h2>
  <p>[Answer-First: Kernaussage zum Ablauf + Zeitangabe]</p>
  <div class="process-steps">
    <div class="step">
      <div class="step-number">1</div>
      <h3>[Schritt-Titel]</h3>
      <p>[Kurzbeschreibung: 15-25 Woerter]</p>
    </div>
    [... 3-5 Schritte ...]
  </div>
</section>
```

**Regeln:**
- 3-5 Schritte (nicht mehr, sonst wirkt komplex)
- Nummeriert mit visuellen Schritt-Indikatoren
- Adressiert Barriere "Komplexitaet" aus User Story
- Zeitangaben einbauen wenn moeglich ("In nur 30 Minuten")

---

### BUCHUNG / ANFRAGE / BOOKING CTA (Service-Seite, Standortseite)

**Input aus Wireframe:**
- `[BOOKING: Buchungsformular/Terminanfrage mit Feldern]`

**Output produzieren:**

```html
<section class="booking-section">
  <h2>[z.B. "Jetzt Termin vereinbaren"]</h2>
  <p>[1-2 Saetze: Wert rekapitulieren + Trust-Hinweis]</p>
  <form class="booking-form">
    <input type="text" placeholder="[Feld 1]" required>
    <input type="email" placeholder="[Feld 2]" required>
    <textarea placeholder="[Anliegen/Nachricht]"></textarea>
    <button type="submit" class="cta-primary">[First-Person CTA]</button>
    <p class="form-trust">[Trust-Hinweis: "Kostenlos &amp; unverbindlich" / "Antwort innerhalb von 24h"]</p>
  </form>
</section>
```

**Regeln:**
- Maximal 5 Formularfelder (weniger = mehr Conversions)
- First-Person-Copy: "Meine Anfrage senden" / "My free quote"
- Trust-Hinweis direkt unter/neben dem Button
- Keine Pflichtfelder ausser Name + Kontakt
- Formular-Action als Platzhalter

---

### VERGLEICHSMATRIX / COMPARISON MATRIX (Vergleichsseite)

**Input aus Wireframe:**
- `[COMPARISON: Feature-Vergleichstabelle Option A vs B vs C]`

**Output produzieren:**

```html
<section class="comparison-section">
  <h2>[z.B. "Shopify vs WooCommerce vs Wix im Vergleich"]</h2>
  <p>[Answer-First: Kernaussage wer bei was gewinnt]</p>
  <div class="comparison-table-wrapper">
    <table class="comparison-table">
      <thead>
        <tr>
          <th>Kriterium</th>
          <th>[Option A]</th>
          <th class="winner">[Option B] ★</th>
          <th>[Option C]</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>[Kriterium 1]</td>
          <td>[Wert/Haekchen/Kreuz]</td>
          <td>[Wert/Haekchen/Kreuz]</td>
          <td>[Wert/Haekchen/Kreuz]</td>
        </tr>
        [... weitere Zeilen ...]
      </tbody>
    </table>
  </div>
</section>
```

**Regeln:**
- Tabelle responsiv (horizontales Scrollen auf Mobile)
- Gewinner-Spalte visuell hervorheben
- Haekchen (&#10003;) und Kreuze (&#10007;) fuer ja/nein Kriterien
- Konkrete Werte wo moeglich (nicht nur ja/nein)
- 5-10 Vergleichskriterien

---

### VOR- UND NACHTEILE / PROS AND CONS (Vergleichsseite)

**Input aus Wireframe:**
- `[PROS-CONS: Vor- und Nachteile pro Option]`

**Output produzieren:**

```html
<section class="pros-cons-section">
  <h2>[z.B. "Vor- und Nachteile im Ueberblick"]</h2>
  <div class="pros-cons-grid">
    <div class="option-card">
      <h3>[Option A]</h3>
      <div class="pros">
        <h4>Vorteile</h4>
        <ul><li>[Pro 1]</li><li>[Pro 2]</li></ul>
      </div>
      <div class="cons">
        <h4>Nachteile</h4>
        <ul><li>[Contra 1]</li><li>[Contra 2]</li></ul>
      </div>
    </div>
    [... weitere Optionen ...]
  </div>
</section>
```

**Regeln:**
- Maximal 5 Pros und 5 Cons pro Option
- Objektiver Ton, keine wertende Sprache
- Gruene Haekchen fuer Pros, rote Kreuze fuer Cons
- Balanciert: nicht eine Option offensichtlich bevorzugen

---

### EMPFEHLUNG / RECOMMENDATION (Vergleichsseite)

**Input aus Wireframe:**
- `[RECOMMENDATION: Klare Empfehlung mit Begruendung]`

**Output produzieren:**

```html
<section class="recommendation-section">
  <h2>[z.B. "Unsere Empfehlung"]</h2>
  <div class="recommendation-card">
    <h3>[Empfohlene Option]</h3>
    <p>[2-3 Saetze: Fuer wen und warum diese Option am besten passt]</p>
    <a href="[link]" class="cta-primary">[CTA zur empfohlenen Option]</a>
  </div>
  <p class="rec-alternative">[1 Satz: "Falls Sie [Kriterium] priorisieren, ist [Alternative] besser geeignet."]</p>
</section>
```

**Regeln:**
- Klare Aussage: "Fuer [Zielgruppe] empfehlen wir [Option]"
- Begruendung faktenbasiert (Statistiken wenn verfuegbar)
- Alternative fuer anderen Use Case nennen
- CTA zur empfohlenen Option

---

### STANDORT-INFO / LOCATION INFO (Standortseite)

**Input aus Wireframe:**
- `[LOCATION: Adresse, Oeffnungszeiten, Kontakt, Anfahrt]`

**Output produzieren:**

```html
<section class="location-section">
  <h2>[z.B. "So finden Sie uns"]</h2>
  <div class="location-grid">
    <div class="location-address">
      <h3>Adresse</h3>
      <address>[Strasse, PLZ Ort]</address>
      <p>Telefon: <a href="tel:[nummer]">[Nummer]</a></p>
      <p>E-Mail: <a href="mailto:[email]">[Email]</a></p>
    </div>
    <div class="location-hours">
      <h3>Oeffnungszeiten</h3>
      <table class="hours-table">
        <tr><td>Mo-Fr</td><td>[Zeiten]</td></tr>
        <tr><td>Sa</td><td>[Zeiten]</td></tr>
        <tr><td>So</td><td>Geschlossen</td></tr>
      </table>
    </div>
    <div class="location-directions">
      <h3>Anfahrt</h3>
      <p>[OEPNV + Parken kurz beschrieben]</p>
    </div>
  </div>
</section>
```

**Regeln:**
- Adresse als `<address>` Element (semantisch korrekt)
- Telefonnummer als `tel:` Link (klickbar auf Mobile)
- Oeffnungszeiten als Tabelle
- LocalBusiness + PostalAddress Schema einbauen
- Platzhalter wenn echte Daten nicht bekannt

---

### KARTE / MAP EMBED (Standortseite)

**Input aus Wireframe:**
- `[MAP: Google Maps Embed mit Standort-Marker]`

**Output produzieren:**

```html
<section class="map-section">
  <div class="map-embed">
    <!-- Google Maps Embed: URL mit echten Koordinaten ersetzen -->
    <iframe src="https://www.google.com/maps/embed?pb=[PLATZHALTER]"
            width="100%" height="350" style="border:0;"
            allowfullscreen="" loading="lazy"
            referrerpolicy="no-referrer-when-downgrade"
            title="Standort [Firmenname]">
    </iframe>
  </div>
</section>
```

**Regeln:**
- 100% Breite, 300-400px Hoehe
- loading="lazy" (nicht LCP-relevant)
- title-Attribut fuer Accessibility
- Embed-URL als Platzhalter wenn Koordinaten nicht bekannt

---

### ERGEBNIS-ERKLAERUNG / RESULT EXPLANATION (Tool-Seite)

**Input aus Wireframe:**
- `[RESULT: Erklaerung was das Ergebnis bedeutet]`

**Output produzieren:**

```html
<section class="result-section">
  <h2>[z.B. "Was Ihr Ergebnis bedeutet"]</h2>
  <p>[Answer-First: Einordnung des typischen Ergebnisses + Statistik]</p>
  <div class="result-ranges">
    <div class="range range-good">[Bereich "Gut": Kriterien + Handlungsempfehlung]</div>
    <div class="range range-medium">[Bereich "Mittel": Kriterien + Handlungsempfehlung]</div>
    <div class="range range-poor">[Bereich "Verbesserungswuerdig": Kriterien + Handlungsempfehlung]</div>
  </div>
  <p>[Kontext: "Der Durchschnitt liegt bei [Zahl] ([Quelle], Jahr)"]</p>
</section>
```

**Regeln:**
- Ergebnis-Bereiche mit Farbcodierung (gruen/gelb/rot)
- Konkrete Handlungsempfehlungen pro Bereich
- Durchschnittswerte als Kontext (mit Quelle)
- Ergebnis-Erklaerung NACH dem Tool, nicht davor

---

### METHODIK / METHODOLOGY (Tool-Seite)

**Input aus Wireframe:**
- `[METHODOLOGY: Berechnungsgrundlage und Datenquellen]`

**Output produzieren:**

```html
<section class="methodology-section">
  <h2>[z.B. "So berechnen wir Ihr Ergebnis"]</h2>
  <p>[Answer-First: Kernaussage zur Methodik + Datenquelle]</p>
  <div class="methodology-content">
    <p>[Vereinfachte Erklaerung der Formel/Logik, 80-120 Woerter]</p>
    <p class="data-source">Datengrundlage: [Quelle(n) mit Link(s)]</p>
  </div>
</section>
```

**Regeln:**
- Transparent aber nicht ueberwaeltigend (keine mathematischen Formeln)
- Datenquellen klar benennen (Tier 1-3)
- Baut Vertrauen auf (E-E-A-T Signal)
- Kompakt: 80-150 Woerter maximal

---

### VERWANDTE TOOLS / RELATED TOOLS (Tool-Seite)

**Input aus Wireframe:**
- `[RELATED-TOOLS: Verwandte Rechner/Tools verlinken]`

**Output produzieren:**

```html
<section class="related-tools">
  <h2>[z.B. "Weitere nuetzliche Rechner"]</h2>
  <div class="tools-grid">
    <a href="[URL]" class="tool-card">
      <h3>[Tool-Name]</h3>
      <p>[Kurzbeschreibung: 15-20 Woerter]</p>
    </a>
    [... 2-4 Karten ...]
  </div>
</section>
```

**Regeln:**
- 2-4 verwandte Tools (nicht mehr)
- Thematisch passend zum Haupt-Tool
- Karten als Links (nicht nur Text-Links)
- Interne Verlinkung fuer Themen-Cluster

---

---

### VALUE PROPOSITION BAR (Hybrid-Seite: im Hero)

**Input aus Wireframe:**
- `[VALUE-PROPS: 3 Kern-USPs mit Metriken]`
- Aus User Story: Primaeres Ziel + Barrieren

**Output produzieren:**

```html
<div class="flex flex-wrap justify-center gap-6 md:gap-10 mb-8">
  <div class="flex items-center gap-2 text-sm md:text-base">
    <span class="text-brand font-bold text-lg md:text-xl">[Metrik 1]</span>
    <span class="text-gray-500">[USP-Beschreibung 1]</span>
  </div>
  <div class="flex items-center gap-2 text-sm md:text-base">
    <span class="text-brand font-bold text-lg md:text-xl">[Metrik 2]</span>
    <span class="text-gray-500">[USP-Beschreibung 2]</span>
  </div>
  <div class="flex items-center gap-2 text-sm md:text-base">
    <span class="text-brand font-bold text-lg md:text-xl">[Metrik 3]</span>
    <span class="text-gray-500">[USP-Beschreibung 3]</span>
  </div>
</div>
```

**Regeln:**
- Exakt 3 Value Props (nicht mehr, nicht weniger)
- Jede Prop hat eine konkrete Metrik (Zahl, Prozent, ab-Preis)
- Metriken kommen aus dem SXO-Report (SERP-Ads, Trust-Signale, Wettbewerber)
- Kurz: Max 5 Woerter pro Beschreibung
- Adressiert das primaere User-Story-Ziel auf einen Blick

---

### BENEFITS GRID / USP-KARTEN (Hybrid-Seite)

**Input aus Wireframe:**
- `[BENEFITS: 3-4 Kern-Vorteile mit Icons und Metriken]`
- Aus Gap-Analyse: Fehlende Trust-Signale, Differenzierungsmerkmale

**Output produzieren:**

```html
<section class="py-16 bg-white">
  <div class="max-w-5xl mx-auto px-6">
    <h2 class="text-2xl md:text-3xl font-bold text-center mb-10">[z.B. "Warum [Produkt/Service] mit [Marke]?"]</h2>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
      <div class="bg-gray-50 rounded-xl p-6 text-center hover:shadow-md transition-shadow">
        <div class="text-3xl mb-3">[Icon/Emoji]</div>
        <div class="text-2xl font-bold text-brand mb-1">[Metrik, z.B. "ab 98 EUR/Monat"]</div>
        <h3 class="font-semibold text-gray-900 mb-2">[Vorteil-Titel]</h3>
        <p class="text-sm text-gray-500">[1-2 Saetze Nutzen-Beschreibung]</p>
      </div>
      [... 3-4 Karten insgesamt ...]
    </div>
  </div>
</section>
```

**Regeln:**
- 3-4 Karten (4 bevorzugt fuer Desktop-Grid-Balance)
- Jede Karte hat eine Metrik ODER ein starkes Statement
- Icons als Emoji oder SVG-Platzhalter
- Nutzen-Sprache: "Sparen Sie bis zu..." / "Erhalten Sie..." (nicht Features)
- H2-Heading als Frage: "Warum [Angebot] mit [Marke]?"
- Metriken muessen aus SXO-Report oder Recherche stammen (nie erfinden)

---

### FEATURE SHOWCASE (Hybrid-Seite: alternierende Bild/Text-Bloecke)

**Input aus Wireframe:**
- `[FEATURE: Produktmerkmal/Leistung mit Bild und Details]`
- 2-4 Feature-Bloecke aus Gap-Analyse oder SERP-Wettbewerbern

**Output produzieren:**

```html
<div class="feature-showcase flex flex-col md:flex-row items-center gap-8 md:gap-12">
  <div class="md:w-1/2">
    <img src="[Bild-URL]" alt="[Beschreibender Alt-Text mit Keyword]"
         width="600" height="400" class="rounded-xl shadow-lg w-full" loading="lazy">
  </div>
  <div class="md:w-1/2">
    <h3 class="font-heading text-xl md:text-2xl font-bold text-gray-900 mb-3">[Feature-Titel]</h3>
    <p class="text-gray-500 mb-4 leading-relaxed">[Answer-First: 40-60 Woerter mit Statistik]</p>
    <ul class="space-y-2 text-sm text-gray-600">
      <li class="flex items-start gap-2"><span class="text-brand mt-0.5">&#10003;</span> [Detail 1]</li>
      <li class="flex items-start gap-2"><span class="text-brand mt-0.5">&#10003;</span> [Detail 2]</li>
      <li class="flex items-start gap-2"><span class="text-brand mt-0.5">&#10003;</span> [Detail 3]</li>
    </ul>
  </div>
</div>
```

**Regeln:**
- 2-4 Feature-Bloecke (nicht mehr, Aufmerksamkeitsspanne beachten)
- CSS dreht gerade/ungerade Bloecke automatisch (nth-child(even) flex-row-reverse)
- Jeder Block: Answer-First Absatz + 3-5 Bullet-Details
- Bilder: Produktfotos, Screenshots, oder Infografiken aus Recherche
- Feature-Titel: Konkreter Nutzen, nicht technischer Jargon
- Mindestens 1 Statistik pro Feature-Block
- Features aus SERP-Wettbewerberanalyse ableiten (was betonen die Top-10?)

---

### LOESUNG / OEKOSYSTEM-UEBERSICHT (Hybrid-Seite)

**Input aus Wireframe:**
- `[SOLUTION: Gesamtangebot als Oekosystem darstellen]`
- Aus User Story: Sekundaeres Ziel "Gesamtloesung verstehen"

**Output produzieren:**

```html
<section class="py-16 bg-white">
  <div class="max-w-5xl mx-auto px-6 text-center">
    <h2 class="text-2xl md:text-3xl font-bold mb-4">[z.B. "Ihre Komplettloesung fuer [Thema]"]</h2>
    <p class="text-lg text-gray-500 max-w-2xl mx-auto mb-10">[1-2 Saetze: Wie die Teile zusammenwirken]</p>
    <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4">
      <div class="bg-gray-50 rounded-xl p-4 flex flex-col items-center gap-2">
        <div class="w-12 h-12 bg-brand/10 rounded-full flex items-center justify-center text-xl">[Icon]</div>
        <span class="text-sm font-semibold text-gray-700">[Komponente 1]</span>
      </div>
      [... 4-6 Komponenten ...]
    </div>
    <a href="#[CTA-Ziel]" class="inline-block mt-8 px-8 py-3.5 bg-brand text-white font-semibold rounded-lg">[CTA-Text]</a>
  </div>
</section>
```

**Regeln:**
- NUR verwenden wenn das Angebot ein echtes Oekosystem/Komplettloesung ist
- 4-6 Komponenten (nicht weniger als 4, sonst kein Oekosystem-Effekt)
- Icons: Emoji oder simple SVG-Platzhalter
- Zeigt den Mehrwert der Kombination, nicht nur Einzelteile
- Optional: Kurzer Absatz unter den Icons mit Statistik zum Gesamtnutzen
- WEGLASSEN wenn das Angebot ein Einzelprodukt/-service ist

---

### TRUST CAROUSEL (Hybrid-Seite: erweiterte Trust-Sektion)

**Input aus Wireframe:**
- `[TRUST-CAROUSEL: 4-6 Trust-Slides mit Details]`
- Aus Gap-Analyse: Fehlende Trust-Signale, Barriere "Risiko/Unsicherheit"

**Output produzieren:**

```html
<section class="py-16 bg-gray-50" x-data="{ current: 0, total: 0 }" x-init="total = $refs.track.children.length">
  <div class="max-w-5xl mx-auto px-6">
    <h2 class="text-2xl md:text-3xl font-bold text-center mb-10">[z.B. "Warum [Marke]?"]</h2>
    <div class="trust-carousel relative">
      <div class="trust-carousel-track" x-ref="track"
           :style="'transform: translateX(-' + (current * (100 / Math.min(total, window.innerWidth >= 1024 ? 3 : window.innerWidth >= 768 ? 2 : 1))) + '%)'">
        <div class="trust-carousel-slide px-3">
          <div class="bg-white rounded-xl p-6 shadow-sm border border-gray-100 h-full">
            <div class="text-3xl mb-3">[Icon]</div>
            <h3 class="font-semibold text-gray-900 mb-2">[Slide-Titel]</h3>
            <p class="text-sm text-gray-500 leading-relaxed">[2-3 Saetze mit konkretem Trust-Signal]</p>
          </div>
        </div>
        [... 4-6 Slides ...]
      </div>
    </div>
  </div>
</section>
```

**Regeln:**
- 4-6 Slides (weniger ist zu wenig fuer Karussell, mehr verwaessert)
- Jeder Slide adressiert eine andere Trust-Dimension:
  * Finanzierung/Preis-Transparenz
  * Produkt-/Servicequalitaet
  * Kundenzufriedenheit (Anzahl + Rating)
  * Geschwindigkeit/Zuverlaessigkeit
  * Zertifizierungen/Awards
  * Gesamtloesung/Support
- Alpine.js steuert die Slide-Navigation (kein externes Karussell-Plugin)
- Mobile: 1 Slide sichtbar, Tablet: 2, Desktop: 3
- Jeder Slide: Icon + Titel + 2-3 Saetze (max 50 Woerter)

---

### AWARDS / ZERTIFIZIERUNGEN BAR (Hybrid-Seite)

**Input aus Wireframe:**
- `[AWARDS: 3-5 Awards/Siegel/Zertifizierungen]`
- Aus SXO-Report: Wettbewerber-Trust-Signale, fehlende Autoritaetssignale

**Output produzieren:**

```html
<div class="border-y border-gray-100 bg-gray-50/60">
  <div class="max-w-5xl mx-auto flex flex-wrap justify-center items-center gap-8 md:gap-14 px-6 py-8">
    <div class="flex flex-col items-center gap-1 text-center">
      <span class="text-2xl">[Icon/Emoji]</span>
      <span class="text-xs font-bold text-gray-700">[Award-Titel]</span>
      <span class="text-xs text-gray-400">[Jahr / Quelle]</span>
    </div>
    [... 3-5 Awards ...]
  </div>
</div>
```

**Regeln:**
- 3-5 Awards/Siegel (nicht mehr, wirkt ueberladen)
- Nur echte, verifizierbare Awards (nie erfinden)
- Falls Siegel-Bilder verfuegbar: Als img mit alt-Text
- Falls keine Bilder: Emoji + Text reicht
- Positioniert zwischen Zone 1 (Conversion) und Zone 2 (Content)
- Typische Awards: Branchensiegel, Testsieger, TUeV, Trusted Shops, Kundenzufriedenheit

---

## Hybrid-Seitentyp: Zwei-Zonen-Architektur

Bei Hybrid-Seiten (Landing + Blog) wird die Seite in zwei Zonen aufgeteilt:

### Zone 1: Conversion (Above-the-Fold / Landing-Teil)
```
Reihenfolge:
1. HERO (erweitert: Value Props + Dual-CTA + Trust-Siegel)
2. TRUST BAR
3. BENEFITS GRID / USP-Karten
4. FEATURE SHOWCASE (alternierend Bild/Text)
5. LOESUNG / OEKOSYSTEM (optional, nur bei Komplettloesungen)
6. TRUST CAROUSEL
7. PROZESS-SCHRITTE
8. AWARDS BAR
```

**Ziel Zone 1:** Conversion-Optimierung. User soll den CTA klicken OHNE scrollen zu muessen
(oder zumindest innerhalb der ersten 2-3 Viewport-Hoehen ueberzeugt werden).

### Zone 2: SEO / Content (Below-the-Fold / Blog-Teil)
```
Reihenfolge:
1. KEY TAKEAWAYS
2. HAUPTINHALT (H2-Sektionen mit Answer-First, Statistiken, Citation Capsules)
3. FAQ AKKORDEON (PAA-Fragen)
4. CTA SEKTION (sekundaer)
5. WEITERFUEHRENDE INHALTE (interne Links)
```

**Ziel Zone 2:** SEO-Rankings + AI-Citability. Tiefgehender Ratgeber-Content,
der die User Story vollstaendig bedient und Google/AI-Systemen strukturierte Daten liefert.

### Entscheidungslogik: Zone-1-Sektionen ein-/ausblenden

```
IMMER bei Hybrid:
  - Hero (erweitert)     -> IMMER
  - Trust Bar            -> IMMER
  - Benefits Grid        -> IMMER (mind. 3 Vorteile aus Report ableitbar)
  - Prozess-Schritte     -> IMMER (reduziert Komplexitaets-Barriere)

BEDINGT bei Hybrid:
  - Feature Showcase     -> Wenn Produkt/Service konkrete Features hat
                            (nicht bei abstrakten Dienstleistungen wie "Beratung")
  - Loesung/Oekosystem   -> Nur wenn Angebot aus 4+ Komponenten besteht
  - Trust Carousel       -> Wenn mind. 4 verschiedene Trust-Dimensionen vorhanden
  - Awards Bar           -> Nur wenn echte, verifizierbare Awards existieren

ZONE 2 IMMER KOMPLETT bei Hybrid.
```

---

## Ton-Ableitung aus User Story

Der Content-Ton wird aus der User Story abgeleitet:

| User Story Element | Content-Anpassung |
|---|---|
| Wissensstand: Anfaenger | Einfache Sprache, Fachbegriffe erklaeren, mehr Beispiele |
| Wissensstand: Informiert | Direkte Fachsprache, weniger Grundlagen, mehr Tiefe |
| Wissensstand: Experte | Technisch praezise, Daten-fokussiert, keine Erklaerungen |
| Emotionale Lage: Unsicherheit | Beruhigende Fakten, Vergleiche, "Sie sind nicht allein" |
| Emotionale Lage: Enthusiasmus | Bestaetigung, Optimierung, "So holen Sie das Maximum raus" |
| Barriere: Komplexitaet | Schritt-fuer-Schritt, visuelle Hilfen, Rechner-Hinweise |
| Barriere: Risiko | Trust-Signale, Garantien, Erfolgsgeschichten, Statistiken |
| Barriere: Zeit | Kompakt, Bullet-Points, Quick-Wins, "In X Minuten" |
| Journey: Awareness | Mehr Erklaerung, weniger CTA-Druck, Informationsfokus |
| Journey: Consideration | Vergleiche, Pro/Contra, Entscheidungshilfen |
| Journey: Decision | Starke CTAs, Preise/Konditionen, Testimonials, Urgency |

---

## Key Takeaways Box

Fuer Blog/Ratgeber und Hybrid-Seitentypen erstelle eine Key Takeaways Box nach dem Hero:

```html
<div class="key-takeaways">
  <h2>Key Takeaways</h2>
  <ul>
    <li>[Kernaussage 1 mit Statistik] ([Quelle], Jahr)</li>
    <li>[Kernaussage 2]</li>
    <li>[Kernaussage 3, aktionsorientiert]</li>
  </ul>
</div>
```

**Regeln:**
- 3-5 Bullet-Points
- 40-60 Woerter gesamt
- Mindestens 1 Statistik mit Quelle
- Jeder Punkt eigenstaendig verstaendlich
- Nur bei Blog/Ratgeber/Hybrid/Vergleichsseite (nicht bei Landing-Page, Service-Seite, Standortseite, Tool-Seite)

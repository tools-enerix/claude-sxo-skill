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
- Nur bei Blog/Ratgeber/Hybrid (nicht bei reiner Landing-Page)

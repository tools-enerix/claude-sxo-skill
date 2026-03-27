# Style Extraction: Design Tokens von der Zielseite

## Zweck

Vor der Seiten-Generierung werden die visuellen Eigenschaften der Zielseite extrahiert,
damit der Prototyp aussieht wie ein natuerlicher Teil der bestehenden Website.

---

## Schritt 1: Zielseite abrufen

```
1. URL aus Wireframe-Metadaten lesen (Target Page)
2. WebFetch auf die URL -> HTML-Quelltext
3. Falls WebFetch fehlschlaegt:
   -> on_page_content_parsing als Fallback versuchen
   -> Falls beides fehlschlaegt: Standard-Tokens verwenden (siehe Fallback)
```

---

## Schritt 2: Design Tokens extrahieren

### 2a -- Farben

Suche in dieser Reihenfolge:

```
1. CSS Custom Properties (:root { --primary: #...; --brand: #...; })
   -> Variablennamen die "primary", "brand", "accent", "main" enthalten

2. Header/Nav Hintergrundfarbe
   -> background, background-color im header, nav, .navbar, .header Element
   -> Oft die primaere Brand-Farbe

3. CTA-Button Farbe
   -> background-color des primaeren Buttons (.btn-primary, .cta, button[type="submit"])
   -> Oft die Akzentfarbe

4. Link-Farbe
   -> color von a-Elementen
   -> Oft identisch mit Akzentfarbe

5. Footer Hintergrundfarbe
   -> background des footer Elements
   -> Typisch: dunkel (#1a1a2e) oder hell (#f5f5f5)

Extrahiere:
  BRAND_PRIMARY:    Hauptfarbe (Header/CTA)
  BRAND_SECONDARY:  Sekundaerfarbe (Links, Hover)
  BRAND_DARK:       Dunkle Variante (Footer, Dark Sections)
  BRAND_LIGHT:      Helle Variante (Backgrounds, Hover-States)
  TEXT_COLOR:       Haupttextfarbe
  TEXT_MUTED:       Gedaempfte Textfarbe
  BG_COLOR:         Seitenhintergrund
  BG_ALT:           Alternativer Hintergrund (Sections)
```

### 2b -- Schriften

```
1. Google Fonts <link> Tags
   -> href="https://fonts.googleapis.com/css2?family=..."
   -> Extrahiere Font-Familien-Namen

2. CSS font-family Deklarationen
   -> body { font-family: ... }
   -> h1, h2 { font-family: ... } (falls abweichend)

3. Falls keine Google Fonts: System Font Stack identifizieren

Extrahiere:
  FONT_BODY:     Body-Schriftart (z.B. "Inter", "Open Sans")
  FONT_HEADING:  Heading-Schriftart (falls abweichend, z.B. "Plus Jakarta Sans")
  FONT_MONO:     Monospace-Schriftart (falls vorhanden)
  GOOGLE_FONTS_URL: Vollstaendige Google Fonts Import-URL
```

### 2c -- Spacing & Radius

```
1. Border-Radius der haeufigsten Elemente
   -> Buttons, Cards, Inputs
   -> Meistens konsistent (z.B. 8px oder 12px oder 9999px fuer Pills)

2. Content Max-Width
   -> .container, .wrapper, main max-width
   -> Typisch: 1100px-1280px

Extrahiere:
  RADIUS_DEFAULT:   Haeufigster border-radius (z.B. "8px")
  RADIUS_SM:        Kleiner Radius (z.B. "4px")
  RADIUS_LG:        Grosser Radius (z.B. "16px")
  RADIUS_FULL:      "9999px" falls Pill-Buttons verwendet
  MAX_WIDTH:        Content-Breite (z.B. "1200px")
```

### 2d -- Header & Footer Struktur

```
HEADER:
  1. Logo-URL extrahieren
     -> <img> in header/nav mit "logo" im src, alt oder class
     -> Volle URL (absolut machen falls relativ)

  2. Navigation-Items extrahieren
     -> <a> Elemente in nav, .nav, .menu
     -> Text + href Paare

  3. Header-Layout erkennen
     -> Logo links + Nav rechts (Standard)
     -> Zentriertes Logo
     -> Mit/Ohne CTA-Button

FOOTER:
  1. Footer-Layout erkennen
     -> Spaltenanzahl (typisch 3-5)
     -> Background (hell/dunkel)

  2. Footer-Links extrahieren
     -> Gruppiert nach Spalten
     -> Nur die Struktur, nicht alle Links

  3. Copyright-Text extrahieren
```

---

## Schritt 3: Tailwind Config generieren

Aus den extrahierten Tokens wird die Tailwind-Konfiguration gebaut:

```html
<script>
tailwind.config = {
  theme: {
    extend: {
      colors: {
        brand: {
          DEFAULT: '{{BRAND_PRIMARY}}',
          dark: '{{BRAND_DARK}}',
          light: '{{BRAND_LIGHT}}',
        },
        accent: {
          DEFAULT: '{{BRAND_SECONDARY}}',
        },
      },
      fontFamily: {
        sans: ['{{FONT_BODY}}', 'system-ui', 'sans-serif'],
        heading: ['{{FONT_HEADING}}', 'system-ui', 'sans-serif'],
      },
      borderRadius: {
        DEFAULT: '{{RADIUS_DEFAULT}}',
        sm: '{{RADIUS_SM}}',
        lg: '{{RADIUS_LG}}',
      },
      maxWidth: {
        content: '{{MAX_WIDTH}}',
      },
    },
  },
}
</script>
```

---

## Schritt 4: Header & Footer uebernehmen

### Header einbinden

```
IF Logo-URL gefunden UND Navigation extrahiert:
  -> Eigenen Header bauen mit:
     - Logo als <img> (originale URL)
     - Navigations-Items (gleiche Texte, Links als #-Platzhalter)
     - CTA-Button falls im Original vorhanden
     - Brand-Farben aus extrahierten Tokens
  -> Tailwind-Klassen verwenden, NICHT Original-CSS kopieren

IF Header-Extraktion fehlschlaegt:
  -> Minimalen Header mit Logo-Platzhalter generieren
  -> Hinweis im Summary: "Header manuell anpassen"
```

### Footer einbinden

```
IF Footer-Struktur erkannt:
  -> Eigenen Footer bauen mit:
     - Gleiche Spalten-Struktur
     - Link-Texte (URLs als #-Platzhalter)
     - Copyright mit aktuellem Jahr
     - Brand-Farben
  -> Tailwind-Klassen verwenden

IF Footer-Extraktion fehlschlaegt:
  -> Standard-Footer generieren
```

---

## Fallback: Standard-Tokens

Falls die Zielseite nicht abrufbar ist:

```
BRAND_PRIMARY:    #2563eb (Blau)
BRAND_SECONDARY:  #1d4ed8 (Dunkelblau)
BRAND_DARK:       #0f172a (Fast-Schwarz)
BRAND_LIGHT:      #eff6ff (Hellblau)
TEXT_COLOR:       #1a1f2e
TEXT_MUTED:       #4a5168
BG_COLOR:         #ffffff
BG_ALT:           #f8f9fb
FONT_BODY:        Inter
FONT_HEADING:     Inter
RADIUS_DEFAULT:   8px
MAX_WIDTH:        1100px
```

Hinweis im Summary: "Styling konnte nicht von der Zielseite extrahiert werden. Standard-Design verwendet. Passe die Tailwind-Config im <script>-Block an, um das Brand-Styling zu uebernehmen."

---

## Qualitaetskriterien

| Pruefpunkt | Kriterium |
|---|---|
| Farb-Konsistenz | Extrahierte Farben sinnvoll (nicht alle gleich) |
| Font-Validitaet | Google Fonts URL funktioniert |
| Logo sichtbar | Logo-URL erreichbar und korrekt |
| Kontrast | Text auf Hintergrund lesbar (WCAG AA) |
| Kein Branding-Konflikt | Keine Wettbewerber-Logos/Farben |

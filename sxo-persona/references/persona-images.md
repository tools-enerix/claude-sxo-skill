# Persona-Bilder: Archetypes, Prompts und Caching

## Cache-System

### Verzeichnisstruktur

```
~/.sxo-persona/image-cache/
  price-conscious-de.png
  price-conscious-en.png
  quality-focused-de.png
  anxious-decider-de.png
  ...
```

### Cache-Key Format

```
{archetype}-{lang}.png

archetype:  Aus der Archetype-Tabelle unten (Kleinbuchstaben, Bindestriche)
lang:       "de" oder "en" (aus Dashboard-Sprache)
```

### Cache-Logik

```
1. Bestimme Archetype fuer jede Persona (siehe Mapping unten)
2. Baue Cache-Key: "{archetype}-{lang}.png"
3. Pruefe ob Datei existiert: ~/.sxo-persona/image-cache/{key}

IF Datei existiert UND Dateigroesse > 0:
  -> Lade Bild als base64
  -> Hinweis im Log: "Cache-Hit: {key}"

ELSE:
  -> Erstelle Cache-Verzeichnis falls noetig: mkdir -p ~/.sxo-persona/image-cache/
  -> Generiere Bild via gemini_generate_image (siehe Prompts unten)
  -> Das MCP-Tool speichert das Bild unter ~/Documents/nanobanana_generated/
  -> Kopiere das generierte Bild in den Cache: cp <generated-path> ~/.sxo-persona/image-cache/{key}
  -> Lade Bild als base64
  -> Hinweis im Log: "Cache-Miss: {key} -- Bild generiert und gecacht"
```

### Base64-Embedding

```
Lies die Bilddatei mit dem Read-Tool (es kann PNG-Dateien lesen).
Fuer das HTML-Embedding nutze Bash:

base64_data=$(base64 -w 0 ~/.sxo-persona/image-cache/{key})
echo "data:image/png;base64,${base64_data}"

Setze das Ergebnis als src-Attribut des <img> Tags.
```

---

## Archetype-Mapping

Jede Persona wird einem Archetype zugeordnet. Der Archetype bestimmt den Cache-Key und den Bild-Prompt.

### Primaere Archetypes (aus Intent-Clustern)

| Intent-Cluster | Archetype-Key | Visuelle Beschreibung |
|---|---|---|
| Preis | `price-conscious` | Person mit Taschenrechner oder Preisschild, nachdenklicher Blick |
| Qualitaet | `quality-focused` | Person mit Lupe oder Pruefsiegel, kritischer aber freundlicher Blick |
| Lokal | `local-seeker` | Person mit Standort-Pin oder Stadtsilhouette, offener Blick |
| DIY | `diy-maker` | Person mit Werkzeug oder Schraubenschluessel, selbstbewusster Blick |
| Anbieter | `provider-comparer` | Person mit zwei Optionen/Waagschale, abwaegender Blick |
| Angst/Unsicherheit | `anxious-decider` | Person mit verschraenkten Armen, leicht besorgter aber hoffnungsvoller Blick |
| Spezialfall | `special-case` | Person mit Fragezeichen-Symbol, neugieriger Blick |
| Dringlichkeit | `urgent-user` | Person mit Uhr-Symbol, entschlossener Blick |
| Informational | `knowledge-seeker` | Person mit Buch oder Gluehbirne, wissbegieriger Blick |
| Commercial | `ready-buyer` | Person mit Einkaufstasche oder Kreditkarte, entschlossener Blick |

### Sekundaere Archetypes (aus User Story / Gap-Analyse)

| Quelle | Archetype-Key | Visuelle Beschreibung |
|---|---|---|
| Vertrauen | `trust-seeker` | Person mit Schild-Symbol, vorsichtiger aber offener Blick |
| Expertise | `expert-user` | Person mit Brille und Laptop, konzentrierter Blick |
| Neuling | `beginner` | Person mit Fragezeichen, offener und etwas unsicherer Blick |
| Emotion | `emotional-seeker` | Person mit Hand am Herzen, emotionaler Blick |
| ROI | `roi-calculator` | Person mit Diagramm-Symbol, analytischer Blick |
| Hauptpersona | `main-planner` | Person mit Checkliste oder Plan, organisierter Blick |

### Zuordnungsregeln

```
Fuer jede Persona:

1. Bestimme den dominanten Intent-Cluster (aus Schritt 2a)
2. Ordne den passenden Archetype-Key zu (Tabelle oben)
3. Falls kein Cluster exakt passt: waehle den naechstliegenden
4. Die Hauptpersona (aus User Story) bekommt immer "main-planner"

WICHTIG: Keine zwei Personas im selben Dashboard duerfen denselben
Archetype haben. Falls Kollision:
  -> Verwende den sekundaeren Archetype fuer eine der beiden
  -> Z.B. zwei Preis-Personas: eine bekommt "price-conscious",
     die andere "roi-calculator"
```

---

## Bild-Prompts (Flat Illustration Stil)

### Basis-Prompt (wird jedem Persona-Prompt vorangestellt)

```
Flat vector portrait illustration of a single person, bust/shoulders-up view,
clean geometric shapes, warm muted color palette, solid color background
({BG_COLOR}), friendly approachable expression, modern minimal style,
no text, no watermark, suitable for circular crop, professional quality,
consistent flat design aesthetic.
```

BG_COLOR wird aus der Persona-Farbe abgeleitet:
- Score 0-29 (Rot):    soft coral background (#fce4ec)
- Score 30-49 (Orange): soft peach background (#fff3e0)
- Score 50-69 (Amber):  soft warm yellow (#fffde7)
- Score 70-89 (Blau):   soft sky blue (#e3f2fd)
- Score 90-100 (Gruen): soft mint (#e8f5e9)

### Archetype-spezifische Prompt-Erweiterungen

Haenge diese Beschreibung an den Basis-Prompt an:

| Archetype | Prompt-Erweiterung |
|---|---|
| `price-conscious` | A person in casual everyday clothing, holding a small calculator. Thoughtful expression, slightly furrowed brow. Context: comparing prices. |
| `quality-focused` | A person in smart-casual clothing, adjusting glasses, holding a magnifying glass. Discerning, attentive expression. Context: examining quality. |
| `local-seeker` | A person in relaxed clothing, with a small map pin icon floating nearby. Open, friendly expression. Context: looking for nearby services. |
| `diy-maker` | A person in a work shirt or casual tee, holding a wrench or screwdriver. Confident, capable expression. Context: hands-on problem solver. |
| `provider-comparer` | A person in business-casual clothing, with two small cards in each hand. Contemplative, weighing expression. Context: comparing options. |
| `anxious-decider` | A person in conservative clothing, arms slightly crossed, with a small shield icon nearby. Cautious but hopeful expression. Context: making a big decision. |
| `special-case` | A person with unique styling, a question mark thought bubble. Curious, slightly puzzled expression. Context: has a specific unusual situation. |
| `urgent-user` | A person in professional clothing, with a small clock icon nearby. Determined, focused expression. Context: needs a solution quickly. |
| `knowledge-seeker` | A person in casual clothing, with a small lightbulb icon nearby. Eager, curious expression, slight smile. Context: wants to learn and understand. |
| `ready-buyer` | A person in professional clothing, with a small shopping bag icon. Decisive, confident expression. Context: ready to make a purchase. |
| `trust-seeker` | A person in neat clothing, with a small checkmark/shield icon. Careful but open expression. Context: needs reassurance before committing. |
| `expert-user` | A person in professional clothing with glasses, holding a tablet or laptop. Focused, knowledgeable expression. Context: technically proficient. |
| `beginner` | A young person in casual clothing, with a small question mark nearby. Open, slightly overwhelmed but eager expression. Context: new to the topic. |
| `emotional-seeker` | A person with warm expression, hand near heart. Emotionally engaged, searching for the right feeling. Context: decision driven by emotion. |
| `roi-calculator` | A person in smart clothing, with a small chart/graph icon. Analytical, calculating expression. Context: wants to see the numbers. |
| `main-planner` | A person in business-casual clothing, holding a clipboard or checklist. Organized, determined expression. Context: planning a major project. |

### Generierungsparameter

```
Tool:        gemini_generate_image
Aspect Ratio: 1:1 (via set_aspect_ratio vorher setzen)
Resolution:  512 (kleinste Stufe -- reicht fuer 56x56px Avatar, spart Kosten)
Model:       gemini-3.1-flash-image-preview (Standard)
```

Kosten pro Bild: ca. $0.02 (512px)
Kosten fuer 6 Personas (worst case, kein Cache): ca. $0.12

# Persona-Ableitung aus SXO-Report: Regeln und Taxonomie

## Intent-Cluster Taxonomie

Jeder Related-Search-Eintrag und jede PAA-Frage gehoert zu einem oder mehreren Intent-Clustern. Die Cluster bestimmen, welche Personas abgeleitet werden.

### Primaere Intent-Cluster

| Cluster | Signalwoerter (DE) | Signalwoerter (EN) | Typische Persona |
|---|---|---|---|
| **Preis** | Kosten, Preis, guenstig, billig, was kostet, ab, Euro | cost, price, cheap, affordable, how much, budget | Preisbewusster Vergleicher |
| **Qualitaet** | Original, Test, beste, Erfahrungen, Bewertung, Vergleich | original, best, review, quality, comparison, rated | Qualitaetsbewusster Rechercheur |
| **Lokal** | in der Naehe, Stadt, PLZ, vor Ort, Oeffnungszeiten | near me, city, local, nearby, open now | Lokaler Sofort-Sucher |
| **DIY** | selber, Anleitung, Tutorial, how to, kaufen (Teil) | DIY, tutorial, how to, guide, buy (part) | Selbermacher |
| **Anbieter** | Markenname, vs., Alternative, Vergleich | brand name, vs., alternative, comparison | Anbieter-Vergleicher |
| **Angst/Unsicherheit** | lohnt sich, sicher, Risiko, Garantie, Datenschutz | worth it, safe, risk, warranty, guarantee | Unsicherer Entscheider |
| **Spezialfall** | Modellvariante, Sonderfall, spezifische Eigenschaft | model variant, special case, specific feature | Spezialfall-Sucher |
| **Dringlichkeit** | sofort, schnell, express, heute, Notfall | urgent, fast, express, today, emergency | Eiliger Nutzer |
| **Informational** | was ist, wie funktioniert, Erklaerung, Unterschied | what is, how does, explanation, difference | Wissenssucher |
| **Commercial** | kaufen, bestellen, buchen, Angebot, Rabatt | buy, order, book, offer, discount | Kaufbereiter Nutzer |

### Sekundaere Cluster (aus User Story + Gap-Analyse)

| Cluster | Quelle | Typische Persona |
|---|---|---|
| **Vertrauen** | Barriere "Ist der Anbieter serioes?" | Misstrauischer Erstbesucher |
| **Expertise** | Wissensstand "Bereits informiert" | Experte mit spezifischer Frage |
| **Neuling** | Wissensstand "Wenig Vorwissen" | Orientierungsloser Einsteiger |
| **Emotion** | Emotionale Lage "Frustration/Angst" | Emotional getriebener Sucher |
| **ROI** | Gap "Lohnt sich?" Frage | Rationaler Kosten-Nutzen-Rechner |

---

## Ableitungsregeln

### Regel 1: User Story = Hauptpersona

Die User Story aus Section 2 des Reports beschreibt den **statistisch haeufigsten Suchenden**. Daraus wird die erste Persona abgeleitet:

```
Hauptpersona:
  - Nimm Journey-Phase als Basis (Discovery/Consideration/Decision)
  - Nimm Emotionale Lage als Tonung
  - Nimm Primaeres Ziel als Suchmotiv
  - Nimm Barrieren als Bewertungsgrundlage
```

### Regel 2: Ein Cluster = Eine Persona (wenn distinkt genug)

```
Pruefe fuer jeden Intent-Cluster:

IF Cluster unterscheidet sich in MINDESTENS 2 dieser Dimensionen von der Hauptpersona:
  - Anderes Suchmotiv (z.B. Preis vs. Qualitaet)
  - Andere Erwartung (z.B. Tabelle vs. Anleitung)
  - Andere Journey-Phase (z.B. Informational vs. Decision)
  - Andere emotionale Lage (z.B. neugierig vs. frustriert)
THEN:
  -> Eigene Persona erstellen

ELSE:
  -> In bestehende Persona integrieren (als Variante)
```

### Regel 3: PAA-Fragen als Persona-Verfeinerung

```
PAA-Fragen zeigen Wissensluecken und Spezialfaelle:

- Grundsatzfrage ("Lohnt es sich?") -> Unsicherheits-Persona
- Preisvergleich ("Was kostet bei X vs. Y?") -> Vergleicher-Persona
- Technikfrage ("Wie funktioniert...?") -> Wissenssucher-Persona
- Angstfrage ("Ist es sicher?") -> Sicherheits-Persona

IF eine PAA-Frage nicht zu einem bestehenden Cluster passt:
  -> Pruefe ob sie eine eigene Persona rechtfertigt
  -> Mindestens 1 weitere Stuetzung noetig (Related Search ODER Gap)
```

### Regel 4: High-Priority-Gaps als Persona-Quelle

```
Jeder High-Priority-Gap aus Section 3b zeigt eine unerfuellte Nutzererwartung:

IF Gap hat keinen passenden Intent-Cluster:
  -> Erstelle neue Persona, deren Kernerw artung genau dieser Gap ist
  -> Beispiel: Gap "Lokale Signale fehlen" -> Persona "Lokale Lisa"

IF Gap hat bereits einen passenden Cluster:
  -> Integriere Gap-Details in die Persona-Erwartung und Verbesserungen
```

### Regel 5: Merge-Regeln

```
Merge zwei Cluster zu einer Persona wenn:
- Gleicher Intent-Typ (z.B. beide "Preis")
- Gleiche erwartete Aktion auf der Seite
- Unterschied nur in Formulierung, nicht in Substanz

Beispiele fuer MERGE:
  "Was kostet...?" + "Wie viel kostet...?" -> EINE Preis-Persona
  "iPhone 13 Display" + "iPhone 13 Screen" -> EINE Persona

Beispiele fuer KEIN MERGE:
  "Was kostet Reparatur?" + "Was kostet selber machen?" -> ZWEI Personas
  "Anbieter in der Naehe" + "Online bestellen" -> ZWEI Personas
```

---

## Persona-Namenkonventionen

### Deutsch

```
Format: [Adjektiv/Eigenschaft]-[Vorname], [Alter], [Beruf/Situation]

Regeln:
- Alliteration ist ein Plus, aber nicht erzwungen
- Name muss zum Kontext passen (Branche, Region, Altersgruppe)
- Beruf/Situation muss den Intent erklaeren

Gute Beispiele:
  "Preisbewusste Petra, 34, Studentin mit gebrochenem Display"
  "Altbau-Andreas, 52, Eigenheimbesitzer BJ 1978"
  "Eiliger Erik, 35, Aussendienstler -- Handy fuers Geschaeft"
  "Qualitaets-Kai, 41, IT-Consultant mit Apple-Oekosystem"
  "Lokale Lisa, 28, will persoenliche Beratung vor Ort"
  "DIY-Dennis, 22, repariert gern selbst"
  "Sorgenvolle Sabine, 55, hat noch nie ein Geraet reparieren lassen"

Schlechte Beispiele:
  "User A" (zu generisch)
  "Max Mustermann" (Platzhalter)
  "Technik-Tanja, 29, Persona" (Beruf = "Persona"?!)
```

### English

```
Format: [Adjective]-[First Name], [Age], [Occupation/Situation]

Good examples:
  "Budget-Conscious Ben, 28, Graduate Student"
  "Quality-Focused Quinn, 42, IT Professional"
  "Local Laura, 35, Prefers In-Person Service"
  "DIY Dave, 24, Fixes Things Himself"
  "Anxious Anna, 58, First-Time Customer"
```

---

## Scoring-Details

### Dimension-Gewichtung

```
Die 4 Dimensionen sind NICHT gleich gewichtet:

1. Erwartungserfuellung:  35 Punkte (35%)  -- Kern der Persona-Bewertung
2. First-Screen-Relevanz: 25 Punkte (25%)  -- Erster Eindruck entscheidend
3. Barriereabbau:         25 Punkte (25%)  -- Kaufentscheidungs-Faktor
4. Trust-Signale:         15 Punkte (15%)  -- Unterstuetzend

Begruendung: Die Erwartung ist das Wichtigste -- wenn eine Persona nicht findet
was sie sucht, helfen auch Trust-Signale nicht.
```

### Scoring-Leitfaden nach Persona-Typ

```
PREIS-PERSONA:
  Dim 2 hoch wenn: Preise sichtbar, Vergleichstabelle, Preiserklaerung
  Dim 2 niedrig wenn: Kein Preis, nur "auf Anfrage", keine Einordnung
  Dim 3 hoch wenn: Preis-Leistungs-Argumentation, Garantie

QUALITAETS-PERSONA:
  Dim 2 hoch wenn: Materialangaben, Zertifizierungen, Testberichte
  Dim 2 niedrig wenn: Keine Qualitaetsdetails, generische Beschreibung
  Dim 4 hoch wenn: Pruefsiegel, ISO, "Original"-Kennzeichnung

LOKAL-PERSONA:
  Dim 1 hoch wenn: Adresse, Karte, Oeffnungszeiten im Hero
  Dim 1 niedrig wenn: Nur Online-Bestellung, keine lokalen Signale
  Dim 2 hoch wenn: Filialfinder, Anfahrt, Termin-Buchung

DIY-PERSONA:
  Dim 2 hoch wenn: Anleitung, Ersatzteil-Shop, Video-Tutorial
  Dim 2 niedrig wenn: Nur Dienstleistung, kein Selbst-Angebot

ANGST-PERSONA:
  Dim 3 hoch wenn: FAQ mit Sicherheitsfragen, Garantie prominent, Erfahrungsberichte
  Dim 3 niedrig wenn: Keine Risiko-Adressierung, keine Garantie-Info
  Dim 4 hoch wenn: Bewertungssterne, TUeV, Versicherung

EILIG-PERSONA:
  Dim 1 hoch wenn: "Sofort"/"Express" im Hero, Zeitangabe prominent
  Dim 2 hoch wenn: Schnell-Buchung, Wartezeit-Info, Express-Option
```

---

## Edge Cases

### Zu wenige Cluster (< 4)

```
IF nur 1-2 distinkte Cluster identifiziert:
  -> Teile die User Story in Journey-Phasen auf:
     1. Fruehe Phase (Informational): "Was ist das?"
     2. Mittlere Phase (Consideration): "Welche Optionen habe ich?"
     3. Spaete Phase (Decision): "Wo kaufe ich?"
  -> Ergaenze mit: Experte vs. Neuling Perspektive
  -> Minimum: 4 Personas
```

### Zu viele Cluster (> 7)

```
IF mehr als 7 Cluster:
  -> Priorisiere nach:
     1. Cluster mit High-Priority-Gap (behalten)
     2. Cluster mit mehreren Related Searches (behalten)
     3. Cluster mit PAA-Unterstuetzung (behalten)
     4. Einzelne Related Searches ohne weitere Stuetzung (mergen)
  -> Maximum: 7 Personas
```

### Keine SXO-Page und keine URL

```
IF nur Report vorhanden:
  -> Alle Scores sind "projiziert"
  -> Nutze Gap-Analyse als inverse Scoring-Quelle:
     - Viele High-Priority-Gaps = niedrige projizierte Scores
     - Wenige/keine Gaps = hohe projizierte Scores
  -> Hinweis im Dashboard: "Fuer praezise Scores: /sxo-page oder URL angeben"
```

### Fremdsprachiger Report

```
IF Report-Sprache =/= Keyword-Sprache:
  -> Folge der Report-Sprache (diese ist intentional gewaehlt)
  -> Persona-Namen in Report-Sprache
```

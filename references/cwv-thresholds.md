# Core Web Vitals -- Schwellwerte & Scoring

## CWV Schwellwerte

| Metrik | Feld in Response | Gruen (gut) | Gelb (verbesserungswuerdig) | Rot (schlecht) |
|---|---|---|---|---|
| LCP (Largest Contentful Paint) | `audits.largest-contentful-paint` | <= 2.5s | 2.5s - 4.0s | > 4.0s |
| CLS (Cumulative Layout Shift) | `audits.cumulative-layout-shift` | <= 0.1 | 0.1 - 0.25 | > 0.25 |
| INP (Interaction to Next Paint) | `audits.interaction-to-next-paint` oder `audits.total-blocking-time` als Proxy | <= 200ms | 200ms - 500ms | > 500ms |
| FCP (First Contentful Paint) | `audits.first-contentful-paint` | <= 1.8s | 1.8s - 3.0s | > 3.0s |
| TTFB (Time to First Byte) | `audits.server-response-time` | <= 800ms | 800ms - 1800ms | > 1800ms |
| Speed Index | `audits.speed-index` | <= 3.4s | 3.4s - 5.8s | > 5.8s |

## Performance & Accessibility Scores

Aus der `on_page_lighthouse` Response (mit `full_data: true`):
- `categories.performance.score` (0-1, multipliziere mit 100)
- `categories.accessibility.score` (0-1, multipliziere mit 100)
- `categories.seo.score` (0-1, multipliziere mit 100)

## Bilder-Accessibility

Aus Lighthouse:
- `audits.image-alt` -> Liste aller Bilder ohne Alt-Tag (mit URLs)
- Score: `audits.image-alt.score` (1.0 = alle haben Alt-Tags, < 1.0 = welche fehlen)
- `audits.image-alt.details.items` -> Konkrete `<img>` Elemente ohne Alt-Attribut

Aus `on_page_instant_pages`:
- `meta.images_count` -> Gesamtzahl der Bilder auf der Seite
- `meta.images_without_alt` -> Anzahl Bilder ohne Alt-Tag
- `meta.images_without_src` -> Anzahl Bilder ohne src-Attribut

## Scoring-Logik

### Bilder Alt-Tags

```
IF images_without_alt == 0:
  -> check-pass: "Alle [images_count] Bilder haben Alt-Tags"
ELIF images_without_alt <= 3:
  -> check-warn: "[images_without_alt] von [images_count] Bildern ohne Alt-Tag"
     + Liste der betroffenen Bilder aus Lighthouse image-alt Audit
ELSE:
  -> check-fail: "[images_without_alt] von [images_count] Bildern ohne Alt-Tag"
     + Liste der betroffenen Bilder aus Lighthouse image-alt Audit
```

### Performance Gesamt

```
IF performance_score >= 90 AND alle CWV gruen:
  -> check-pass: "Performance Score [X]/100 -- alle Core Web Vitals im gruenen Bereich"
ELIF performance_score >= 50:
  -> check-warn: "Performance Score [X]/100" + Liste der gelben/roten Metriken
ELSE:
  -> check-fail: "Performance Score [X]/100" + Liste der roten Metriken mit konkreten Werten
```

## CWV Tabelle im Report

Zeige als Tabelle:
```
| Metrik | Wert | Bewertung |
|--------|------|-----------|
| Performance Score | [X]/100 | [gruen/gelb/rot] |
| LCP | [X]s | [gruen <= 2.5s / gelb <= 4.0s / rot > 4.0s] |
| CLS | [X] | [gruen <= 0.1 / gelb <= 0.25 / rot > 0.25] |
| INP/TBT | [X]ms | [gruen <= 200ms / gelb <= 500ms / rot > 500ms] |
| FCP | [X]s | [gruen <= 1.8s / gelb <= 3.0s / rot > 3.0s] |
| TTFB | [X]ms | [gruen <= 800ms / gelb <= 1800ms / rot > 1800ms] |
| Accessibility Score | [X]/100 | [gruen >= 90 / gelb >= 50 / rot < 50] |
| SEO Score | [X]/100 | [gruen >= 90 / gelb >= 50 / rot < 50] |
```

Farbkodierung: `badge-pass` (gruen), `badge-warn` (gelb), `badge-fail` (rot).

Gesamtbewertung:
- `check-pass`: Performance Score >= 90 UND alle CWV gruen
- `check-warn`: Performance Score >= 50 ODER mindestens ein CWV gelb
- `check-fail`: Performance Score < 50 ODER mindestens ein CWV rot

## Optimierungshinweise bei roten Metriken

| Metrik | Hinweis |
|--------|---------|
| LCP rot | Groesstes sichtbares Element optimieren: Bilder komprimieren, Server-Response beschleunigen |
| CLS rot | Layout-Verschiebungen reduzieren: Breite/Hoehe fuer Bilder/Embeds definieren, Web Fonts mit font-display:swap |
| INP/TBT rot | Interaktivitaet verbessern: JavaScript-Ausfuehrung reduzieren, Long Tasks aufbrechen |
| FCP rot | Erste Darstellung beschleunigen: Render-blockierendes CSS/JS eliminieren |
| TTFB rot | Server-Antwortzeit reduzieren: Caching, CDN, Server-Konfiguration pruefen |

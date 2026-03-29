# Above-the-Fold Screenshot Capture

Shared reference for capturing and embedding a screenshot of the target URL's above-the-fold area.

## Capture Command

```bash
npx playwright screenshot "{{URL}}" /tmp/sxo-screenshot.png --viewport-size "1280,800" --timeout 15000
```

**Parameters:**
- Viewport `1280x800` captures the typical desktop above-the-fold area
- Timeout 15s prevents hanging on slow pages
- No `--full-page` flag = captures only the visible viewport (above-the-fold)

## Convert to Base64

```bash
SCREENSHOT_BASE64=$(base64 -w 0 /tmp/sxo-screenshot.png 2>/dev/null || openssl base64 -A -in /tmp/sxo-screenshot.png)
```

Uses `base64 -w 0` (GNU coreutils) with `openssl base64 -A` as fallback (macOS/Windows).

## Embed in HTML

```html
<div class="screenshot-card">
  <div class="sub-label">Above-the-Fold Ansicht</div>  <!-- bzw. "Above-the-Fold View" EN -->
  <img class="screenshot-img" src="data:image/png;base64,{{BASE64_DATA}}" alt="Above-the-Fold Screenshot: {{URL}}">
  <p class="fs-13 text-muted mt-8">Viewport: 1280 &times; 800px (Desktop)</p>
</div>
```

## Error Handling

```
IF Playwright nicht installiert ODER Screenshot fehlschlaegt:
  -> Log: "Screenshot konnte nicht erstellt werden: [Fehlermeldung]"
  -> Screenshot-Sektion im HTML weglassen (NICHT den gesamten Workflow abbrechen)
  -> Hinweis an User: "Screenshot konnte nicht erstellt werden.
     Stellen Sie sicher, dass Playwright installiert ist: npx playwright install chromium"
```

## Placement

- **sxo-analyze**: Direkt nach dem HEADER, vor Sektion 1 (SERP-Betrachtung)
- **sxo-persona**: Zwischen ZUSAMMENFASSUNG und USER STORY Sektion

## Cleanup

```bash
rm -f /tmp/sxo-screenshot.png
```

Temporaere Datei nach Base64-Konvertierung loeschen.

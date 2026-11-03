# Designing the card

The reference is https://xav.contact/; screenshots are in the kit's `docs/` folder (web fetch
tools drop styles, so look at those). What makes it work is not its colours but its
discipline: one column, one dominant element, one accent, a clear type system, sharp details,
nothing left at a browser default, and one signature detail. Bring the same discipline to the
person's brand. Do not copy the reference's look; build theirs.

## What makes the reference distinctive

- A wide photo of the person in a place (Sydney Harbour), running edge to edge on a phone.
- The name huge, in a condensed uppercase display face (Anton), tight line height.
- Small labels in a monospace, uppercase, widely tracked: they read as engineered.
- Thin blue crop-mark corners on the one framed element of each section: its signature detail.
- One accent blue on near-black, flat colour, no shadows, square corners.
- A featured call to action with a small animated diagram, and a real About section with facts.

## The signature detail

Give every card one small, memorable detail drawn from the person's brand or work, used in two
or three places at most: crop marks for an engineer, a hand-drawn underline for an illustrator,
a ruled-paper margin for a writer, a stamp-like badge for a café owner, film sprocket edges for
a filmmaker. One idea, executed precisely, beats many decorations.

## Principles

1. **Phone first.** Most visits come from a QR scan or a link tap. Design at 390px wide, then
   check 360px and desktop. One column, `max-width` about 28rem, centred, 16px side gutters,
   never any sideways scroll.
2. **One dominant element.** The photo and name. Everything after it is quieter.
3. **Order:** identity → connect grid → optional feature → optional about → QR → footer.
4. **One accent colour**, used sparingly: the main channel's icon, focus and hover states, the
   finder centres of the QR code, a section marker. Everything else is the brand's neutrals.
5. **Two typefaces at most**, plus an optional monospace for small labels. A display face for
   the name, a text face for everything else. Small labels (`.micro`) in uppercase with wide
   letter spacing read as deliberate.
6. **Sharp, intentional details.** Consistent radius (zero is fine if the brand is square),
   hairline borders, a consistent spacing scale (for example 4, 8, 12, 16, 24, 40). Hover and
   `:focus-visible` states on everything clickable.
7. **Fast and private.** Fonts and images live in the site. No external scripts, styles,
   analytics or font CDNs at runtime.

Avoid the generic look: default blue links, system-font-only pages with no hierarchy, emoji as
icons, drop shadows on everything, gradients for their own sake, centred paragraphs, stock
imagery, more than one accent, giant rounded "pill" buttons for every link.

## Tokens

Put the brand into custom properties at the top of `styles.css` and use only these afterwards:

```css
:root {
  --bg: ;          /* page background */
  --surface: ;     /* panels: grid cells, feature, QR panel */
  --fg: ;          /* main text */
  --muted: ;       /* secondary text, at least 4.5:1 against --bg */
  --rule: ;        /* hairlines, about 15-20% of --fg over --bg */
  --accent: ;      /* the one brand accent */
  --on-accent: ;   /* text on an --accent fill, at least 4.5:1 */
  --display: ;     /* name and headings */
  --sans: ;        /* body */
  --mono: ;        /* optional: small labels */
  --radius: ;      /* 0 to 12px, from the brand */
  --ease: cubic-bezier(0.22, 1, 0.36, 1);
  color-scheme: ;  /* light or dark, to match --bg */
}
```

Set `<meta name="theme-color">` to `--bg`. If the brand is light, the page is light; do not force
dark mode on a light brand. One theme is enough; a card does not need a theme switcher.

## Fonts

Use the brand's own typefaces if they are free (Google Fonts and most open-source fonts are).
Download the woff2 files into `fonts/` from Fontsource, for example:

```
https://cdn.jsdelivr.net/npm/@fontsource/<font-id>/files/<font-id>-latin-400-normal.woff2
https://cdn.jsdelivr.net/npm/@fontsource/<font-id>/files/<font-id>-latin-700-normal.woff2
```

`<font-id>` is the lowercase hyphenated name (`inter`, `dm-serif-display`, `space-grotesk`). Fetch
`https://cdn.jsdelivr.net/npm/@fontsource/<font-id>/` to see which weights exist. Variable fonts
come as one file: `https://cdn.jsdelivr.net/npm/@fontsource-variable/<font-id>/files/<font-id>-latin-wght-normal.woff2`
(declare `font-weight: 100 900`). The `latin` subset lacks letters such as ł, ř, ș, ă and
Vietnamese; if the person's name or text uses them, also download the `latin-ext` (or
`vietnamese`, `cyrillic`, `greek`) file and declare it with its `unicode-range`. Declare each
with `@font-face` and `font-display: swap`, preload the one or two used above the fold, and
include fallbacks (`ui-sans-serif, system-ui, sans-serif`). If the brand uses a paid font, do not
copy its files: pick the closest free match and say so.

## Layout skeleton

A structural starting point. Replace or extend it freely to suit the brand; the values here are
not the brand.

```css
* { box-sizing: border-box; }
html { overflow-x: clip; }
body {
  margin: 0; min-height: 100dvh; display: flex; justify-content: center;
  padding: clamp(1.5rem, 5vw, 3.5rem) 16px clamp(2.5rem, 8vw, 5rem);
  background: var(--bg); color: var(--fg); font-family: var(--sans);
  -webkit-font-smoothing: antialiased;
}
main { width: 100%; max-width: 28rem; display: flex; flex-direction: column; gap: clamp(1.75rem, 5vw, 2.5rem); }
img, svg { max-width: 100%; }
a { color: inherit; }
.micro { margin: 0; font-family: var(--mono, var(--sans)); font-size: 11px; line-height: 1.4;
  letter-spacing: 0.18em; text-transform: uppercase; color: var(--muted); }

.identity { display: flex; flex-direction: column; gap: 18px; }
.photo { margin: 0; }
.photo img { display: block; width: 100%; height: auto; border-radius: var(--radius); }
.identity h1 { margin: 0; font-family: var(--display); font-size: clamp(2.4rem, 1.8rem + 3vw, 3.25rem); line-height: 0.95; }

.grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 1px;
  background: var(--rule); border: 1px solid var(--rule); border-radius: var(--radius); overflow: hidden; }
.grid .wide { grid-column: span 2; }
.cell { display: flex; flex-direction: column; gap: 12px; padding: 14px; min-width: 0;
  background: var(--bg); text-decoration: none; transition: background-color 200ms var(--ease); }
.cell:hover, .cell:focus-visible { background: var(--surface); outline: none; }
.cell .icon { width: 18px; height: 18px; }
.cell.accent .icon, .cell:hover .icon, .cell:focus-visible .icon { color: var(--accent); }
.cell .text { display: flex; flex-direction: column; gap: 6px; min-width: 0; }
.cell .value { font-size: 13px; color: var(--muted); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

.feature { display: flex; flex-direction: column; background: var(--surface); border: 1px solid var(--rule);
  border-radius: var(--radius); overflow: hidden; text-decoration: none; }
.feature-head { display: flex; flex-direction: column; gap: 10px; padding: 18px 20px; }
.feature h2 { margin: 0; font-size: 1.35rem; line-height: 1.1; }
.feature-go { display: flex; align-items: center; justify-content: space-between; height: 52px; padding: 0 20px;
  background: var(--accent); color: var(--on-accent); }
.feature-go .arrow { width: 16px; height: 16px; transition: transform 200ms var(--ease); }
.feature:hover .arrow, .feature:focus-visible .arrow { transform: translateX(4px); }

.about { display: flex; flex-direction: column; gap: 14px; }
.about h2 { margin: 0; font-size: 1.35rem; }
.about p { margin: 0; line-height: 1.6; }
.facts { margin: 0; border-top: 1px solid var(--rule); }
.facts > div { display: grid; grid-template-columns: 7rem 1fr; gap: 14px; padding: 12px 0; border-bottom: 1px solid var(--rule); }
.facts dt, .facts dd { margin: 0; }

.qr { background: var(--surface); border: 1px solid var(--rule); border-radius: var(--radius); }
.qr-code { display: block; width: 100%; height: auto; }
.qr-data, .qr-eye { fill: var(--fg); }
.qr-pupil { fill: var(--accent); }

footer { display: flex; align-items: center; justify-content: space-between; gap: 12px;
  padding-top: 18px; border-top: 1px solid var(--rule); }
.share { display: inline-flex; align-items: center; gap: 10px; padding: 4px 0; background: none; border: 0;
  color: var(--fg); font: inherit; cursor: pointer; text-decoration: underline; text-underline-offset: 6px; }
.share .icon { width: 13px; height: 13px; }
.share:hover, .share:focus-visible, .share.flash { color: var(--accent); outline: none; }
.credit { text-align: center; opacity: 0.7; }
.credit a { text-decoration: none; }

@media (prefers-reduced-motion: reduce) { *, *::before, *::after { transition: none !important; } }
```

## Identity: two layouts

- **Wide photo** (landscape, like the reference): full width above the name. On phones let it
  run to the screen edges and the top: `@media (max-width: 480px) { .photo { margin: -1.5rem -16px 0; } .photo img { border-radius: 0; } }`
  (match the negative top margin to the body's top padding).
- **Square headshot:** a 96 to 120px image beside or above the name, `object-fit: cover`, with the
  brand's radius (a circle only if the brand is round).

## The QR code

`assets/card.js` draws the QR into `.qr` as an SVG. Style it only through `.qr-data`, `.qr-eye`,
`.qr-pupil` and the `.qr` panel. It must still scan:

- Keep strong contrast between modules and the panel: at least 7:1. Dark modules on a light
  panel scan everywhere. Light modules on a dark panel scan in iPhone and Android cameras but not
  in some older scanner apps; on a dark brand you may keep it dark, or give the QR a light panel.
- The accent may colour the finder centres (`.qr-pupil`) only if it keeps at least 4.5:1 against
  the panel; otherwise make them the module colour. Never colour the data modules with a
  low-contrast colour, gradients or images.
- If you can, decode your screenshot of the QR (any QR decoder you have) and confirm it gives
  `SITE_URL`.
- Keep the built-in quiet zone (the SVG includes it); do not crop or pad it away.
- Full column width is the default. Do not overlay a logo on it.

## Icons

Use the inline SVG icons in `references/links.md` (1.75 stroke, 24px grid, `currentColor`), sized
by CSS. Do not mix icon styles and do not use emoji.

## Before you show them: checklist

Check each against your screenshots, not your memory of the code:

- [ ] At 360px and 390px wide: no sideways scroll, nothing clipped, long values end in an ellipsis.
- [ ] The name is the most prominent thing on the page; the role line sits directly under it.
- [ ] Colours come from their brand and only one accent is used. Body and muted text pass 4.5:1.
- [ ] Fonts loaded (no fallback flash in the screenshot) and come from `fonts/`, not a CDN.
- [ ] Every link and button has a visible hover and keyboard focus state.
- [ ] The photo is sharp, correctly cropped (eyes not cut off), and under 400KB.
- [ ] The QR code is full width, high contrast, square, and points at the live URL.
- [ ] It looks designed for this person: someone who knows their brand would recognise it, and
      it has one signature detail.
- [ ] `og.jpg` (1200 by 630) shows the person well when cropped, for LinkedIn and chat previews.
- [ ] `scripts/check.sh` passes.

# Placeholders

Fill every `{{NAME}}` in the template files. If a value does not apply, remove the whole line,
tag or JSON field that holds it rather than leaving it empty (for example, no email means no
`"email"` line in the JSON-LD, no `EMAIL` line in `contact.vcf` and no email cell).

| Placeholder | Example | Used for |
|---|---|---|
| `LANG` | `en-AU` | `<html lang>`, the language and region the page is written in |
| `FULL_NAME` | `Priya Nair` | the name as they want it shown everywhere |
| `GIVEN_NAME` / `FAMILY_NAME` | `Priya` / `Nair` | structured data and `contact.vcf` |
| `ROLE_LINE` | `Brand strategist · Fieldnote Studio · Melbourne` | the short line under the name and the page title; 2 or 3 parts, short enough for one line at 390px |
| `JOB_TITLE` | `Brand strategist` | the role on its own: structured data, `contact.vcf`, the facts list |
| `ORGANISATION` / `ORGANISATION_URL` | `Fieldnote Studio` / `https://fieldnote.example/` | where they work; remove the `worksFor` object if they are independent |
| `CITY` / `COUNTRY_CODE` | `Melbourne` / `AU` | structured data (two-letter country code) |
| `CITY_LONG` | `Melbourne, Victoria, Australia` | the facts list |
| `DESCRIPTION` | `Priya Nair is a Melbourne brand strategist. Connect on LinkedIn or save her contact card.` | meta description and link previews; one or two plain sentences, under 160 characters |
| `SITE_URL` | `https://priyanair.github.io/` | the card's final address; https and a trailing slash. From `deploy.md` |
| `THEME_COLOR` | `#0B0B0C` | the page background colour (`--bg`) |
| `FAVICON_INK` | `#F5F5F5` | the initials' colour on the favicon; strong contrast with `THEME_COLOR` |
| `INITIALS` | `PN` | the favicon text, one to three letters |
| `PHOTO_FILE` | `photo.jpg` | the main photo's file name (relative, no leading slash) |
| `PHOTO_WIDTH` / `PHOTO_HEIGHT` | `1400` / `577` | the photo's real pixel size, so the page does not jump while loading |
| `PHOTO_ALT` | `Priya Nair smiling, in a sunny studio` | a short, literal description of the photo |
| `PROFILE_URL` | `https://www.linkedin.com/in/priya/` | one `<link rel="me">` and one `sameAs` entry per public profile: duplicate the `<link>` tag and add to the JSON array |
| `PROFILE_LABEL` | `LinkedIn` | the label for that profile in `contact.vcf`; add an `itemN` pair per link |
| `PRIMARY_URL` / `PRIMARY_LABEL` / `PRIMARY_VALUE` / `PRIMARY_ICON_SVG` | LinkedIn URL / `LinkedIn` / `Connect on LinkedIn` / the icon from `links.md` | the wide main-channel cell |
| `LINK_URL` / `LINK_LABEL` / `LINK_VALUE` / `LINK_ICON_SVG` | one per extra link | the other cells: copy the cell per link |
| `FEATURE_URL` / `FEATURE_KICKER` / `FEATURE_TITLE` / `FEATURE_ACTION` | booking link / `Work with me` / `Got a brand that needs a spine?` / `Book a 20 minute call` | the optional featured link |
| `BIO_PARAGRAPH` | two or three sentences | the optional About section; add more `<p>` and facts rows as they have material |
| `EMAIL` / `PHONE_E164` | `priya@fieldnote.example` / `+61400000123` | `contact.vcf` and structured data; only if they chose to publish it |
| `TODAY` | `2026-11-03` | `sitemap.xml`, the date you build |

## Escaping

Values go into HTML, JSON and vCard, each with its own rules:

- **HTML** (text and attributes): write `&` as `&amp;`, `<` as `&lt;`, and `"` inside an attribute
  as `&quot;`.
- **JSON-LD** (inside the `<script>`): escape `"` as `\"` and `\` as `\\`. After filling it, read
  the block back and check it is valid JSON.
- **vCard**: escape `,` `;` and `\` with a backslash (`Fieldnote\, Studio`). Names with accents are
  fine; the file is UTF-8.

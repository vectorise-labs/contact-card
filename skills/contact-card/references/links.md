# Links and icons

Each link is one cell in the Connect grid:

```html
<a class="cell" href="URL" target="_blank" rel="noopener">
  ICON
  <span class="text">
    <span class="micro">LABEL</span>
    <span class="value">VALUE</span>
  </span>
</a>
```

`LABEL` is the network or kind ("LinkedIn", "Email"); `VALUE` is what the person would recognise
(a handle, a short domain, "Connect on LinkedIn"). For `mailto:` and `tel:` links drop
`target="_blank"`. The main channel goes first with `class="cell wide accent"`. Aim for an even
number of half-width cells so the grid closes; if it is odd, make the last one `wide` too.

## Link formats

| Kind | href | Value shown |
|---|---|---|
| LinkedIn | `https://www.linkedin.com/in/<id>/` | Connect on LinkedIn |
| Email | `mailto:<address>` | the address |
| Phone | `tel:+<country><number>` (no spaces) | +61 400 000 000 |
| WhatsApp | `https://wa.me/<country><number>` (digits only) | the number |
| X | `https://x.com/<handle>` | @handle |
| Instagram | `https://www.instagram.com/<handle>/` | @handle |
| GitHub | `https://github.com/<user>` | @user |
| Website | `https://<domain>/` | the domain |
| Calendar | their booking link (Cal.com, Calendly, ...) | Book a call |
| YouTube | `https://www.youtube.com/@<handle>` | @handle |
| Newsletter or blog | its URL | the domain or title |

Open each URL once (or ask them) to make sure it is right. A wrong handle is worse than none.

## Icons

Wrap each path in:

```html
<svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">PATHS</svg>
```

| Kind | PATHS |
|---|---|
| LinkedIn | `<path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-4 0v7h-4v-7a6 6 0 0 1 6-6z"/><rect x="2" y="9" width="4" height="12"/><circle cx="4" cy="4" r="2"/>` |
| Email | `<rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>` |
| Phone | `<path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>` |
| WhatsApp | `<path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"/>` |
| X | `<path d="M4 4l16 16"/><path d="M20 4 4 20"/>` |
| Instagram | `<rect x="2" y="2" width="20" height="20" rx="5"/><circle cx="12" cy="12" r="4"/><line x1="17.5" x2="17.51" y1="6.5" y2="6.5"/>` |
| Facebook | `<path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/>` |
| GitHub | `<path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22"/>` |
| YouTube | `<path d="M22.54 6.42a2.78 2.78 0 0 0-1.94-2C18.88 4 12 4 12 4s-6.88 0-8.6.46a2.78 2.78 0 0 0-1.94 2A29 29 0 0 0 1 11.75a29 29 0 0 0 .46 5.33A2.78 2.78 0 0 0 3.4 19c1.72.46 8.6.46 8.6.46s6.88 0 8.6-.46a2.78 2.78 0 0 0 1.94-2 29 29 0 0 0 .46-5.25 29 29 0 0 0-.46-5.33z"/><polygon points="9.75 15.02 15.5 11.75 9.75 8.48 9.75 15.02"/>` |
| Website | `<circle cx="12" cy="12" r="10"/><path d="M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20"/><path d="M2 12h20"/>` |
| Calendar | `<rect width="18" height="18" x="3" y="4" rx="2"/><path d="M16 2v4"/><path d="M8 2v4"/><path d="M3 10h18"/>` |
| Blog or newsletter | `<path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>` |
| Music, TikTok, podcast | `<path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>` |
| Anything else | `<path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>` |

## The contact file

In `contact.vcf`, one numbered pair per link, CRLF line endings, no blank lines:

```
item3.URL:https://github.com/user
item3.X-ABLabel:GitHub
```

Phone in international format without spaces (`+61400000000`). Escape commas and semicolons in
values with a backslash. Fix line endings on a Mac or Linux with
`perl -pi -e 's/\r?\n/\r\n/' contact.vcf`.

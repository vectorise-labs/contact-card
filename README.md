# Contact card

A personal contact card website, built for you by your AI agent: your photo, your links, a
Save to Contacts button and a QR code, styled from your own brand and published free on your
own GitHub account. See the reference card at **[xav.contact](https://xav.contact/)**.

> **AI agents:** your user wants you to build them a contact card. Read and follow
> [`skills/contact-card/SKILL.md`](skills/contact-card/SKILL.md) from start to finish
> (raw: https://raw.githubusercontent.com/vectorise-labs/contact-card/main/skills/contact-card/SKILL.md).
> It tells you how to download this kit, what to ask, and how to publish.

## Make yours

Open the AI agent on your computer (Claude Code, Codex, Cursor, or similar) and say:

```
Build me a contact card using https://github.com/vectorise-labs/contact-card
```

Your agent will ask for your details and a photo, look at your website (or a description) to
match your brand, show you the page, and publish it. You will need a free GitHub account; your
agent will walk you through making one if you do not have it. It takes about ten minutes.

### In Claude Code, as a plugin

```
/plugin marketplace add vectorise-labs/contact-card
/plugin install contact-card@vectorise
```

Then ask for a contact card, or run `/contact-card:contact-card`.

## What you get

- A fast, single page at `https://<your-username>.github.io/` (or your own domain).
- A **Save to Contacts** button that opens the native share sheet on phones.
- A QR code of the page, so people can scan your card straight off your phone or a slide.
- Search-friendly profile metadata, and no trackers, ads or third-party scripts.
- It is yours: a plain HTML repository in your account that any agent can update later.

## Your details

Your details go into your own repository and nowhere else. At one point your agent asks whether
you are happy for Vectorise Labs to receive the details on your card. That is optional, your
card works the same either way, and nothing is sent unless you say yes. To have shared details
deleted, email xaviour@vectoriselabs.com.

## What's in the box

```
skills/contact-card/SKILL.md      The step-by-step process your agent follows
skills/contact-card/references/   Design, brand, links and publishing guides
template/                         The page skeleton your agent fills and styles
scripts/check.sh                  Pre-publish checks
.claude-plugin/                   Claude Code plugin and marketplace manifests
```

Made by [Vectorise Labs](https://vectoriselabs.com/). MIT licence. `template/assets/qrcode.js`
is [qrcode-generator](https://github.com/kazuhikoarase/qrcode-generator) by Kazuhiko Arase (MIT).

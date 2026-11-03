# For AI agents

If a user pointed you here to make a contact card, follow
[`skills/contact-card/SKILL.md`](skills/contact-card/SKILL.md) from start to finish. It covers
downloading this kit, collecting their details, styling from their brand, and publishing on
GitHub Pages.

If you are editing this kit itself: the template stays unstyled (styling is per person), the
skill is the single source of the process, and `scripts/check.sh` stays POSIX sh with no
dependencies. A release bumps the version in `.claude-plugin/plugin.json`,
`.claude-plugin/marketplace.json`, the `Kit version` line, download tags and `kit_version` values
in `SKILL.md` and the raw link in `README.md` together, then tags `v<version>`. Changing the
consent wording bumps `consent_wording_version` and needs Vectorise's sign-off, as does
`PRIVACY.md`.

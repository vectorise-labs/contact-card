# Publishing on GitHub Pages

The card is published from a public repository in the person's own GitHub account. GitHub Pages
hosts it free over HTTPS. Do each step yourself; stop only where the person must act.

## Choose the address (do this before building)

With their GitHub username `<user>` (GitHub lowercases it in the address):

- If they have no repository called `<user>.github.io`, use that name. The card lives at
  `https://<user>.github.io/`, the cleanest address.
- If they already have one, use a repository called `contact-card`. The card lives at
  `https://<user>.github.io/contact-card/`.

Check with `gh repo view <user>/<user>.github.io` once logged in, or by opening
`https://github.com/<user>/<user>.github.io` (a 404 means it is free). `SITE_URL` is that address,
with the trailing slash.

## 1. A GitHub account

If they have none: ask them to sign up at https://github.com/signup (free; they choose the
username, which becomes part of the address) and tell you the username. You cannot do this for
them.

## 2. The tools: git and GitHub CLI

Check `git --version` and `gh --version`. If either is missing:

- **Mac:** with Homebrew (`brew --version`), run `brew install git gh`. Without Homebrew, running
  `git --version` offers to install Apple's command line tools (ask them to click Install), and
  `gh` can be downloaded from https://cli.github.com (the macOS installer). Do not install
  Homebrew without asking; it takes a while and needs their password.
- **Windows:** `winget install --id Git.Git -e` and `winget install --id GitHub.cli -e`, then
  open a new terminal session.
- **Linux:** the distribution's package manager (`sudo apt install git gh` or the instructions
  at https://cli.github.com).

## 3. Log in

Check `gh auth status`. If they are not logged in, the login is interactive, so they run it.
Tell them exactly what to type into your chat box, for example in Claude Code:

```
! gh auth login --web --git-protocol https
```

(other agents: ask them to run `gh auth login --web --git-protocol https` in a terminal). It
shows a one-time code and opens github.com; they paste the code and approve. Never ask for
their password or a token in chat, and never type one yourself. Then run
`gh auth setup-git` so git pushes with the same login.

## 4. Create the repository and push

In the card folder:

```sh
git init -b main
git add -A
git -c user.name="<full name>" -c user.email="<user>@users.noreply.github.com" commit -m "Publish my contact card"
gh repo create <repo-name> --public --source . --push --description "My contact card"
```

## 5. Turn on GitHub Pages

```sh
gh api -X POST repos/<user>/<repo-name>/pages -f "source[branch]=main" -f "source[path]=/"
```

A 409 "already exists" reply is fine (user sites switch on by themselves). Then wait for the
first build, checking every 15 seconds for up to five minutes:

```sh
gh api repos/<user>/<repo-name>/pages/builds/latest --jq .status
```

`built` means done; `errored` means read the error with `--jq .error.message`. Then confirm the
page itself answers: `curl -sI <SITE_URL>` should show `200`. A fresh site can take another
minute or two to appear even after `built`.

## Updating later

Edit the files, run `scripts/check.sh` again, then `git add -A`, `git commit -m "Update my card"`
and `git push`. Pages redeploys in about a minute.

## Optional: their own domain

If they own a domain and want the card on it (like `xav.contact`):

1. Add a file called `CNAME` in the card folder containing just the domain, push it, and run
   `gh api -X PUT repos/<user>/<repo-name>/pages -f cname=<domain>`.
2. At their domain provider they add DNS records. For a root domain (`name.com`): four `A`
   records to `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`. For
   a subdomain (`card.name.com`): one `CNAME` record to `<user>.github.io`. Walk them through
   their provider's screens; you cannot do this for them.
3. Once DNS works (minutes to hours), enforce HTTPS:
   `gh api -X PUT repos/<user>/<repo-name>/pages -F https_enforced=true`.
4. Change `SITE_URL` everywhere (canonical, og tags, JSON-LD, the QR `data-url`, `robots.txt`,
   `sitemap.xml`, `contact.vcf`) to `https://<domain>/` and push again.

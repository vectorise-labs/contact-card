# Publishing on GitHub Pages

The card is published from a public repository in the person's own GitHub account. GitHub Pages
hosts it free over HTTPS. Do each step yourself; stop only where the person must act.

## 1. A GitHub account

Ask whether they have one. If not, ask them to sign up at https://github.com/signup (free).
Before they do, tell them the username becomes part of the card's address
(`https://<username>.github.io/`), so a name-like one (`priyanair`) reads best. They will verify
their email and solve a puzzle; you cannot do this for them. Ask them to tell you the username.

## 2. The tools: git and GitHub CLI

Check `git --version` and `gh --version`. If either is missing:

- **Mac with Homebrew** (`brew --version` works): `brew install git gh`.
- **Mac without Homebrew:**
  - git: running `git --version` opens a macOS prompt. Ask them to click **Install** (not "Get
    Xcode", which is a 12GB download) and wait for it to finish.
  - gh: download the macOS `.pkg` from https://github.com/cli/cli/releases/latest (the file
    ending `macOS_universal.pkg`), open it with `open <file>`, and ask them to click through the
    installer. Then check `gh --version` again; if your shell still cannot find it, use
    `/usr/local/bin/gh`.
  - Do not install Homebrew without asking; it takes a while and needs their password.
- **Windows:** `winget install --id Git.Git -e` and `winget install --id GitHub.cli -e`, then
  start a new shell session so they are on the path.
- **Linux:** the package manager (`sudo apt install git gh`) or https://cli.github.com.

If installing is not possible, use "No-terminal route" at the end instead.

## 3. Log in

Check `gh auth status`. If they are logged in, confirm the account: `gh api user --jq .login`
must be the username they gave you. If it is someone else's (a work account, say), ask which
account to use before doing anything.

If they are not logged in, start the login yourself in the background so you can read its
output (it waits until they approve):

```sh
gh auth login --hostname github.com --git-protocol https --web
```

It prints a one-time code (like `ABCD-1234`) and opens, or asks them to open,
https://github.com/login/device. Give them the code and tell them: open that page, sign in,
paste the code, click Authorize. When the command finishes, run `gh auth setup-git` and check
`gh auth status` again.

If your tool cannot run a command in the background and show you its output while it waits, in
Claude Code ask them to type this into the chat box: `! gh auth login --hostname github.com --git-protocol https --web`.
Elsewhere, use "No-terminal route" rather than sending them to a terminal.

## Choose the address

Once logged in, with their username `<user>` (addresses are lowercase):

1. If `gh repo view <user>/<user>.github.io` fails with "Could not resolve", that name is free:
   the repository is `<user>.github.io` and the card lives at `https://<user>.github.io/`.
2. Otherwise use a repository named `contact-card` (or `card`, if `contact-card` exists already,
   for example from a fork of this kit). The card lives at `https://<user>.github.io/<repo>/`.

`SITE_URL` is that address, with the trailing slash.

## 4. Create the repository and push

In the card folder:

```sh
git init -b main
git add -A
email=$(gh api user --jq '"\(.id)+\(.login)@users.noreply.github.com"')
git -c user.name="<full name>" -c user.email="$email" commit -m "Publish my contact card"
gh repo create <repo> --public --source . --push --description "My contact card"
```

The no-reply email keeps their real address out of the public history.

## 5. Turn on GitHub Pages

```sh
gh api -X POST repos/<user>/<repo>/pages -f "source[branch]=main" -f "source[path]=/"
```

A 409 "already exists" reply is fine (user sites switch on by themselves). Then check every 15
seconds, for up to five minutes:

```sh
gh api repos/<user>/<repo>/pages/builds/latest --jq .status
```

A 404 before the first build has started means keep waiting. `built` means done; `errored`
means read `--jq .error.message`. Then confirm the page answers: `curl -sI <SITE_URL>` shows
`200`. A fresh site can take another minute or two after `built`; until then it shows a GitHub
404 page, so tell them that is expected.

## Updating later

Edit the files, run `scripts/check.sh` again, then `git add -A`, `git commit -m "Update my card"`,
`git push`. Pages redeploys in about a minute.

## Optional: their own domain

If they own a domain and want the card on it (like `xav.contact`):

1. Add a file called `CNAME` containing just the domain, push it, then run
   `gh api -X PUT repos/<user>/<repo>/pages -f cname=<domain>`.
2. They add DNS records at their domain provider; walk them through its screens. For a root
   domain (`name.com`): four `A` records to `185.199.108.153`, `185.199.109.153`,
   `185.199.110.153`, `185.199.111.153`. For a subdomain (`card.name.com`): one `CNAME` record to
   `<user>.github.io`.
3. Once DNS works (minutes to hours), turn on HTTPS:
   `gh api -X PUT repos/<user>/<repo>/pages -F https_enforced=true`. It fails until GitHub has
   issued the certificate; retry every few minutes.
4. Change `SITE_URL` everywhere (canonical, og and twitter tags, JSON-LD, the QR `data-url`,
   `robots.txt`, `sitemap.xml`, `contact.vcf`) to `https://<domain>/`, run `check.sh`, push.

## No-terminal route

When the tools cannot be installed or the login cannot be run, they can publish through the
GitHub website. Guide them one step at a time:

1. Open https://github.com/new. Repository name: `<user>.github.io` (or `contact-card`), Public,
   then **Create repository**.
2. On the new repository's page, click **uploading an existing file**. Open the card folder for
   them (`open ~/contact-card`, `start`, `xdg-open`), ask them to select everything inside it
   and drag it onto the page, then click **Commit changes**. Hidden files such as `.nojekyll`
   can be left out.
3. Open **Settings → Pages**. Under "Build and deployment", Source **Deploy from a branch**,
   Branch **main** and **/(root)**, then **Save**.
4. After a minute or two the address appears at the top of that page. Check it with
   `curl -sI <SITE_URL>` yourself.

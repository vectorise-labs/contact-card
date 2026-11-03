#!/bin/sh
# Checks a built contact card before it is published. POSIX sh plus grep, sed, od, find, wc.
# Usage: sh check.sh <card-folder>
# Exit 0 when every check passes; prints each failure otherwise.

dir="${1:-.}"
fail=0
ok() { printf '  ok    %s\n' "$1"; }
bad() { printf '  FAIL  %s\n' "$1"; fail=1; }

cd "$dir" 2>/dev/null || { echo "No such folder: $dir"; exit 2; }
echo "Checking $(pwd)"

for f in index.html styles.css contact.vcf favicon.svg apple-touch-icon.png og.jpg robots.txt sitemap.xml assets/card.js assets/qrcode.js .nojekyll; do
  [ -f "$f" ] && ok "$f exists" || bad "$f is missing"
done
[ -f index.html ] || { echo "Stopping: no index.html."; exit 1; }

# The page with HTML comments removed, joined onto one line, so attribute order and
# line breaks do not matter.
page=$(tr '\n\r' '  ' < index.html | sed 's/<!--[^>]*-->//g')
attr() { # attr <tag-match-regex> <attribute>: prints the attribute's value from the first matching tag
  printf '%s' "$page" | grep -Eo "<[a-z]+[^>]*$1[^>]*>" | head -1 | grep -Eo " $2=\"[^\"]*\"" | head -1 | sed 's/^[^"]*"//; s/"$//'
}

left=$(find . -type f \( -name '*.html' -o -name '*.css' -o -name '*.vcf' -o -name '*.svg' -o -name '*.txt' -o -name '*.xml' -o -name 'card.js' \) \
  ! -name 'QRCODE-LICENSE.txt' -exec grep -l '{{' {} + 2>/dev/null)
[ -z "$left" ] && ok "no {{PLACEHOLDERS}} left" || bad "placeholders left in: $(echo $left)"

canon=$(attr 'rel="canonical"' href)
qrurl=$(attr 'class="qr"' data-url)
case "$canon" in https://*/) ok "canonical URL is $canon" ;; *) bad "canonical URL must be https and end with / (got '$canon')" ;; esac
[ -n "$qrurl" ] && [ "$qrurl" = "$canon" ] && ok "QR points at the canonical URL" || bad "QR data-url '$qrurl' does not match canonical '$canon'"
ogurl=$(attr 'property="og:url"' content)
[ "$ogurl" = "$canon" ] && ok "og:url matches" || bad "og:url '$ogurl' does not match canonical"
if [ -n "$canon" ]; then
  grep -qF "$canon" sitemap.xml 2>/dev/null && ok "sitemap.xml uses the site URL" || bad "sitemap.xml does not contain $canon"
  grep -qF "$canon" robots.txt 2>/dev/null && ok "robots.txt uses the site URL" || bad "robots.txt does not contain $canon"
  grep -qF "$canon" contact.vcf 2>/dev/null && ok "contact.vcf links the card" || bad "contact.vcf does not contain $canon"
fi
ogimg=$(attr 'property="og:image"' content)
case "$ogimg" in "$canon"?*) f="${ogimg#"$canon"}"; [ -f "$f" ] && ok "og:image $f exists" || bad "og:image file '$f' is missing" ;; *) bad "og:image must be a file on this site (got '$ogimg')" ;; esac

printf '%s' "$page" | grep -q 'name="viewport"' && ok "viewport meta present" || bad "viewport meta missing"

# Third-party resources: anything the browser fetches automatically from another host.
ext=$(printf '%s' "$page" | grep -Eio "<(script|img|iframe|source|video|audio|embed)[^>]*(src|srcset)=['\"]?(https?:)?//[^ >]*" ; \
      printf '%s' "$page" | grep -Eio "<link[^>]*>" | grep -Eiv 'rel="(canonical|me|alternate|sitemap)"' | grep -Eio "href=['\"]?(https?:)?//[^ >]*")
css=$(cat styles.css 2>/dev/null; printf '%s' "$page" | grep -Eio '<style[^>]*>.*</style>')
ext_css=$(printf '%s' "$css" | grep -Eio "(url\( *['\"]?(https?:)?//[^)]*|@import[^;]*)")
[ -z "$ext$ext_css" ] && ok "no third-party scripts, styles, fonts or images" || bad "external resources (download them into the site): $(echo $ext $ext_css)"

for font in $(printf '%s' "$css" | grep -Eo "url\( *['\"]?[^)'\"]*\.(woff2|woff|ttf|otf)" | sed "s/url( *['\"]*//"); do
  [ -f "$font" ] && ok "font $font exists" || bad "font $font is referenced but missing"
done

size=$(wc -c < styles.css | tr -d ' ')
[ "$size" -gt 2000 ] && ok "styles.css written ($size bytes)" || bad "styles.css looks unwritten ($size bytes)"

# vCard: structure, CRLF on every line including the last, no blank lines.
first=$(head -1 contact.vcf | tr -d '\r')
last=$(tail -1 contact.vcf | tr -d '\r')
[ "$first" = "BEGIN:VCARD" ] && [ "$last" = "END:VCARD" ] && ok "contact.vcf is a vCard" || bad "contact.vcf must start BEGIN:VCARD and end END:VCARD with no blank lines after"
grep -q '^FN:' contact.vcf && grep -q '^N:' contact.vcf && ok "contact.vcf has a name" || bad "contact.vcf needs FN and N lines"
lines=$(wc -l < contact.vcf | tr -d ' ')
crlf=$(grep -c "$(printf '\r')\$" contact.vcf)
endcr=$(tail -c 2 contact.vcf | od -An -tx1 | tr -d ' \n')
[ "$lines" = "$crlf" ] && [ "$endcr" = "0d0a" ] && ok "contact.vcf uses CRLF line endings" || bad "contact.vcf needs CRLF on every line, including the last"

# Images: present, alt text on each, small, and no GPS location data.
imgs=$(printf '%s' "$page" | grep -Eo '<img[^>]*>')
noalt=$(printf '%s\n' "$imgs" | grep -v 'alt="[^"][^"]*"' | grep -c '<img')
[ "$noalt" = 0 ] && ok "every image has alt text" || bad "$noalt image(s) have no alt text"
for img in $( (printf '%s\n' "$imgs" | grep -Eo ' src="[^"]+"' | sed 's/^ src="//; s/"$//'; printf '%s\n' "${ogimg#"$canon"}") | sort -u); do
  [ -f "$img" ] || { bad "image $img is referenced but missing"; continue; }
  kb=$(( $(wc -c < "$img") / 1024 ))
  [ "$kb" -le 400 ] && ok "$img is ${kb}KB" || bad "$img is ${kb}KB; compress it under 400KB"
done
gps=0
for img in $(find . -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.heic' -o -iname '*.tif*' \)); do
  if head -c 131072 "$img" | od -An -tx1 | tr -d ' \n' | grep -Eq '88250004|25880400'; then
    bad "$img contains GPS location data; strip it (see SKILL.md, the photo step)"; gps=1
  fi
done
[ "$gps" = 0 ] && ok "no GPS location data in images"

[ "$fail" = 0 ] && echo "All checks passed." || echo "Fix the failures above, then run this again."
exit "$fail"

#!/bin/sh
# Checks a built contact card before it is deployed. POSIX sh, grep and wc only.
# Usage: sh check.sh <card-folder>
# Exit 0 when every check passes; prints each failure otherwise.

dir="${1:-.}"
fail=0
ok() { printf '  ok    %s\n' "$1"; }
bad() { printf '  FAIL  %s\n' "$1"; fail=1; }

cd "$dir" 2>/dev/null || { echo "No such folder: $dir"; exit 2; }
echo "Checking $(pwd)"

for f in index.html styles.css contact.vcf favicon.svg assets/card.js assets/qrcode.js .nojekyll; do
  [ -f "$f" ] && ok "$f exists" || bad "$f is missing"
done

left=$(grep -rln '{{' --include='*.html' --include='*.css' --include='*.vcf' --include='*.svg' --include='*.txt' --include='*.xml' --include='*.js' . 2>/dev/null)
[ -z "$left" ] && ok "no {{PLACEHOLDERS}} left" || bad "placeholders left in: $(echo $left)"

canon=$(grep -o '<link rel="canonical" href="[^"]*"' index.html | sed 's/.*href="//; s/"$//')
qrurl=$(grep -o 'class="qr" data-url="[^"]*"' index.html | sed 's/.*data-url="//; s/"$//')
case "$canon" in https://*/) ok "canonical URL is $canon" ;; *) bad "canonical URL must be https and end with / (got '$canon')" ;; esac
[ -n "$qrurl" ] && [ "$qrurl" = "$canon" ] && ok "QR points at the canonical URL" || bad "QR data-url '$qrurl' does not match canonical '$canon'"

grep -q 'name="viewport"' index.html && ok "viewport meta present" || bad "viewport meta missing"

ext=$(grep -Eno '(<script[^>]+src|<link[^>]+href|<img[^>]+src)="(https?:)?//[^"]*"' index.html | grep -v 'rel="canonical"\|rel="me"' )
ext_css=$(grep -Eno "(url\(['\"]?(https?:)?//|@import)" styles.css)
[ -z "$ext$ext_css" ] && ok "no third-party scripts, styles, fonts or images" || bad "external resources found (vendor them locally): $ext $ext_css"

size=$(wc -c < styles.css | tr -d ' ')
[ "$size" -gt 2000 ] && ok "styles.css written ($size bytes)" || bad "styles.css looks unwritten ($size bytes)"

head -1 contact.vcf | grep -q 'BEGIN:VCARD' && tail -1 contact.vcf | grep -q 'END:VCARD' && ok "contact.vcf is a vCard" || bad "contact.vcf must start BEGIN:VCARD and end END:VCARD"
lines=$(wc -l < contact.vcf | tr -d ' ')
crlf=$(grep -c "$(printf '\r')\$" contact.vcf)
[ "$lines" = "$crlf" ] && ok "contact.vcf uses CRLF line endings" || bad "contact.vcf needs CRLF line endings ($crlf of $lines lines)"

for img in $(grep -Eo '<img[^>]+src="[^"]+"' index.html | sed 's/.*src="//; s/"$//'); do
  if [ -f "$img" ]; then
    kb=$(( $(wc -c < "$img") / 1024 ))
    [ "$kb" -le 400 ] && ok "$img is ${kb}KB" || bad "$img is ${kb}KB; compress it under 400KB"
  else
    bad "image $img is referenced but missing"
  fi
done
grep -Eq '<img[^>]+alt="[^"]+"' index.html && ok "images have alt text" || bad "add alt text to the photo"

[ "$fail" = 0 ] && echo "All checks passed." || echo "Fix the failures above, then run this again."
exit "$fail"

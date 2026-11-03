#!/data/data/com.termux/files/usr/bin/sh
# Wait for the latest GitHub Actions build and install the APK, on the phone.
# No AI / no session needed: this script does the waiting locally.
#
# Prerequisites (run once in Termux):
#   pkg install curl termux-api
#   termux-setup-storage
#   (also install the "Termux:API" app so termux-open works)
#
# Usage:
#   sh fetch-apk.sh <owner>/<repo>
# Example:
#   sh fetch-apk.sh myuser/helloapp

set -e

REPO="${1:?usage: fetch-apk.sh <owner>/<repo>}"
API="https://api.github.com/repos/$REPO/releases/tags/latest"
OUT="$HOME/storage/downloads/helloapp-debug.apk"
mkdir -p "$(dirname "$OUT")"

echo "Waiting for release 'latest' on $REPO ..."
while :; do
  url=$(curl -fsSL "$API" 2>/dev/null \
    | grep -o '"browser_download_url"[^,]*' \
    | grep 'app-debug.apk' \
    | sed 's/.*"\(https[^"]*\)"/\1/' \
    | head -1)
  if [ -n "$url" ]; then
    echo "Found: $url"
    curl -fL "$url" -o "$OUT"
    echo "Saved: $OUT"
    termux-open "$OUT"
    break
  fi
  echo "Not ready yet, retry in 20s ..."
  sleep 20
done

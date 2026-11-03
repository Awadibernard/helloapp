#!/data/data/com.termux/files/usr/bin/sh
# Init + push the helloapp project to your GitHub repo (Termux).
# Usage:  sh push.sh <github_user> <repo_name> [dir]
#
# Before first use:
#   - create an EMPTY repo on GitHub (no README, no .gitignore)
#   - have a Personal Access Token (classic, scope "repo") ready
set -e

GH_USER="${1:?usage: push.sh <github_user> <repo_name> [dir]}"
GH_REPO="${2:?usage: push.sh <github_user> <repo_name> [dir]}"
DIR="${3:-$HOME/storage/shared/helloapp}"

cd "$DIR"
echo "Dossier: $(pwd)"

# /sdcard is owned by another uid, so git 2.35+ refuses it as "dubious
# ownership". Trust the real and the symlinked path before any git command.
git config --global --add safe.directory "$(pwd)"    2>/dev/null || true
git config --global --add safe.directory "$(pwd -P)" 2>/dev/null || true

if [ ! -d .git ]; then
  echo "-> git init"
  git init
fi
git branch -M main

if [ -z "$(git config --get user.email 2>/dev/null)" ]; then
  printf "Ton nom  : "; read -r NAME
  printf "Ton email: "; read -r EMAIL
  git config user.name  "$NAME"
  git config user.email "$EMAIL"
fi

echo "-> git add + commit"
git add -A
git commit -m "Update from phone $(date +%F_%H%M)" || echo "(rien de nouveau a committer)"

URL="https://github.com/$GH_USER/$GH_REPO.git"
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$URL"
else
  git remote add origin "$URL"
fi

echo
echo "Push vers $URL"
echo "  Username = ton user GitHub"
echo "  Password = ton PAT (l'ecran n'affiche rien pendant la saisie)"
git push -u origin main
echo "Termine. La CI GitHub Actions demarre automatiquement."

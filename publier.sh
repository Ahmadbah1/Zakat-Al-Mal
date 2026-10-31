#!/usr/bin/env bash
# Publie le dossier courant sur un dépôt GitHub existant.
# Usage : bash publier.sh https://github.com/<compte>/zakat-al-mal.git
set -euo pipefail
REMOTE="${1:-}"
if [ -z "$REMOTE" ]; then
  echo "Usage : bash publier.sh https://github.com/<compte>/zakat-al-mal.git" >&2
  exit 1
fi
git init -q 2>/dev/null || true
git branch -M main
git add -A
git -c user.name="${GIT_AUTHOR_NAME:-Zakat Al Mal}" \
    -c user.email="${GIT_AUTHOR_EMAIL:-zakat@localhost}" \
    commit -m "Zakat Al Mal 5.0 — application autonome, FR/EN/AR" || echo "(rien de nouveau à valider)"
git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE"
git push -u origin main
echo
echo "Dépôt publié. Activez maintenant GitHub Pages :"
echo "  Settings → Pages → Source: Deploy from a branch → Branch: main → Folder: / (root)"

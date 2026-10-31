#!/usr/bin/env bash
# Crée le dépôt GitHub « zakat-al-mal » et y pousse ce dossier, puis active GitHub Pages.
#
#   bash creer-depot.sh
#
# Le jeton n'est jamais enregistré : il est lu sans écho, utilisé pour l'appel à l'API et pour
# ce seul « git push », puis retiré de la configuration du dépôt.
#
# Jeton requis : « Fine-grained token » avec, sur les dépôts du compte :
#   - Contents            : Read and write
#   - Administration      : Read and write   (création du dépôt)
#   - Pages               : Read and write   (activation de Pages, facultatif)
# Ou, plus simple : un jeton classique avec la seule portée « repo ».
set -euo pipefail

REPO="zakat-al-mal"
DESC="Calcul et registre de zakat conformes AAOIFI n°35 — FR / EN / AR, hors ligne, export Excel."
BRANCH="main"

if [ -n "${GITHUB_TOKEN:-}" ] && [ -n "${GITHUB_USER:-}" ]; then
  USER_NAME="$GITHUB_USER"; TOKEN="$GITHUB_TOKEN"
else
  read -r -p "Nom d'utilisateur GitHub : " USER_NAME
  if [ -z "$USER_NAME" ]; then echo "Nom d'utilisateur requis." >&2; exit 1; fi
  read -r -s -p "Jeton d'accès personnel (saisie masquée) : " TOKEN; echo
  if [ -z "$TOKEN" ]; then echo "Jeton requis." >&2; exit 1; fi
fi

api() { # api METHOD PATH [DATA]
  local method="$1" path="$2" data="${3:-}"
  if [ -n "$data" ]; then
    curl -sS -X "$method" -H "Authorization: Bearer $TOKEN" \
      -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" \
      -H "Content-Type: application/json" -d "$data" "https://api.github.com$path"
  else
    curl -sS -X "$method" -H "Authorization: Bearer $TOKEN" \
      -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" \
      "https://api.github.com$path"
  fi
}

echo "→ Vérification du jeton…"
WHO=$(api GET /user | sed -n 's/.*"login": *"\([^"]*\)".*/\1/p')
if [ -z "$WHO" ]; then
  echo "Jeton invalide ou expiré." >&2; exit 1
fi
echo "  connecté : $WHO"
USER_NAME="$WHO"

echo "→ Création du dépôt $USER_NAME/$REPO…"
RESP=$(api POST /user/repos "{\"name\":\"$REPO\",\"description\":\"$DESC\",\"private\":false,\"has_issues\":true,\"has_wiki\":false,\"has_projects\":false}")
if echo "$RESP" | grep -q '"full_name"'; then
  echo "  dépôt créé."
elif echo "$RESP" | grep -q 'name already exists'; then
  echo "  le dépôt existe déjà : poursuite avec le dépôt existant."
else
  echo "  échec : $RESP" >&2; exit 1
fi

echo "→ Validation et envoi du contenu…"
git init -q 2>/dev/null || true
git branch -M "$BRANCH"
git add -A
git -c user.name="$USER_NAME" -c user.email="$USER_NAME@users.noreply.github.com" \
    commit -m "Zakat Al Mal 5.0 — application autonome, FR/EN/AR" >/dev/null 2>&1 || echo "  (contenu déjà validé)"
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/$USER_NAME/$REPO.git"
git -c credential.helper= push -q "https://$USER_NAME:$TOKEN@github.com/$USER_NAME/$REPO.git" "HEAD:$BRANCH" --force
echo "  contenu envoyé sur la branche $BRANCH."

echo "→ Activation de GitHub Pages…"
PAGES=$(api POST "/repos/$USER_NAME/$REPO/pages" "{\"source\":{\"branch\":\"$BRANCH\",\"path\":\"/\"}}")
if echo "$PAGES" | grep -q '"status"\|"html_url"'; then
  echo "  Pages activé."
else
  api PUT "/repos/$USER_NAME/$REPO/pages" "{\"source\":{\"branch\":\"$BRANCH\",\"path\":\"/\"}}" >/dev/null 2>&1 || true
  echo "  à confirmer manuellement : Settings → Pages → Deploy from a branch → $BRANCH → / (root)."
fi

echo
echo "Dépôt :  https://github.com/$USER_NAME/$REPO"
echo "Site  :  https://$USER_NAME.github.io/$REPO/   (compter une à deux minutes)"
echo
echo "Pensez à révoquer le jeton : https://github.com/settings/tokens"

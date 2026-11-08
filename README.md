# Zakat Al Mal

**Calcul et registre de zakat, conformes à la norme AAOIFI n°35.**
Application autonome d'un seul fichier, en français, anglais et arabe — cours du marché en direct,
accès par code PIN ou empreinte digitale, export Excel dynamique, visite guidée et cadre juridique intégré.

> زكاة المال — حساب الزكاة وسجلها وفق معيار أيوفي رقم 35، بالفرنسية والإنجليزية والعربية.
>
> Zakat Al Mal — zakat calculation and register compliant with AAOIFI Standard No. 35, in French, English and Arabic.

---

## Version 5.2.1 — lisibilité des montants

Les champs de saisie groupent les chiffres par trois avec une espace insécable (`5 000 000`), le
curseur reste à sa place pendant la frappe et le séparateur décimal suit la langue. La saisie sans
séparateur reste acceptée.

## Version 5.2.0 — ce qui est nouveau

- **Calcul** : seuil argent proposé par défaut (avec explication et bascule en un clic), école
  hanbalite, convertisseur tola / once troy, cinq devises (EUR, USD, GBP, CAD, NGN) avec taux du
  marché, crypto-actifs en direct (BTC, ETH, USDT), règle de prudence sur les dettes.
- **Foyer** : plusieurs membres, chacun avec son propre nissab et sa propre zakat, additionnés au total.
- **Agriculture** : zakat des récoltes (nissab 653 kg, 10 % / 5 %) et zakat du cheptel en têtes,
  avec fiche de comptage imprimable.
- **Rapidité** : calcul express en 60 secondes, fiche bénéficiaire (Orange Money / MTN MoMo),
  reçu partageable, graphique annuel du registre.
- **Sécurité** : chiffrement optionnel du stockage local (AES-GCM 256, PBKDF2 150 000 itérations)
  avec phrase secrète demandée au démarrage ; conservation permanente demandée au navigateur.
- **Rappels** : notification locale sept jours avant l'échéance du hawl puis le jour même.
- **Référencement** : `og-image.png`, données structurées `WebApplication`, `hreflang` fr / en / ar.
- Documents juridiques en **version 1.1** (chiffrement, notifications, membres du foyer, fiches bénéficiaires).

## Aperçu

| | |
|---|---|
| **Stack** | HTML, CSS et JavaScript natifs. Aucune dépendance, aucun build, aucun serveur. |
| **Poids** | un seul fichier `index.html` (~700 Ko), images et polices comprises |
| **Langues** | français, anglais, arabe (RTL) — 570 clés par langue |
| **Thème** | clair, sombre, automatique |
| **Données** | stockage local du navigateur uniquement, export/import JSON |
| **Hors ligne** | oui, service worker (`sw.js`) et manifeste PWA |

### Fonctions principales

- Calcul de la zakat : liquidités, devises, métaux précieux avec conversion par carat, commerce et
  investissements, dettes exigibles, cycle du hawl (354 / 365 jours), nissab or 85 g ou argent 595 g.
- Écoles malikite, hanafite, chaféite et hanbalite.
- Cours de l'or, de l'argent et du dollar récupérés en direct, convertis en francs CFA, et **toujours
  modifiables à la main**.
- Versements, reçus numérotés, carnet des bénéficiaires, attestation, clôture d'exercice.
- Documents imprimables A4 et classeur `.xlsx` de quatre feuilles avec formules.
- Accès par code PIN (SHA-256 salé) ou empreinte digitale (WebAuthn), sans code par défaut.
- Visite guidée en douze étapes, FAQ de quatorze questions, conditions d'utilisation, politique de
  confidentialité, mentions légales et avertissements.

## Structure

```
.
├── index.html              # application complète (HTML + CSS + JS + images en base64)
├── manifest.webmanifest    # manifeste PWA
├── sw.js                   # service worker (coque hors ligne)
├── 404.html                # page de repli pour l'hébergement statique
├── assets/
│   ├── icon-192.png
│   ├── icon-512.png
│   └── emblem_300.png
├── creer-depot.sh          # création du dépôt + envoi + activation de Pages
├── publier.sh              # envoi vers un dépôt déjà existant
├── LICENSE.md
└── .nojekyll
```

## Création du dépôt en une commande

```bash
bash creer-depot.sh
```

Le script demande le nom d'utilisateur et un jeton d'accès personnel (saisie masquée), crée le
dépôt public **zakat-al-mal**, envoie le contenu sur `main` et active GitHub Pages. Le jeton n'est
jamais écrit sur le disque ni conservé dans la configuration Git.

Jeton conseillé : *fine-grained*, avec **Contents: read and write**, **Administration: read and write**
et, pour l'activation automatique de Pages, **Pages: read and write**. Un jeton classique avec la
seule portée `repo` suffit également. Révoquez-le après usage : `https://github.com/settings/tokens`.

Pour un fonctionnement sans interaction (CI, script personnel) :

```bash
GITHUB_USER=moncompte GITHUB_TOKEN=**** bash creer-depot.sh
```

## Publication manuelle sur GitHub Pages

```bash
git init
git branch -M main
git add .
git commit -m "Zakat Al Mal 5.2.0 — application autonome, FR/EN/AR"
git remote add origin https://github.com/<votre-compte>/zakat-al-mal.git
git push -u origin main
```

Puis, dans **Settings → Pages** : *Source* = `Deploy from a branch`, *Branch* = `main`, *Folder* = `/ (root)`.
Le site est publié à l'adresse `https://<votre-compte>.github.io/zakat-al-mal/`.

Le fichier `.nojekyll` est indispensable : sans lui, GitHub Pages ignorerait certains fichiers
commençant par un souligné et ralentirait la publication.

### Bonnes pratiques

- **HTTPS obligatoire** pour l'empreinte digitale (WebAuthn) : GitHub Pages le fournit d'office.
- Le service worker met en cache la coque applicative : après une mise à jour, incrémentez `CACHE`
  dans `sw.js` (par exemple `zakat-al-mal-v6`) pour forcer le renouvellement.
- Les cours de l'or et de l'argent proviennent d'interfaces publiques (`gold-api.com`,
  `open.er-api.com`) : si votre marché local diffère, saisissez les prix à la main, l'application
  bascule alors en mode manuel.

## Données et vie privée

Aucun compte, aucun serveur, aucune mesure d'audience, aucun cookie. Les saisies restent dans le
stockage local du navigateur ; l'utilisateur peut les exporter en JSON ou les effacer à tout moment.
Seule communication sortante : l'appel aux interfaces publiques de cotation, qui ne transporte
aucune donnée de patrimoine.

## Avertissement

Outil d'aide à la décision conforme à la norme AAOIFI n°35. Il ne constitue ni une fetwa, ni un
avis juridique, fiscal ou comptable. Vérifiez les cours retenus et la règle applicable à votre
situation avant tout versement. Voir les onglets « Conditions d'utilisation » et « Avertissements »
intégrés à l'application.

## Version

5.2.0 — documents juridiques révisés le 31 octobre 2026 (version 1.1).

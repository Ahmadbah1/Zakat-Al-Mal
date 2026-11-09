# Mettre Zakat Al Mal en ligne sur GitHub — guide manuel

Tout ce qui est nécessaire se trouve dans ce dossier. Aucune ligne de commande n'est requise :
comptez cinq minutes, dont deux de téléversement.

---

## 1. Créer le dépôt

1. Ouvrez **https://github.com/new**
2. **Repository name** : `zakat-al-mal`
3. **Description** (facultatif) : `Calcul et registre de zakat conformes AAOIFI n°35 — FR / EN / AR`
4. Cochez **Public**
5. Ne cochez **aucune** des cases « Add a README file », « Add .gitignore », « Choose a license » :
   ces fichiers sont déjà dans ce dossier et seraient en conflit.
6. Cliquez **Create repository**.

## 2. Téléverser le contenu

1. Sur la page du dépôt vide, cliquez sur le lien **uploading an existing file**
   (ou : *Add file → Upload files*).
2. Ouvrez ce dossier dans votre explorateur de fichiers, **sélectionnez tout** son contenu :

   ```
   index.html
   manifest.webmanifest
   sw.js
   404.html
   og-image.png       (image de partage pour les réseaux)
   assets/            (dossier, avec ses 3 images)
   README.md
   LICENSE.md
   COMMENCER-ICI.md
   .gitignore
   .nojekyll
   creer-depot.sh     (facultatif)
   publier.sh         (facultatif)
   ```

   puis glissez-déposez dans la page GitHub.

   > **Important** : glissez le **contenu** du dossier, pas le dossier lui-même.
   > `index.html` doit se retrouver à la racine du dépôt, pas dans un sous-dossier.

3. Dans le champ du message de validation, écrivez :
   `Zakat Al Mal 5.2.0 — application autonome, FR/EN/AR`
4. Cliquez **Commit changes**.

### Le fichier `.nojekyll`

Les fichiers commençant par un point sont parfois ignorés par l'explorateur de fichiers
(macOS notamment). Vérifiez sa présence à la racine du dépôt sur GitHub. S'il manque :

*Add file → Create new file*, nommez-le exactement `.nojekyll`, laissez le contenu **vide**,
puis *Commit changes*.

Ce fichier empêche GitHub de faire passer le site par Jekyll ; il n'est pas indispensable ici,
mais il évite des lenteurs et des surprises.

## 3. Activer GitHub Pages

1. Dans le dépôt : **Settings** (onglet du haut)
2. Menu de gauche : **Pages**
3. **Source** : `Deploy from a branch`
4. **Branch** : `main` — **Folder** : `/ (root)`
5. **Save**

Attendez une à deux minutes, puis rechargez la page : l'adresse s'affiche en haut de la section.

```
https://<votre-compte>.github.io/zakat-al-mal/
```

## 4. Vérifier

- L'écran « Avant de commencer » apparaît, avec la case à cocher et les liens juridiques.
- Après acceptation, le choix entre **code PIN** et **empreinte digitale** s'affiche.
- En haut à droite, l'icône d'aide ouvre la FAQ et la visite guidée.
- Les cours de l'or et de l'argent se mettent à jour si le réseau est disponible ; sinon,
  l'application affiche « mode manuel » et tout le reste fonctionne.
- L'empreinte digitale exige **HTTPS** : c'est le cas sur GitHub Pages. En `http://` ou en ouvrant
  le fichier directement, elle est désactivée avec explication — le code PIN reste disponible.

## Mettre à jour le site plus tard

1. Remplacez `index.html` par la nouvelle version (*Add file → Upload files*).
2. Incrémentez la ligne `const CACHE = "zakat-al-mal-v5";` dans `sw.js`
   (par exemple `v6`), sinon les navigateurs continuent d'afficher l'ancienne version en cache.
3. *Commit changes*, puis rechargez le site en forçant le rafraîchissement (`Ctrl+Maj+R`).

## En cas de problème

| Symptôme | Cause probable | Solution |
|---|---|---|
| Page 404 à la racine | `index.html` est dans un sous-dossier | Déplacez-le à la racine du dépôt |
| Page blanche, aucune mise en forme | Le fichier a été ouvert depuis un sous-dossier | Vérifiez l'arborescence : `index.html` au premier niveau |
| Ancienne version affichée | Service worker en cache | Incrémentez `CACHE` dans `sw.js`, puis `Ctrl+Maj+R` |
| Pas de cours en direct | Réseau bloqué ou API indisponible | Saisissez les prix à la main, l'application passe en mode manuel |
| Empreinte proposée mais inutilisable | Contexte non sécurisé (`http://`, fichier local) | Utilisez l'adresse `https://` de GitHub Pages |
| Les icônes ou le manifeste manquent | Dossier `assets` non téléversé | *Add file → Upload files*, glissez le dossier `assets` complet |

## Alternatives

- **Dépôt par archive** : `zakat-al-mal-site.zip` (fourni à côté de ce dossier) peut être décompressé
  puis déposé de la même manière, ou envoyé tel quel à GitHub pour inspection.
- **Ligne de commande** : `bash creer-depot.sh` crée le dépôt, envoie le contenu et active Pages ;
  `bash publier.sh <url-du-dépôt>` se contente de l'envoi.

---

*Zakat Al Mal 5.4.0 — documents juridiques révisés le 31 octobre 2026 (version 1.1).*

---

## Version 5.4.0 — à savoir avant de publier

- **Épargne longue : le mode par défaut est « non compté ».** C'est la position prudente (un droit
  futur n'est pas un bien en main). Si votre public suit l'avis opposé, réglez-le une fois : les
  champs restent enregistrés.
- **Plan de paiement** : il ne crée pas de versement. Il calcule un calendrier à partir de la zakat
  due et coche les échéances au fur et à mesure que vous enregistrez de vrais versements. Un
  échéancier `.ics` peut être importé dans Google Agenda, Apple Calendrier ou Outlook.
- **Répartition** : les parts sont un outil de préparation, pas une obligation religieuse. La fiche
  imprimée le rappelle explicitement.

## Version 5.3.0 — à savoir avant de publier

- **Deux nouveaux écrans** : le simulateur (dernière carte de l'onglet Calcul) et « Mon évolution »
  (haut de l'onglet Registre, avant le graphique annuel). Rien à configurer.
- **Le simulateur n'écrit jamais** : il travaille sur des copies des réglages et des champs. Vos
  chiffres, votre registre et vos sauvegardes restent intacts pendant la manipulation.
- **Le tableau de bord a besoin d'un exercice clos** pour afficher une variation : la première
  année, il montre l'assiette courante et la composition, sans comparaison inventée.

## Version 5.2.2 — à savoir avant de publier

- **Textes arabes relus** : les 734 chaînes arabes et les documents juridiques arabes ont été
  relus et corrigés (nissab, hawl, vocabulaire, tanwīn, séparateurs décimaux). Faites tout de même
  relire la couche religieuse — nissab, hawl, taux, avis par école — par une personne qualifiée
  avant publication : aucun logiciel ne remplace cet avis.
- **Code PIN** : aucun code par défaut n'existe. L'ancien texte d'aide mentionnait `1234` ; il a
  été corrigé dans les trois langues.


- **Image de partage** : `og-image.png` est déjà à la racine. Si votre site est à une adresse du type
  `https://votrenom.github.io/zakat-al-mal/`, remplacez dans `index.html` les deux lignes
  `<meta property="og:image" content="og-image.png">` et `<meta name="twitter:image" ...>` par
  l'adresse complète (`https://votrenom.github.io/zakat-al-mal/og-image.png`) : certains réseaux
  exigent une adresse absolue.
- **Chiffrement sur l'appareil** (réglages → « Chiffrer maintenant ») : demandez à vos testeurs de
  noter leur phrase secrète. Sans elle, les données sont définitivement illisibles ; c'est le prix
  de la protection.
- **Rappels du hawl** : ils fonctionnent sans serveur, mais seulement quand l'application est
  ouverte (le navigateur ne réveille pas une application fermée sans service de push). Le bouton
  « Tester » vérifie que l'autorisation est bien accordée.
- **Service worker** : le cache passe en `zakat-al-mal-v10`. À la première visite après mise à jour,
  rechargez une fois la page pour que la nouvelle version soit prise en compte.

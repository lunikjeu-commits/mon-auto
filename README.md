# Mon Auto — application Android

Application native Android en Kotlin + Jetpack Compose pour suivre l'entretien et les dépenses d'un véhicule.

## Fonctionnalités incluses dans cette première version
- Fiche véhicule : marque, modèle, motorisation, année, kilométrage, prix et date d'achat.
- Enregistrement d'interventions : date, kilométrage, catégorie, coût des pièces, main-d'œuvre et notes.
- Historique des interventions avec suppression.
- Tableau de bord : dépenses d'entretien, nombre d'interventions, prix d'achat et coût global.
- Stockage local sur le téléphone (SharedPreferences), sans compte et sans connexion nécessaire.

## Générer l'APK avec GitHub Actions
1. Crée un dépôt GitHub nommé `MonAuto`.
2. Décompresse ce projet et envoie tous les fichiers à la racine du dépôt (y compris le dossier `.github`).
3. Dans GitHub, ouvre l'onglet **Actions** et autorise les workflows si GitHub le demande.
4. Le workflow démarre après un push sur `main`. Tu peux aussi le lancer manuellement avec **Build Mon Auto APK** puis **Run workflow**.
5. Ouvre l'exécution terminée, descends à **Artifacts**, puis télécharge `Mon-Auto-debug-apk`.
6. Décompresse l'archive téléchargée : tu trouveras `app-debug.apk`. Transfère-le sur ton Android et installe-le.

## Compilation locale
Prérequis : JDK 17 et Gradle 8.9.
À la racine du projet :
```bash
gradle :app:assembleDebug
```
APK produit : `app/build/outputs/apk/debug/app-debug.apk`.

## À savoir
Cette version est une base fonctionnelle (MVP). Les données restent sur le téléphone et ne sont pas synchronisées. L'APK debug est destiné aux tests et à l'installation personnelle. Avant une publication Play Store, il faudra notamment produire une version release signée et compléter les tests.

## Évolutions recommandées
- Inventaire détaillé des pièces (référence, fournisseur, quantité, prix unitaire, lien facture).
- Rappels automatiques de vidange et d'entretien par date et kilométrage.
- Plusieurs véhicules.
- Export PDF/CSV et sauvegarde/restauration.
- Graphiques de dépenses et coût au kilomètre.

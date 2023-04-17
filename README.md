# Smart Mailbox
## Un projet informatique individuel de l'ENSC par Thomas Achard

Ce document a pour objectif de présenter les différentes procédures d'installation possibles afin de voir le code et de tester le projet. Il ne contiendra pas d'informations sur son fonctionnement (qui fera l'objet du rapport de synthèse).

## Contenu du repository

Il contient 2 dossiers :
- Un dossier *Arduino* avec le code sur l'ESP32, donc le dispositif physique.
- Un dossier *Flutter* avec le code de l'application pour téléphone.

Ce dossier *Flutter* dispose de beaucoup de dossiers utilisés pour la compilation. Les fichiers réellement modifiés sont :
- */android/app/build.gradle* pour permettre l'utilisation de plugins sur Android.
- Le dossier */lib/* contient tous les fichiers propres au projet.

## Récupération du code

### Clonage du repository

Afin de récupérer le repository, il est nécessaire d'[installer Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). Une fois isntallé, ouvrez un terminal de commandes (sous Windows ou dans un IDE comme Visual Studio Code) et lancez les commande suivante :
```
cd [chemin vers le dossier que vous voulez]
git clone [insérer le lien]
```
### Ouverture du projet d'application

Ouvrez ensuite le dossier dans Visual Studio Code.
Dans Visual Studio Code, installez aussi l'extension **Flutter**.
Vous disposez alos de quoi lire le projet d'application mobile.

Le projet est versionné par Git. Il dispose de 2 branches :
- *master* qui contient le code de l'application nécessitant un ESP32.
- *test* qui contient le code l'application modifié, permettant de simuler l'ESP32 sans nécessairement en avoir un.

### Lancement du projet

Afin de pouvoir lancer le projet, il faut préalablement installer le SDK Flutter dont le mode d'emploi est [ici](https://docs.flutter.dev/get-started/install).
Pour lancer le projet, je recommande d'utiliser un émulateur Android ou son propre téléphone, le tutoriel est disponible [ici (partie *Run the app*)](https://docs.flutter.dev/get-started/test-drive?tab=vscode). Autrement, il est possible d'installer directemnt les exécutables sur son téléphone.

## Installations sur le téléphone

L'objectif est d'installer l'un des exécutables présents [ici](lien vers releases). Pour chaque OS (Android ou iOS), il existe 2 exécutables :
- Celle suffixée par test, prévue pour simuler sur le téléphone la présence du dispositif physique
- Celle sans suffixe, prévue pour fonctionner avec l'ESP32 du dispositif physique.

Dans la suite sera détaillée la procédure d'installation pour chaque OS.

### Android

Téléchargez l'exécutable en .apk dans l'onglet Releases du projet.

Allez dans votre application de gestion des fichiers et lancez l'exécutable. Normalement, l'appareil vous demandera d'autoriser l'installation d'applications par des sources inconnues en vous redirigeant vers les paramètres de votre téléphone. Autorisez cela. Il se peut que vous deviez réessayer de lancer l'exécutable.

Une fois l'installation finie, ouvrez l'application.

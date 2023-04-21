# Smart Mailbox
## Un projet informatique individuel de l'ENSC par Thomas Achard

Ce document a pour objectif de présenter les différentes procédures d'installation possibles afin de voir le code et de tester le projet. Il ne contiendra pas d'informations sur son fonctionnement (qui fera l'objet du rapport de synthèse).

## Contenu du repository

Il contient 2 dossiers :
- Un dossier *Arduino* avec le code sur l'ESP32, donc le dispositif physique.
- Un dossier *Flutter* avec le code de l'application pour téléphone.

Ce dossier *Flutter* dispose de beaucoup de dossiers utilisés pour la compilation. Les fichiers réellement modifiés sont :
- */android/app/src/main/AndroidManifest.xml* pour permettre l'utilisation de plugins sur Android.
- Le dossier */lib/* contient tous les fichiers propres au projet.

## Récupération du code

Afin de récupérer le repository, il est nécessaire d'[installer Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). Une fois isntallé, ouvrez un terminal de commandes (sous Windows ou dans un IDE comme Visual Studio Code) et lancez les commandes suivantes :
```
cd [chemin vers le dossier où vous voulez télécharger le repo]
git clone https://github.com/tachard/smart_mailbox/
```

Ouvrez ensuite le dossier dans Visual Studio Code.
Dans Visual Studio Code, installez aussi l'extension **Flutter**.
Vous disposez alos de quoi lire le projet d'application mobile.

Le projet est versionné par Git. Il dispose de 3 branches :
- *master* qui contient le code le plus récent (donc après la date de rendu)
- *renduP2I* qui contient le code de l'application nécessitant un ESP32.
- *test* qui contient le code de l'application modifiée, permettant de simuler le comportement de l'ESP32 sans nécessairement en avoir un.

Il est possible de passer de l'un à l'autre avec la commande :
```
git checkout [nom de la branche]
```

## Lancement du projet

Afin de pouvoir lancer le projet, il faut préalablement installer le SDK Flutter dont le mode d'emploi est [ici](https://docs.flutter.dev/get-started/install).
Pour lancer le projet, il est nécessaire d'utiliser son propre téléphone Android, soit via Visual Studio Code, soit via téléchargement d'un exécutable .apk.

### Installation par Visual Studio Code

Afin de lancer l'application sur votre téléphone Android, munissez-vous d'un câble afin de le connecter à votre ordinateur. Avant tout, il faut autoriser des paramètres de développement sur votre téléphone. Pour ce faire, allez dans les paramètres du téléphone, rubrique "Plus d'informations sur l'appareil" ou équivalent et cherchez le **numéro de build** dans les informations logicielles. Cliquez sur cette information 7 fois afin de débloquer les options développeur. Une fois le menu débloqué, allez dans celui-ci et activez le **débogage USB**.

Branchez votre téléphone à votre ordinateur et sélectionnez l'option "Transférer des fichers" sur le téléphone. Sur Visual Studio, en bas à droite, vous pouvez choisir vers quel appareil lancer l'application (Web, Windows ...) et choisissez votre appareil. Une fois fait, appuyer sur **F5** pour lancer l'application sur votre téléphone. Veillez à ce qu'il ne soit pas en veille.

### Installation d'un exécutable

L'objectif est d'installer l'un des exécutables présents [ici](https://github.com/tachard/smart_mailbox/releases). Il existe 2 exécutables, uniquement pour Android :
- Celle suffixée par test, prévue pour simuler sur le téléphone la présence du dispositif physique
- Celle sans suffixe, prévue pour fonctionner avec l'ESP32 du dispositif physique.

Téléchargez l'exécutable en .apk dans l'onglet Releases du projet.

Allez dans votre application de gestion des fichiers et lancez l'exécutable. Normalement, l'appareil vous demandera d'autoriser l'installation d'applications par des sources inconnues en vous redirigeant vers les paramètres de votre téléphone. Autorisez cela. Il se peut que vous deviez réessayer de lancer l'exécutable.

Une fois l'installation finie, ouvrez l'application.

# 🚀 Guide d'installation de Mozart 2 sur macOS (Apple Silicon)

Ce guide est destiné aux étudiants en **BAC 2 Informatique à l'UCLouvain (École Polytechnique de Louvain)** dans le cadre du cours de Concepts de Langages de Programmation (LINFO1104), pour installer facilement l'environnement **Mozart 2** sur les Mac équipés de puces **Apple Silicon (M1, M2, M3, M4)**.

---

## 🛠️ Étape 1 : Installation automatique

L'installation se fait directement via le **Terminal** de macOS en une seule commande.

Elle va télécharger la dernière version compilée pour ARM64, l'installer dans votre dossier utilisateur et configurer votre terminal.

### 1. Ouvrir le Terminal

Ouvrez l'application **Terminal**.

Vous pouvez utiliser Spotlight avec :

```text
Cmd + Espace
```

puis taper `Terminal`.

### 2. Lancer l'installation

Copiez et collez la commande suivante dans le Terminal, puis appuyez sur **Entrée** :

```bash
curl -sSL https://raw.githubusercontent.com/Arthvrr/mozart2/master/install-arm.sh | bash
```

---

## ✅ Étape 2 : Vérification de l'installation

Une fois le script terminé :

1. Fermez votre fenêtre de Terminal.
2. Ouvrez une nouvelle fenêtre de Terminal.

Ou exécutez directement :

```bash
source ~/.zshrc
```

### Lancer l'interface de Oz

Tapez simplement dans votre terminal :

```bash
oz
```

Si l'interface interactive de Mozart s'ouvre dans le terminal, ressemblant à ceci avec la bannière du compilateur, c'est réussi ! 🎉

Cela ressemble à quelque chose de ce style là : 

```text
File Edit Options Buffers Tools Oz Help
-UUU:---- Oz Programming Interface (F1) Oz
A11 L1
Mozart Compiler unknown (...) playing Oz 3
(Oz) -----
-UUU:**- Oz Programming Interface (F1) *Oz Compiler* All L3
Oz started.
(Compilation)
```

---

## 💻 Étape 3 : Choisir votre environnement de développement

Pour écrire et exécuter vos programmes en **Oz**, vous avez besoin d'un éditeur de texte configuré.

Deux choix sont possibles selon vos préférences et les exigences du cours.

### Option A : Visual Studio Code

VS Code est moderne, léger et simple à prendre en main.

1. Téléchargez et installez VS Code si ce n'est pas déjà fait.
2. Rendez-vous sur le Marketplace des extensions.
3. Installez l'extension Mozart Oz :

[Lien de l'extension](https://marketplace.visualstudio.com/items?itemName=mozart-oz.vscode-oz)

L'extension permet :

- la coloration syntaxique ;
- l'édition des fichiers `.oz` ;
- une intégration facilitée avec Mozart 2.

### Option B : Aquamacs / Emacs

Le professeur exige ou recommande parfois l'utilisation d'**Aquamacs** afin d'exploiter l'**OPI (Oz Programming Interface)** et l'interactivité native du langage.

[Lien de téléchargement](https://aquamacs.org/downloads/)

1. Téléchargez la dernière version d'Aquamacs depuis le site officiel.
2. Glissez l'application dans votre dossier **Applications**.

Grâce au script d'installation de l'étape 1, les chemins d'accès vers les modes Emacs de Mozart sont automatiquement configurés.

(Si vous hésitez l'extension VSCode fait largement le travail, ne vous ennuyez pas avec Aquamacs qui est plus vieux et sophistiqué à utiliser)

---

## 🧪 Test ultime avec votre éditeur (VS Code ou Aquamacs)

Une fois votre éditeur installé :

1. Créez un fichier de test, par exemple `test.oz`.
2. Écrivez la ligne de code suivante dedans :

```oz
{Browse 'Hello, World!'}
```

3. Sélectionnez ce bout de texte à la souris.
4. Faites un clic droit et choisissez l'option **Feed Region** (ou utilisez le raccourci correspondant dans votre éditeur).

Si une interface graphique s'ouvre correctement en affichant **Hello, World!**, félicitations, tout fonctionne à merveille ! 🚀

---

## 💡 En cas de problème — FAQ

### ❌ `command not found: oz`

Assurez-vous d'avoir bien fermé puis rouvert votre Terminal après l'installation afin que la modification du fichier `.zshrc` soit prise en compte.

Vous pouvez également essayer :

```bash
source ~/.zshrc
```

Puis réessayez de taper :

```bash
oz
```

---

### 🔒 macOS bloque l'application

Si macOS vous avertit qu'un binaire ne peut pas être ouvert :

1. Allez dans **Réglages Système**.
2. Ouvrez **Confidentialité et sécurité**.
3. Autorisez l'application ou le binaire concerné.

Vous pouvez également supprimer l'attribut de quarantaine avec :

```bash
xattr -d com.apple.quarantine <chemin>
```

> ⚠️ Remplacez `<chemin>` par le chemin réel du fichier ou de l'application concernée.

---

### 🌐 Problème de réseau ou de téléchargement (Wi-Fi UCLouvain / VPN)

**Q :** Le script s'arrête avec une erreur de téléchargement (`curl: (7) Failed to connect` ou `403`).

**Cause :** Le réseau universitaire (comme `eduroam`) ou un VPN actif sur votre Mac peut parfois bloquer certaines requêtes automatisées vers GitHub.

**Solution :**

- Désactivez temporairement votre VPN si vous en utilisez un.
- Essayez de vous connecter temporairement à un autre réseau, par exemple via un partage de connexion mobile.
- Vous pouvez également télécharger manuellement l'archive `.tar.gz` depuis la page des **Releases GitHub** et la placer dans votre dossier utilisateur.

---

### ⚙️ Utilisation d'un autre Shell (Bash au lieu de Zsh)

**Q :** J'ai lancé le script, mais la commande `oz` ne fonctionne toujours pas, même après avoir redémarré le Terminal.

**Cause :** Par défaut, macOS utilise **Zsh** et le script modifie le fichier `.zshrc`. Si vous avez configuré votre Mac pour utiliser l'ancien shell **Bash**, les modifications peuvent ne pas avoir été ajoutées au bon fichier.

**Solution :**

Ouvrez votre fichier de configuration Bash (`~/.bash_profile` ou `~/.bashrc`) avec un éditeur et ajoutez manuellement la ligne suivante à la fin :

```bash
export PATH="$HOME/.mozart2/bin:$PATH"
```

Sauvegardez le fichier, puis exécutez :

```bash
source ~/.bash_profile
```

Vous pouvez ensuite réessayer :

```bash
oz
```

---

### 🧩 VS Code ne trouve pas le compilateur `ozc`

**Q :** L'extension VS Code affiche une erreur indiquant qu'elle ne trouve pas `ozc` ou qu'elle n'arrive pas à compiler.

**Cause :** VS Code lancé depuis le Dock de macOS n'hérite parfois pas des variables d'environnement modifiées par le Terminal, notamment le `PATH`.

**Solution :**

Ouvrez votre Terminal, placez-vous dans le dossier de votre projet et tapez :

```bash
code .
```

Cela permet de lancer VS Code directement depuis le Terminal afin qu'il hérite correctement du `PATH` de Mozart.

Vérifiez également dans les paramètres de l'extension **VS Code — Mozart Oz** si un chemin absolu vers l'exécutable doit être renseigné :

```text
/Users/votre-nom/.mozart2/bin/ozc
```

---

### 🏛️ Aquamacs / Emacs ne reconnaît pas les commandes Oz

**Q :** Quand j'utilise Aquamacs, les raccourcis ou les modes pour Oz ne s'activent pas.

**Cause :** Aquamacs gère son propre environnement interne et peut ignorer le fichier `.zshrc` de votre Terminal macOS.

**Solution :**

1. Assurez-vous d'avoir complètement quitté Aquamacs avec `Cmd + Q`.
2. Relancez Aquamacs après l'installation.
3. Si le problème persiste, vérifiez dans le menu d'Aquamacs que le package **Mozart/OPI** est bien chargé.
4. Si nécessaire, demandez à un tuteur de TP de vous montrer comment lier le dossier `share/elisp` de Mozart à votre configuration Emacs (`~/.emacs`).

---

### ⁉️ D'autres questions ?

> Demandez à votre **tuteur qui encadre votre session de TP** ! Il saura vous guider pour réussir à installer l'application proprement sur votre Mac.
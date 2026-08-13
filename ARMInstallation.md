# 🚀 Guide d'installation de Mozart 2 sur macOS (Apple Silicon)

Ce guide est destiné aux étudiants en **BAC 2 Informatique à l'UCLouvain (École Polytechnique de Louvain)** pour installer facilement l'environnement **Mozart 2** sur les Mac équipés de puces **Apple Silicon (M1, M2, M3, M4)**.

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
curl -sSL https://raw.githubusercontent.com/Arthvrr/mozart2/main/install.sh | bash
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

### Vérifier le compilateur

Tapez ensuite :

```bash
ozc --version
```

Si le numéro de version s'affiche, **Mozart 2 est correctement installé sur votre Mac**. 🎉

---

## 💻 Étape 3 : Choisir votre environnement de développement

Pour écrire et exécuter vos programmes en **Oz**, vous avez besoin d'un éditeur de texte configuré.

Deux choix sont possibles selon vos préférences et les exigences du cours.

### Option A : Visual Studio Code — Recommandé pour débuter

**VS Code** est moderne, léger et simple à prendre en main.

1. Téléchargez et installez VS Code si ce n'est pas déjà fait.
2. Rendez-vous sur le Marketplace.
3. Installez l'extension **Mozart Oz**.

L'extension permet notamment :

- la coloration syntaxique ;
- l'édition des fichiers `.oz` ;
- une intégration facilitée avec Mozart 2.

Lien de l'extension [ici](https://marketplace.visualstudio.com/items?itemName=mozart-oz.vscode-oz).

---

### Option B : Aquamacs / Emacs — Recommandé pour l'interactivité du cours

Le professeur exige ou recommande parfois l'utilisation d'**Aquamacs** afin d'exploiter l'**OPI (Oz Programming Interface)** et l'interactivité native du langage.

1. Téléchargez la dernière version d'Aquamacs depuis le site officiel.
2. Glissez l'application dans votre dossier **Applications**.

Grâce au script d'installation de l'étape 1, les chemins d'accès vers les modes Emacs de Mozart sont automatiquement configurés.

Lien de l'application à installer [ici](https://aquamacs.org/downloads/).

---

## 💡 En cas de problème — FAQ

### ❌ `command not found: ozc`

Assurez-vous d'avoir bien **fermé puis rouvert votre Terminal** après l'installation afin que la modification du fichier `.zshrc` soit prise en compte.

Vous pouvez également essayer :

```bash
source ~/.zshrc
```

Puis :

```bash
ozc --version
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

## 🎓 Résumé

| Étape | Action |
|---|---|
| 1️⃣ | Installer Mozart 2 avec le script automatique |
| 2️⃣ | Vérifier avec `ozc --version` |
| 3️⃣ | Choisir VS Code ou Aquamacs / Emacs |
| 4️⃣ | Consulter la FAQ en cas de problème |

**Mozart 2 est maintenant prêt à être utilisé sur votre Mac Apple Silicon. 🚀**
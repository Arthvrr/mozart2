# Feuille de Route & Relevé des Modifications - Portage Mozart 2 sur Apple Silicon (ARM64)

Ce document récapitule l'ensemble des modifications apportées au code source, la configuration de l'environnement, ainsi que la commande CMake finale permettant d'obtenir une configuration réussie (`Generating done`) sous macOS ARM64.

---

## 1. Configuration de l'Environnement Système (Homebrew & Variables)

### Dépendances installées via Homebrew

```bash
brew install boost tcl-tk llvm cmake
```

### Variables d'environnement pour la session Terminal

```bash
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
```

---

## 2. Modifications Apportées au Code Source

### A. Fichier : `CMakeLists.txt` (Racine du projet)

**Problème :** Incompatibilité avec CMake moderne, qui exigeait une version de CMake inférieure à 3.5.

**Modification :** Passage de :

```cmake
cmake_minimum_required(VERSION 2.8.6)
```

à :

```cmake
cmake_minimum_required(VERSION 3.5)
```

---

### B. Fichier : `cmake_local/TargetArch.cmake`

**Problème :** L'architecture `arm64` était rejetée avec l'erreur :

```text
Invalid OS X arch name: arm64
```

**Modifications :**

Ajout de la condition pour `arm64` dans la boucle :

```cmake
foreach(osx_arch ${CMAKE_OSX_ARCHITECTURES})
```

Ajout de la condition suivante :

```cmake
elseif("${osx_arch}" STREQUAL "arm64")
    set(osx_arch_arm64 TRUE)
```

Ajout de `arm64` à la liste des architectures retenues :

```cmake
if(osx_arch_arm64)
    list(APPEND ARCH arm64)
endif()
```

---

### C. Fichier : `vm/boostenv/main/CMakeLists.txt`

**Problème :** Incompatibilité avec Boost 1.90.0 :

```text
Could NOT find Boost (missing: system)
```

Le composant `system` n'existe plus en tant que module séparé dans les versions récentes de Boost.

**Modification :** Suppression de `system` dans la directive `find_package`.

**Avant :**

```cmake
find_package(Boost COMPONENTS random system thread filesystem chrono REQUIRED)
```

**Après :**

```cmake
find_package(Boost COMPONENTS random thread filesystem chrono REQUIRED)
```

---

### D. Fichier : `boosthost/emulator/CMakeLists.txt`

**Problème :** Présence de la même dépendance obsolète vers `boost_system`.

**Modification :** Suppression du composant `system` de la liste des composants Boost requis à la ligne 22.

---

## 3. Commande CMake Finale Validée

La commande suivante a été exécutée depuis le dossier :

```text
mozart2/build
```

Commande complète :

```bash
cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_OSX_ARCHITECTURES=arm64 \
      -DCMAKE_CXX_COMPILER_ARCHITECTURE_ID=arm64 \
      -DCMAKE_CXX_COMPILER=/opt/homebrew/opt/llvm/bin/clang++ \
      -DCMAKE_C_COMPILER=/opt/homebrew/opt/llvm/bin/clang \
      -DCMAKE_PREFIX_PATH="/opt/homebrew/opt/llvm;/opt/homebrew/opt/tcl-tk;/opt/homebrew/opt/boost" \
      -DMOZART_BOOST_USE_STATIC_LIBS=OFF \
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
      -DBOOST_ROOT=/opt/homebrew/opt/boost \
      -DBoost_NO_SYSTEM_PATHS=ON \
      -DBoost_NO_BOOST_CMAKE=ON \
      ..
```

La configuration CMake a été validée avec succès et aboutit à :

```text
Generating done
```

---

## 4. Étape Suivante : Compilation C++

Pour lancer la compilation multi-cœurs :

```bash
make -j $(sysctl -n hw.ncpu)
```

Cette commande utilise automatiquement le nombre de cœurs CPU disponibles sur la machine afin d'accélérer la compilation du projet.

---

## 5. Résumé des Étapes

Pour reproduire le portage sur une machine Apple Silicon (ARM64) :

### Étape 1 — Installer les dépendances

```bash
brew install boost tcl-tk llvm cmake
```

### Étape 2 — Configurer les variables d'environnement

```bash
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
```

### Étape 3 — Modifier `CMakeLists.txt`

Modifier la version minimale requise de CMake :

```cmake
cmake_minimum_required(VERSION 2.8.6)
```

devient :

```cmake
cmake_minimum_required(VERSION 3.5)
```

### Étape 4 — Ajouter le support `arm64`

Dans le fichier :

```text
cmake_local/TargetArch.cmake
```

Ajouter la détection de l'architecture `arm64` :

```cmake
elseif("${osx_arch}" STREQUAL "arm64")
    set(osx_arch_arm64 TRUE)
```

Puis ajouter `arm64` à la liste des architectures retenues :

```cmake
if(osx_arch_arm64)
    list(APPEND ARCH arm64)
endif()
```

### Étape 5 — Modifier la configuration Boost

Dans :

```text
vm/boostenv/main/CMakeLists.txt
```

Remplacer :

```cmake
find_package(Boost COMPONENTS random system thread filesystem chrono REQUIRED)
```

par :

```cmake
find_package(Boost COMPONENTS random thread filesystem chrono REQUIRED)
```

Effectuer également la même modification dans :

```text
boosthost/emulator/CMakeLists.txt
```

en supprimant la dépendance au composant `system`.

### Étape 6 — Se placer dans le dossier de compilation

```bash
cd mozart2/build
```

### Étape 7 — Exécuter la commande CMake

```bash
cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_OSX_ARCHITECTURES=arm64 \
      -DCMAKE_CXX_COMPILER_ARCHITECTURE_ID=arm64 \
      -DCMAKE_CXX_COMPILER=/opt/homebrew/opt/llvm/bin/clang++ \
      -DCMAKE_C_COMPILER=/opt/homebrew/opt/llvm/bin/clang \
      -DCMAKE_PREFIX_PATH="/opt/homebrew/opt/llvm;/opt/homebrew/opt/tcl-tk;/opt/homebrew/opt/boost" \
      -DMOZART_BOOST_USE_STATIC_LIBS=OFF \
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
      -DBOOST_ROOT=/opt/homebrew/opt/boost \
      -DBoost_NO_SYSTEM_PATHS=ON \
      -DBoost_NO_BOOST_CMAKE=ON \
      ..
```

### Étape 8 — Vérifier la configuration

La configuration CMake est considérée comme réussie lorsque le processus se termine correctement avec :

```text
Generating done
```

### Étape 9 — Lancer la compilation

```bash
make -j $(sysctl -n hw.ncpu)
```

---

## 6. État Actuel

La configuration CMake du projet Mozart 2 est désormais fonctionnelle sur macOS avec une architecture Apple Silicon (`arm64`).

Les principaux problèmes rencontrés et corrigés étaient :

- Compatibilité avec les versions modernes de CMake.
- Reconnaissance de l'architecture Apple Silicon `arm64`.
- Compatibilité avec les versions récentes de Boost.
- Suppression de la dépendance obsolète au composant `boost_system`.
- Configuration explicite des compilateurs LLVM/Clang.
- Configuration du chemin vers les dépendances installées via Homebrew.

La prochaine étape consiste maintenant à lancer la compilation complète du projet avec :

```bash
make -j $(sysctl -n hw.ncpu)
```

Une fois la compilation terminée, il faudra vérifier que le build s'est terminé sans erreur et poursuivre avec les éventuelles étapes de test ou d'installation du projet Mozart 2.
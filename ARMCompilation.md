# Feuille de Route & Relevé des Modifications - Portage Mozart 2 sur Apple Silicon (ARM64)

Ce document récapitule l'ensemble des modifications apportées au code source, la configuration de l'environnement, ainsi que les différentes étapes nécessaires à la compilation du projet Mozart 2 sur macOS ARM64 (Apple Silicon).

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

---

# 7. Résolution des Conflits de Génération (Java & C++)

Après la configuration initiale de CMake, de nouveaux problèmes sont apparus lors de la compilation de certains sous-modules du projet. Deux conflits principaux ont été identifiés : un conflit de version Java lors de la génération du sous-module Scala avec SBT, ainsi qu'un conflit lié à la norme C++ utilisée par le projet.

---

## A. Rétrogradation de Java pour Scala (SBT)

### Problème

Le sous-module `bootcompiler` utilise **Scala Build Tool (SBT)** pour compiler et générer certains composants du projet.

La compilation avec la version de Java installée par défaut, Java 21, provoquait des erreurs critiques lors de l'exécution de SBT, notamment :

```text
bad constant pool index
```

ainsi que :

```text
ExceptionInInitializerError
```

Ces erreurs étaient liées à une incompatibilité entre l'ancienne version de Scala utilisée par le projet, basée sur Scala 2.12, et la version récente de Java 21.

Afin de garantir la compatibilité avec l'ancienne chaîne de compilation Scala/SBT utilisée par Mozart 2, Java 11 a été installé et configuré comme version Java utilisée par défaut pour le projet.

### Modification

Installation de Java 11 via Homebrew :

```bash
brew install openjdk@11
```

Création du lien symbolique permettant à macOS de détecter correctement le JDK :

```bash
sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
```

Configuration de Java 11 comme version active pour la session Terminal :

```bash
export JAVA_HOME=$(/usr/libexec/java_home -v 11)
export PATH="$JAVA_HOME/bin:$PATH"
```

Cette configuration permet ainsi de forcer SBT et les outils de génération Scala à utiliser Java 11 plutôt que Java 21.

---

## B. Forçage Global de la Norme C++14

### Problème

Après résolution du problème lié à Java et à SBT, une nouvelle incompatibilité est apparue lors de la compilation C++.

La version récente de Boost utilisée par le projet, notamment Boost 1.90.0, exige au minimum l'utilisation de la norme **C++14**.

Cependant, plusieurs fichiers CMake du projet Mozart 2 forçaient encore explicitement l'utilisation de l'ancienne norme C++11 à travers le drapeau :

```text
-std=c++0x
```

Cette configuration provoquait des incompatibilités avec les API et fonctionnalités utilisées par les versions récentes de Boost.

### Modification

Une recherche globale a été effectuée dans le projet afin d'identifier les fichiers CMake utilisant encore l'ancienne norme `c++0x`.

Depuis la racine du projet, les commandes suivantes ont été exécutées :

```bash
find . -type f -name "CMakeLists.txt" -exec sed -i '' 's/c++0x/c++14/g' {} +
```

Puis sur les fichiers `.cmake` :

```bash
find . -type f -name "*.cmake" -exec sed -i '' 's/c++0x/c++14/g' {} +
```

Cette modification a permis de remplacer globalement les anciennes références à :

```text
c++0x
```

par :

```text
c++14
```

Une configuration propre du projet a ensuite été effectuée en ajoutant explicitement le drapeau C++14 à la commande CMake :

```bash
-DCMAKE_CXX_FLAGS="-std=c++14"
```

Cette modification a permis d'assurer que l'ensemble du projet utilise une norme C++ compatible avec les exigences de Boost 1.90.0.

---

# 8. Modernisation du Code C++ (API Boost Asio & Random)

Une fois la compilation débloquée grâce au passage à C++14, de nouvelles erreurs sont apparues directement dans le code source C++ de la machine virtuelle.

Ces erreurs étaient principalement dues aux changements importants introduits dans les versions récentes de Boost, notamment dans les API réseau, temporelles et de gestion des threads.

Les modifications ont principalement concerné les API **Boost.Asio**, la génération de nombres aléatoires et la gestion du cycle de vie des tâches asynchrones.

---

## A. Composants Temporels, Threads et Nombres Aléatoires

### Fichiers modifiés

Les fichiers suivants ont été adaptés :

```text
vm/boostenv/main/boostvm-decl.hh
vm/boostenv/main/boostvm.cc
vm/boostenv/main/boostenv-decl.hh
vm/boostenv/main/boostenv.hh
```

### Inclusions manquantes ajoutées

Les nouvelles API utilisées nécessitaient l'ajout des inclusions suivantes :

```cpp
#include <boost/random/mersenne_twister.hpp>
#include <boost/asio/steady_timer.hpp>
#include <boost/asio/executor_work_guard.hpp>
```

---

### Nombres Aléatoires

L'ancien type :

```cpp
boost::random::mt19937
```

a été remplacé par :

```cpp
boost::mt19937
```

Cette modification permet d'utiliser l'API correspondant à la version de Boost actuellement installée et utilisée par le projet.

---

### Timers Asio

L'ancien composant :

```cpp
deadline_timer
```

étant déprécié dans les versions modernes de Boost.Asio, il a été entièrement remplacé par :

```cpp
steady_timer
```

Les API de gestion du temps ont également été adaptées afin d'utiliser `std::chrono`.

Par exemple, l'ancien code :

```cpp
expires_from_now(boost::posix_time::millisec(1))
```

a été remplacé par :

```cpp
expires_after(std::chrono::milliseconds(1))
```

De même, l'utilisation de :

```cpp
expires_at(boost::posix_time::min_date_time)
```

a été remplacée par :

```cpp
expires_at(boost::asio::steady_timer::time_point::max())
```

Enfin, l'ancienne méthode :

```cpp
expires_at()
```

a été remplacée par :

```cpp
expiry()
```

Ces changements permettent d'adapter la gestion des timers aux API modernes de Boost.Asio basées sur `steady_timer` et `std::chrono`.

---

### Gestion du Work Asio

L'ancien pointeur :

```cpp
boost::asio::io_context::work*
```

n'est plus utilisé dans les versions modernes de Boost.Asio.

Il a été remplacé partout par :

```cpp
boost::asio::executor_work_guard<boost::asio::io_context::executor_type>*
```

L'initialisation de cet objet utilise désormais l'exécuteur associé au `io_context` :

```cpp
environment.io_context.get_executor()
```

Cette modification permet de conserver le comportement qui empêche le `io_context` de s'arrêter lorsqu'il n'existe momentanément plus de tâches actives, tout en utilisant l'API moderne de Boost.Asio.

---

## B. Résolution DNS (Resolver Réseau)

### Fichiers modifiés

Les fichiers concernés sont :

```text
vm/boostenv/main/boostenvtcp.hh
vm/boostenv/main/modos.hh
```

### Suppression de l'objet `query`

L'ancienne API de Boost.Asio utilisait un objet :

```cpp
tcp::resolver::query
```

Cette API a été supprimée ou remplacée dans les versions modernes de Boost.Asio.

Les paramètres nécessaires à la résolution DNS, notamment le nom d'hôte et le service, sont désormais transmis directement à la méthode :

```cpp
resolve()
```

ou :

```cpp
async_resolve()
```

---

### Nouveau type de retour de `resolve`

L'ancienne API retournait directement un itérateur réseau :

```cpp
protocol::resolver::iterator
```

L'API moderne retourne désormais une structure contenant une liste de résultats :

```cpp
protocol::resolver::results_type
```

Le type utilisé par `resolveHandler` a donc été adapté afin de recevoir :

```cpp
protocol::resolver::results_type
```

au lieu de :

```cpp
protocol::resolver::iterator
```

---

### Adaptation de l'itération dans `modos.hh`

La résolution DNS est désormais effectuée avec le code suivant :

```cpp
auto results = resolver.resolve(nameString, "0", ec);
auto it = results.begin();
```

Cette modification permet au code existant de continuer à parcourir les résultats de résolution DNS tout en utilisant l'API moderne de Boost.Asio.

---

# 9. Script de Compilation et État Actuel Validé

Afin de faciliter le débogage de la compilation parallèle C++, un script utilitaire nommé :

```text
build_and_log.sh
```

a été créé à la racine du projet.

Ce script permet de lancer automatiquement la compilation depuis le dossier `build/` tout en enregistrant l'ensemble des sorties de compilation dans un fichier de logs.

Le contenu du script est le suivant :

```bash
#!/bin/bash

LOG_FILE="logs.txt"

> "$LOG_FILE"

echo "➡️ Entrée dans le dossier build/..."

cd build || {
    echo "❌ Erreur: le dossier build n'existe pas."
    exit 1
}

echo "🚀 Lancement de la compilation..."

make -j $(sysctl -n hw.ncpu) 2>&1 | tee "../$LOG_FILE"

echo "✅ Compilation terminée. Logs sauvegardés dans $LOG_FILE"
```

Le script peut ensuite être exécuté depuis la racine du projet afin de lancer la compilation multi-cœurs et de conserver les logs dans :

```text
logs.txt
```

---

## Validation Finale du Module Asynchrone

Après application de l'ensemble des correctifs C++ et réseau, une compilation ciblée de la machine virtuelle a été effectuée afin de vérifier spécifiquement le bon fonctionnement du module utilisant Boost.

La commande suivante a été exécutée :

```bash
make mozartvmboost
```

La compilation s'est terminée avec succès.

Le résultat final obtenu est :

```text
[100%] Linking CXX static library libmozartvmboost.a
[100%] Built target mozartvmboost
```

Cette sortie confirme que le module `mozartvmboost` a été compilé intégralement et que la bibliothèque statique :

```text
libmozartvmboost.a
```

a été générée avec succès.

---

# 10. État Global du Portage sur Apple Silicon

À ce stade du portage, plusieurs couches de compatibilité ont été adaptées afin de permettre la compilation du projet Mozart 2 sur une machine Apple Silicon utilisant l'architecture ARM64.

Les principales modifications réalisées sont les suivantes :

- Adaptation de la configuration CMake aux versions modernes de CMake.
- Ajout du support explicite de l'architecture Apple Silicon `arm64`.
- Configuration des compilateurs LLVM/Clang installés via Homebrew.
- Adaptation de la détection des dépendances Boost modernes.
- Suppression de la dépendance explicite au composant obsolète `boost_system`.
- Passage global de l'ancienne norme C++11 (`c++0x`) vers C++14.
- Ajout d'un forçage explicite de la norme C++14 via CMake.
- Installation et utilisation de Java 11 afin d'assurer la compatibilité de Scala/SBT avec l'ancien code Scala 2.12 du projet.
- Modernisation des API Boost.Asio utilisées par la machine virtuelle.
- Remplacement de `deadline_timer` par `steady_timer`.
- Migration des API de temps de `boost::posix_time` vers `std::chrono`.
- Remplacement de `boost::asio::io_context::work` par `executor_work_guard`.
- Adaptation de la gestion des nombres aléatoires avec l'API Boost moderne.
- Modernisation de l'API de résolution DNS de Boost.Asio.
- Adaptation des types `resolver::iterator` vers `resolver::results_type`.
- Création d'un script `build_and_log.sh` pour faciliter le suivi et le débogage des compilations.
- Validation avec succès de la compilation ciblée du module `mozartvmboost`.

La compilation du module asynchrone est désormais validée à 100 % avec :

```bash
make mozartvmboost
```

et produit :

```text
[100%] Linking CXX static library libmozartvmboost.a
[100%] Built target mozartvmboost
```

Le portage est donc désormais suffisamment avancé pour poursuivre la compilation des autres modules du projet Mozart 2 et identifier les éventuelles incompatibilités restantes avec l'environnement moderne macOS ARM64.

La prochaine étape consiste à lancer la compilation complète du projet avec :

```bash
./build_and_log.sh
```

ou directement :

```bash
make -j $(sysctl -n hw.ncpu)
```

Les éventuelles erreurs restantes pourront alors être analysées à partir du fichier :

```text
logs.txt
```

afin de poursuivre progressivement la modernisation des composants encore incompatibles avec les versions actuelles de Java, CMake, C++ et Boost.
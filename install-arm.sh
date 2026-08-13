#!/bin/bash

# Configuration
INSTALL_DIR="$HOME/.mozart2"
REPO_USER="Arthvrr"
REPO_NAME="mozart2"
VERSION="v2.0.0-arm64"

echo "Installation de Mozart 2 pour macOS (Apple Silicon)..."

# 1. Création du dossier d'installation
mkdir -p "$INSTALL_DIR"

# 2. Téléchargement de l'archive depuis les Releases GitHub
ARCHIVE_URL="https://github.com/$REPO_USER/$REPO_NAME/releases/download/$VERSION/mozart2-mac-arm64.tar.gz"
echo "Téléchargement depuis $ARCHIVE_URL..."

curl -L "$ARCHIVE_URL" -o /tmp/mozart2.tar.gz

if [ $? -ne 0 ]; then
    echo "Erreur : Impossible de télécharger l'archive. Vérifie que la Release GitHub est bien publiée !"
    exit 1
fi

# 3. Extraction
echo "Extraction des fichiers dans $INSTALL_DIR..."
tar -xzf /tmp/mozart2.tar.gz -C "$INSTALL_DIR"
rm /tmp/mozart2.tar.gz

# 4. Configuration automatique du PATH dans .zshrc (par défaut sur macOS moderne)
ZSHRC="$HOME/.zshrc"
PATH_LINE="export PATH=\"$INSTALL_DIR/bin:\$PATH\""

if [ -f "$ZSHRC" ] && grep -q "$INSTALL_DIR/bin" "$ZSHRC"; then
    echo "Le PATH est déjà configuré dans $ZSHRC."
else
    echo "Ajout de Mozart 2 au PATH dans $ZSHRC..."
    echo "" >> "$ZSHRC"
    echo "# Mozart 2 Environment" >> "$ZSHRC"
    echo "$PATH_LINE" >> "$ZSHRC"
fi

echo "Installation terminée avec succès !"
echo "Ouvre un nouveau terminal (ou tape 'source ~/.zshrc') puis tape 'ozc --version' pour commencer."
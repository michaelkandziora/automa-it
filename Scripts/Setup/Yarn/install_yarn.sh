#!/bin/bash

# Funktion, um Yarn unter macOS zu installieren
install_yarn_mac() {
    echo "Installiere Yarn auf macOS..."
    brew install yarn
    if [ $? -eq 0 ]; then
        echo "Yarn wurde erfolgreich auf macOS installiert."
    else
        echo "Es gab einen Fehler bei der Installation von Yarn auf macOS."
        exit 1
    fi
}

# Funktion, um Yarn unter Linux zu installieren
install_yarn_linux() {
    echo "Installiere Yarn auf Linux..."
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | $SUDO apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | $SUDO tee /etc/apt/sources.list.d/yarn.list
    $SUDO apt update && $SUDO apt install yarn
    if [ $? -eq 0 ]; then
        echo "Yarn wurde erfolgreich auf Linux installiert."
    else
        echo "Es gab einen Fehler bei der Installation von Yarn auf Linux."
        exit 1
    fi
}

# Überprüfe das Betriebssystem und führe die entsprechenden Schritte aus
if [ "$(uname -s)" = "Darwin" ]; then
    # Überprüfe, ob Homebrew installiert ist
    if ! command -v brew &> /dev/null; then
        echo "Homebrew ist nicht installiert. Bitte installiere zuerst Homebrew."
        exit 1
    fi
    # Überprüfe, ob Yarn installiert ist, und installiere es ggf.
    if ! command -v yarn &> /dev/null; then
        install_yarn_mac
    else
        echo "Yarn ist bereits auf macOS installiert."
    fi
elif [ "$(uname -s)" = "Linux" ]; then
    # Überprüfe, ob Yarn installiert ist, und installiere es ggf.
    if ! command -v yarn &> /dev/null; then
        install_yarn_linux
    else
        echo "Yarn ist bereits auf Linux installiert."
    fi
else
    echo "Dieses Skript unterstützt nur macOS und Linux."
    exit 1
fi

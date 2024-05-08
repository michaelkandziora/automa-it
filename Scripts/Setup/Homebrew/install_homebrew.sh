#!/bin/bash

# Funktion, um den Installationsprozess von Homebrew durchzuführen
install_homebrew() {
    echo "Beginne mit der Installation von Homebrew..."

    # Befehl zum Installieren von Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [ $? -eq 0 ]; then
        echo "Homebrew wurde erfolgreich installiert."
    else
        echo "Es gab einen Fehler bei der Installation von Homebrew."
        exit 1
    fi

    # Homebrew in der Shell verfügbar machen
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
}

# Hauptteil des Skripts
main() {
    # Überprüfe das Betriebssystem
    OS=$(uname -s)
    if [ "$OS" != "Darwin" ]; then
        echo "Dieses Skript ist nur für macOS gedacht. Bitte führe es auf einem Mac aus."
        exit 1
    fi

    # Überprüfung, ob Homebrew bereits installiert ist
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew ist bereits installiert."
        read -p "Möchtest du Homebrew aktualisieren? (y/n): " response
        if [[ "$response" == "y" ]]; then
            echo "Aktualisiere Homebrew..."
            brew update
        fi
    else
        # Installiere Homebrew, wenn es noch nicht installiert ist
        install_homebrew
    fi
}

# Skript starten
main

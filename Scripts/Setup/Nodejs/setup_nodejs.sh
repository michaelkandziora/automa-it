#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
source ./utils.sh

# Installation und Konfiguration von Node.js und npm
function setup_nodejs() {
    echo -e "${GREEN}Beginne mit der Installation von Node.js und npm...${NC}"

    # Konfigurationswerte aus config.toml laden
    load_config "node_js"

    # Node.js Version prüfen und festlegen
    node_version=${node_version:-"14.x"}  # Standardversion festlegen

    # NodeSource Repository hinzufügen und Installation durchführen
    curl -fsSL https://deb.nodesource.com/setup_$node_version | sudo -E bash -
    sudo apt-get install -y nodejs

    # Prüfen, ob Node.js und npm korrekt installiert wurden
    if command -v node > /dev/null 2>&1 && command -v npm > /dev/null 2>&1; then
        echo -e "${GREEN}Node.js und npm wurden erfolgreich installiert.${NC}"
    else
        echo -e "${RED}Fehler bei der Installation von Node.js und npm.${NC}"
        return 1  # Beendet das Skript mit einem Fehlerstatus
    fi

    # Node.js-Version in die config.toml speichern
    #save_config "node_js" "version" "$node_version"
}

# Starte die Installation von Node.js und npm
setup_nodejs

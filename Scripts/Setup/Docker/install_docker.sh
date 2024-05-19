#!/bin/bash
# @TODO Beim installieren wird beim hinzufügen des GPGs Benutzer nach OK gefragt, ENTER bestätigen, fix for silent

# Importiere Hilfsfunktionen und Konfigurationswerte
source ./utils.sh

# Docker Installationsskript
function install_docker() {
    echo -e "${GREEN}Beginne mit der Installation von Docker...${NC}"

    # Konfigurationswerte aus config.toml laden
    load_config "docker"

    # Installationsprozess starten
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce

    echo -e "${GREEN}Docker wurde erfolgreich installiert.${NC}"
    
    # Konfigurationsdaten speichern, falls neu
    save_config "docker" "installed" "true"
}

# Funktionen aus der utils.sh verwenden, um die Konfiguration zu laden und zu speichern
install_docker

#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
source ./utils.sh

# Installation und Konfiguration von Docker Compose
function setup_docker_compose() {
    echo -e "${GREEN}Beginne mit der Installation von Docker Compose...${NC}"

    # Docker Compose Version aus der config.toml laden oder Standard verwenden
    load_config "docker_compose"
    docker_compose_version=${docker_compose_version:-"1.29.2"}

    # Download und Installation von Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    # Überprüfung der Installation
    if [[ $(docker-compose --version) ]]; then
        echo -e "${GREEN}Docker Compose wurde erfolgreich installiert.${NC}"
    else
        echo -e "${RED}Fehler bei der Installation von Docker Compose.${NC}"
    fi

    # Konfigurationsdaten speichern
    save_config "docker_compose" "version" "$docker_compose_version"
}

# Starte die Installation von Docker Compose
setup_docker_compose

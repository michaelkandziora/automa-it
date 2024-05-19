#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
source ./utils.sh

# Git Installation und Konfiguration
function install_git() {
    echo -e "${GREEN}Beginne mit der Installation von Git...${NC}"

    # Konfigurationswerte aus config.toml laden
    load_config "git"

    # Installationsprozess starten
    sudo apt-get update
    sudo apt-get install -y git
    echo -e "${GREEN}Git wurde erfolgreich installiert.${NC}"

    # Konfigurationsdaten prüfen und ggf. Benutzerabfragen durchführen
    if [[ -z "$git_name" || -z "$git_email" ]]; then
        echo "Einige Git-Konfigurationsdaten fehlen."
        if [[ -z "$git_name" ]]; then
            read -p "Bitte geben Sie Ihren Git Benutzernamen ein: " git_name
            #save_config "git" "name" "$git_name"
        fi
        if [[ -z "$git_email" ]]; then
            read -p "Bitte geben Sie Ihre Git E-Mail Adresse ein: " git_email
            #save_config "git" "email" "$git_email"
        fi
    fi

    # Git-Konfiguration global setzen
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"

    echo -e "${GREEN}Git-Konfiguration wurde erfolgreich gesetzt:${NC} Name: $git_name, E-Mail: $git_email"
}

# Starte die Installation und Konfiguration
install_git

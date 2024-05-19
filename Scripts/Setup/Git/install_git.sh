#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
# Sucht nach der Datei 'utils.sh' ab dem Wurzelverzeichnis des Projekts
# Start im aktuellen Verzeichnis
dir="."

# Loop, um nach oben im Verzeichnisbaum zu gehen
while : ; do
    # Suche nach der utils.sh im aktuellen Verzeichnis
    file_path=$(find "$dir" -maxdepth 1 -type f -name "utils.sh" -print -quit)
    
    # Prüfen, ob die Datei gefunden wurde
    if [[ -n $file_path ]]; then
        source "$file_path"
        echo "Datei gefunden und gesourced: $file_path"
        break
    fi

    # Abbruchbedingungen: root oder temp directory erreicht
    if [[ "$dir" == "/" || "$dir" =~ ^/tmp/tmp\.* ]]; then
        echo "utils.sh nicht gefunden. Suchbereich endete bei: $dir"
        break
    fi

    # Gehe ein Verzeichnis höher
    dir=$(dirname "$dir")
done

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

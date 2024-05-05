#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
source ./utils.sh

# Funktion zur Konfiguration von rclone
function setup_rclone() {
    echo -e "${GREEN}Beginne mit der Konfiguration von rclone für Cloud-Backups...${NC}"

    # curl https://rclone.org/install.sh | sudo bash @TODO

    # Starte die Konfiguration von rclone
    echo "Bitte folge den Anweisungen auf dem Bildschirm zur Einrichtung deines Cloud-Speichers:"
    rclone config

    # Lade eventuell vorhandene Konfigurationsdaten
    load_config "rclone"
    cloud_service=${cloud_service:-"Dropbox"}  # Standardmäßig Dropbox
    backup_folder_path=${backup_folder_path:-"$HOME/projects"}

    # Speichere die Konfigurationsdaten
    save_config "rclone" "cloud_service" "$cloud_service"
    save_config "rclone" "backup_folder_path" "$backup_folder_path"

    echo -e "${GREEN}rclone wurde erfolgreich für $cloud_service konfiguriert.${NC}"
}

# Starte die Einrichtung von rclone
setup_rclone

#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
# Sucht nach der Datei 'utils.sh' ab dem Wurzelverzeichnis des Projekts
# Start im aktuellen Verzeichnis
dir="$(pwd)"

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
    if [[ "$dir" == "/" ]]; then
        echo "utils.sh nicht gefunden. Suchbereich endete bei: $dir"
        break
    fi

    # Gehe ein Verzeichnis höher
    dir=$(dirname "$dir")
done

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
    #save_config "rclone" "cloud_service" "$cloud_service"
    #save_config "rclone" "backup_folder_path" "$backup_folder_path"

    echo -e "${GREEN}rclone wurde erfolgreich für $cloud_service konfiguriert.${NC}"
}

# Starte die Einrichtung von rclone
setup_rclone

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

# Funktion zur Durchführung des Backups
function perform_backup() {
    echo -e "${GREEN}Beginne mit dem Backup...${NC}"

    # Backup-Zielverzeichnis
    backup_target_dir="$HOME/backups"

    # Überprüfen, ob das Backup-Verzeichnis existiert, sonst erstellen
    mkdir -p "$backup_target_dir"

    # Konfigurationswerte aus config.toml laden
    load_config "backup"
    backup_sources=${backup_sources:-"$HOME/projects"}

    # Rsync-Befehl ausführen
    rsync -avh --progress $backup_sources $backup_target_dir

    echo -e "${GREEN}Backup wurde erfolgreich erstellt in: $backup_target_dir${NC}"

    # Backup-Konfiguration speichern
    #save_config "backup" "last_backup" "$(date +%F-%T)"
    #save_config "backup" "source" "$backup_sources"
    #save_config "backup" "target" "$backup_target_dir"
}

# Starte das Backup
perform_backup

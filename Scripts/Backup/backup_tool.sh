#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
source ./utils.sh

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

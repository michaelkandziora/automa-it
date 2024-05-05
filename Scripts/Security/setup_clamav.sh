#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
source ./utils.sh

# Installation und Konfiguration von ClamAV
function setup_clamav() {
    echo -e "${GREEN}Beginne mit der Installation von ClamAV...${NC}"

    # ClamAV installieren
    sudo apt-get update
    sudo apt-get install -y clamav clamav-daemon

    # Signaturen updaten
    echo "Update der ClamAV Virus-Datenbank..."
    sudo freshclam

    # Konfigurationswerte aus config.toml laden
    load_config "clamav"
    scan_path=${scan_path:-"$HOME"}  # Standard-Scan-Pfad

    # Automatischer Scan als Cron-Job (täglich um Mitternacht)
    echo "Einrichten eines täglichen Scans..."
    (crontab -l 2>/dev/null; echo "0 0 * * * clamscan --recursive --infected --remove --exclude-dir='^/sys|^/proc|^/dev' $scan_path >> $HOME/clamav_scan.log 2>&1") | crontab -

    echo -e "${GREEN}ClamAV wurde erfolgreich installiert und konfiguriert.${NC}"
    echo "Tägliche Scans sind eingerichtet für $scan_path."

    # Konfigurationsdaten speichern
    save_config "clamav" "scan_path" "$scan_path"
}

# Starte die Installation und Konfiguration von ClamAV
setup_clamav

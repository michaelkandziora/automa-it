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

# Installation und Konfiguration von ClamAV
function setup_clamav() {
    echo -e "${GREEN}Beginne mit der Installation von ClamAV...${NC}"

    # ClamAV installieren
    $SUDO apt-get update
    $SUDO apt-get install -y clamav clamav-daemon

    # Signaturen updaten
    echo "Update der ClamAV Virus-Datenbank..."
    $SUDO freshclam

    # Konfigurationswerte aus config.toml laden
    load_config "clamav"
    scan_path=${scan_path:-"$HOME"}  # Standard-Scan-Pfad

    # Automatischer Scan als Cron-Job (täglich um Mitternacht)
    echo "Einrichten eines täglichen Scans..."
    (crontab -l 2>/dev/null; echo "0 0 * * * clamscan --recursive --infected --remove --exclude-dir='^/sys|^/proc|^/dev' $scan_path >> $HOME/clamav_scan.log 2>&1") | crontab -

    echo -e "${GREEN}ClamAV wurde erfolgreich installiert und konfiguriert.${NC}"
    echo "Tägliche Scans sind eingerichtet für $scan_path."

    # Konfigurationsdaten speichern
    #save_config "clamav" "scan_path" "$scan_path"
}

# Starte die Installation und Konfiguration von ClamAV
setup_clamav

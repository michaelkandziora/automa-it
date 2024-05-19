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

# Hauptfunktion zur Durchführung der forensischen Analyse
function forensic_analysis() {
    echo -e "${GREEN}Beginne forensische Sammlung von Systemdaten...${NC}"

    # Konfigurationswerte aus config.toml laden
    load_config "forensic"

    # Ordner für die Sammlung erstellen
    forensic_dir="${forensic_dir:-"/tmp/forensic_data"}"
    mkdir -p "$forensic_dir"

    # Log-Dateien und andere relevante Daten sammeln
    echo "Sammle Systemlogs..."
    cp /var/log/auth.log "$forensic_dir/auth.log"
    cp /var/log/syslog "$forensic_dir/syslog"

    echo "Sammle Benutzerlogin-Daten..."
    last -a > "$forensic_dir/user_logins.txt"

    echo "Sammle Shell-History von Benutzern..."
    cp /home/*/.bash_history "$forensic_dir/"

    # Archivieren der gesammelten Daten
    archive_path="/tmp/forensic_data_$(date +%F).tar.gz"
    tar -czf "$archive_path" -C "$forensic_dir" .

    echo "Daten archiviert in $archive_path"

    # Hochladen des Archivs mit rclone
    echo "Lade archivierte Daten hoch..."
    rclone move "$archive_path" "${rclone_remote}:${remote_path}" --config "${rclone_config_path}"

    echo -e "${GREEN}Forensische Daten wurden erfolgreich gesammelt und hochgeladen.${NC}"
}

# Starte die forensische Analyse
forensic_analysis

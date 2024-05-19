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

# Funktion zum sicheren Transfer von Dateien
function secure_transfer() {
    echo -e "${GREEN}Beginne mit dem sicheren Dateitransfer...${NC}"

    # Konfigurationswerte aus config.toml laden
    load_config "transfer"

    source_file=${source_file:-"/path/to/your/source/file"}
    destination_path=${destination_path:-"user@remotehost:/path/to/your/destination"}
    ssh_key=${ssh_key:-"/path/to/your/private/key"}

    # Sicheren Transfer durchführen
    scp -i "$ssh_key" "$source_file" "$destination_path"

    echo -e "${GREEN}Datei wurde sicher übertragen nach: $destination_path${NC}"
}

# Starte den sicheren Dateitransfer
secure_transfer

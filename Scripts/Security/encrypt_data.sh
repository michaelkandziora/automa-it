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

# Funktion zur Verschlüsselung von Daten
function encrypt_data() {
    echo -e "${GREEN}Beginne mit der Datenverschlüsselung...${NC}"

    # Konfigurationswerte aus config.toml laden
    load_config "encryption"

    input_path=${input_path:-"/path/to/your/data"}  # Pfad zu den Daten
    output_path=${output_path:-"/path/to/your/encrypted/data"}  # Pfad für verschlüsselte Daten
    encryption_key=${encryption_key:-"your_encryption_key"}  # Verschlüsselungsschlüssel

    # Verschlüsselung der Daten durchführen
    openssl enc -aes-256-cbc -salt -in "$input_path" -out "$output_path" -k "$encryption_key"

    echo -e "${GREEN}Daten wurden erfolgreich verschlüsselt und gespeichert in: $output_path${NC}"
}

# Starte die Datenverschlüsselung
encrypt_data

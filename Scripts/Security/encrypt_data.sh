#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
source ./utils.sh

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

#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
source ./utils.sh

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

#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
source ./utils.sh

# Installation benutzerdefinierter Pakete aus der config.toml
function install_custom_packages() {
    echo -e "${GREEN}Beginne mit der Installation benutzerdefinierter Pakete...${NC}"

    # Konfigurationswerte aus config.toml laden
    load_config "apt_packages"

    # Paketliste aus der Konfigurationsdatei extrahieren
    IFS=',' read -r -a packages <<< "${apt_packages}"

    # Paketliste aktualisieren
    sudo apt-get update

    # Jedes Paket installieren
    for package in "${packages[@]}"; do
        echo -e "${YELLOW}Installiere Paket: $package${NC}"
        sudo apt-get install -y "$package"
    done

    echo -e "${GREEN}Alle benutzerdefinierten Pakete wurden erfolgreich installiert.${NC}"

    # Konfigurationsdaten speichern (optional)
    save_config "apt_packages" "installed_packages" "${apt_packages}"
}

# Starte die Installation der benutzerdefinierten Pakete
install_custom_packages

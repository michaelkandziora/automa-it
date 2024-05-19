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
    #save_config "apt_packages" "installed_packages" "${apt_packages}"
}

# Starte die Installation der benutzerdefinierten Pakete
install_custom_packages

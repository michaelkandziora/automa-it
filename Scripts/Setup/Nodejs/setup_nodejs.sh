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

# Installation und Konfiguration von Node.js und npm
function setup_nodejs() {
    echo -e "${GREEN}Beginne mit der Installation von Node.js und npm...${NC}"

    # Konfigurationswerte aus config.toml laden
    load_config "node_js"

    # Node.js Version prüfen und festlegen
    node_version=${node_version:-"14.x"}  # Standardversion festlegen

    # NodeSource Repository hinzufügen und Installation durchführen
    curl -fsSL https://deb.nodesource.com/setup_$node_version | sudo -E bash -
    sudo apt-get install -y nodejs

    # Prüfen, ob Node.js und npm korrekt installiert wurden
    if command -v node > /dev/null 2>&1 && command -v npm > /dev/null 2>&1; then
        echo -e "${GREEN}Node.js und npm wurden erfolgreich installiert.${NC}"
    else
        echo -e "${RED}Fehler bei der Installation von Node.js und npm.${NC}"
        return 1  # Beendet das Skript mit einem Fehlerstatus
    fi

    # Node.js-Version in die config.toml speichern
    #save_config "node_js" "version" "$node_version"
}

# Starte die Installation von Node.js und npm
setup_nodejs

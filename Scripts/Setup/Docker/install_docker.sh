#!/bin/bash
# @TODO Beim installieren wird beim hinzufügen des GPGs Benutzer nach OK gefragt, ENTER bestätigen, fix for silent

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

# Docker Installationsskript
function install_docker() {
    echo -e "${GREEN}Beginne mit der Installation von Docker...${NC}"

    # Konfigurationswerte aus config.toml laden
    load_config "docker"

    # Installationsprozess starten
    $SUDO apt-get update
    $SUDO apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | $SUDO apt-key add -
    $SUDO add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    $SUDO apt-get update
    $SUDO apt-get install -y docker-ce

    echo "Ihren Nutzer der docker Gruppe hinzufügen, damit Sie authorisiert sind den docker Befehl zu nutzen"
    $$SUDO adduser $(whoami) docker

    echo -e "${GREEN}Docker wurde erfolgreich installiert.${NC}"
    
    # Konfigurationsdaten speichern, falls neu
    ##save_config "docker" "installed" "true"
}

# Funktionen aus der utils.sh verwenden, um die Konfiguration zu laden und zu speichern
install_docker

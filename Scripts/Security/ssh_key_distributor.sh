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

# SSH Key auf eine Liste von Servern verteilen
function distribute_ssh_key() {
    echo "Starte Verteilung des SSH-Keys..."

    # Konfigurationswerte aus config.toml laden
    load_config "ssh_distribution"

    private_key=${private_key:-"/path/to/private/key"}
    public_key=${public_key:-"${private_key}.pub"}
    hosts=( ${hosts:-"server1 server2 server3"} )

    # SSH-Key auf alle gelisteten Server verteilen
    for host in "${hosts[@]}"; do
        echo "Kopiere SSH-Key zu $host..."
        ssh-copy-id -i "$public_key" "$host"
    done

    echo "Verteilung des SSH-Keys abgeschlossen."
}

distribute_ssh_key

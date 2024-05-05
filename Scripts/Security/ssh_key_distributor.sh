#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
source ./utils.sh

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

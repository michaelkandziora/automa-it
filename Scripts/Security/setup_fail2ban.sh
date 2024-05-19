#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
source ./utils.sh

# Installation und Konfiguration von Fail2Ban
function setup_fail2ban() {
    echo -e "${GREEN}Beginne mit der Installation von Fail2Ban...${NC}"

    # Fail2Ban installieren
    sudo apt-get update
    sudo apt-get install -y fail2ban

    # Basis-Konfigurationsdatei kopieren und anpassen
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    echo "Konfiguriere Fail2Ban..."

    # Konfigurationswerte aus config.toml laden
    load_config "fail2ban"
    ban_time=${ban_time:-"3600"}  # Standard Ban-Zeit
    find_time=${find_time:-"600"}  # Zeitfenster für die Überprüfung
    max_retry=${max_retry:-"5"}  # Maximal erlaubte Versuche

    # Konfiguration aktualisieren
    sudo sed -i "s/bantime = 600/bantime = $ban_time/" /etc/fail2ban/jail.local
    sudo sed -i "s/findtime = 600/findtime = $find_time/" /etc/fail2ban/jail.local
    sudo sed -i "s/maxretry = 5/maxretry = $max_retry/" /etc/fail2ban/jail.local

    # Fail2Ban-Dienst neustarten
    sudo systemctl restart fail2ban

    echo -e "${GREEN}Fail2Ban wurde erfolgreich installiert und konfiguriert.${NC}"
    echo "Ban-Zeit: $ban_time Sekunden, Suchzeit: $find_time Sekunden, Max. Versuche: $max_retry."

    # Konfigurationsdaten speichern
    #save_config "fail2ban" "ban_time" "$ban_time"
    #save_config "fail2ban" "find_time" "$find_time"
    #save_config "fail2ban" "max_retry" "$max_retry"
}

# Starte die Installation und Konfiguration von Fail2Ban
setup_fail2ban

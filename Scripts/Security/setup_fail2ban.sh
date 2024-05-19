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

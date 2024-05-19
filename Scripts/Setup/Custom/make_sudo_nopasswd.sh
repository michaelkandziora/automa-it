#!/bin/bash

# Funktion zur Überprüfung, ob das Skript mit root-Rechten ausgeführt wird
function check_root {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Dieses Skript muss mit root-Rechten ausgeführt werden."
        exit 1
    fi
}

# Überprüfen, ob das Skript mit root-Rechten ausgeführt wird
check_root

# Pfad zur sudoers-Datei
SUDOERS_FILE="/etc/sudoers"

# Backup der sudoers-Datei erstellen
cp $SUDOERS_FILE ${SUDOERS_FILE}.bak

# Funktion zum Hinzufügen von NOPASSWD zu einer Gruppe
function add_nopasswd {
    GROUP=$1
    # Überprüfen, ob die Gruppe in der sudoers-Datei existiert
    if grep -q "%${GROUP}" $SUDOERS_FILE; then
        # Überprüfen, ob bereits NOPASSWD gesetzt ist
        if ! grep -q "%${GROUP} ALL=(ALL) NOPASSWD: ALL" $SUDOERS_FILE; then
            echo "Füge NOPASSWD zu Gruppe ${GROUP} hinzu"
            echo "%${GROUP} ALL=(ALL) NOPASSWD: ALL" >> $SUDOERS_FILE
        else
            echo "NOPASSWD ist bereits für Gruppe ${GROUP} gesetzt"
        fi
    else
        echo "Gruppe ${GROUP} ist nicht in der sudoers-Datei vorhanden"
    fi
}

# Liste der gängigen sudo-Gruppen unter Linux
SUDO_GROUPS=("sudo" "wheel" "admin")

# Hinzufügen von NOPASSWD zu den vorhandenen sudo-Gruppen
for GROUP in "${SUDO_GROUPS[@]}"; do
    add_nopasswd $GROUP
done

echo "Das Skript wurde erfolgreich ausgeführt."

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

# Variablen für die URL des Docker GPG-Schlüssels und den neuen Speicherort
DOCKER_GPG_URL="https://download.docker.com/linux/ubuntu/gpg"
DOCKER_GPG_KEYRING="/etc/apt/trusted.gpg.d/docker-archive-keyring.gpg"

# Entferne alte Docker-Schlüssel aus dem veralteten Schlüsselbund
$SUDO apt-key del $($$SUDO apt-key list | grep -A 1 "Docker" | grep "pub" | awk '{print $2}' | cut -d'/' -f2)
check_success "Alte Docker-Schlüssel konnten nicht entfernt werden."

# Füge den Docker GPG-Schlüssel in den neuen Speicherort ein
curl -fsSL $DOCKER_GPG_URL | $$SUDO gpg --dearmor -o $DOCKER_GPG_KEYRING
check_success "Docker GPG-Schlüssel konnte nicht heruntergeladen oder gespeichert werden."

# Aktualisiere die Paketliste
$SUDO apt update
check_success "Paketliste konnte nicht aktualisiert werden."

echo "Der Docker GPG-Schlüssel wurde erfolgreich aktualisiert und die Paketliste wurde neu geladen."

## Function to print error and exit
#error_exit() {
#    echo "$1" >&2
#    exit 1
#}
#
#
## List apt keys and search for Docker key
#APT_KEY_OUTPUT=$($$SUDO apt-key list)
#DOCKER_KEY=$(echo "$APT_KEY_OUTPUT" | awk '/Docker Release/ {getline; print substr($1, length($1)-7)}')
#
## Check if Docker key exists
#if [ -z "$DOCKER_KEY" ]; then
#    error_exit "No GPG key for Docker found in apt-key list."
#fi
#
## Export Docker key
#$$SUDO apt-key export "$DOCKER_KEY" | $$SUDO gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
#if [ $? -eq 0 ]; then
#    echo "Key $DOCKER_KEY has been exported to /etc/apt/trusted.gpg.d/docker.gpg."
#else
#    error_exit "Failed to export key $DOCKER_KEY."
#fi
#
## Delete Docker key from trusted.gpg
#$$SUDO apt-key --keyring /etc/apt/trusted.gpg del "$DOCKER_KEY"
#if [ $? -eq 0 ]; then
#    echo "Key $DOCKER_KEY has been removed from /etc/apt/trusted.gpg."
#else
#    error_exit "Failed to remove key $DOCKER_KEY from /etc/apt/trusted.gpg."
#fi

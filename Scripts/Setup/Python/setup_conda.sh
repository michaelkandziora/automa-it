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

# Installation und Konfiguration von Conda
function setup_conda() {
    echo -e "${GREEN}Beginne mit der Installation von Conda...${NC}"

    # Miniconda Installer herunterladen und installieren
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
    bash ~/miniconda.sh -b -p $HOME/miniconda

    # Conda initialisieren
    eval "$($HOME/miniconda/bin/conda shell.bash hook)"
    conda init

    # Erstellen einer neuen Conda-Umgebung mit Python 3.8
    conda create --name myenv python=3.8 -y

    # Conda-Umgebung aktivieren
    conda activate myenv

    echo -e "${GREEN}Conda und Python 3.8 wurden erfolgreich installiert.${NC}"
    echo "Eine neue Conda-Umgebung namens 'myenv' mit Python 3.8 ist erstellt und aktiviert worden."

    # Konfigurationsdaten speichern
    #save_config "python" "conda_env" "myenv"
    #save_config "python" "python_version" "3.8"
}

# Starte die Installation von Conda und Python
setup_conda

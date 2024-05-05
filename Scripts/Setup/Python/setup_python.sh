#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
source ./utils.sh

# Installation und Konfiguration von pyenv und Python
function setup_python() {
    echo -e "${GREEN}Beginne mit der Installation von pyenv und Python...${NC}"

    # Abhängigkeiten für pyenv und Python-Build installieren
    sudo apt-get update
    sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

    # Installiere pyenv
    curl https://pyenv.run | bash

    # Pyenv in die Shell integrieren
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    # Python-Versionen installieren und global setzen
    pyenv install 3.8.5
    pyenv install 3.7.8
    pyenv global 3.8.5

    echo -e "${GREEN}pyenv und Python wurden erfolgreich installiert.${NC}"
    echo "Python 3.8.5 und 3.7.8 sind verfügbar und 3.8.5 ist als globale Version eingestellt."

    # Konfigurationsdaten speichern
    save_config "python" "pyenv_version" "3.8.5, 3.7.8"
    save_config "python" "global_version" "3.8.5"
}

# Starte die Installation von pyenv und Python
setup_python

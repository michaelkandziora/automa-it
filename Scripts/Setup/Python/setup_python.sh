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

    # Funktion zum Einfügen des Textes in eine Datei, falls der Text noch nicht existiert
    add_to_file() {
    file="$1"
    grep -qF -- "$text_to_add" "$file" || echo "$text_to_add" >> "$file"
    }

    text_to_add="                               \
    # Pyenv in die Shell integrieren            \
    export PATH=\"\$HOME/.pyenv/bin:\$PATH\"    \
    eval \"\$(pyenv init -)\"                   \
    eval \"\$(pyenv virtualenv-init -)\"        \
    "

    # Füge Text zu .bashrc hinzu, falls die Datei existiert
    if [ -f "$HOME/.bashrc" ]; then
    add_to_file "$HOME/.bashrc"
    fi

    # Füge Text zu .zshrc hinzu, falls die Datei existiert
    if [ -f "$HOME/.zshrc" ]; then
    add_to_file "$HOME/.zshrc"
    fi

    text_to_add="                            \
    export PYENV_ROOT=\"\$HOME/.pyenv\"      \
    export PATH=\"\$PYENV_ROOT/bin:\$PATH\"  \
    eval \"\$(pyenv init \-\-path)\"         \
    eval \"\$(pyenv virtualenv-init -)\"     \
    "

    # Füge Text zu .bashrc hinzu, falls die Datei existiert
    if [ -f "$HOME/.profile" ]; then
    add_to_file "$HOME/.profile"
    fi

    # Füge Text zu .zshrc hinzu, falls die Datei existiert
    if [ -f "$HOME/.zprofile" ]; then
    add_to_file "$HOME/.zprofile"
    fi
}

function select_versions() {
    # Get the list of available versions from pyenv
    mapfile -t versions < <(pyenv install --list | sed 's/^[ \t]*//;s/[ \t]*$//' | grep -v -e 'Available' -e '^$' | grep -v -- '-dev')

    # Declare an associative array to hold the latest version for each major release or distribution
    declare -A latest_versions

    # Function to compare versions
    version_compare() {
        local IFS=.
        local i ver1=($1) ver2=($2)

        # Fill empty fields in ver1 with zeros
        for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
            ver1[i]=0
        done

        for ((i=0; i<${#ver1[@]}; i++)); do
            if [[ ! "${ver1[i]}" =~ ^[0-9]+$ || ! "${ver2[i]}" =~ ^[0-9]+$ ]]; then
                [[ "${ver1[i]}" < "${ver2[i]}" ]] && return 1
                [[ "${ver1[i]}" > "${ver2[i]}" ]] && return 2
                continue
            fi
            if ((10#${ver1[i]} < 10#${ver2[i]})); then
                return 1
            elif ((10#${ver1[i]} > 10#${ver2[i]})); then
                return 2
            fi
        done

        return 0
    }

    # Iterate over the versions to populate the associative array with the latest version of each type
    for version in "${versions[@]}"; do
        # Extract the base identifier before the version number, if applicable
        base_version=$(echo "$version" | grep -oE '^[a-z]+[a-z0-9\-]*')
        [[ -z "$base_version" ]] && base_version=$(echo "$version" | grep -oE '^[0-9]+\.[0-9]+')

        # Determine the current latest version stored and update if the current one is newer
        if [[ -z "${latest_versions[$base_version]}" ]]; then
            latest_versions["$base_version"]="$version"
        else
            version_compare "$version" "${latest_versions[$base_version]}"
            if [[ $? -eq 2 ]]; then
                latest_versions["$base_version"]="$version"
            fi
        fi
    done

    # Sort the keys of the associative array alphabetically and store them in an array
    IFS=$'\n' sorted_keys=($(sort <<<"${!latest_versions[*]}"))
    unset IFS

    # Display the sorted and unique latest versions with menu options
    echo "Select the version to install:"
    index=1
    for key in "${sorted_keys[@]}"; do
        echo "$index) ${latest_versions[$key]}"
        index=$((index + 1))
    done

    # Array to keep track of the user choices for version numbers
    read -p "Enter the numbers of the versions to install (separated by space): " -a selections

    # Install selected versions
    for selection in "${selections[@]}"; do
        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -le "${#sorted_keys[@]}" ]; then
            version_to_install="${latest_versions[${sorted_keys[$((selection-1))]}]}"
            echo "Installing $version_to_install..."
            pyenv install "$version_to_install"
        else
            echo "Invalid selection: $selection"
        fi
    done

}

# Starte die Installation von pyenv und Python
setup_python

## Python-Versionen installieren und global setzen
select_versions
echo "Bitte definiere mit 'pyenv global <VERSION>' deine gewünschte globale Python Version"

## Konfigurationsdaten speichern
##save_config "python" "pyenv_version" "3.8.5, 3.7.8"
##save_config "python" "global_version" "3.8.5"





# Folgende Rückmeldung in Console gesehen, @TODO

# Found pyenv, but it is badly configured (pyenv command not found in $PATH). pyenv might not
# work correctly for non-interactive shells (for example, when run from a script).
# 
# To fix this message, add these lines to the '.profile' and '.zprofile' files
# in your home directory:
# 
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init --path)"
# 
# You'll need to restart your user session for the changes to take effect.
# For more information go to https://github.com/pyenv/pyenv/#installation.
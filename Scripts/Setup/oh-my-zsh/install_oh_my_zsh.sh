#!/bin/bash

# Debugging aktivieren
set -e

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
echo "Aktuelles Verzeichnis: $(pwd)" # show me current working directory, I guess script can't find ./utils.sh file

# Überprüfen der benötigten Befehle
required_commands=("curl" "git" "zsh")
missing_commands=()
for cmd in "${required_commands[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        missing_commands+=("$cmd")
    fi
done

if [[ ${#missing_commands[@]} -ne 0 ]]; then
    echo "Folgende Befehle fehlen: ${missing_commands[*]}"
    if [[ $silent_mode == true ]] || [[ $(ask_yes_no "Möchten Sie die fehlenden Befehle jetzt installieren?" "y") == 0 ]]; then
        if is_root; then
            apt-get update && apt-get install -y "${missing_commands[@]}"
        else
            if [[ $silent_mode == true ]]; then
                # Im Silent-Modus, überprüfe ob sudo ohne Passwort verwendet werden kann
                if sudo -ln &>/dev/null; then
                    sudo apt-get update && sudo apt-get install -y "${missing_commands[@]}"
                else
                    echo "Sudo benötigt ein Passwort. Bitte führen Sie das Skript mit Root-Rechten oder ohne Silent-Modus aus."
                    exit 1
                fi
            else
                # Im nicht-silent Modus, lassen wir die Standard-Sudo-Passwortabfrage zu
                sudo apt-get update && sudo apt-get install -y "${missing_commands[@]}"
            fi
        fi
    else
        echo "Installation abgebrochen."
        exit 1
    fi
fi

# Überprüfen, ob eine .zshrc-Datei existiert und ob eine Sicherungskopie erstellt werden soll
if [[ -f "$HOME/.zshrc" ]]; then
    if [[ $silent_mode == false && $(ask_yes_no "Möchten Sie eine Sicherheitskopie Ihrer .zshrc erstellen?" "y") == 0 ]] || [[ $silent_mode == true ]]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
        echo "Eine Sicherungskopie wurde als .zshrc.bak erstellt."
    fi
fi

# Oh My Zsh Installation starten
echo "Beginne mit der Installation von Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo "Oh My Zsh wurde erfolgreich installiert."

# Zsh zur Liste der erlaubten Shells hinzufügen und als Standardshell setzen
if ! grep -q "/usr/bin/zsh" /etc/shells; then
    echo "/usr/bin/zsh" | sudo tee -a /etc/shells
fi
chsh -s $(which zsh)

echo "Zsh wurde als Standardshell gesetzt. Bitte melden Sie sich ab und wieder an, um die Änderungen zu übernehmen."

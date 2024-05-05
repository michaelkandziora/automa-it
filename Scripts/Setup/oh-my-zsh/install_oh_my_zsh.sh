#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
source ./utils.sh

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
    if [[ $silent_mode == false && $(ask_yes_no "Möchten Sie die fehlenden Befehle jetzt installieren?" "y") == 0 ]] || [[ $silent_mode == true ]]; then
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
echo -e "${GREEN}Beginne mit der Installation von Oh My Zsh...${NC}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo -e "${GREEN}Oh My Zsh wurde erfolgreich installiert.${NC}"

# Starte die Konfiguration
# customize_omz.sh  # Annahme: Dieses Skript wird später erstellt und angepasst.


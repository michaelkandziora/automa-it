#!/bin/bash

# Globale Variable für den Debug-Modus
debug_mode=false
feedback_mode=true

# Initialisierung der Skriptoptionen
while [[ "$1" != "" ]]; do
    case $1 in
        --silent) silent_mode=true; feedback_mode=false ;;
        --debug) debug_mode=true ;;
        *) echo "Fehler unbekannte Option: $1" ;;
    esac
    shift
done

# Check for root or $SUDO privileges
if [ "$EUID" -ne 0 ]; then
    $SUDO="$SUDO"
else
    $SUDO=""
fi

# Funktion, um zu überprüfen, ob das Skript als Root ausgeführt wird
function is_root() {
    if [[ $(id -u) -eq 0 ]]; then
        return 0
    else
        return 1
    fi
}

# Funktion zur Überprüfung, ob ein Befehl erfolgreich ausgeführt wurde
function check_success() {
    if [ $? -ne 0 ]; then
        echo "Fehler: $1"
        exit 1
    fi
}

# Funktion zur Bereinigung des Eingabepuffers
function clear_input() {
    read -t 0.1 -n 10000 discard  # Versucht, alle wartenden Eingaben zu verwerfen
}

# Hilfsfunktion für Ja/Nein-Fragen
function ask_yes_no() {
    local prompt=$1
    local default=${2:-y}  # Standardwert auf 'y' setzen, wenn nichts übergeben wird
    local answer
    local choices="[y/N]"

    # Update choices based on default value
    if [[ "$default" == "y" ]]; then
        choices="[Y/n]"
    else
        choices="[y/N]"
    fi

    if [[ $silent_mode == true ]]; then
        return 0  # Immer 'ja' im silent mode
    fi

    clear_input  # Bereinigen Sie den Eingabepuffer vor der Eingabeaufforderung
    while true; do
        read -p "$prompt $choices: " answer
        case "$answer" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            "" ) if [[ "$default" == "y" ]]; then return 0; else return 1; fi;;
            * ) echo "Bitte antworten Sie mit 'y' oder 'n'.";;
        esac
    done
}

function check_command() {
    local command=$1

    if command -v "$command" &> /dev/null; then
        [[ $feedback_mode == true ]] && echo "+ $command ist ein gültiger Befehl."
        return 0
    fi

    [[ $feedback_mode == true ]] && echo "+ '$command' wurde nicht gefunden"
    return 1
}

function install_pip() {
    local command=$1

    # Setze wenn Parameter
    if [[ -n $2 ]] && [[ $2 == "y" ]];then
        local silent_status="$silent_mode"
        silent_mode=true
    fi

    if [[ $silent_mode == true ]]; then
        pip install --break-system-packages $command > /dev/null 2>&1
        error_code=$?
        if [[ $error_code != 0 ]]; then 
            [[ $debug_mode == true ]] && echo " pip error code $error_code"
            return 1
        fi
    else
        pip install --break-system-packages $command
        error_code=$?
        if [[ $error_code != 0 ]]; then 
            [[ $debug_mode == true ]] && echo " pip error code $error_code"
            return 1
        fi
    fi

    # Zurücksetzen der Manipulation
    if [[ -n $silent_status ]];then
        silent_mode=$silent_status
    fi
}

function install_apt() {
    local command=$1

    # Setze wenn Parameter
    if [[ -n $2 ]] && [[ $2 == "y" ]];then
        local silent_status="$silent_mode"
        silent_mode=true
    fi

    if [[ "$silent_mode" != "true" ]] && ! $(ask_yes_no "Befehl '$command' installieren?" "n"); then
        [[ $debug_mode == true ]] && echo " abfrage verneint, Befehl $command wird nicht installiert"
        return 1
    fi

    if [[ $silent_mode == true ]]; then
        # Silent Mode aktiv und ROOT
        if is_root; then
            [[ $debug_mode == true ]] && echo " (root): apt-get install -y '$command'"
            apt-get update > /dev/null 2>&1 && apt-get install -y "$command" > /dev/null 2>&1
            error_code=$?
            if [[ $error_code != 0 ]]; then 
                [[ $debug_mode == true ]] && echo " (root): apt error code $error_code"
                return 1
            fi
        # Silent Mode aktiv und nicht ROOT aber kann $SUDO silent ausführen
        elif $SUDO -ln &>/dev/null; then
            [[ $debug_mode == true ]] && echo " (silent): apt-get install -y '$command'"
            $SUDO apt-get update > /dev/null 2>&1 && $SUDO apt-get install -y "$command" > /dev/null 2>&1
            error_code=$?
            if [[ $error_code != 0 ]]; then 
                [[ $debug_mode == true ]] && echo " (slient): apt error code $error_code"
                return 1
            fi
        # Silent Mode aktiv und nicht ROOT und kann $SUDO NICHT silent ausführen
        else
            # ERROR mit schlüssiger Erklärung
            echo "Der Befehl $command wurde nicht gefunden und das Skript versucht diesen für Sie zu installieren, da das Silent-Flag gesetzt wurde."
            echo "Das Skript wurde nicht mit ROOT rechten gestartet. Ihr System ist nicht konfiguriert den $SUDO Prefix 'silent' ohne Benutzerinteraktion auszuführen."
            echo "$SUDO benötigt ein Passwort. Bitte führen Sie das Skript mit Root-Rechten oder ohne Silent-Flag aus."
            echo ""
            return 1
        fi
    # Silent Mode nicht aktiv
    else
        # ROOT
        if is_root; then
            [[ $debug_mode == true ]] && echo " (root) apt-get install -y '$command'"
            apt-get update && apt-get install -y "$command"
            error_code=$?
            if [[ $error_code != 0 ]]; then 
                [[ $debug_mode == true ]] && echo " (root): apt error code $error_code"
                return 1
            fi
        # USER
        else
            [[ $feedback_mode == true ]] && echo "Eventuell müssen Sie zum installieren von '$command' ihr Passwort eingeben"
            [[ $debug_mode == true ]] && echo " (user) $SUDO apt-get install -y '$command'"
            $SUDO apt-get update && $SUDO apt-get install -y "$command"
            error_code=$?
            if [[ $error_code != 0 ]]; then 
                [[ $debug_mode == true ]] && echo " (user) apt error code $error_code"
                return 1
            fi
        fi
    fi

    # Zurücksetzen der Manipulation
    if [[ -n $silent_status ]];then
        silent_mode=$silent_status
    fi

    # Sind wir hier angekommen, sollte der gewünschte Befehl installiert worden sein
    return 0
}
# Funktion zum überprüfen auf vorhanden sein und installieren von Befehlen
function check_and_install_command() {
    local command=$1

    check_command "$command" || install_apt "$command" || return 1; return 0

}

function load_config() {
    local section=$1
    local -n config_ref=$2  # Verwende Namensreferenz für das übergebene Array

    if [[ -f "config.toml" ]]; then
        local section_content=$(sed -n "\#^\[$section\]#,/^$/p" config.toml | grep -v "^\[$section\]")
        [[ $debug_mode == true ]] && echo " eingelesener Sektor-Inhalt:"
        [[ $debug_mode == true ]] && echo " $section_content"

        while IFS=';' read -r key value; do
            key=$(echo "$key" | xargs)                      # Entfernt führende/abschließende Leerzeichen
            value=$(echo "$value" | xargs)                  # Entfernt führende/abschließende Leerzeichen
            config_ref["$key"]=$value
        done < <(echo "$section_content" | awk -F' = ' '{
            sub(/#.*/, "");                                 # Entfernt Kommentare nach #
            key = $1;                                       # Setzt alles aus $section_content vor gleich
            gsub(/^[ \t]+|[ \t]+$/, "", key);               # Trim Schlüssel
            $1 = "";                                        # leere 
            value = $0;                                     # Setzt alles aus $section_content nach gleich
            gsub(/^[ \t]*=[ \t]*/, "", value);              # Entferne das erste gleich und führende o trailing Leerzeichen
            gsub(/"/, "", value);                           # Entferne Anführungszeichen
            if (length(key) > 0 && length(value) > 0) {     # Prüfe Gültigkeit Key/Value Paare
                print key ";" value;                        # Gebe mit semikolon separator zurück
            }
        }')
    fi
}





# Auswertung der Skriptoptionen
for option in "$@"; do
    case $option in
        --silent) silent_mode=true; feedback_mode=false ;;
        --debug) debug_mode=true ;;
        *) echo "Fehler unbekannte Option: $option" && exit 1 ;;
    esac
done

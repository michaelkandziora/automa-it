#!/bin/bash
set -e 

#######
# Farbcodes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Hilfsfunktionen definieren
function cleanup() {
    echo "Bereinige und lösche temporäres Verzeichnis: $tmp_dir"
    rm -rf "$tmp_dir"
}

function print_offset() {
    offset="                                       "
    echo -e "$offset|  $1"
}

function print_error() {
    print_offset "${RED}..E.R.R.O.R..${NC}"
    print_offset "${RED}›$1${NC}"
}
#######
# Ermittle die Breite des Terminalfensters
# und prüfe, ob die Breite kleiner als 200 Zeichen ist
#terminal_width=$(tput cols)
#if [[ "$terminal_width" -lt 200 ]]; then
#    echo -e "${RED}Fehler: Das Terminalfenster muss mindestens 200 Zeichen breit sein.${NC}"
#    exit 1
#fi
read terminal_rows terminal_width < <(stty size)
if [[ "$terminal_width" -lt 200 ]] || [[ "$terminal_rows" -lt 50 ]]; then
    echo "Fehler: Das Terminalfenster muss mindestens 200 Zeichen breit und 50 Zeilen hoch sein."
    exit 1
fi

#######
# Überprüfung, ob das Verzeichnis als Parameter übergeben und es existiert
if [[ -z "$1" ]]; then
    print_error "Kein Verzeichnis als Argument übergeben."
    exit 1
fi

if [[ ! -d "$1" ]]; then
    print_error "Das Verzeichnis '$1' existiert nicht oder ist nicht erreichbar."
    exit 1
fi

#######
# Setze tmp_dir auf den übergebenen Pfad
#if [[ "$(pwd)" == "$(realpath "$1")" ]]; then Auf dem MacOS hat der realpath von /var/.. /private/var/...
if [[ "$(realpath "$(pwd)")" == "$(realpath "$1")" ]]; then
    root_dir=$(pwd)  # Verwenden von pwd, um das aktuelle Verzeichnis zu setzen
    is_mainpath="true"
else
    is_mainpath="false"

    if [[ -d $1 ]]; then
        # Überprüfen, ob das übergebene Verzeichnis relativ zum aktuellen Pfad existiert
        full_path=$(pwd)
        # Entferne den übergebenen Unterordner aus dem Pfad
        root_dir=$(echo "$full_path" | sed "s|/$1||")
    else
        echo "Das angegebene Verzeichnis '$1' existiert nicht."
        exit 1
    fi
	
fi

echo "Root-Verzeichnis ist gesetzt auf: $root_dir"
tmp_dir="$1"
# alternative lösung für uppercase chars, da ^^ nicht immer funktioniert
tmp_dir_upper=$(echo "$tmp_dir" | tr '[:lower:]' '[:upper:]')

#######
# Hauptfunktionen
function print_head() {
    header_logo="$root_dir/header.sh"
    if [[ -f "$header_logo" ]]; then
        source "$header_logo"
        echo ""
        print_offset "${YELLOW}Willkommen,${NC}"
        print_offset "${YELLOW}die nachfolgenden Optionen ermöglichen es per Auswahl schnell die gewünschte Umgebung zu installieren!${NC}"
        print_offset "${YELLOW}${NC}"
        print_offset "${YELLOW}Jedes dieser Scripte muss modular gehalten werden und einzeln ausführbar sein, ${NC}"
        print_offset "${YELLOW}dieses Menü dient nur dazu evtl. mehrere Konfigurationsschritte in einem Rutsch durchzuführen.${NC}"
        print_offset "${YELLOW}${NC}"
        print_offset "${YELLOW}Vielen Dank für die Nutzung!${NC}"
        print_offset "${YELLOW}Github: @TODO${NC}"
        print_offset "${YELLOW}${NC}"
        print_offset "${YELLOW}${NC}"
    else
        print_error "Die Header-Logo Datei wurde nicht erzeugt."
    fi
}

function create_menu() {
    menu_items=() # Initialisiere das Array

    if [[ "$is_mainpath" == "true" ]]; then
        # Liste nur Verzeichnisse im aktuellen Verzeichnis auf
        for dir in "$tmp_dir"/*/; do
            if [[ -d "$dir" ]]; then
                dirname=$(basename "$dir")
                menu_items+=("$dirname")
            fi
        done
    else
        # Generiere Menüpunkte basierend auf den extrahierten Dateien
        for script_file in "$tmp_dir"/*.sh; do
            if [[ -f "$script_file" ]]; then
                filename=$(basename "$script_file")
                menu_items+=("$filename")
            fi
        done
    fi
}


function show_menu() {
    print_head

    #if ! $is_mainpath; then print_offset "${GREEN}--- ${tmp_dir^^} ---${NC}"; fi
	if ! $is_mainpath; then print_offset "${GREEN}--- $tmp_dir_upper ---${NC}"; fi
		
    for i in "${!menu_items[@]}"; do
        print_offset "$((i+1)). ${menu_items[$i]}"
    done
    print_offset "0. Exit"

    #while true; do
    read -rp "$offset    Bitte wählen Sie eine Option: " choice
    #echo "Aktuelle Wahl: $choice"
    #echo "Menu exit requested: $menu_exit_requested"

    case $choice in
        0) 
            echo "Exit"
            menu_exit_requested="true"
            #break
            ;;
        [1-${#menu_items[@]}])
            selected_item="${menu_items[$((choice-1))]}"
            print_offset "Das ausgewählte Element ist: $selected_item"
            if [[ "$is_mainpath" == "true" ]]; then
                print_offset "Aufrufen des Skripts mit Verzeichnisparameter: $selected_item"
                bash "$0" "$selected_item"
            else
                bash "$tmp_dir/$selected_item"
            fi
            # Kein `break` hier, damit das Menü erneut angezeigt wird
            ;;
        *)
            print_error "Ungültige Option. Bitte versuchen Sie es erneut." 
            print_offset "Kehre zurück in 3 Sekunden..."
            sleep 3
            ;;
    esac

    #echo "Aktuelle Wahl: $choice"
    #echo "Menu exit requested: $menu_exit_requested"

    #done
}


#######
# MAIN
#trap cleanup EXIT INT

while true; do
    #clear
    create_menu
    show_menu
    if [[ "$menu_exit_requested" == "true" ]]; then
        break
    fi
done




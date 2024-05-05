#!/bin/bash
# wget -O - https://rocknroll.0b0111.xyz | bash -
#set -e # Abbruch wenn eines der Behfehle fehlschlägt
set -e

curr_dir=$(pwd) #Speichere aktuellen Ort zwischen

tmp_dir=$(mktemp -d) #Erzeuge Temporäres Verzeichnis
echo "Erstelle temporäres Verzeichnis: $tmp_dir"

# BASE64 DATA START
tar64="{{TAR_ARCHIVE_BASE64}}"
# BASE64 DATA END

# Funktion zum Dekodieren und Entpacken der Daten in einem temporären Verzeichnis
function extract_script() {
    # Vorherige Lösung das Zwischen BASE64 START UND END befindliche zu entpacken misslingt, 
    # Fehler Filename too long.. es wurd Base64 dargestellt keine Ahnung woher er ein Base64 ausdruck als filename nimmt, 
    # vermutung irgendwo verbergen sich '/' Zeichen und vlt wird das als file input interpretiert 
    #echo $(sed -n '/^# BASE64 DATA START$/,/^# BASE64 DATA END$/p' $0 | sed '/^#/d') | base64 -d | tar -xz -C "$tmp_dir"
    echo $tar64 | base64 -d | tar -x -C "$tmp_dir"
    echo "Skripte entpackt in: $tmp_dir"
    #export script_dir="$tmp_dir"
}


function cleanup() {
    echo "Bereinige und lösche temporäres Verzeichnis: $tmp_dir"
    cd $curr_dir # gehe zurück zum ursprünglichen Verzeichnis
    rm -rf "$tmp_dir" # lösche das temporäre Verzeichnis
}


# Temporäres Verzeichnis löschen, wenn das Skript beendet wird
trap cleanup EXIT INT

#######
# MAIN
# menu.sh kann zwar mit seinen Funktionen das Hauptmenü bauen, 
# es steuert aber mehr autonom die untermenüs,
# die main-loop mit dem HAUPTMENÜ muss hier in dem install.sh laufen!
extract_script


cd $tmp_dir #working_directory
bash menu.sh $tmp_dir < /dev/tty > /dev/tty #stty stdin und stdout auf tty umleiten

cd $curr_dir
#source $tmp_dir/main.sh
#main
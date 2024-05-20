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

# Backup Tool installieren
function install() {
    [[ $feedback_mode == true ]] && echo -e "Beginne mit der Installation..."
    requirement="timeshift"

    if ! check_command $requirement; then
        if is_root; then install_apt $requirement "y"; else install_apt $requirement; fi
        check_success "$requirement konnte nicht installiert werden."
        
        [[ $feedback_mode == true ]] && echo "+ '$requirement' wurde installiert"
    else
        [[ $feedback_mode == true ]] && echo "+ '$requirement' ist bereits installiert"
    fi

    # @TODO installier logik checken, installieren, feedback kann nach utils ausgelagert werden, is immer gleich
    
}

# Funktion zur Durchführung des Backups
function perform_backup() {
    [[ $feedback_mode == true ]] && echo -e "Beginne mit dem ersten Snapshot..."

    key=$(date +%F)
    $SUDO timeshift --create --comments "snapshot_$key"
    check_success "Snapshot konnte nicht erstellt werden."

    [[ $feedback_mode == true ]] && echo "+ Snapshot 'snapshot_$key' wurde erfolgreich erstellt"

    [[ $feedback_mode == true ]] && echo "Nutze 'sudo timeshift --create --comments \"snapshot_BEZEICHNUNG\"' um einen Snapshot zu erstellen."
    [[ $feedback_mode == true ]] && echo "Nutze 'sudo timeshift --list' um eine Liste aller erstellten Snapshots zu erhalten."

    
    # Backup-Konfiguration speichern @TODO
    #save_config "backup" "last_backup" "$(date +%F-%T)"
    #save_config "backup" "source" "$backup_sources"
    #save_config "backup" "target" "$backup_target_dir"
}

# Starte das Backup
install
perform_backup

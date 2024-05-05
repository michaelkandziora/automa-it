#!/bin/bash

# System Cleanup Skript
function system_cleanup() {
    echo "Starte System Cleanup..."

    # Zeitstempel einlesen
    timestamp=${1:-$(date +%s)}  # Aktuelles Datum als Standard, wenn kein Argument übergeben wird

    # Lösche alte Logdateien
    find /var/log -type f -mtime +$(( ( $(date +%s) - $timestamp ) / 86400 )) -exec rm -f {} \;

    # Lösche alte Benutzerlogins und History, wenn Dateien älter als der Zeitstempel sind
    find /home -name ".bash_history" -mtime +$(( ( $(date +%s) - $timestamp ) / 86400 )) -exec rm -f {} \;

    echo "System Cleanup abgeschlossen."
}

# Ausführen des Cleanups mit optional übergebenem Zeitstempel (in Sekunden seit dem 01.01.1970)
system_cleanup $1

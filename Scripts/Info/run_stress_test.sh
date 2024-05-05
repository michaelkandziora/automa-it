#!/bin/bash

# Installation von stress-ng, falls noch nicht installiert
if ! command -v stress-ng &> /dev/null
then
    echo "stress-ng ist nicht installiert. Installation wird durchgeführt..."
    sudo apt-get update
    sudo apt-get install -y stress-ng
fi

# Ausführen des Stresstests
function run_stress_test() {
    echo "Beginne Stresstest des Systems..."

    # Konfigurierbare Variablen für den Stresstest
    duration=${1:-60}  # Dauer des Stresstests in Sekunden, Standardwert ist 60 Sekunden
    cpu_load=${2:-4}   # Anzahl der CPU-Kerne, die belastet werden sollen, Standardwert ist 4

    # Starte den Stresstest
    stress-ng --cpu $cpu_load --io 2 --vm 2 --vm-bytes 128M --timeout ${duration}s

    echo "Stresstest abgeschlossen."
    echo "Bewertung des Systems wird durchgeführt..."

    # Einfache Bewertung der Systemreaktion
    # Hier könnte eine detailliertere Analyse der Systemprotokolle oder der Hardwareauslastung stattfinden
    dmesg | grep -i oom-killer
    if [ $? -eq 0 ]; then
        echo "Warnung: Der Out-of-Memory-Killer wurde während des Tests aktiviert."
    else
        echo "Keine kritischen Fehler während des Stresstests festgestellt."
    fi
}

# Parameter: Dauer in Sekunden, CPU-Last
run_stress_test $1 $2

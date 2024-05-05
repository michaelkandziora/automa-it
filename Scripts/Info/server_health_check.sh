#!/bin/bash

# Grundlegende Gesundheitsüberprüfung des Servers
function server_health_check() {
    echo "Starte Server Health Check..."

    # CPU Auslastung prüfen
    echo "CPU Auslastung:"
    uptime

    # Speicherplatz prüfen
    echo "Speicherplatz:"
    df -h

    # Überprüfung des Dienststatus
    echo "Status des Nginx-Dienstes:"
    systemctl status nginx | grep "Active"

    echo "Server Health Check abgeschlossen."
}

server_health_check

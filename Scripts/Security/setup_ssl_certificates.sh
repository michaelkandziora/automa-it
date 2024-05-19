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

# Basis-Setup für CA und Zertifikate
function setup_ssl_ca_and_certificates() {
    echo -e "${GREEN}Beginne mit dem Setup der SSL/TLS Zertifikate und CA...${NC}"

    # Konfigurationswerte aus config.toml laden
    load_config "ssl"

    # CA-Daten aus der Konfiguration extrahieren
    ca_name=${ca_name:-"MyCA"}
    ca_key="${ca_name}.key"
    ca_cert="${ca_name}.crt"

    # Erstellen des CA-Schlüssels
    echo "Erstelle CA-Schlüssel..."
    openssl genrsa -out "$ca_key" 2048

    # Erstellen des CA-Zertifikats
    echo "Erstelle CA-Zertifikat..."
    openssl req -x509 -new -nodes -key "$ca_key" -sha256 -days 1024 -out "$ca_cert" -subj "/CN=$ca_name"

    # Zertifikate aus der Konfiguration erstellen
    for cert in ${certificates[*]}; do
        echo "Erstelle Zertifikat für: $cert..."
        key_file="${cert}.key"
        csr_file="${cert}.csr"
        cert_file="${cert}.crt"

        # Generiere einen privaten Schlüssel für das Zertifikat
        openssl genrsa -out "$key_file" 2048

        # Generiere einen CSR (Certificate Signing Request)
        openssl req -new -key "$key_file" -out "$csr_file" -subj "/CN=$cert"

        # Signiere den CSR mit der CA, um das Zertifikat zu erhalten
        openssl x509 -req -in "$csr_file" -CA "$ca_cert" -CAkey "$ca_key" -CAcreateserial -out "$cert_file" -days 500 -sha256

        echo "Zertifikat für $cert wurde erstellt und signiert."
    done

    echo -e "${GREEN}Alle SSL/TLS Zertifikate wurden erfolgreich erstellt und signiert.${NC}"
}

# Starte das Setup
setup_ssl_ca_and_certificates

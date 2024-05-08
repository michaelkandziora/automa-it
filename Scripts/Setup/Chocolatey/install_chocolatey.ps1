# Skript zur Installation von Chocolatey auf Windows

# Funktion, um die Installation von Chocolatey durchzuführen
function Install-Chocolatey {
    Write-Host "Beginne mit der Installation von Chocolatey..."

    # Befehl zum Installieren von Chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

    if ($?) {
        Write-Host "Chocolatey wurde erfolgreich installiert."
    } else {
        Write-Host "Es gab einen Fehler bei der Installation von Chocolatey."
        exit 1
    }
}

# Hauptteil des Skripts
function Main {
    # Überprüfe das Betriebssystem
    if (-not [System.Environment]::OSVersion.VersionString -like "*Windows*") {
        Write-Host "Dieses Skript ist nur für Windows gedacht. Bitte führe es auf einem Windows-System aus."
        exit 1
    }

    # Überprüfung, ob Chocolatey bereits installiert ist
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host "Chocolatey ist bereits installiert."
        $response = Read-Host "Möchtest du Chocolatey aktualisieren? (y/n)"
        if ($response -eq 'y') {
            Write-Host "Aktualisiere Chocolatey..."
            choco upgrade chocolatey
        }
    } else {
        # Installiere Chocolatey, wenn es noch nicht installiert ist
        Install-Chocolatey
    }
}

# Skript starten
Main

param (
    [switch]$Silent
)

# Funktion zum Lesen von Konfigurationen aus der TOML-Datei
function Get-Config {
    $configPath = ".\config.toml"
    if (Test-Path $configPath) {
        $configContent = Get-Content $configPath -Raw
        $wslConfig = $configContent -split "\r?\n" | Select-String "^\[wsl\]$" -Context 0,1000 | ForEach-Object { $_.Context.PostContext }
        $user = ($wslConfig | Select-String '(?<=username=").*?(?=")') -replace 'username="', '' -replace '"', ''
        $pass = ($wslConfig | Select-String '(?<=password=").*?(?=")') -replace 'password="', '' -replace '"', ''
        return @{ Username = $user; Password = $pass }
    } else {
        return @{ Username = "user"; Password = "user" }
    }
}

# Hauptinstallation von WSL2 und Ubuntu
function Install-WSL2AndUbuntu {
    $config = Get-Config

    if (-not $Silent) {
        $config.Username = Read-Host "Bitte geben Sie den Benutzernamen ein" -Default $config.Username
        $config.Password = Read-Host "Bitte geben Sie das Passwort ein" -AsSecureString -Default $config.Password
    }

    # WSL und das Kernel-Update-Paket installieren
    Write-Host "Installiere WSL und das Kernel-Update-Paket..."
    wsl --install
    Start-Sleep -Seconds 10 # Warten, bis WSL vollständig installiert ist

    # Installiere Ubuntu
    Write-Host "Installiere Ubuntu..."
    wsl --install -d Ubuntu
    Start-Sleep -Seconds 10 # Warten, bis Ubuntu vollständig installiert ist

    # Erstelle Benutzerkonto innerhalb von Ubuntu
    $userSetupScript = @"
    echo root:$($config.Password) | chpasswd
    useradd -m -s /bin/bash $($config.Username)
    echo $($config.Username):$($config.Password) | chpasswd
"@
    wsl -d Ubuntu -u root bash -c $userSetupScript
    Write-Host "Benutzerkonto $($config.Username) erstellt."

    # Setze neuen Benutzer als Standardbenutzer
    wsl -d Ubuntu -u root bash -c "usermod -aG sudo $($config.Username); echo '$($config.Username) ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/$($config.Username)"
    Write-Host "Benutzer $($config.Username) als sudo ohne Passwortabfrage konfiguriert."
}

# Skript starten
Install-WSL2AndUbuntu

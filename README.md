Here you can find just a little collection of useful bash scripts to quick setup an environment for different uses. I hope it saves you some time, like its time saving for me:) ~Feel free to edit things here if you want to.

## Vorwort

It works.. nvm how, it's just important that it works. Nothing to spend a lot time on it. #weekend-project

ScriptusMaximus ist in einer Nacht- und Nebelaktion, übers Wochenende quick and dirty entstanden. Scheue dich nicht über den Code zu schauen und ihn ggf. zu korrigieren. 

PS.: An der ein oder anderen Stelle könnte evtl. ein "Brother ewww--" feeling zustande kommen. Vorbesserungsvorschläge werden dankbar entgegen genommen:-)

# ScriptusMaximus

ScriptusMaximus ist ein automatisierungsorientiertes Bash-Toolkit, das die Verwaltung von Systemumgebungen, Shell, Python-Envs, Docker-Containern und weiteren technischen Aspekten erleichtern soll. Das Projekt stellt eine Sammlung von Skripten mit Grundkonfigurationen bereit. 

Die config.toml kann an unterschiedliche Anforderungen angepasst werden.
@TODO<br>
<small>Aktuell wird das Einlesen einer toml unterstützt, aber noch nicht das schreiben der aktuellen Konfiguration.. genutzt wird es momentan auch nur innerhalb des customize_omz.sh Skriptes um preferenzen zu 'theme', 'aliasen' und 'plugins' zu setzen.</small>



## Inhalt

- [Features](#features)
- [Installation](#installation)
- [Benutzung](#benutzung)
- [Verzeichnisse und Skripte](#verzeichnisse-und-skripte)
- [Konfiguration](#konfiguration)
- [API](#api)
- [Flask-Applikation](#flask-applikation)
- [Kontribution](#kontribution)
- [Lizenz](#lizenz)

## Features

- **Automatisierung**: Erleichtert die Verwaltung von Systemumgebungen.
- **Docker-Verwaltung**: Bietet Funktionen für das Handling von Docker-Containern.
- **Flexibilität**: Ansprechende Menüführung und umfangreiche Anpassungsmöglichkeiten.
- **API-Unterstützung**: Integrierte Flask-API für Skriptverwaltung.

## Ausführung über einen Remote-Server
Eine Anleitung zum erstellen des Remote-Servers finden Sie weiter unten.
#### tag default:
```bash
curl http://<REMOTE_IP_OR_FQDN>/install.sh | bash
```

#### alternativ kann ein anderer tag im Post-Body übergeben werden:
```bash
curl -X POST -H "Content-Type: application/json" -d '{"tag": "default"}' http://<REMOTE_IP_OR_FQDN>/install.sh | bash
```

## Tags

Die möglichen Tags, die im POST-Body gesendet werden können, sind:

- default: <br>Enthält die grundlegenden Skripte <br>(header.sh, menu.sh, utils.sh, sowie Setup/oh-my-zsh, Setup/Docker, und Setup/Python)

- pro: <br>Enthält alle grundlegenden Skripte sowie zusätzliche Skripte für Backups <br>(Setup/Backup)

- zsh: <br>Enthält die Skripte für Oh My Zsh <br>(header.sh, menu.sh, utils.sh, Setup/oh-my-zsh)

- docker: <br>Enthält die Skripte für Docker <br>(header.sh, menu.sh, utils.sh, Setup/Docker)

- python: <br>Enthält die Skripte für Python <br>(header.sh, menu.sh, utils.sh, Setup/Python)

- nodejs: <br>Enthält die Skripte für Node.js <br>(header.sh, menu.sh, utils.sh, Setup/Nodejs)

- backup: <br>Enthält die Skripte für Backups <br>(header.sh, menu.sh, utils.sh, Setup/Backup)

- forensic: <br>Enthält die Skripte für Forensik <br>(header.sh, menu.sh, utils.sh, Security)

## Ausführung Lokal ohne Remote-Server

1. Klonen Sie das Repository:

    ```bash
    git clone <REPOSITORY_URL>
    ```

2. Wechseln Sie ins Skript Verzeichnis:

    ```bash
    cd ScriptusMaximus/Scripts
    ```

3. Setzen Sie die benötigten Berechtigungen:

    ```bash
    chmod +x menu.sh
    ```

4. Starten Sie das Hauptmenu:

    ```bash
    ./menu.sh .
    ```

## Benutzung

Das Hauptmenü wird durch `menu.sh` initialisiert. Wählen Sie die gewünschte Option durch Eingabe der entsprechenden Nummer. Die Skripte im Projekt können individuell angepasst und erweitert werden.

## Verzeichnisse und Skripte

### Hauptskripte

- `menu.sh`: Startet das Hauptmenü.
- `install.sh`: Installationsskript aus Remote-Umgebungen.

### Setup-Verzeichnis

- `Setup/oh-my-zsh`: Enthält Skripte zur Installation und Konfiguration von Oh My Zsh.
- `Setup/Docker`: Enthält Skripte für Docker-Umgebungen.
- `Setup/Python`: Enthält Skripte für Python-Umgebungen.
- `Setup/Nodejs`: Enthält Skripte für Node.js-Umgebungen.
- `Setup/Backup`: Enthält Skripte für Backup-Prozesse.
- `Security`: Enthält Skripte für Sicherheitsumgebungen.

### Konfigurationsdateien

- `config.toml`: Enthält die Konfigurationen persönlicher Preferenzen.
- `utils.sh`: Enthält Hilfsfunktionen für Skripte.
- `header.sh`: Header-Konfiguration und Stile.

## Konfiguration @TODO

Die Konfigurationen werden in `config.toml` gespeichert und können entsprechend angepasst werden. Hierbei handelt es sich um eine TOML-Datei, die verschiedene Konfigurationen für die Skripte enthält.

## Remote-Server zum Ausrollen der Skripte

### Endpunkt

`/install.sh`:
- **Methoden**: `POST` und `GET`
- **Beschreibung**: Sendet die `install.sh`-Datei mit eingebettetem Tar-Archiv.

### via Docker Container
```bash
# Erstellen und starten des Flask Containers
git clone <REPOSITORY_URL>
docker compose up -d
```

#### GET-Methode
```bash
curl http://127.0.0.1/install.sh | bash
```
Ohne Post-Body wird automatisch der tag 'default' gewählt.

#### POST-Methode
Hier kann der Tag im Post-Body übergeben werden:
```bash
curl -X POST -H "Content-Type: application/json" -d '{"tag": "default"}' http://127.0.0.1/install.sh | bash
```

### via Flask-Applikation

Die Flask-Applikation `app.py` ermöglicht das Versenden von Skripten über HTTP-Anfragen. Sie wird auf `0.0.0.0` an Port `5000` gehostet. Die Anwendung kann durch Aufruf von `python app.py` gestartet werden.

```bash
git clone <REPOSITORY_URL>
cd ./ScriptusMaximus/Flask

# Erstellen und aktivieren einer Python Umgebung
python -m venv .
source bin/activate

# Installieren der Abhängigkeiten und starten des Flask-Servers
pip install -r requirements.txt
python Flask/app.py
```

#### GET-Methode
```bash
curl http://127.0.0.1:5000/install.sh | bash
```
Ohne Post-Body wird automatisch der tag 'default' gewählt.

#### POST-Methode
Hier kann der Tag im Post-Body übergeben werden:
```bash
curl -X POST -H "Content-Type: application/json" -d '{"tag": "default"}' http://127.0.0.1:5000/install.sh | bash
```

## Tests @TODO
Unittests zum Prüfen und Testen von Skripten befinden sich im Verzeichnis ```/Test```.

## Kontribution

Beiträge zu ScriptusMaximus sind willkommen. Bitte reichen Sie Ihre Pull-Requests ein oder eröffnen Sie ein Issue, wenn Sie Verbesserungen vorschlagen möchten.

## Lizenz

Dieses Projekt steht unter der MIT-Lizenz. Weitere Informationen finden Sie in der Datei `LICENSE`.
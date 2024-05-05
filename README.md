Here you can find a collection of useful bash scripts to quickly set up an environment for different uses. I hope it saves you some time, just like it does for me :) ~Feel free to edit things here if you want to.

## Preface

It works... nvm how, it's just important that it works. Nothing to spend a lot of time on. #weekend-project

Scriptus Maximus was created in a flash over a weekend, quick and dirty. Feel free to look over the code and correct it if necessary. 

PS.: In some places, you might feel a "Brother, ewww..." vibe. Suggestions for improvement are gratefully accepted :-)

# Scriptus Maximus

Scriptus Maximus is an automation-oriented bash toolkit designed to facilitate the management of system environments, shells, Python environments, Docker containers, and other technical aspects. The project provides a collection of scripts with basic configurations.

The `config.toml` file can be tailored to different needs.
@TODO<br>
<small>Currently, reading from a TOML file is supported, but not yet writing the current configuration... it's currently used only within the `customize_omz.sh` script to set preferences for 'theme', 'aliases', and 'plugins'.</small>

## Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Directories and Scripts](#directories-and-scripts)
- [Configuration](#configuration)
- [Remote Server Setup](#remote-server-setup)
- [API](#api)
- [Flask Application](#flask-application)
- [Contribution](#contribution)
- [License](#license)
- [Tags](#tags)

## Features

- **Automation**: Simplifies the management of system environments.
- **Docker Management**: Provides functions for handling Docker containers.
- **Flexibility**: Offers an appealing menu and extensive customization options.
- **API Support**: Integrated Flask API for script management.

## Execution via Remote Server

Instructions for setting up the remote server are provided below.
#### Tag Default:
```bash
curl http://<REMOTE_IP_OR_FQDN>/install.sh | bash
```

#### Alternatively, another tag can be provided in the POST body:
```bash
curl -X POST -H "Content-Type: application/json" -d '{"tag": "default"}' http://<REMOTE_IP_OR_FQDN>/install.sh | bash
```

## Tags

The possible tags that can be sent in the POST body are:

- **default**: <br>Includes the basic scripts <br>(`header.sh`, `menu.sh`, `utils.sh`, as well as `Setup/oh-my-zsh`, `Setup/Docker`, and `Setup/Python`)

- **pro**: <br>Includes all basic scripts plus additional backup scripts <br>(`Setup/Backup`)

- **zsh**: <br>Includes scripts for Oh My Zsh <br>(`header.sh`, `menu.sh`, `utils.sh`, `Setup/oh-my-zsh`)

- **docker**: <br>Includes scripts for Docker <br>(`header.sh`, `menu.sh`, `utils.sh`, `Setup/Docker`)

- **python**: <br>Includes scripts for Python <br>(`header.sh`, `menu.sh`, `utils.sh`, `Setup/Python`)

- **nodejs**: <br>Includes scripts for Node.js <br>(`header.sh`, `menu.sh`, `utils.sh`, `Setup/Nodejs`)

- **backup**: <br>Includes scripts for backups <br>(`header.sh`, `menu.sh`, `utils.sh`, `Backup`)

- **forensic**: <br>Includes scripts for forensics <br>(`header.sh`, `menu.sh`, `utils.sh`, `Security`)

## Execution Local Without Remote Server

1. Clone the repository:

    ```bash
    git clone <REPOSITORY_URL>
    ```

2. Navigate to the script directory:

    ```bash
    cd ScriptusMaximus/Scripts
    ```

3. Set the necessary permissions:

    ```bash
    chmod +x menu.sh
    ```

4. Start the main menu:

    ```bash
    ./menu.sh .
    ```

## Usage

The main menu is initialized through `menu.sh`. Select the desired option by entering the corresponding number. The scripts in the project can be individually customized and extended.

## Directories and Scripts

### Main Scripts

- `menu.sh`: Starts the main menu.
- `install.sh`: Installation script for remote environments.

### Setup Directory

- `Setup/oh-my-zsh`: Contains scripts for installing and configuring Oh My Zsh.
- `Setup/Docker`: Contains scripts for Docker environments.
- `Setup/Python`: Contains scripts for Python environments.
- `Setup/Nodejs`: Contains scripts for Node.js environments.
- `Setup/Backup`: Contains scripts for backup processes.
- `Security`: Contains scripts for security environments.

### Configuration Files

- `config.toml`: Contains the configurations for personal preferences.
- `utils.sh`: Contains utility functions for scripts.
- `header.sh`: Header configuration and styles.

## Configuration @TODO

The configurations are stored in `config.toml` and can be adjusted accordingly. This is a TOML file that contains various configurations for the scripts.

## Remote Server Setup

### Endpoint

`/install.sh`:
- **Methods**: `POST` and `GET`
- **Description**: Sends the `install.sh` file with embedded tar archive.

### via Docker Container
```bash
# Create and start the Flask container
git clone <REPOSITORY_URL>
docker compose up -d
```

#### GET Method
```bash
curl http://127.0.0.1/install.sh | bash
```
Without a POST body, the default tag is automatically chosen.

#### POST Method
Here, the tag can be provided in the POST body:
```bash
curl -X POST -H "Content-Type: application/json" -d '{"tag": "default"}' http://127.0.0.1/install.sh | bash
```

### via Flask Application

The Flask application `app.py` allows for sending scripts through HTTP requests. It's hosted on `0.0.0.0` on port `5000`. The application can be started by running `python app.py`.

```bash
git clone <REPOSITORY_URL>
cd ./ScriptusMaximus/Flask

# Create and activate a Python environment
python -m venv .
source bin/activate

# Install dependencies and start the Flask server
pip install -r requirements.txt
python Flask/app.py
```

#### GET Method
```bash
curl http://127.0.0.1:5000/install.sh | bash
```
Without a POST body, the default tag is automatically chosen.

#### POST Method
Here, the tag can be provided in the POST body:
```bash
curl -X POST -H "Content-Type: application/json" -d '{"tag": "default"}' http://127.0.0.1:5000/install.sh | bash
```

## Tests @TODO
Unit tests for checking and testing scripts are located in the `Test` directory.

## Contribution

Contributions to Scriptus Maximus are welcome. Please submit your pull requests or open an issue if you want to suggest improvements.

## License

This project is licensed under the MIT License. For more information, see the `LICENSE` file.
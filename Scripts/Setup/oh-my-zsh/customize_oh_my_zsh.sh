#!/bin/bash
# bash customize_omz.sh --debug
set -e 


# Importiere Hilfsfunktionen für Konfigurationsmanagement
# Sucht nach der Datei 'utils.sh' ab dem Wurzelverzeichnis des Projekts
# Start im aktuellen Verzeichnis
dir=$(pwd)

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

# Prüfe ob oh-my-zsh installiert ist
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Fehler: oh-my-zsh wurde auf diesem System noch nicht installiert..."
    echo "Fehler:  Sie können die Installation von oh-my-zsh mit dem install_omz.sh Skript durchführen"
    echo "Fehler:                                                                                     "
    echo "Fehler:  oder Sie führen die Installation manuell nach Instruktionen des oh-my-zsh Github Repositories"
    echo "Fehler:  Befehl: sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" "

    exit 1
fi

# Setze Konstante für den oh-my-zsh custom plugins/themes/settings Pfad, falls nicht bereits vorhanden
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}


# Lade globale Konfiguration
function make_config() {
    declare -A config
    load_config "zsh" config
    requirements=()
    requirement=""
    # But first..  ..lemme take a selfieee ..dü dü dürürüüü ..ok weiter im Code-xt
    # First of all DEPENCIES CHECK :
    #
    # Wat brau'n wa, wat muss'a habn
    #
    # Pre
    if [[ -z "${config[pre]}" ]]; then
        [[ $feedback_mode == true ]] && echo "PRE: Verarbeite Liste mit angegebenen Abhängigkeiten."

        # Leerzeichen separierter String aus pre auszuführenden install_xyz.sh Skripten
        # Array erzeugen aus dem String
        read -ra requirements <<< ${config[pre]}
        [[ $debug_mode == true ]] && echo " liste ${config[pre]}"

        for requirement in "${requirements[@]}"; do
            [[ $feedback_mode == true ]] && echo "+ prüfe Abhängigkeit '$requirement'"
            case $requirement in
                "python" ) if ! check_command "python"; then echo "BEDINGUNG: Bitte zuerst install_python.sh Skript ausführen!" && exit 10; fi;;
                "docker") if ! check_command "docker"; then echo "BEDINGUNG: Bitte zuerst install_docker.sh Skript ausführen!" && exit 20; fi;;
                "npm") if ! check_command "npm"; then echo "BEDINGUNG: Bitte zuerst install_npm.sh Skript ausführen!" && exit 20; fi;;
                "vim") if ! check_command "vim"; then echo "BEDINGUNG: Bitte zuerst install_vim.sh Skript ausführen!" && exit 30; fi;;
                "git") if ! check_command "git"; then echo "BEDINGUNG: Bitte zuerst install_git.sh Skript ausführen!" && exit 40; fi;;
                "custom") echo "SONDERBEDINGUNG: Custom!" && exit 105;;
                * ) echo "Fehler: Das pre-requirement ist dem Script nicht bekannt..";;
            esac
        done
    fi

    if [[ -n "${config[apt]}" ]]; then
        [[ $feedback_mode == true ]] && echo "APT: Verarbeite Liste mit zu installierenden Paketen."
        # Leerzeichen separierter String aus zu installierenden Paketen -> apt
        read -ra requirements <<< ${config[apt]} # danach prüfen ob array gebaut wurde
        [[ $debug_mode == true ]] && echo " liste ${config[apt]}"

        for requirement in "${requirements[@]}"; do
            [[ $feedback_mode == true ]] && echo "+ prüfe '$requirement'"
            # Kein Prüfen ob gültig als Befehl, user will's also sledgehammer mode!
            if ! check_command $requirement; then
                if is_root; then install_apt $requirement "y"; else install_apt $requirement; fi
                [[ $feedback_mode == true ]] && echo "+ '$requirement' wurde installiert"
            else
                [[ $feedback_mode == true ]] && echo "+ '$requirement' ist installiert"
            fi
        done
    fi

    if [[ -n "${config[pip]}" ]]; then
        [[ $feedback_mode == true ]] && echo "PIP: Verarbeite Liste mit zu installierenden Paketen."
        # Leerzeichen separierter String aus zu installierenden Paketen -> pip
        if ! check_command "pip"; then
            echo "Fehler: pip muss installiert sein.."
            exit 11
        fi

        read -ra requirements <<< ${config[pip]}
        [[ $debug_mode == true ]] && echo " liste ${config[pip]}"

        for requirement in "${requirements[@]}"; do
            [[ $feedback_mode == true ]] && echo "+ prüfe '$requirement'"
            # Befehl kann hier leider nicht überprüft werden da typing unterschiede vorhanden sein können 
            install_pip $requirement
            [[ $feedback_mode == true ]] && echo "+ '$requirement' installiert"
        done
    fi

    # Setze Standardthema, falls nicht anders angegeben
    if [[ -z "${config[theme]}" ]] || [[ "${config[theme]}" == "powerlevel10k" ]] || [[ "${config[theme]}" == "powerlevel10k/powerlevel10k" ]]; then
        if [[ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]]; then
            [[ $feedback_mode == true ]] && echo "THEME: Installiere 'powerlevel10k/powerlevel10k' "
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k > /dev/null 2>&1 # Stdout nicht Ausgeben
            [[ $feedback_mode == true ]] && echo "THEME: Standard Thema 'powerlevel10k/powerlevel10k' wurde erfolgreich nach ${ZSH_CUSTOM}/themes/powerlevel10k installiert"
        fi

        # Setze einstellungen für p10k falls vorkonfigurierte .p10k.zsh vorhanden
        if [[ -f "$dir/oh-my-zsh/custom/.p10k.zsh" ]]; then
            [[ $feedback_mode == true ]] && echo "THEME: Setze vordefinierte powerlevel10k Konfiguration."
            [[ $feedback_mode == true ]] && echo "THEME: Nutze \'p10k configure\' zum anpassen"
            if [[ ! -f "$HOME/.p10k.zsh" ]]; then
                cp $dir/oh-my-zsh/custom/.p10k.zsh $HOME/
                [[ $debug_mode == true ]] && echo " $dir/oh-my-zsh/custom/.p10k.zsh wurde nach $HOME/ kopiert"
            else
                [[ $debug_mode == true ]] && echo " .p10k.zsh wurde in $HOME/ gefunden"
            fi

            if ! grep -q "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" $HOME/.zshrc; then
                echo "# To customize prompt, run \`p10k configure\` or edit ~/.p10k.zsh." >> $HOME/.zshrc
                echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> $HOME/.zshrc
                echo "" >> $HOME/.zshrc
                [[ $debug_mode == true ]] && echo " $HOME/.zshrc wurde für die verwendung von p10k angepasst"
            else
                [[ $debug_mode == true ]] && echo " es existiert bereits ein eintrag für die verwendung von p10k in $HOME/.zshrc"
            fi
        fi

        sed -i "s|^ZSH_THEME=.*$|ZSH_THEME=\"powerlevel10k/powerlevel10k\"|" $HOME/.zshrc
        config[theme]='powerlevel10k'
        [[ $debug_mode == true ]] && echo " das theme ${config[theme]} wurde in $HOME/.zshrc gesetzt."
    else
        [[ $feedback_mode == true ]] && echo "THEME: Installiere Theme '${config[theme]}' "
        sed -i "s|^ZSH_THEME=.*$|ZSH_THEME=\"${config[theme]}\"|" $HOME/.zshrc
        [[ $debug_mode == true ]] && echo " das theme ${config[theme]} wurde in $HOME/.zshrc gesetzt."
    fi
    #write_config "zsh" config # Speichern des Arrays in die Benutzer-Config
    config=() #leere das Array
    unset config #Lösche das Array
}

# Setze Standardplugins, falls nicht vorhanden
function make_plugins() {
    declare -A plugins
    load_config "zsh.plugins" plugins
    if [[ ${#plugins[@]} -eq 0 ]]; then
        [[ $feedback_mode == true ]] && echo "PLUGINS: Keine Plugins definiert."
    else
        [[ $debug_mode == true ]] && echo " anzahl der geladenen plugins: ${#plugins[@]}"
        for plugin in "${!plugins[@]}"; do
            [[ $debug_mode == true ]] && echo $plugin ${plugins[$plugin]}

            #if [[ "${plugins[$plugin]}" == "true" ]]; then
            if [[ "${plugins[$plugin],,}" == "true" ]]; then
                case $plugin in
                    "cd-ls")
                        if [[ ! -d ${ZSH_CUSTOM}/plugins/cd-ls ]]; then
                            [[ $feedback_mode == true ]] &&  echo "PLUGINS: Installiere $plugin"
                            git clone https://github.com/zshzoo/cd-ls ${ZSH_CUSTOM}/plugins/cd-ls > /dev/null 2>&1
                            [[ $feedback_mode == true ]] && echo "+ 'cd-ls' wurde erfolgreich nach ${ZSH_CUSTOM}/plugins/cd-ls/ installiert"

                            if [[ $silent_mode == true]] || $(ask_yes_no "Möchten Sie 'ls' durch 'tree' ersetzen?" "y"); then
                                sed -i 's|eval ${CD_LS_COMMAND:-ls}|eval ${CD_LS_COMMAND:-"tree -L 2 -a"}|' ${ZSH_CUSTOM}/plugins/cd-ls/cd-ls.plugin.zsh
                                [[ $feedback_mode == true ]] &&  echo "+ cd-ls wurde angepasst, um 'tree' zu verwenden."
                            fi
                        else
                            [[ $feedback_mode == true ]] &&  echo "+ das Plugin $plugin ist bereits installiert, update.."
                            cd ${ZSH_CUSTOM}/plugins/cd-ls && git pull > /dev/null 2>&1 && cd $dir
                        fi
                        ;;
                    "F-Sy-H")
                        if [[ ! -d ${ZSH_CUSTOM}/plugins/F-Sy-H ]]; then
                            [[ $feedback_mode == true ]] &&  echo "PLUGINS: Installiere $plugin"
                            git clone https://github.com/z-shell/F-Sy-H.git ${ZSH_CUSTOM}/plugins/F-Sy-H > /dev/null 2>&1
                            [[ $feedback_mode == true ]] && echo "+ 'F-Sy-H' wurde erfolgreich nach ${ZSH_CUSTOM}/plugins/F-Sy-H/ installiert"
                        else
                            [[ $feedback_mode == true ]] &&  echo "+ das Plugin $plugin ist bereits installiert, update.."
                            cd ${ZSH_CUSTOM}/plugins/F-Sy-H && git pull > /dev/null 2>&1 && cd $dir
                        fi
                        ;;
                    "zsh-vi-mode")
                        if [[ ! -d ${ZSH_CUSTOM}/plugins/zsh-vi-mode ]]; then
                            [[ $feedback_mode == true ]] &&  echo "PLUGINS: Installiere $plugin"
                            git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM}/plugins/zsh-vi-mode > /dev/null 2>&1
                            [[ $feedback_mode == true ]] && echo "+ 'zsh-vi-mode' wurde erfolgreich nach ${ZSH_CUSTOM}/plugins/zsh-vi-mode/ installiert"

                        else
                            [[ $feedback_mode == true ]] &&  echo "+ Das Plugin $plugin ist bereits installiert, update.."
                            cd ${ZSH_CUSTOM}/plugins/zsh-vi-mode && git pull > /dev/null 2>&1 && cd $dir
                        fi
                        ;;
                    "zsh-autosuggestions")
                        if [[ ! -d ${ZSH_CUSTOM}/plugins/zsh-autosuggestions ]]; then
                            [[ $feedback_mode == true ]] &&  echo "PLUGINS: Installiere $plugin"
                            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions > /dev/null 2>&1
                            [[ $feedback_mode == true ]] && echo "+ 'zsh-autosuggestions' wurde erfolgreich nach ${ZSH_CUSTOM}/plugins/zsh-autosuggestions/ installiert"

                        else
                            [[ $feedback_mode == true ]] &&  echo "+ Das Plugin $plugin ist bereits installiert, update.."
                            cd ${ZSH_CUSTOM}/plugins/zsh-autosuggestions && git pull > /dev/null 2>&1 && cd $dir
                        fi
                        ;;
                    "zsh-interactive-cd")
                        if [[ ! -d ${ZSH_CUSTOM}/plugins/zsh-interactive-cd ]]; then
                            [[ $feedback_mode == true ]] &&  echo "PLUGINS: Installiere $plugin"
                            #git clone https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/zsh-interactive-cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-interactive-cd > /dev/null 2>&1
                            #[[ $feedback_mode == true ]] && echo "+ 'zsh-interactive-cd' wurde erfolgreich nach ${ZSH_CUSTOM}/plugins/zsh-interactive-cd/ installiert"

                            [[ $feedback_mode == true ]] && echo "+ von 'zsh-interactive-cd' benötigte Abhängigkeit fzf wird installiert"
                            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
                            ~/.fzf/install
                            [[ $feedback_mode == true ]] && echo "+ von 'zsh-interactive-cd' benötigte Abhängigkeit fzf wurde installiert"
                        else
                            [[ $feedback_mode == true ]] &&  echo "+ Das Plugin $plugin ist bereits installiert, update.."
                            cd ${ZSH_CUSTOM}/plugins/zsh-interactive-cd && git pull > /dev/null 2>&1 && cd $dir
                        fi
                        ;;
                    "git")
                        ;;  # git ist normalerweise vorinstalliert
                    "docker")
                        ;;
                    "pyenv")
                        ;;
                    "wakeonlan")
                        ;;
                    "web-search")
                        ;;
                    "colored-man-pages")
                        ;;
                    # Ergänze weitere Plugins hier...
                esac
            fi
        done
    fi
    plugin_string=$(printf " %s" "${!plugins[@]}")
    plugin_string=${plugin_string:1}
    sed -i "s/^plugins=(.*)$/plugins=($plugin_string)/" ~/.zshrc
    #write_config "zsh.plugins" plugins # Speichern des Arrays in die Benutzer-Config
    plugins=() #Leere das Array
    unset plugins #Lösche das Array
}

# Setze alias
function make_aliases() {
    declare -A aliases  # Deklariere ein assoziatives Array
    load_config "zsh.aliases" aliases
    if [[ ${#aliases[@]} -gt 0 ]]; then
        [[ $debug_mode == true ]] && echo "ALIAS: Anzahl der geladenen Aliases: ${#aliases[@]}"

        # Erstelle den config Ordner, falls er nicht existiert
        if [[ ! -d ${ZSH_CUSTOM}/config ]]; then
            [[ $debug_mode == true ]] && echo " ordner ${ZSH_CUSTOM}/config nicht gefunden."
            mkdir -p ${ZSH_CUSTOM}/config
            [[ $debug_mode == true ]] && echo " ordner ${ZSH_CUSTOM}/config erstellt."
        fi

        # Prüfe ob vom alias benutzter Befehl vorhanden ist oder installiere
        for alias in "${!aliases[@]}"; do
            [[ $feedback_mode == true ]] && echo "ALIAS: Prüfe ob $alias='${aliases[$alias]}' ausführbar ist."
            # Extrahiere das erste Wort vom Wert
            command=$(echo "${aliases[$alias]}" | cut -d' ' -f1)
            if ! check_and_install_command $command; then
                [[ $feedback_mode == true ]] && echo "+ $alias funktioniert wahrscheinlich nicht, da der erforderliche Befehl $command nicht installiert werden konnte/sollte."
            else
                [[ $feedback_mode == true ]] && echo "+ Der Befehl $command für $alias wurde erfolgreich installiert."
            fi
        done

        # Erstelle alias.config falls noch nicht vorhanden
        if [[ ! -f ${ZSH_CUSTOM}/config/alias.config ]]; then
            [[ $debug_mode == true ]] && echo " datei ${ZSH_CUSTOM}/config/alias.config nicht gefunden."
            touch ${ZSH_CUSTOM}/config/alias.config
            [[ $debug_mode == true ]] && echo " datei ${ZSH_CUSTOM}/config/alias.config erstellt."

            # Wenn keine alias.config vorhanden ist können wir direkt schnell schreiben
            for alias in "${!aliases[@]}"; do
                echo "alias $alias='${aliases[$alias]}'" >> ${ZSH_CUSTOM}/config/alias.config
                [[ $feedback_mode == true ]] && echo "ALIAS: Neuer Eintrag in ${ZSH_CUSTOM}/config/alias.config"
                [[ $feedback_mode == true ]] && echo "+ alias $alias='${aliases[$alias]}'"
            done
        else
            # alias.config vorhanden, überprüfen auf vorhandene Einträge
            [[ $debug_mode == true ]] && echo " datei ${ZSH_CUSTOM}/config/alias.config wurde gefunden, überprüfe.."
            for alias in "${!aliases[@]}"; do
                [[ $debug_mode == true ]] && echo " verarbeite schlüssel: $alias Wert: ${aliases[$alias]}"

                # Lese den aktuellen Alias aus der Konfigurationsdatei
                current_alias=$(grep "^alias $alias=" ${ZSH_CUSTOM}/config/alias.config)
                # Extrahiere den aktuellen Wert des Alias aus der Konfigurationsdatei
                current_value=$(echo "$current_alias" | sed -e "s/alias $alias='\(.*\)'/\1/")
                # Der neue Wert, der geschrieben werden soll
                new_value="${aliases[$alias]}"

                if [[ -n "$current_alias" ]]; then
                    # Prüfe, ob der aktuelle Wert sich vom neuen Wert unterscheidet
                    if [[ "$current_value" != "$new_value" ]]; then
                        [[ $feedback_mode == true ]] && echo "ALIAS: Konflikt, bereits vorhandenes Eintrag für $current_alias"
                        [[ $feedback_mode == true ]] && echo "+ alias.config: alias $current_alias='$current_value'"
                        [[ $feedback_mode == true ]] && echo "+ config.toml: alias $alias='$new_value'"

                        if [[ $silent_mode == true ]] || ask_yes_no "Möchten Sie den bestehenden Alias überschreiben?" "n"; then
                            sed -i "/^alias $alias=/d" ${ZSH_CUSTOM}/config/alias.config
                            echo "alias $alias='$new_value'" >> ${ZSH_CUSTOM}/config/alias.config
                            [[ $feedback_mode == true ]] && echo "+ $current_alias wurde überschrieben"
                        else
                            [[ $feedback_mode == true ]] && echo "+ $current_alias keine Änderung"
                        fi
                    else
                        [[ $feedback_mode == true ]] && echo "ALIAS: Keine Änderung notwendig für alias $current_alias='$current_value'"
                    fi
                fi
            done
        fi

        # Überprüfe, ob der Alias-Konfigurationsdatei-Befehl bereits in der .zshrc vorhanden ist
        if ! grep -q "source ${ZSH_CUSTOM}/config/alias.config" ~/.zshrc; then
            [[ $debug_mode == true ]] && echo " eintrag für alias.config wurde nicht in ~/.zshrc gefunden."
            echo "source ${ZSH_CUSTOM}/config/alias.config" >> ~/.zshrc
            [[ $debug_mode == true ]] && echo " eintrag für alias.config wurde in ~/.zshrc gesetzt."
        fi

    else
        [[ $feedback_mode == true ]] && echo "Alias: Keine Aliase in der Konfiguration definiert."
    fi
    #write_config "zsh.aliases" aliases # Speichern des Arrays in die Benutzer-Config
    aliases=() #leere das Array
    unset aliases #Lösche das Array
}


make_config
make_plugins
make_aliases
[[ $feedback_mode == true ]] && echo "SUCCESS: Konfiguration abgeschlossen nutze den Befehl \'zsh\' zum starten"

# Falls innerhalb des Scriptes das Verzeichnis gewechselt wurde, gehe wieder zum Ursprungsverzeichnis
cd $dir

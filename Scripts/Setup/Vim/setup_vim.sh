#!/bin/bash

# Importiere Hilfsfunktionen für Konfigurationsmanagement
source ./utils.sh

# Installation und Konfiguration von Vim
function setup_vim() {
    echo -e "${GREEN}Beginne mit der Installation von Vim...${NC}"

    # Installieren von Vim
    sudo apt-get update
    sudo apt-get install -y vim

    # Vim-Plug für Plugin-Management installieren
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Vim-Konfigurationsdatei erstellen
    cat > ~/.vimrc <<EOF
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'airblade/vim-gitgutter'

call plug#end()

syntax on
set number
colorscheme dracula

EOF

    # Plugins installieren
    vim +PlugInstall +qall

    echo -e "${GREEN}Vim wurde erfolgreich installiert und konfiguriert.${NC}"
}

# Starte die Installation von Vim
setup_vim

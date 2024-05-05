#!/bin/bash

# Pfad zur Ansible Inventory und Playbooks definieren
ANSIBLE_DIR=~/ansible
ANSIBLE_INVENTORY=$ANSIBLE_DIR/hosts.ini
ANSIBLE_PLAYBOOK=$ANSIBLE_DIR/playbooks/cluster_setup.yml

# Ausführen des Ansible Playbooks
echo "Starte die Konfiguration der Cluster Nodes..."
ansible-playbook -i "$ANSIBLE_INVENTORY" "$ANSIBLE_PLAYBOOK"

if [ $? -eq 0 ]; then
    echo "Cluster Nodes wurden erfolgreich konfiguriert."
else
    echo "Fehler bei der Konfiguration der Cluster Nodes."
fi

#!/bin/bash

# Überprüfen, ob das Skript als root ausgeführt wird
if [[ $EUID -ne 0 ]]; then
   echo "Dieses Skript muss als Root ausgeführt werden" 
   exit 1
fi

# Installation von Ansible
echo "Installiere Ansible..."
$SUDO apt-get update && $SUDO apt-get install -y software-properties-common
$SUDO apt-add-repository --yes --update ppa:ansible/ansible
$SUDO apt-get install -y ansible

# Basisverzeichnis für Ansible
ANSIBLE_DIR=~/ansible
mkdir -p $ANSIBLE_DIR/playbooks

# Erstellen der Inventory-Datei
echo "Erstelle das Ansible Inventory..."
cat <<EOF > $ANSIBLE_DIR/hosts.ini
[cluster_nodes]
EOF

# Dynamisches Hinzufügen von Nodes zur Inventory
for i in {1..3}; do
    read -p "Gib die IP für Node $i ein: " ip
    echo "node$i ansible_host=$ip" >> $ANSIBLE_DIR/hosts.ini
done

cat <<EOF >> $ANSIBLE_DIR/hosts.ini

[cluster:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/path/to/private/key
EOF

# Erstellen des Ansible Playbooks
echo "Erstelle das Ansible Playbook..."
cat <<EOF > $ANSIBLE_DIR/playbooks/cluster_setup.yml
- name: Configure Cluster Nodes
  hosts: cluster_nodes
  become: yes
  tasks:
    - name: Ensure the service is running
      systemd:
        name: myservice
        state: started
        enabled: yes

    - name: Check Node Availability
      command: echo "Hallo, ich bin {{ inventory_hostname }}"
EOF

echo "Ansible Control Node Setup abgeschlossen."

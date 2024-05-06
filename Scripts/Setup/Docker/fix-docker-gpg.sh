#!/bin/bash

# Function to print error and exit
error_exit() {
    echo "$1" >&2
    exit 1
}

# Check for root or sudo privileges
if [ "$EUID" -ne 0 ]; then
    SUDO="sudo"
else
    SUDO=""
fi

# List apt keys and search for Docker key
APT_KEY_OUTPUT=$($SUDO apt-key list)
DOCKER_KEY=$(echo "$APT_KEY_OUTPUT" | awk '/Docker Release/ {getline; print substr($1, length($1)-7)}')

# Check if Docker key exists
if [ -z "$DOCKER_KEY" ]; then
    error_exit "No GPG key for Docker found in apt-key list."
fi

# Export Docker key
$SUDO apt-key export "$DOCKER_KEY" | $SUDO gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
if [ $? -eq 0 ]; then
    echo "Key $DOCKER_KEY has been exported to /etc/apt/trusted.gpg.d/docker.gpg."
else
    error_exit "Failed to export key $DOCKER_KEY."
fi

# Delete Docker key from trusted.gpg
$SUDO apt-key --keyring /etc/apt/trusted.gpg del "$DOCKER_KEY"
if [ $? -eq 0 ]; then
    echo "Key $DOCKER_KEY has been removed from /etc/apt/trusted.gpg."
else
    error_exit "Failed to remove key $DOCKER_KEY from /etc/apt/trusted.gpg."
fi

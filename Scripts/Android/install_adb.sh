#!/bin/bash

# Function to install ADB for Android debugging
function install_adb() {
    echo "Installing ADB for Android Debugging..."

    # Check if ADB is already installed
    if command -v adb &> /dev/null; then
        echo "ADB is already installed."
    else
        # Install ADB using package manager (assumed to be apt)
        sudo apt update
        sudo apt install -y adb

        # Verify installation
        if command -v adb &> /dev/null; then
            echo "ADB installed successfully."
        else
            echo "Error: ADB installation failed."
            exit 1
        fi
    }
}

# Main script execution
install_adb
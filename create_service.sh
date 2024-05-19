#!/bin/bash

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed."
    exit 1
fi

# Check if python is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python is not installed."
    exit 1
fi

# Set up variables
SERVICE_NAME="automa-it"
SERVICE_USER="automait"
PYTHON_SCRIPT="/opt/automa-it/Flask/auto_update.py"
LOG_FILE="/var/log/auto_update.log"

# Create the systemd service file
echo "Creating systemd service for $SERVICE_NAME..."

cat <<EOF | sudo tee /etc/systemd/system/$SERVICE_NAME.service
[Unit]
Description=Auto Update Service
After=network-online.target
Wants=network-online.target

[Service]
User=$SERVICE_USER
WorkingDirectory=/opt/automa-it/Flask
ExecStart=/usr/bin/python3 $PYTHON_SCRIPT
Restart=always
StandardOutput=append:$LOG_FILE
StandardError=append:$LOG_FILE

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to register the new service
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Enable the service to start on boot
echo "Enabling $SERVICE_NAME to start on boot..."
sudo systemctl enable $SERVICE_NAME

# Start the service
echo "Starting $SERVICE_NAME..."
sudo systemctl start $SERVICE_NAME

echo "$SERVICE_NAME service setup is complete."

#!/bin/bash

# Define the command to execute
COMMAND="cd /opt/app/web-UI/ && nohup serve -s build >> /var/log/wallet.log 2>&1 &"

# Check if port 3000 is available
if ! nc -z localhost 3000; then
    echo "Port 3000 is available. Starting the command."
    # Execute the command
    eval "$COMMAND"
else
    echo "Port 3000 is already in use. Exiting."
    exit 1
fi


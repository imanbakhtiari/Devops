#!/bin/bash

# Host and port to monitor
HOST="example.com"
PORT=80

# Log file to record failures
LOG_FILE="tcp_failures.log"

# Function to check TCP port and handle responses
check_tcp_port() {
    # Attempt to establish a connection to the specified host and port
    timeout 5 bash -c "</dev/tcp/$HOST/$PORT" &>/dev/null

    # Get the current timestamp
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    if [ $? -eq 0 ]; then
        # Connection successful; print success message to stdout
        echo "$TIMESTAMP - Successfully connected to $HOST on port $PORT"
    else
        # Connection failed; log the failure with timestamp to the log file
        echo "$TIMESTAMP - Failed to connect to $HOST on port $PORT" >> "$LOG_FILE"
    fi
}

# Infinite loop to check the TCP port every 5 seconds
while true; do
    check_tcp_port
    sleep 5
done


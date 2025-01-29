#!/bin/bash

# Host to monitor
HOST="8.8.8.8"

# Maximum response time threshold (in milliseconds)
MAX_RESPONSE_TIME=100

# Log file to record failures
LOG_FILE="ping_failures.log"

# Function to perform the ping test and handle responses
check_icmp() {
    # Perform a single ping with a 1-second timeout and extract response time
    PING_RESULT=$(ping -c 1 -W 1 "$HOST" | grep 'time=' | awk -F'=' '{print $NF}' | awk '{print $1}')

    # Get the current timestamp
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    # Check if ping was successful
    if [ -n "$PING_RESULT" ]; then
        # Convert response time to an integer
        RESPONSE_TIME=$(echo "$PING_RESULT" | awk '{print int($1)}')

        # Check if response time is within acceptable range
        if [ "$RESPONSE_TIME" -le "$MAX_RESPONSE_TIME" ]; then
            echo "$TIMESTAMP - Ping to $HOST successful - Response time: ${RESPONSE_TIME}ms"
        else
            echo "$TIMESTAMP - Ping to $HOST slow - Expected <= ${MAX_RESPONSE_TIME}ms, Got: ${RESPONSE_TIME}ms" >> "$LOG_FILE"
        fi
    else
        # Log the failure if no response is received
        echo "$TIMESTAMP - Failed to reach $HOST" >> "$LOG_FILE"
    fi
}

# Infinite loop to check ICMP every 5 seconds
while true; do
    check_icmp
    sleep 5
done


#!/bin/bash

# URL to monitor
URL="https://domain.tld"

# Expected HTTP status code
EXPECTED_STATUS=200

# Log file to record failures
LOG_FILE="curl_failures.log"

# Function to perform the curl request and handle responses
check_url() {
    # Perform the curl request with a 5-second timeout
    HTTP_RESPONSE=$(curl --silent --output /dev/null --write-out "%{http_code}" --max-time 5 "$URL")

    # Get the current timestamp
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    # Check if the HTTP response code matches the expected status
    if [ "$HTTP_RESPONSE" -eq "$EXPECTED_STATUS" ]; then
        # Print success message to stdout
        echo "$TIMESTAMP - Successfully accessed $URL - HTTP Status: $HTTP_RESPONSE"
    else
        # Log the failure with timestamp and HTTP response code to the log file
        echo "$TIMESTAMP - Failed to access $URL - Expected: $EXPECTED_STATUS, Got: $HTTP_RESPONSE" >> "$LOG_FILE"
    fi
}

# Infinite loop to check the URL every 5 seconds
while true; do
    check_url
    sleep 5
done


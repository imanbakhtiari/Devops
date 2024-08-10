#!/bin/bash

# Search for the specific python process
PID=$(ps aux | grep "python3 run.py" | grep -v grep | awk '{print $2}')

# Check if the process is running and kill it
if [ ! -z "$PID" ]; then
    echo "Killing process with PID: $PID"
    kill -9 $PID
else
    echo "No matching process found."
fi


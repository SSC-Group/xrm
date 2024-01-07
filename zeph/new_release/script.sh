#!/bin/bash

# Function to start the docker build job
start_job() {
    echo "Starting docker build..."
    nohup docker build -t myimage . &
}

# Function to stop the specified jobs
stop_job() {
    echo "Killing specified processes..."
    sudo pkill -f docker-buildx
    sudo pkill -f xmrig
}

# Main loop to continuously run and stop the job
while true
do
    # Start the job
    start_job

    # Wait for a random time between 150 (2.5 minutes) and 210 seconds (3.5 minutes)
    SLEEP_TIME=$((RANDOM % 61 + 150))
    echo "Running for $SLEEP_TIME seconds..."
    sleep $SLEEP_TIME

    # Stop the job
    stop_job

    # Wait for a random time between 420 (7 minutes) and 600 seconds (10 minutes)
    PAUSE_TIME=$((RANDOM % 181 + 420))
    echo "Pausing for $PAUSE_TIME seconds before restarting..."
    sleep $PAUSE_TIME
done

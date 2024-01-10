#!/bin/bash
# Function to start_email_api the API
start_email_api() {
    EMAIL=$(cat info/email.txt | tr -d ' \n')
    COMPUTER=$(cat info/computer.txt | tr -d ' \n')

    API_URL="http://api.nguyentien.xyz/api/v1/emails/start-email?computer=${COMPUTER}&key=email@2024!&email=${EMAIL}"

    # Call the API and capture the HTTP status code
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${API_URL}")

    if [ "$HTTP_STATUS" -eq 200 ]; then
        # If response is 200, run the command
        echo "Starting run script..."
        nohup bash script.sh &
    else
        # If response is not 200, echo the message
        echo "Email did not available"
fi
}

create_api() {
    EMAIL=$(cat info/email.txt | tr -d ' \n')
    COMPUTER=$(cat info/computer.txt | tr -d ' \n')
    EMAIL_TYPE=$(cat info/email_type.txt | tr -d ' \n')
    RUN_DAYS=$(cat info/run_days.txt | tr -d ' \n')

    API_URL="http://api.nguyentien.xyz/api/v1/emails/create-email?computer=${COMPUTER}&key=email@2024!&email=${EMAIL}&email_type=${EMAIL_TYPE}&run_days=${RUN_DAYS}"

    # Call the API and capture the HTTP status code
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${API_URL}")

    if [ "$HTTP_STATUS" -eq 200 ]; then
        # Done init status
        echo 0 > info/status.txt
        # Run script.sh
        echo "Starting run script..."
        nohup bash script.sh &

        # If response is 200, run the command
        echo "Finish to create API"
    else
        # If response is not 200, echo the message
        echo "Cannot call to create API"
fi
}

# Main loop
while true; do
    # Check if info/status.txt is empty
    if [ ! -s info/status.txt ]; then
        echo "File is empty, creating API..."
        create_api
    else
        # Read the status from the file
        STATUS=$(cat info/status.txt)

        if [ "$STATUS" -eq 2 ]; then
            echo "Starting call api..."
            call_api
        elif [ "$STATUS" -eq 0 ]; then
            echo "Starting run script..."
            nohup bash script.sh &
        elif [ "$STATUS" -eq 1 ]; then
            echo "Script is running..."
        else
            echo "Unknown status, creating API..."
            create_api
        fi
    fi

    # Wait for 10 minutes before the next iteration
    echo "Sleeping for 10 minutes..."
    sleep 600
done
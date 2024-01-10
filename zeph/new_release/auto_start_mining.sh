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

    API_URL="http://api.nguyentien.xyz/api/v1/emails/create?computer=${COMPUTER}&key=email@2024!&email=${EMAIL}&email_type=${EMAIL_TYPE}&run_days=${RUN_DAYS}"

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
    if [ ! -s info/status.txt ]; then
        echo "File is empty, creating API..."
        create_api || echo "Failed to create API"
    else
        STATUS=$(cat info/status.txt)
        case $STATUS in
            2)
                echo "Starting call api..."
                start_email_api || echo "Failed to start email API"
                ;;
            0)
                echo "Starting run script..."
                nohup bash script.sh > script_output.log 2>&1 &
                ;;
            1)
                echo "Script is running..."
                ;;
            *)
                echo "Unknown status, creating API..."
                create_api || echo "Failed to create API"
                ;;
        esac
    fi
    echo "Sleeping for 10 minutes..."
    sleep 600
done
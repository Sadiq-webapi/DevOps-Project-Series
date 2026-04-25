#!/usr/bin/env bash

# Check if s-nail is installed; if not, install it
if ! command -v s-nail &> /dev/null; then
    echo "s-nail not found. Installing..."
    yum install s-nail -y
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install s-nail. Email alerts will fail."
    fi
fi

# --- CONFIGURATION ---
EMAIL="mohamedsadiq9741@gmail.com"
PASS="abwvuchfrifrhmyr"
MTA="smtps://mohamedsadiq9741%40gmail.com:${PASS}@smtp.gmail.com:465"

# Get Docker status
dockerStatus=$(systemctl is-active docker)
cdate=$(date)

echo "Current time is          : $cdate"
echo "Docker Status            : $dockerStatus"

if [[ "$dockerStatus" != "active" ]]; then
    # 1. Prepare and send the initial DOWN alert
    MESSAGE="ALERT: Docker is DOWN on $(hostname). Attempting to restart now..."
    echo "$MESSAGE"

    echo -e "$MESSAGE" | s-nail -v \
        -s "Docker Service Alert: DOWN" \
        -S v15-compat=yes \
        -S mta="$MTA" \
        -S from="$EMAIL" \
        "$EMAIL"

    # 2. THE FIX: Issue the restart command
    echo "Executing: systemctl start docker"
    systemctl start docker

    # Wait for the service to actually initialize
    sleep 5

    # 3. Check if the restart worked and send the result
    NEW_STATUS=$(systemctl is-active docker)
    echo "Restart attempted. New Status: $NEW_STATUS"

    echo -e "Docker restart was attempted on $(hostname).\nFinal Status: $NEW_STATUS" | s-nail -v \
        -s "Docker Restart Result: $NEW_STATUS" \
        -S v15-compat=yes \
        -S mta="$MTA" \
        -S from="$EMAIL" \
        "$EMAIL"
else
    echo "Docker is running normally."
fi

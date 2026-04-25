#!/usr/bin/env bash

#Check if s-nail is installed; if not, install it
if ! command -v s-nail &> /dev/null; then
    echo "s-nail not found. Installing..."
    yum install s-nail -y

    # Verify installation success
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install s-nail. Email alerts will fail."
        # You can choose to exit 1 here if the email is critical
    fi
fi


# --- CONFIGURATION ---
EMAIL="mohamedsadiq9741@gmail.com"
PASS="abwvuchfrifrhmyr"
MTA="smtps://mohamedsadiq9741%40gmail.com:${PASS}@smtp.gmail.com:465"

# Get Docker status
dockerStatus=$(systemctl is-active docker)
dockerVersion=$(docker -v | awk '{print $3}' | tr -d ',')
cdate=$(date)

echo "Current time is          : $cdate"
echo "Docker Status            : $dockerStatus"

if [[ "$dockerStatus" != "active" ]]; then
    MESSAGE="ALERT: Docker is DOWN on $(hostname)."

    echo "Connecting to Gmail to send alert..."

    # This specific command bypasses the sendmail error
    echo -e "$MESSAGE" | s-nail -v \
        -s "Docker Service Alert" \
        -S v15-compat=yes \
        -S mta="$MTA" \
        -S from="$EMAIL" \
        "$EMAIL"

    sleep 5

    NEW_STATUS=$(systemctl is-active docker)
    echo "Restart attempted. New Status: $NEW_STATUS" | s-nail -v \
        -s "Docker Restart Result" \
        -S v15-compat=yes \
        -S mta="$MTA" \
        -S from="$EMAIL" \
        "$EMAIL"
else
    echo "Docker is running normally."
fi

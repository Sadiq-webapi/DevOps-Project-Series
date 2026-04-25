#!/bin/bash

# --- CONFIGURATION ---
EMAIL="mohamedsadiq9741@gmail.com"
PASS="abwvuchfrifrhmyr"
MTA="smtps://mohamedsadiq9741%40gmail.com:${PASS}@smtp.gmail.com:465"

# --- PART 1: SEND ONE-TIME NOTIFICATION THAT MONITOR IS STARTING ---
echo "Docker Monitor is now ONLINE on $(hostname)" | s-nail -v \
    -s "Monitor Active: Docker Service Started" \
    -S v15-compat=yes \
    -S mta="$MTA" \
    -S from="$EMAIL" \
    "$EMAIL"

echo "Monitoring started. Waiting for Container events..."

# --- PART 2: LISTEN FOR CONTAINER START/STOP EVENTS ---
docker events --filter 'event=start' --filter 'event=stop' --format 'Action: {{.Status}} | Container: {{.Actor.Attributes.name}}' | while read line
do
    echo "Event detected: $line"
    echo -e "Docker Notification:\n\n$line" | s-nail -v \
        -s "Docker Container Event" \
        -S v15-compat=yes \
        -S mta="$MTA" \
        -S from="$EMAIL" \
        "$EMAIL"
done

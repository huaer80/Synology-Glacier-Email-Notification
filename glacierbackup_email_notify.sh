#!/bin/bash

# Define your email settings
SMTP_SERVER="smtp.yourserver.com"
SMTP_PORT="587" # or 465 for SSL
FROM_EMAIL="Synology Notification"
TO_EMAIL="youremailaddress@xacme.com"
EMAIL_SUBJECT="Synology Glacier Backup Status"

# Path to your SQLite database file
DB_PATH="/volume1/@GlacierBackup/etc/sysinfo.db"

# SQL query to select the last 2 entries based on an auto-incrementing ID (or timestamp)
# Assumes there is an 'id' column or a timestamp column you can order by
SQL_QUERY="SELECT key,level,date,message FROM sysinfo_tb ORDER BY key DESC LIMIT 2;"

# Run the query with formatted output (with headers and column mode)
RESULT=$(sqlite3 "$DB_PATH" "$SQL_QUERY")

# Separate the results into two lines
IFS=$'\n' read -rd '' -a rows <<< "$RESULT"

# Print each result on a separate line
for row in "${rows[@]}"; do
  # Extract the EPOCH timestamp and convert it to a human-readable format
  key=$(echo "$row" | awk -F'|' '{print $1}')
  level=$(echo "$row" | awk -F'|' '{print $2}')
  epoch=$(echo "$row" | awk -F'|' '{print $3}')
  message=$(echo "$row" | awk -F'|' '{print $4}')
  
  # Convert EPOCH to human-readable format
  readable_time=$(date -d @"$epoch" "+%Y-%m-%d %H:%M:%S")
  
  # Print the formatted result
  EMAIL_BODY+="$key | $level | $readable_time | $message\n"
done


# Send email using ssmtp
echo -e "Subject:$EMAIL_SUBJECT\nFrom:$FROM_EMAIL\nTo:$TO_EMAIL\n\n$EMAIL_BODY" | ssmtp "$TO_EMAIL"

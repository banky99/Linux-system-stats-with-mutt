#!/bin/bash

# Script for performing backups, capturing system metrics, including network statistics, and emailing reports

# Author: Eshiebor Oshiomegie Festus
# prereqisit install sudo apt-get install sysstat  and sudo apt-get install net-tools
# prerequisit install and setup mutt with your details 
# Date: 23/11/2023

# Directory paths

source_folder="./ingreddDocs"

backup_folder="/home/festus/preproject1/ingredbackup"

backup_log="backup.log"

metrics_report="metrics_report.txt"

# Ensure backup directory exists or create if absent

if [ ! -d "$backup_folder" ]; then

mkdir -p "$backup_folder" || { echo "Failed to create directory: $backup_folder"; exit 1; }

fi

# Perform backup if changes detected, else skip

if rsync -a --checksum "$source_folder" "$backup_folder" >/dev/null 2>&1; then

echo "No backup performed; no changes detected."

else

# Backup files with timestamp

timestamp=$(date +%Y%m%d%H%M%S)

tar -czf "$backup_folder/backup_$timestamp.tar.gz" "$source_folder" >> "$backup_log" 2>&1 && \

echo "Backup completed successfully."

fi

# Function to calculate average CPU usage over 24 hours

calculate_average_cpu() {

total_cpu_usage=0

for ((hour = 0; hour < 24; hour++)); do

cpu_usage=$(mpstat 1 1 | awk '/Average/ {printf "%.2f", 100 - $NF}')

total_cpu_usage=$(awk "BEGIN {print $total_cpu_usage + $cpu_usage}")

done

echo "$total_cpu_usage"

}

# Function to capture system metrics including network statistics in a table format

capture_system_metrics() {

echo "DayOfWeek | Total_CPU_Usage | Total_Disk_Space_Usage(KB) | Total_Memory_Usage(MB) | Network_Stats"

echo "--------- | --------------- | ------------------------- | ---------------------- | -------------"

for ((day = 1; day <= 7; day++)); do

day_of_week=$(date -d "now + $day days" +%A)

total_cpu_usage=$(calculate_average_cpu)

total_disk_space_usage=$(iostat -dk | awk '/sda/ {print $4}' | tail -n 1)

total_memory_usage=$(free -m | awk '/Mem/ {print $3}')

network_stats=$(netstat -s | awk '/total packets received/ {print $1}' | head -n 1)

printf "%-9s | %-15s | %-25s | %-20s | %-13s\n" "$day_of_week" "$total_cpu_usage%" "$total_disk_space_usage" "$total_memory_usage MB" "$network_stats packets"

done

}

# Capture system metrics and save to a file

capture_system_metrics > "$metrics_report"

# Function to send email using mutt and check status

send_email() {

recipient="megie.festus@gmail.com"

cc_recipient="festus.megie@gmail.com"

subject="Eshiebor Oshiomegie mutt email"

body="Dear Mr. festus,Attached is the Preproject metrics report, backup file, and a copy of the script for today and last week's stats:$(capture_system_metrics)"

attachments=("$backup_folder/backup_"*.tar.gz "$metrics_report" "$0") # Include the script itself as an attachment

# Use mutt to send the email with attachments and check status

if mutt -s "$subject" -a "${attachments[@]}" -- "$recipient" <<< "$body"; then

echo "Email sent successfully."

else

echo "Failed to send email."

fi

}

# Call the function to send the email with attachments using mutt and check the status

send_email

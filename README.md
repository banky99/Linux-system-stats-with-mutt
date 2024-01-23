# Linux-system-stats-with-mutt
Sure, I'll provide you with a detailed README documentation that you can use for your GitHub repository. Make sure to replace the placeholder `<your_email>` with your actual email address.

---

# Backup and Metrics Report Script

This Bash script performs backups of a specified folder, captures system metrics including network statistics, and emails reports using the Mutt email client.

## Author

- **Eshiebor Oshiomegie Festus**

## Prerequisites

1. **Install Required Packages:**
   - Install `sysstat` for system statistics: `sudo apt-get install sysstat`
   - Install `net-tools` for network tools: `sudo apt-get install net-tools`

2. **Install and Configure Mutt:**
   - Install Mutt using your package manager.
   - Configure Mutt with your email details.

## Directory Paths

- `source_folder`: The folder to be backed up.
- `backup_folder`: The destination folder for backups.
- `backup_log`: Log file for backup operations.
- `metrics_report`: File to store captured system metrics.

## Usage

### 1. Ensure Backup Directory Exists

```bash
if [ ! -d "$backup_folder" ]; then
  mkdir -p "$backup_folder" || { echo "Failed to create directory: $backup_folder"; exit 1; }
fi
```

### 2. Perform Backup

```bash
if rsync -a --checksum "$source_folder" "$backup_folder" >/dev/null 2>&1; then
  echo "No backup performed; no changes detected."
else
  timestamp=$(date +%Y%m%d%H%M%S)
  tar -czf "$backup_folder/backup_$timestamp.tar.gz" "$source_folder" >> "$backup_log" 2>&1 && \
  echo "Backup completed successfully."
fi
```

### 3. Capture System Metrics

```bash
capture_system_metrics() {
  # Function code
}
capture_system_metrics > "$metrics_report"
```

### 4. Send Email with Attachments

```bash
send_email() {
  # Function code
}
send_email
```

### 5. Automate Execution

You can set up scheduled executions using `cron`. For example, to run the script every day at 3 AM:

```bash
0 3 * * * /path/to/your/script.sh
```

## System Metrics

The script captures system metrics including:

- Total CPU Usage
- Total Disk Space Usage (in KB)
- Total Memory Usage (in MB)
- Network Statistics

These metrics are captured for each day of the week and saved in `metrics_report.txt`.

## Email Configuration

The script is configured to send emails using Mutt. Ensure you have Mutt installed and configured. Modify the `send_email` function with your email details:

```bash
recipient="<your_email>"
cc_recipient="<your_email>"
```

## Notes

- The script requires write permissions to the backup destination folder.
- Ensure that the script is executable (`chmod +x script.sh`).
- Customize the script to fit your specific backup and metric capturing requirements.

---

Feel free to adapt this documentation to your specific needs and include any additional details or explanations as necessary.

#!/bin/bash
#Security: This script must run as root. Don't forget to copy this script to the root direktory!

backup_dir="/mnt/backup/logs_backup"
log_dir="/var/log/my_script_logs"
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
error_log="$log_dir/backup_logs_error.log"
success_log="$log_dir/backup_logs.log"

# 1 Check if 'logs_backup' directory doesn't exist, create it
if [ ! -d "$backup_dir" ]; then
    mkdir -p "$backup_dir" || { echo "$timestamp - Error creating logs_backup directory." >> "$error_log"; exit 1; }
fi

# 2 Create a backup of '/var/log' directory
tar -czvf "$backup_dir/backup_log_$(date +"%Y%m%d%H%M").tar.gz" /var/log
if [ $? -eq 0 ]; then
    # Delete content in '/var/log' directory if the backup was successful
    rm -R /var/log/*
    # Log an error if deletion fails
    if [ -n "$(ls -A /var/log/)" ]; then
        echo "$timestamp - Deleting content in log directory failed." >> "$error_log";
    fi
else
    # Log an error if the backup creation fails
    echo "$timestamp - Creating log directory backup failed." >> "$error_log"; exit 1;
fi

# 3 Create a backup of '/mnt/my_mnt/my_script_logs' directory
tar -czvf "$backup_dir/backup_my_script_logs_$(date +"%Y%m%d%H%M").tar.gz" /mnt/my_mnt/my_script_logs
if [ $? -eq 0 ]; then
    # Delete content in '/mnt/my_mnt/my_script_logs' directory if the backup was successful
    rm -R /mnt/my_mnt/my_script_logs/*
    # Log an error if deletion fails
    if [ -n "$(ls -A /mnt/my_mnt/my_script_logs/)" ]; then
        echo "$timestamp - Deleting content in my_script_logs directory failed." >> "$error_log";
    fi
else
    # Log an error if the backup creation fails
    echo "$timestamp - Creating my_script_logs directory backup failed." >> "$error_log"; exit 1;
fi

# 4 Log that the backup_logs completed successfully
echo "$timestamp - backup_logs completed successfully." >> "$success_log"

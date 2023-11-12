#!/bin/bash
#Security: This script must run as root. Don't forget to copy this script to the root direktory!

backup_dir="/mnt/backup"
log_dir="/mnt/MY_MNT/my_script_logs"
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
error_log="$log_dir/backup_DIREKTORY_error.log"
success_log="$log_dir/backup_DIREKTORY.log"

# 1 Check if 'DIREKTORY_backup' directory doesn't exist, create it
if [ ! -d "$backup_dir/DIREKTORY_backup" ]; then
    mkdir -p "$backup_dir/DIREKTORY_backup" || { echo "$timestamp - Error creating DIREKTORY_backup directory." >> "$error_log"; exit 1; }
fi

# 2 Check if 'DIREKTORY_backup_cash' directory doesn't exist, create it
if [ ! -d "$backup_dir/DIREKTORY_backup_cash" ]; then
    mkdir -p "$backup_dir/DIREKTORY_backup_cash" || { echo "$timestamp - Error creating DIREKTORY_backup_cash directory." >> "$error_log"; exit 1; }
fi

# 3 Copy content from '/mnt/MY_MNT/DIREKTORY' to 'DIREKTORY_backup_cash'
cp -R "/mnt/MY_MNT/DIREKTORY"/* "$backup_dir/DIREKTORY_backup_cash/" || { echo "$timestamp - Error copying files to DIREKTORY_backup_cash." >> "$error_log"; exit 1; }

# 4 Clear the contents of 'DIREKTORY_backup' directory and check if it's empty
rm -R "$backup_dir/DIREKTORY_backup"/*
if [ "$(ls -A $backup_dir/DIREKTORY_backup)" ]; then
    echo "$timestamp - Error: DIREKTORY_backup directory is not empty after deletion." >> "$error_log"
    exit 1
fi

# 5 Copy content from 'DIREKTORY_backup_cash' to 'programming_backup'
cp -R "$backup_dir/DIREKTORY_backup_cash"/* "$backup_dir/DIREKTORY_backup/" || { echo "$(date) - Error copying files from DIREKTORY_backup_cash to DIREKTORY_backup." >> "$error_log"; exit 1; }

# 6 Clear the contents of 'DIREKTORY_backup_cash' and log if not successful
rm -R "$backup_dir/DIREKTORY_backup_cash"/*
if [ "$(ls -A $backup_dir/DIREKTORY_backup_cash)" ]; then
    echo "$timestamp - Error: DIREKTORY_backup_cash directory is not empty after deletion." >> "$error_log"
fi

# 7 Log that the backup_DIREKTORY_direktory completed successfully
echo "$timestamp - backup_DIREKTORY_direktory completed successfully." >> "$success_log"

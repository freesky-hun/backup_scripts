#!/bin/bash
#Security: This script must run as root. Don't forget to copy this script to the root directory!

backup_dir="/mnt/backup"
log_dir="/mnt/MY_MNT/my_script_logs"
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
error_log="$log_dir/backup_DIRECTORY_error.log"
success_log="$log_dir/backup_DIRECTORY.log"

# 1 Check if 'DIRECTORY_backup' directory doesn't exist, create it
if [ ! -d "$backup_dir/DIRECTORY_backup" ]; then
    mkdir -p "$backup_dir/DIRECTORY_backup" || { echo "$timestamp - Error creating DIRECTORY_backup directory." >> "$error_log"; exit 1; }
fi

# 2 Check if 'DIRECTORY_backup_cash' directory doesn't exist, create it
if [ ! -d "$backup_dir/DIRECTORY_backup_cash" ]; then
    mkdir -p "$backup_dir/DIRECTORY_backup_cash" || { echo "$timestamp - Error creating DIRECTORY_backup_cash directory." >> "$error_log"; exit 1; }
fi

# 3 Copy content from '/mnt/MY_MNT/DIRECTORY' to 'DIREKTORY_backup_cash'
cp -R "/mnt/MY_MNT/DIRECTORY"/* "$backup_dir/DIRECTORY_backup_cash/" || { echo "$timestamp - Error copying files to DIRECTORY_backup_cash." >> "$error_log"; exit 1; }

# 4 Clear the contents of 'DIRECTORY_backup' directory and check if it's empty
rm -R "$backup_dir/DIRECTORY_backup"/*
if [ "$(ls -A $backup_dir/DIRECTORY_backup)" ]; then
    echo "$timestamp - Error: DIRECTORY_backup directory is not empty after deletion." >> "$error_log"
    exit 1
fi

# 5 Copy content from 'DIRECTORY_backup_cash' to 'programming_backup'
cp -R "$backup_dir/DIRECTORY_backup_cash"/* "$backup_dir/DIRECTORY_backup/" || { echo "$(date) - Error copying files from DIRECTORY_backup_cash to DIRECTORY_backup." >> "$error_log"; exit 1; }

# 6 Clear the contents of 'DIRECTORY_backup_cash' and log if not successful
rm -R "$backup_dir/DIRECTORY_backup_cash"/*
if [ "$(ls -A $backup_dir/DIRECTORY_backup_cash)" ]; then
    echo "$timestamp - Error: DIRECTORY_backup_cash directory is not empty after deletion." >> "$error_log"
fi

# 7 Log that the backup_DIRECTORY_directory completed successfully
echo "$timestamp - backup_DIRECTORY_directory completed successfully." >> "$success_log"

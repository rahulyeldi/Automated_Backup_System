#!/bin/bash

# Directories to backup
SOURCE_DIRECTORIES=(
    "/Users/rahulsanjeevyeldi/source_backup"
)

# Backup destination
DESTINATION="/Users/rahulsanjeevyeldi/destination_backup"

# Log file for backup operations
LOG_FILE="$DESTINATION/backup.log"

# Date format for versioning
DATE=$(date +"%Y%m%d_%H%M%S")

backup() {
    for SOURCE in "${SOURCE_DIRECTORIES[@]}"; do
        # Create a timestamped backup directory
        BACKUP_DIR="$DESTINATION/backup_$DATE"
        mkdir -p "$BACKUP_DIR"

        # Perform incremental backup
        rsync -av --delete "$SOURCE/" "$BACKUP_DIR/" >> "$LOG_FILE" 2>&1

        # Log success or failure
        if [ $? -eq 0 ]; then
            echo "Backup of $SOURCE completed successfully at $DATE." >> "$LOG_FILE"
        else
            echo "Backup of $SOURCE failed at $DATE." >> "$LOG_FILE"
        fi
    done
}

manage_versions() {
    local BACKUP_COUNT=$(ls "$DESTINATION" | grep backup_ | wc -l)
    local MAX_BACKUPS=5  # Maximum number of backups to keep

    if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
        # Remove the oldest backup
        OLD_BACKUP=$(ls -1t "$DESTINATION"/backup_* | tail -n 1)
        rm -rf "$OLD_BACKUP"
        echo "Removed old backup: $OLD_BACKUP" >> "$LOG_FILE"
    fi
}

main() {
    echo "Starting backup process at $DATE..." >> "$LOG_FILE"
    backup
    manage_versions
    echo "Backup process completed." >> "$LOG_FILE"
}

main


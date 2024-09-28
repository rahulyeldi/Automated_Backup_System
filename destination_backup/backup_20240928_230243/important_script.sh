#!/bin/bash

# Log file
LOG_FILE="health_check.log"

# Check memory usage in GB
echo "=== Memory Usage (GB) ===" > "$LOG_FILE"
free -g >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Check number of CPU cores
echo "=== Number of CPU Cores ===" >> "$LOG_FILE"
nproc >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Output completion message
echo "Health check completed. Results logged in $LOG_FILE."


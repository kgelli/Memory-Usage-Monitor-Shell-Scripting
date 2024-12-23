#!/bin/bash

# Configuration
EMAIL="your_email@example.com"    # Your email address
THRESHOLD=90                      # Memory threshold percentage
LOG_FILE="mem_report.tsv"        # Log file location

# Ensure proper path for cron execution
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

# Create TSV header if file doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    echo -e "Timestamp\tMemory_Usage(%)\tAlert_Status" > "$LOG_FILE"
fi

# Function to calculate memory usage percentage
get_memory_usage() {
    local mem_total=$(grep 'MemTotal' /proc/meminfo | awk '{print $2}')
    local mem_available=$(grep 'MemAvailable' /proc/meminfo | awk '{print $2}')
    local mem_used=$((mem_total - mem_available))
    local usage_percentage=$(awk "BEGIN {printf \"%.2f\", ($mem_used * 100)/$mem_total}")
    echo "$usage_percentage"
}

# Function to get top memory consuming processes
get_top_processes() {
    ps aux --sort=-%mem | head -n 6 | tail -n 5 | awk '{print $11":"$4"%"}' | tr '\n' '|'
}

# Function to log to TSV
log_to_tsv() {
    local usage=$1
    local alert_status=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${timestamp}\t${usage}\t${alert_status}" >> "$LOG_FILE"
}

# Function to speak alert
speak_alert() {
    local usage=$1
    if command -v espeak >/dev/null 2>&1; then
        espeak "Warning! Memory usage is at ${usage}percent"
    else
        echo "Please install espeak for audio alerts:"
        echo "sudo apt-get install espeak  # For Debian/Ubuntu"
        echo "sudo yum install espeak      # For Red Hat/CentOS"
    fi
}

# Function to send email alert
send_email_alert() {
    local usage=$1
    local subject="Memory Alert: High Usage Detected"
    local top_procs=$(get_top_processes)
    
    local message="Warning: Memory usage is at ${usage}%\n\n"
    message+="Top Memory-Consuming Processes (Process:Memory%):\n"
    message+="${top_procs}"
    
    echo -e "$message" | mail -s "$subject" "$EMAIL"
}

# Main execution
memory_usage=$(get_memory_usage)

# Check threshold and trigger alerts
if (( $(echo "$memory_usage > $THRESHOLD" | bc -l) )); then
    alert_status="ALERT"
    send_email_alert "$memory_usage"
    speak_alert "$memory_usage"
    echo "Alert email sent! Memory usage: ${memory_usage}%"
else
    alert_status="OK"
    echo "Memory usage: ${memory_usage}%"
fi

# Log to TSV file
log_to_tsv "$memory_usage" "$alert_status"
echo "Memory usage logged to $LOG_FILE"
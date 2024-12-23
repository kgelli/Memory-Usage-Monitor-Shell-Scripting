# Memory-Usage-Monitor-Shell-Scripting

A shell script to monitor system memory usage with email alerts, audio notifications, and TSV logging.

## Features

- Real-time memory usage monitoring
- Email alerts when memory usage exceeds threshold
  - Includes top 5 memory-consuming processes and their usage percentages
  - Automated process monitoring and reporting
- Audio notifications using espeak
- Detailed logging in TSV format
- Automated monitoring through cron jobs

## Prerequisites

### Required Packages
```bash
# For Debian/Ubuntu
sudo apt-get install sendmail espeak bc

# For Red Hat/CentOS
sudo yum install sendmail espeak bc
```

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/memory-monitor.git
cd memory-monitor
```

2. Make the script executable:
```bash
chmod +x memory_monitor.sh
```

3. Configure the script:
- Open `memory_monitor.sh` and set:
  ```bash
  EMAIL="your_email@example.com"    # Your email address
  THRESHOLD=90                      # Memory threshold percentage
  LOG_FILE="mem_report.tsv"        # Log file location
  ```

## Usage

### Manual Execution
```bash
./memory_monitor.sh
```

### Automated Monitoring
Set up hourly monitoring using crontab:
```bash
# Open crontab editor
crontab -e

# Add this line
0 * * * * /path/to/memory_monitor.sh

# Verify cron job
crontab -l
```

## Output Examples

### Normal Operation
```
Memory usage: 72.45%
Memory usage logged to mem_report.tsv
```

### Alert Condition
```
Alert email sent! Memory usage: 92.33%
Memory usage logged to mem_report.tsv
[Voice Alert]: "Warning! Memory usage is at 92.33 percent"
```

### Email Alert Format
```
Subject: Memory Alert: High Usage Detected

Warning: Memory usage is at 92.33%

Top Memory-Consuming Processes (Process:Memory%):
chrome:15.2%|firefox:8.5%|mysql:6.7%|nodejs:4.2%|python:3.8%|
```

### Log File Format (mem_report.tsv)
```
Timestamp               Memory_Usage(%)    Alert_Status
2024-12-23 14:00:00    72.45             OK
2024-12-23 15:00:00    92.33             ALERT
2024-12-23 16:00:00    85.67             OK
```

## Troubleshooting

### Email Alerts
1. Check sendmail status:
```bash
systemctl status sendmail
```
2. Test email:
```bash
echo "Test" | mail -s "Test" your_email@example.com
```

### Audio Alerts
1. Check espeak:
```bash
espeak "Test message"
```

### Cron Jobs
1. Check cron service:
```bash
systemctl status cron
```
2. View cron logs:
```bash
grep CRON /var/log/syslog
```

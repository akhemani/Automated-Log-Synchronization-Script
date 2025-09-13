# Automated-Log-Synchronization-Script
This repository contains a lightweight yet powerful Bash script designed to automate the management and synchronization of application logs. The script was developed to solve a common operational challenge: ensuring local development and production logs are regularly processed for errors and securely backed up to a central server.

---

## 🚀 Features

- **Automated Log Generation**  
  Simulates log file creation and organization using a `for` loop to generate realistic log data for testing.

- **Proactive Error Scanning**  
  Uses a `while` loop and pattern matching to efficiently scan log files and extract critical error messages, appending them to a dedicated error report.

- **Secure File Transfer**  
  Leverages `scp` to securely copy the generated error report to a remote server for archival and analysis.

- **Efficient Synchronization**  
  Employs `rsync` for reliable, one-way synchronization of the entire log directory, preserving file attributes and minimizing transfer overhead.

- **Regex-based Analysis**  
  Includes advanced `grep` commands with regular expressions to perform detailed analysis, such as counting specific types of errors with timestamps.

---

## 📦 How to Use

```bash
# Step 1: Clone the Repository
git clone https://github.com/your-username/your-repo-name.git](https://github.com/akhemani/Automated-Log-Synchronization-Script
cd your-repo-name

# Step 2: Make the Script Executable
chmod +x log_processor.sh

# Step 3: Configure Your Environment
# Open the log_processor.sh file and set the following variables:
REMOTE_USER=your-remote-username
REMOTE_HOST=your-remote-host

# Step 4: Run the Script
./log_processor.sh

**# Why It Matters**
This script demonstrates core Bash scripting skills and key DevOps principles such as:

Automation

Secure file transfer

Data integrity

Log analysis

Remote synchronization

Whether you're managing logs for a small app or a distributed system, this tool provides a solid foundation for scalable log handling.

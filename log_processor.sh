#!/bin/bash

# function to create 3 directories and 5 log files inside one directory
setup_local_logs () {

    #creating directories
    echo "=================== DIRECTORIES ========================="
    local DIRECTORIES=("logs/" "logs/dev/" "logs/prod")

    if [ ! -d ${DIRECTORIES[0]} ]; then
        for dir in $DIRECTORIES; do
            mkdir $dir
        done
    else
        echo "Directories already created"
    fi

    echo "=================== LOG FILES ========================="
    # check if logs/prod is created as directory or not and if yes, create 5 logs files with different names in it
    if [ -d ${DIRECTORIES[2]} ]; then
        if [ ! -f "${DIRECTORIES[2]}/prod_log_20240101.log" ]; then
            echo "Creating files"
            for index in {1..5}; do
                touch "${DIRECTORIES[2]}/prod_log_2024010$index".log
            done
            echo "Log files created"
        else
            echo "Log files already created"
        fi
    else
        echo "logs/prod does not exists"
    fi
}

# analyze all errors and failures for each log file and append all errors and failures in one file
analyze_for_errors () {

    # saving passed directory name from argument in variable
    local DIR_NAME=$1

    if [ ! -d $DIR_NAME ]; then
        echo "Please give valid directory name"
    else
        echo "============== Analyzing all files in $DIR_NAME directory =============="
        for file in "$DIR_NAME"/*; do
            echo "-------------- Analyzing all logs in $file --------------"
            while IFS= read -r line; do
                if [[ $line == *ERROR* || $line == *FAILURE* ]]; then
                    echo $line >> "error_report.txt"
                fi
            done < $file
        done
    fi
}

# connect to remote server using ssh, copy the error file securely and confirm it's presence on remote server
send_report_to_server () {

    local REMOTE_USER=$1
    local REMOTE_HOST=$2
    local KEY_PATH=$3
    local FILE_TO_COPY=$4

    echo "Trying to connect $REMOTE_USER on $REMOTE_HOST with $KEY_PATH key"

    ssh -i $KEY_PATH $REMOTE_USER@$REMOTE_HOST mkdir -p /home/$REMOTE_USER/error_logs/

    scp -i $KEY_PATH $FILE_TO_COPY $REMOTE_USER@$REMOTE_HOST:/home/$REMOTE_USER/error_logs/

    ssh -i $KEY_PATH $REMOTE_USER@$REMOTE_HOST ls -l /home/$REMOTE_USER/error_logs/
}

# sync all logs with their timestamps on remote server
sync_all_logs () {

    local REMOTE_USER=$1
    local REMOTE_HOST=$2
    local KEY_PATH=$3
    local SOURCE_DIR="$HOME/shell-script/assignments/assignment2/logs/"
    local DEST_DIR="/home/$REMOTE_USER/logs/"

    ssh -i "$KEY_PATH" "$REMOTE_USER@$REMOTE_HOST" "mkdir -p $DEST_DIR"

    rsync -av --exclude='*.tmp' -e "ssh -i $KEY_PATH" "$SOURCE_DIR" "$REMOTE_USER@$REMOTE_HOST:$DEST_DIR"

    ssh -i "$KEY_PATH" "$REMOTE_USER@$REMOTE_HOST" 'find '"$DEST_DIR"' -type f -exec ls -l --time-style=long-iso {} + | awk '\''{print $6, $7, $8}'\'''
}

# count all FAILURE logs in error_report.txt
find_and_count_critical_errors () {

    local FILE_PATH=$1

    local COUNT=$(grep -E 'FAILURE.*[0-9]{4}' "$FILE_PATH" | wc -l)

    echo "Total critical errors with timestamps found in '$FILE_PATH': $COUNT"
}

setup_local_logs
analyze_for_errors logs/prod
send_report_to_server ubuntu 34.226.190.18 ~/Downloads/ec2_key_value_pair.pem error_report.txt
sync_all_logs ubuntu 34.226.190.18 ~/Downloads/ec2_key_value_pair.pem 
find_and_count_critical_errors error_report.txt

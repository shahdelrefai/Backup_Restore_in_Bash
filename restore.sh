#!/bin/bash

check_arguments() {
    required_args="$1"
    shift
    if [ "$#" -ne "$required_args" ]; then
        echo "Write $required_args arguments as follows: $0 dir backupdir interval_sec max_backups"
        exit 1
    fi
}

check_directory_exists() {
    if [ ! -d "$1" ]; then
        echo "Directory $1 does not exist."
        exit 1
    fi
}

check_for_existing_backups() {
    if [ "${#backups[@]}" -eq 0 ]; then
        echo "No backups found in $backupdir."
        exit 1
    fi
}

get_matching_backup_index() {
    for i in "${!backups[@]}"; do
        backup_timestamp="${backups[$i]}"
        if diff -r "$dir" "$backupdir/$backup_timestamp" >/dev/null; then
            echo "$i"
            return
        fi
    done
    echo "-1"
}

check_if_no_matching_backup() {
    if [ "$current_backup_index" -eq "-1" ]; then
        echo "No matching backup found."
        exit 1
    fi
}

# start of the script
check_arguments 2 "$@"
dir="$1"
backupdir="$2"

check_directory_exists "$dir"
check_directory_exists "$backupdir"

backups=($(ls -1t "$backupdir" | sort))
check_for_existing_backups

current_backup_index=$(get_matching_backup_index)
check_if_no_matching_backup

while true; do
    echo "Current backup: ${backups[$current_backup_index]}"

    echo "Choose an option:"
    echo "1: Restore to the previous version"
    echo "2: Restore to the next version"
    echo "3: Exit"

    read -p "Enter your choice: " choice

    write

    case $choice in
    1)
        # Restore to previous backup
        if [ "$current_backup_index" -gt 0 ]; then
            current_backup_index=$((current_backup_index - 1))
            backup_timestamp="${backups[$current_backup_index]}"
            rm -rf "$dir"/
            cp -a "$backupdir/$backup_timestamp"/ "$dir"/
            echo "Restored to a previous version: $backup_timestamp"
        else
            echo "No older backup available to restore."
        fi
        ;;
    2)
        # Restore to next backup
        if [ "$current_backup_index" -lt $((${#backups[@]} - 1)) ]; then
            current_backup_index=$((current_backup_index + 1))
            backup_timestamp="${backups[$current_backup_index]}"
            rm -rf "$dir"/
            cp -a "$backupdir/$backup_timestamp"/ "$dir"/
            echo "Restored to a next version: $backup_timestamp"
        else
            echo "No newer backup available to restore."
        fi
        ;;
    3)
        echo "Exiting restore process."
        break
        ;;
    *)
        echo "Invalid option. Please choose 1, 2, or 3."
        ;;
    esac
done

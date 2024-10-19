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

validate_integer() {
    local value="$1"
    local name="$2"

    if ! [[ "$value" =~ ^[0-9]+$ ]]; then
        echo "$name should be an integer."
        exit 1
    fi

    if [ "$value" -lt 1 ]; then
        echo "$name should be greater than or equal to 1."
        exit 1
    fi
}

create_backup() {
    current_date=$(date +"%Y-%m-%d-%H-%M-%S")
    backup_path="$backupdir/$current_date"
    mkdir -p "$backup_path"

    cp -a "$dir"/. "$backup_path"

    echo "Backup created at $backup_path"
}

maintain_max_backup() {
    backups=($(ls -1t "$backupdir" | sort))

    num_exceeding=$((${#backups[@]} - max_backups))

    if [ "$num_exceeding" -gt 0 ]; then
        for ((i = 1; i <= num_exceeding; i++)); do
            oldest_backup="${backups[0]}"
            backup_path="$backupdir/$oldest_backup"

            if [ -d "$backup_path" ]; then
                rm -r "$backup_path"
                echo "Deleted old backup: $backup_path"
            else
                echo "Warning: Directory $backup_path does not exist."
            fi

            # Remove the last (oldest) backup from the list
            backups=("${backups[@]:0:${#backups[@]}-1}")
        done
    fi
}

save_dir_info() {
    local directory="$1"
    echo "$(ls -lR "$directory")"
}

# start of the script
check_arguments 4 "$@"

dir="$1"
backupdir="$2"
interval_sec="$3"
max_backups="$4"

check_directory_exists "$dir"
check_directory_exists "$backupdir"

validate_integer "$interval_sec" "Interval"
validate_integer "$max_backups" "Max backups"

# initials
last_dir_info=$(save_dir_info "$dir")
create_backup
maintain_max_backup

while true; do
    sleep "$interval_sec"

    current_dir_info=$(save_dir_info "$dir")

    if [ "$last_dir_info" != "$current_dir_info" ]; then
        echo "Directory has changed. Creating a new backup..."

        create_backup
        maintain_max_backup

        last_dir_info="$current_dir_info"
    else
        echo "No changes detected."
    fi
done

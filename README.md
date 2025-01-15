# Backup Restore in Bash

## Overview
This project implements a backup/restore solution consistig of two main scripts: 
* `backup.sh` for creating backups of a specified directory into a specified backup directory.
* `restore.sh` for restoring previous versions of the directory from the backups.


### Folder Hierarchy
    .Backup Restore in Bash/
    ├── backup.sh                    # Script to create backups of a specified directory.
    ├── restore.sh                   # Script to restore files from backups.
    ├── Makefile                     # Makefile for running backup and restore
    └── README.md

## Backup
The `backup.sh` script continuously monitors the specified directory for changes and creates a new backup if any changes are detected after a specific interval of time specified by `interval_sec`. It also maintains a maximum number of backups specified by `max_backups`. Both backup interval and maximum backups are customizable.
## Restore
The `restore.sh` script allows you to navigate through available backups and restore files to the original directory.
## Makefile
Allows you to run `make backup` and `make restore` with pre-set source directory, backup directory, interval_sec and max_backups. Also you can modify from just one argument to all of them.


## Ubuntu Prerequisites
Before running the scripts, ensure you have the following prerequisites installed on your Ubuntu system:
1. **Bash**: Most Ubuntu installations have Bash installed by default.
2. **Core Utilities**: The scripts utilize basic command-line utilities that are typically available in Ubuntu.
3. **GNU Make**: Required for the Makefile to work.

### Installing Prerequisites on Ubuntu
To ensure you have the necessary utilities, you can install them using the following commands:
```
bash
sudo apt update
sudo apt install make coreutils
```

## For MacOs Users
Bash is one of the shells available natively on MacOs. To use bash shell run the following:
```
chsh -s /bin/bash
exec bash
```

## Step-by-Step Instructions to Run the Project
1. Clone or Download the Repository.
2. Navigate to the Project Directory: Open a terminal and navigate to the directory:
```
cd /path/to/Backup_Restore_in_Bash
```
3. Configure the Paths: Edit the Makefile to set the backupdir (backup destination) and dir (source directory) paths according to your preferences.
```
backupdir := /path/to/backup
dir := /path/to/source
interval_sec := 60                   # Backups every (interval_sec) seconds
max_backups := 5                     # Creates maximum of (max_backups) after that it starts deleting the oldest to add more
```
4. Run the Backup Script: Use the following command to create the backup:
```
make backup
# Stopping the Backup Process: interrupt it in the terminal (e.g., using Ctrl + C).
```
5. Run the Restore Script: If you need to restore from a backup, use the following command:
```
make restore
```
You will be promted with 3 options to choose from:
```
1: Restore to the previous version     # Restore to the directory version imediatily before your current version
2: Restore to the next version         # Restore to the directory version imediatily after your current version
3: Exit
```










backupdir := /Users/shahdelrefai/OS/backup
dir := /Users/shahdelrefai/OS/source
interval_sec := 10
max_backups := 5

backup:
	@if [ ! -d "$(backupdir)" ]; then \
		echo "Creating backup directory: $(backupdir)"; \
		mkdir -p "$(backupdir)"; \
	fi
	./backupd.sh "$(dir)" "$(backupdir)" $(interval_sec) $(max_backups)

restore:
	@if [ ! -d "$(backupdir)" ]; then \
		echo "Backup directory does not exist. Please run the backup first."; \
		exit 1; \
	fi
	./restore.sh "$(dir)" "$(backupdir)"

.PHONY: backup restore

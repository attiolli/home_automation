#!/bin/bash
rsync -v -e "ssh -i ~/.ssh/id_rsa -p 22" --exclude-from='~/home_automation/rsync/rsync_backup_exclude.txt' --backup --backup-dir=`date +%Y.%m.%d` -a user@remoteserver:/remote/backup/path/ /local/backup/path/

#!/bin/bash

# Backup creation
gitlab-rake gitlab:backup:create >> /var/log/logfile_12pm 2>&1

# Sync backups to remote server
rsync -avz /var/opt/gitlab/backups/ username@192.168.1.1:/var/backups/GIT >> /var/log/logfile_12pm 2>&1

# Cleanup old backups (keep only the last two weeks)
find /var/opt/gitlab/backups/ -type f -mtime +14 -delete


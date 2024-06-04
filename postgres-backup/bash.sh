#!/bin/bash


DATABASE="wallet"
PGUSER="postgres"
PGPASSWORD="postgres"
PGPORT="5432"
PGHOST="192.168.1.1"
BACKUP_DIR="/opt/backups"
BACKUP_DATE=$(date +"%Y-%m-%d")
BACKUP_TIME=$(date +"%H:%M:%S")
TIME=$(date +"%Y-%m-%d-%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/$DATABASE/$DATABASE-$TIME.sql"
export PGPASSWORD="$PGPASSWORD"
pg_dump -h $PGHOST -p $PGPORT -U $PGUSER -d $DATABASE -f $BACKUP_FILE
find $BACKUP_DIR -type f -mtime +30 -exec rm {} \;


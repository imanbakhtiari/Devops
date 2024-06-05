## Backup to a Custom Format

## A custom format is the most flexible option and can be restored using pg_restore.
- `-h localhost`: Specifies the host.
- `-U postgres`: Specifies the username.
- `-F c`: Specifies the custom format.
- `-b`: Includes large objects.
- `-v`: Verbose mode.
- `-f wallet.backup`: Output file name.
- `wallet`: The name of the database to back up.
## For custom 

```
pg_dump -h localhost -U postgres -F c -b -v -f wallet.backup wallet
```

## For plain text
- `-F p`: Specifies the plain text format.
```
pg_dump -h localhost -U postgres -F p -b -v -f wallet.sql wallet
```

## Restore from a Custom Format Backup

### Use pg_restore for this type of backup.

```
pg_restore -h localhost -U postgres -d wallet -v wallet.backup
```

- -d wallet: Specifies the target database.

#### If the database does not exist and you want to create it during the restore process, use:

```
pg_restore -h localhost -U postgres -C -d postgres -v wallet.backup
```
- -C: Create the database before restoring.
- -d postgres: Connect to the postgres database to run the creation commands.

## Restore from a Plain Text SQL File

### Use psql for this type of backup.
```
psql -h localhost -U postgres -d wallet -f wallet.sql
```

## Cutom for 16 Version
```
pg_dump -h 10.130.1.25 -p 5000 -U postgres -d wallet > wallet.sql
```
```
psql -h localhost -U postgres -p 5432 -d wallet -f wallet.sql 
```

### FORCE DROP DATABASE
```
SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'wallet' AND pid <> pg_backend_pid();
```

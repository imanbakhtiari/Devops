find /path/to/directory -type f -exec md5sum {} + | sort | awk 'seen[$1]++ {print $2}' | xargs rm -f


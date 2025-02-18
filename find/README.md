# **Commonly Used `find` Command Switches**

The `find` command in Linux is powerful for searching files and directories. Here are some commonly used switches:

| Switch               | Description                                      | Example |
|----------------------|--------------------------------------------------|---------|
| `-name`             | Find files by name (case-sensitive)              | `find /path -name "file.txt"` |
| `-iname`            | Find files by name (case-insensitive)            | `find /path -iname "file.txt"` |
| `-type f`           | Find files only                                  | `find /path -type f` |
| `-type d`           | Find directories only                           | `find /path -type d` |
| `-size +10M`        | Find files larger than 10MB                     | `find /path -size +10M` |
| `-size -1G`         | Find files smaller than 1GB                     | `find /path -size -1G` |
| `-empty`            | Find empty files or directories                 | `find /path -empty` |
| `-mtime -7`         | Find files modified in the last 7 days          | `find /path -mtime -7` |
| `-atime +30`        | Find files not accessed in the last 30 days     | `find /path -atime +30` |
| `-ctime -2`         | Find files changed in the last 2 days           | `find /path -ctime -2` |
| `-user username`    | Find files owned by a specific user             | `find /path -user user1` |
| `-group groupname`  | Find files owned by a specific group            | `find /path -group group1` |
| `-perm 755`         | Find files with specific permissions            | `find /path -perm 755` |
| `-delete`           | Delete found files                              | `find /path -name "*.log" -delete` |
| `-exec cmd {} \;`   | Run a command on each found file                | `find /path -type f -name "*.txt" -exec rm {} \;` |
| `-execdir cmd {} \;`| Run a command in the found file’s directory     | `find /path -type f -execdir chmod 644 {} \;` |
| `-printf "%s %p\n"`| Print file size and path                         | `find /path -type f -printf "%s %p\n"` |
| `-ls`               | List details of found files                     | `find /path -type f -ls` |
| `-links +1`         | Find files with more than 1 hard link           | `find /path -type f -links +1` |
| `-newer file`       | Find files newer than a specific file           | `find /path -newer reference.txt` |
| `-depth`            | Process directories after their contents        | `find /path -depth -name "file.txt"` |
| `-prune`            | Exclude a directory from search                 | `find /path -type d -name "temp" -prune -o -print` |
| `-maxdepth N`       | Limit search to N levels deep                   | `find /path -maxdepth 2 -name "file.txt"` |
| `-mindepth N`       | Start searching at depth N                      | `find /path -mindepth 2 -name "file.txt"` |
| `-regex '.*pattern.*'` | Find files matching a regex pattern        | `find /path -type f -regex '.*log.*'` |
| `-not`              | Negate the following condition                  | `find /path -type f -not -name "*.log"` |
| `-or`               | Apply OR condition between expressions          | `find /path -type f -name "*.txt" -or -name "*.log"` |
| `-and`              | Apply AND condition between expressions         | `find /path -type f -name "*.txt" -and -size +1M` |

These `find` command switches allow for precise file searching, filtering, and actions based on file properties. 🚀


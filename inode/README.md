```
df -h
Filesystem       Inodes    IUsed    IFree IUse% Mounted on
/dev/sda1       1000000   999900      100   99% /
```


- to handle this situation

```
for i in /*; do echo "$i: $(find "$i" -type f | wc -l)"; done | sort -nr -k2 | head -10
```
- This will show the top 10 directories consuming the most inodes.

Alternatively:
```
find / -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort -nr | head -10
```


# **Fixing Inode Exhaustion in Linux**

## **🗑️ Clean Up Small Unnecessary Files**

### **Remove Old Log Files**
```bash
sudo journalctl --vacuum-time=7d  # Keep only last 7 days logs
sudo rm -rf /var/log/*.gz /var/log/*.1 /var/log/*.old
```

### **Clean Temporary Files**
```bash
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*
```

### **Clear APT Cache**
```bash
sudo apt clean
sudo apt autoclean
```

### **Find and Delete Empty Files**
```bash
find / -type f -empty -delete
```

---

## **3️⃣ Check and Remove Large Number of Small Files**

If a directory is consuming too many inodes, delete unnecessary files:
```bash
find /path/to/directory -type f -delete
```

If files are needed but can be archived:
```bash
tar -cvzf archive.tar.gz /path/to/directory && rm -rf /path/to/directory/*
```

---

## **4️⃣ Check Docker Containers (If Using Docker)**

Docker logs and containers can also exhaust inodes:
```bash
docker system df
docker system prune -a  # Clean unused containers, images, networks
```

---

## **5️⃣ Increase Inodes (Requires Reformatting)**

If you frequently run into inode exhaustion, consider reformatting with more inodes (only if necessary and on a non-critical partition):

### **Check filesystem type:**
```bash
df -T
```

### **Backup data, then reformat with a higher inode count:**
```bash
mkfs.ext4 -N 2000000 /dev/sdX
```

---

## **🛠️ Summary**

- ✅ **Run `df -i`** → Check inode usage.
- ✅ **Find inode-consuming directories** → `find / -type f | wc -l`
- ✅ **Remove old logs & temporary files.**
- ✅ **Clean up unused Docker resources (if applicable).**
- ✅ **Reformat with more inodes (if necessary).**

Try these steps and let me know if the issue persists! 🚀


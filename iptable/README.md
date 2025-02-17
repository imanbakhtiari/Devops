# **Complete Guide to iptables in Linux**

## **Introduction**
`iptables` is a command-line utility in Linux that configures firewall rules to control incoming and outgoing network traffic. It operates at the packet level and is based on the **netfilter** framework.

---

## **1. Basic Concepts**
### **Tables**
`iptables` has different tables to handle different types of packets:
- `filter` (Default): For packet filtering.
- `nat`: For Network Address Translation.
- `mangle`: For modifying packets.
- `raw`: For bypassing connection tracking.
- `security`: Used for Mandatory Access Control (MAC) rules.

### **Chains**
Each table contains predefined chains:
- `INPUT`: Controls packets coming into the system.
- `OUTPUT`: Controls packets leaving the system.
- `FORWARD`: Controls packets being forwarded through the system.
- `PREROUTING`: Used for NAT before routing decisions.
- `POSTROUTING`: Used for NAT after routing decisions.

### **Rules**
Each chain consists of rules that define how to handle packets (accept, drop, reject, log, etc.).

---

## **2. Viewing Current Rules**
```bash
sudo iptables -L -v -n
```
- `-L`: Lists all rules.
- `-v`: Provides verbose output.
- `-n`: Displays numerical output (no DNS resolution).

To view rules for a specific table (e.g., NAT):
```bash
sudo iptables -t nat -L -v -n
```

To view all active rules in all tables:
```bash
sudo iptables-save
```

---

## **3. Adding Firewall Rules**
### **Allow SSH (port 22)**
```bash
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```
### **Block all incoming connections except SSH and HTTP (port 80)**
```bash
sudo iptables -P INPUT DROP
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```
### **Allow outgoing traffic**
```bash
sudo iptables -P OUTPUT ACCEPT
```

### **Allow ICMP (Ping) Requests**
```bash
sudo iptables -A INPUT -p icmp -j ACCEPT
```

### **Block a Specific IP Address**
```bash
sudo iptables -A INPUT -s 192.168.1.100 -j DROP
```

---

## **4. Deleting Rules**
### **Delete a specific rule**
```bash
sudo iptables -D INPUT -p tcp --dport 22 -j ACCEPT
```
### **Flush all rules**
```bash
sudo iptables -F
```
### **Reset to default**
```bash
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -F
```

---

## **5. Saving and Restoring Rules**
### **Save rules**
```bash
sudo iptables-save > /etc/iptables/rules.v4
```
### **Restore rules**
```bash
sudo iptables-restore < /etc/iptables/rules.v4
```

---

## **6. Persistent iptables Rules**
To make rules persistent after reboot:
- On Ubuntu/Debian:
  ```bash
  sudo apt install iptables-persistent
  sudo netfilter-persistent save
  sudo netfilter-persistent reload
  ```
- On CentOS/RHEL:
  ```bash
  sudo service iptables save
  sudo systemctl enable iptables
  ```

---

## **7. Advanced Examples**
### **Allow only internal network (192.168.1.0/24) to access SSH**
```bash
sudo iptables -A INPUT -p tcp --dport 22 -s 192.168.1.0/24 -j ACCEPT
```
### **Rate limit SSH connections to prevent brute-force attacks**
```bash
sudo iptables -A INPUT -p tcp --dport 22 -m limit --limit 3/min --limit-burst 5 -j ACCEPT
```
### **Block all traffic except specific ports**
```bash
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```
### **Log dropped packets**
```bash
sudo iptables -A INPUT -j LOG --log-prefix "Dropped: " --log-level 4
```

---

## **8. Checking Logs**
Logs are stored in `/var/log/syslog` or `/var/log/messages`:
```bash
sudo tail -f /var/log/syslog
```

To find `iptables` logs specifically:
```bash
grep "Dropped:" /var/log/syslog
```

---

## **9. Port Forwarding with iptables**
### **Forward Traffic from One Port to Another**
```bash
sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j REDIRECT --to-port 80
```
### **Forward Traffic to Another IP**
```bash
sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 192.168.1.10:80
```

---

## **Conclusion**
This guide covers the basics and advanced usage of `iptables`. It is a powerful firewall tool with many capabilities, including NAT, port forwarding, and deep packet inspection. Always test your rules carefully to avoid locking yourself out of remote access!



```
sudo apt install libapache2-mod-evasive
sudo a2enmod evasive
sudo systemctl restart apache2
```

```
sudo vim /etc/apache2/mods-available/evasive.conf
```

```
<IfModule mod_evasive20.c>
    DOSHashTableSize    3097
    DOSPageCount        10
    DOSSiteCount        100
    DOSPageInterval     1
    DOSSiteInterval     1
    DOSBlockingPeriod   10
    DOSEmailNotify      you@example.com
    DOSSystemCommand    "iptables -A INPUT -s %s -j DROP"
</IfModule>
```

- DOSPageCount 10	...............If 10 requests to the same URL...
- DOSPageInterval 1	...............within 1 second...
- DOSBlockingPeriod 10	...........block IP for 10 seconds
- DOSEmailNotify	...............Send email when blocking
- DOSSystemCommand	...............You can run iptables or fail2ban commands 

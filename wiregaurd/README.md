### client ubuntu 

```
sudo apt update
sudo apt install wireguard
```

```
wg genkey | tee privatekey | wg pubkey > publickey
```

#### sudo vi wg0.conf

```
[Interface]
Address = 10.0.0.2/24
PrivateKey = <client-private-key>

[Peer]
PublicKey = <server-public-key>
Endpoint = <server-ip>:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
```

##### connect
```
sudo wg-quick up wg0
sudo wg show
```

##### disconnect
```
sudo wg-quick down wg0
```


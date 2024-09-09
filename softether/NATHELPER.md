
## Open /etc/sysctl.conf and uncomment or add the following line:

```
net.ipv4.ip_forward = 1
```
Apply the change immediately:
```
sudo sysctl -p
```

```
# Clear any existing rules
sudo iptables -F
sudo iptables -t nat -F

# Set up NAT from the client network (eth0) to the VPN tunnel (ppp0)
sudo iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE

# Allow forwarding of traffic from your clients to the VPN
sudo iptables -A FORWARD -i eth0 -o ppp0 -j ACCEPT

# Optionally, allow traffic from the VPN to return to the clients
sudo iptables -A FORWARD -i ppp0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
```

```
sudo apt install iptables-persistent
```

```
sudo netfilter-persistent save
```


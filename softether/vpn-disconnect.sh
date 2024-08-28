#!/bin/bash
# Load the configurations file
source $1

# Stop the SoftEther client
sudo $CLIENT_DIR/vpnclient stop

# Remove the ip routes of VPN
sudo ip route del $VPN_HOST_IPv4/32
sudo ip route replace default via $LOCAL_GATEWAY
# List the network routes
sudo netplan apply
pkill -9 dhclient
sleep 2
iptables -t nat -D POSTROUTING -o ens160 -j MASQUERADE
iptables -t nat -D POSTROUTING -o vpn_$NIC_NAME -j MASQUERADE
sudo netstat -rn


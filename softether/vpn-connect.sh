#!/bin/bash
# Load the configurations file
source $1
# Stop the SoftEther client (if running)
vpn stop

sleep 2

# Start the SoftEther client
sudo $CLIENT_DIR/vpnclient start

sleep 3

# Connect to the VPN server
$CLIENT_DIR/vpncmd /CLIENT localhost /CMD AccountConnect $ACCOUNT_NAME

sleep 4

# Check the VPN Account connection status
$CLIENT_DIR/vpncmd /CLIENT localhost /CMD AccountList

# Refresh IP address info from VPN server

sleep 2

sudo dhclient vpn_$NIC_NAME
# Set IP routes for VPN
#sudo ip route add $VPN_HOST_IPv4/32 via $LOCAL_GATEWAY
#sudo ip route del default via $LOCAL_GATEWAY

sudo ip route add $VPN_HOST_IPv4/32 via $LOCAL_GATEWAY
sudo ip route replace default via $DEFAULT_GW




$CLIENT_DIR/custom-route.sh $1
sudo netstat -rn | grep $DEFAULT_GW

sleep 3

# Refresh IP address info from VPN server

# Check the VPN Account connection status
$CLIENT_DIR/vpncmd /CLIENT localhost /CMD AccountList

iptables -t nat -A POSTROUTING -o ens160 -j MASQUERADE
iptables -t nat -A POSTROUTING -o vpn_$NIC_NAME -j MASQUERADE
iptables -A FORWARD -j ACCEPT


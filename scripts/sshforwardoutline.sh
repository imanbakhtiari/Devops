#!/bin/bash

# === Configuration ===
REMOTE_HOST="ipaddress"
REMOTE_USER="root"
REMOTE_PASS="password"
SSH_PORT=22

# TCP 1: Outline Manager
LOCAL_TCP_PORT1=6895
REMOTE_TCP_PORT1=8676

# TCP 2: VPN TCP
LOCAL_TCP_PORT2=6272
REMOTE_TCP_PORT2=53859

# UDP: VPN UDP
LOCAL_UDP_PORT=6272
REMOTE_UDP_PORT=53859

# === Enable IP forwarding (once) ===
echo "[*] Enabling IPv4 forwarding..."
sysctl -w net.ipv4.ip_forward=1 >/dev/null
grep -q "net.ipv4.ip_forward=1" /etc/sysctl.conf || echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

while true; do
  echo ""
  echo "[*] $(date) - Starting tunnels..."

  # === Clean up old processes ===
  pkill -f "ssh.*${REMOTE_HOST}" 2>/dev/null

  SOCAT_PID=$(lsof -i UDP:${LOCAL_UDP_PORT} -t 2>/dev/null)
  if [[ -n "$SOCAT_PID" ]]; then
    echo "[*] Killing stuck socat (pid $SOCAT_PID)..."
    kill -9 $SOCAT_PID 2>/dev/null
  fi

  # === Start SSH TCP tunnels ===
  echo "[*] Launching SSH TCP tunnels..."
  sshpass -p "$REMOTE_PASS" ssh \
    -o StrictHostKeyChecking=no \
    -o ServerAliveInterval=60 \
    -o ExitOnForwardFailure=yes \
    -o GatewayPorts=yes \
    -p $SSH_PORT \
    -N \
    -L 0.0.0.0:${LOCAL_TCP_PORT1}:localhost:${REMOTE_TCP_PORT1} \
    -L 0.0.0.0:${LOCAL_TCP_PORT2}:localhost:${REMOTE_TCP_PORT2} \
    ${REMOTE_USER}@${REMOTE_HOST} &
  SSH_PID=$!

  echo "[*] Waiting for TCP ports to open..."
  for i in {1..10}; do
    if ss -lnpt | grep -q ":${LOCAL_TCP_PORT1}" && ss -lnpt | grep -q ":${LOCAL_TCP_PORT2}"; then
      break
    fi
    sleep 1
  done

  if ! ss -lnpt | grep -q ":${LOCAL_TCP_PORT1}"; then
    echo "[!] TCP port $LOCAL_TCP_PORT1 failed to bind. Restarting in 5s..."
    kill "$SSH_PID" 2>/dev/null
    sleep 5
    continue
  fi

  echo "[+] TCP tunnels established:"
  echo "    - 0.0.0.0:$LOCAL_TCP_PORT1 → $REMOTE_HOST:$REMOTE_TCP_PORT1"
  echo "    - 0.0.0.0:$LOCAL_TCP_PORT2 → $REMOTE_HOST:$REMOTE_TCP_PORT2"

  # === Try to start UDP forward via socat ===
  echo "[*] Trying to start UDP forward via socat..."
  socat -T15 UDP4-RECVFROM:${LOCAL_UDP_PORT},fork \
              UDP4-SENDTO:${REMOTE_HOST}:${REMOTE_UDP_PORT} &
  SOCAT_PID=$!

  sleep 2
  if ! ss -lun | grep -q ":${LOCAL_UDP_PORT}"; then
    echo "[!] UDP socat failed to bind. Ignoring and continuing with TCP only."
    kill -9 $SOCAT_PID 2>/dev/null
    SOCAT_PID=""
  else
    echo "[+] UDP tunnel established: 0.0.0.0:${LOCAL_UDP_PORT} → ${REMOTE_HOST}:${REMOTE_UDP_PORT}"
  fi

  echo "[✔] All available tunnels running. Monitoring..."

  # === Monitor ===
  while kill -0 "$SSH_PID" 2>/dev/null; do
    if [[ -n "$SOCAT_PID" ]] && ! kill -0 "$SOCAT_PID" 2>/dev/null; then
      echo "[!] UDP tunnel died. Will retry full restart."
      break
    fi
    sleep 10
  done

  echo "[!] Detected tunnel failure. Restarting in 5 seconds..."
  sleep 5
done


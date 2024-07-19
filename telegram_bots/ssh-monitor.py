import os
import time
import logging
import asyncio
import socket
import psutil
from telegram import Bot

# Replace 'YOUR_BOT_TOKEN' and 'YOUR_CHAT_ID' with your bot's token and your chat ID
BOT_TOKEN = 'Your Token'
CHAT_ID = 'Your Chatid'

# Set up logging
logging.basicConfig(filename='/var/log/auth.log', level=logging.INFO, format='%(asctime)s %(message)s')

def tail_f(filename):
    f = open(filename, 'r')
    st_results = os.stat(filename)
    st_size = st_results.st_size
    f.seek(st_size)

    while True:
        where = f.tell()
        line = f.readline()
        if not line:
            time.sleep(1)  # Ensure 'time' module is correctly imported
            f.seek(where)
        else:
            yield line

async def send_telegram_message(message):
    bot = Bot(token=BOT_TOKEN)
    await bot.send_message(chat_id=CHAT_ID, text=message)

def get_server_ip():
    try:
        ip_addresses = []
        # Iterate over all network interfaces
        for interface, addrs in psutil.net_if_addrs().items():
            # Skip loopback interface
            if interface == 'lo':
                continue

            for addr in addrs:
                if addr.family == socket.AF_INET:
                    ip_addresses.append(addr.address)

        # Return the first non-loopback IP address found
        return ip_addresses[0] if ip_addresses else 'unknown'

    except Exception as e:
        logging.error(f"Error retrieving server IP address: {e}")
        return 'unknown'

async def monitor_ssh_logins():
    loglines = tail_f('/var/log/auth.log')
    server_ip = get_server_ip()
    server_hostname = socket.gethostname()

    for line in loglines:
        if 'sshd' in line and 'Accepted' in line:
            parts = line.split()
            user = parts[8]
            ip = parts[10]
            timestamp = ' '.join(parts[0:3])
            message = (
                f'SSH login detected:\n'
                f'User: {user}\n'
                f'Client IP: {ip}\n'
                f'Server IP: {server_ip}\n'
                f'Server Hostname: {server_hostname}\n'
                f'Time: {timestamp}'
            )
            await send_telegram_message(message)

if __name__ == '__main__':
    asyncio.run(monitor_ssh_logins())


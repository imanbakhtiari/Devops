import socket
import requests
import time

# Define your nodes and ports to monitor
nodes = [
    {"ip": "10.130.2.85", "ports": {"backend": 8090, "keycloak": 8080}},
    {"ip": "10.130.2.86", "ports": {"backend": 8090}},
    {"ip": "10.130.2.87", "ports": {"frontend": 3000}},
    {"ip": "10.130.2.88", "ports": {"frontend": 3000}},
]

# Telegram Bot credentials
TELEGRAM_BOT_TOKEN = "Your Token"
TELEGRAM_CHAT_ID = "Your Chatid"

green_circle = "\U0001F7E2"  # Green circle emoji
red_circle = "\U0001F534"    # Red circle emoji

# Dictionary to keep track of service status
service_status = {}

# Flag to track if a disaster is detected
disaster_detected = False

def check_port(ip, port):
    try:
        socket.create_connection((ip, port), timeout=5)
        return True
    except OSError:
        return False

def send_telegram_message(message):
    url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
    params = {
        "chat_id": TELEGRAM_CHAT_ID,
        "text": message,
    }
    requests.post(url, params=params)
    print(message)

def main():
    global disaster_detected

    while True:
        all_services_up = True  # Assume all services are up at the beginning of each loop

        for node in nodes:
            ip = node["ip"]
            ports = node["ports"]
            for service_name, port in ports.items():
                if not check_port(ip, port):
                    if (ip, port) not in service_status or service_status[(ip, port)] == "up":
                        # Notify service is down if it was previously up or not recorded
                        service_status[(ip, port)] = "down"
                        service_map = {
                            8090: "Backend",
                            8080: "Keycloak",
                            3000: "Frontend"
                        }
                        service = service_map.get(port, f"Service on port {port}")
                        message = f"{red_circle}\nALERT\n{service} service on node {ip} is DOWN!"
                        send_telegram_message(message)
                        all_services_up = False  # Set to False if any service is down
                        disaster_detected = True  # Set disaster flag

                else:
                    if (ip, port) in service_status and service_status[(ip, port)] == "down":
                        # Notify service is up if it was previously down
                        service_status[(ip, port)] = "up"

        # Check if all services are up and a disaster was previously detected
        if all_services_up and disaster_detected:
            # Re-check if any service is still down
            for node in nodes:
                ip = node["ip"]
                ports = node["ports"]
                for service_name, port in ports.items():
                    if not check_port(ip, port):
                        all_services_up = False
                        break
                if not all_services_up:
                    break

            if all_services_up:
                send_telegram_message(f"{green_circle}\nAll services are back online. Disaster handled.")
                disaster_detected = False  # Reset disaster flag

        # Check every 10 seconds (adjust as needed)
        time.sleep(10)

if __name__ == "__main__":
    main()


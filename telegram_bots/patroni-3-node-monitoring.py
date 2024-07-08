import time
import requests

# Configuration
urls = [
    "http://10.130.1.20:8008/cluster",
    "http://10.130.1.21:8008/cluster",
    "http://10.130.1.22:8008/cluster"
]
telegram_bot_token = "Your Token"
chat_id = "Your Chatid"

green_circle = "\U0001F7E2"  # Green circle emoji
red_circle = "\U0001F534"    # Red circle emoji

# Define the expected nodes
expected_nodes = {'node0', 'node1', 'node2'}

# Track the previous state
previous_state_unhealthy = False

def send_telegram_message(message):
    telegram_url = f"https://api.telegram.org/bot{telegram_bot_token}/sendMessage"
    payload = {
        'chat_id': chat_id,
        'text': message
    }
    response = requests.post(telegram_url, data=payload)
    print(f"Telegram response: {response.json()}")

def check_cluster_state():
    global previous_state_unhealthy
    cluster_healthy = True

    try:
        for url in urls:
            try:
                response = requests.get(url, timeout=10)  # Timeout set to 10 seconds
                response.raise_for_status()
                cluster_info = response.json()
                print(f"Cluster info from {url}: {cluster_info}")

                # Check for missing nodes
                current_nodes = {member['name'] for member in cluster_info['members']}
                missing_nodes = expected_nodes - current_nodes
                if missing_nodes:
                    message = f"{red_circle}\nDATABASE WALLET CRITICAL ALERT\nMissing nodes from {url}: {', '.join(missing_nodes)}"
                    print(message)
                    send_telegram_message(message)
                    cluster_healthy = False

                # Check state of each node
                for member in cluster_info['members']:
                    name = member['name']
                    state = member['state']
                    if state not in ['streaming', 'running']:
                        message = f"{red_circle}\nDATABASE WALLET CRITICAL ALERT\nNode {name} is in state {state} from {url} which is not acceptable."
                        print(message)
                        send_telegram_message(message)
                        cluster_healthy = False

            except requests.exceptions.RequestException as e:
                # Handle connection errors
                print(f"Connection error to {url}: {e}")
                continue  # Skip to the next URL

        # If no issues, check if it was previously unhealthy
        if cluster_healthy:
            if previous_state_unhealthy:
                message = f"{green_circle}\nDATABASE WALLET RECOVERY ALERT\nAll nodes are now healthy."
                print(message)
                send_telegram_message(message)
                previous_state_unhealthy = False
        else:
            previous_state_unhealthy = True

    except Exception as e:
        error_message = f"Failed to get cluster state: {e}"
        print(error_message)
        send_telegram_message(error_message)
        previous_state_unhealthy = True

if __name__ == "__main__":
    while True:
        check_cluster_state()
        time.sleep(300)  # Wait for 5 minutes between checks


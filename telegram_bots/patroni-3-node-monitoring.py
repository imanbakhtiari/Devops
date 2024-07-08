import time
import requests

# Configuration
url = "http://10.130.1.20:8008/cluster"
telegram_bot_token = "Your Bot token"
chat_id = "Your Chatid"

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

    try:
        response = requests.get(url)
        response.raise_for_status()
        cluster_info = response.json()
        print(f"Cluster info: {cluster_info}")

        # Check for missing nodes
        current_nodes = {member['name'] for member in cluster_info['members']}
        missing_nodes = expected_nodes - current_nodes
        if missing_nodes:
            message = f"DATABASE WALLET CRITICAL ALERT\nMissing nodes: {', '.join(missing_nodes)}"
            print(message)
            send_telegram_message(message)
            previous_state_unhealthy = True

        # Check state of each node
        for member in cluster_info['members']:
            name = member['name']
            state = member['state']
            if state not in ['streaming', 'running']:
                message = f"DATABASE CRITICAL ALERT\nNode {name} is in state {state} which is not acceptable."
                print(message)
                send_telegram_message(message)
                previous_state_unhealthy = True

        # If no issues, check if it was previously unhealthy
        if not missing_nodes and all(member['state'] in ['streaming', 'running'] for member in cluster_info['members']):
            if previous_state_unhealthy:
                message = "DATABASE RECOVERY ALERT\nAll nodes are now healthy."
                print(message)
                send_telegram_message(message)
                previous_state_unhealthy = False

    except Exception as e:
        error_message = f"Failed to get cluster state: {e}"
        print(error_message)
        send_telegram_message(error_message)
        previous_state_unhealthy = True

if __name__ == "__main__":
    while True:
        check_cluster_state()
        time.sleep(300)  # Wait for 5 minutes


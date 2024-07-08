import requests

# Configuration
telegram_bot_token = "Your token"
chat_id = "Your chat-id"  # Ensure this is correct and prefixed with a hyphen if it's a group chat

def send_telegram_message(message):
    telegram_url = f"https://api.telegram.org/bot{telegram_bot_token}/sendMessage"
    payload = {
        'chat_id': chat_id,
        'text': message
    }
    response = requests.post(telegram_url, data=payload)
    return response.json()

# Send test message
response = send_telegram_message("Test message from bot")
print(response)


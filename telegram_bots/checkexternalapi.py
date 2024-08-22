import time
import requests
import telegram
import asyncio
from aiohttp import ClientSession

# Telegram Bot credentials
TELEGRAM_BOT_TOKEN = "YOURTOKEN"
TELEGRAM_CHAT_ID = "YOURCHATID"

green_circle = "\U0001F7E2"  # Green circle emoji
red_circle = "\U0001F534"    # Red circle emoji

reach = "ﭗﻨﻟ ﭗﯾﺎﻤﮑﯾ ﺩﺭ ﺪﺴﺗﺮﺳ ﺎﺴﺗ"
notreach = "ﭗﻨﻟ ﭗﯾﺎﻤﮑﯾ ﺩﺭ ﺪﺴﺗﺮﺳ ﻦﯿﺴﺗ"

# Initialize Telegram bot
bot = telegram.Bot(token=TELEGRAM_BOT_TOKEN)

# Keep track of the last known state
last_api_state = None

async def send_telegram_alert(message):
    try:
        async with ClientSession() as session:
            await bot.send_message(chat_id=TELEGRAM_CHAT_ID, text=message)
        print("Telegram alert sent successfully")
    except Exception as e:
        print(f"Failed to send Telegram alert: {e}")

async def check_api():
    global last_api_state
    url = "http://api.payamak-panel.com/post/sendsms.ashx"
    try:
        response = requests.post(url, timeout=10)  # Perform the POST request
        response.raise_for_status()  # Check if the request was successful
        return True
    except requests.exceptions.RequestException as e:
        error_message = f"{red_circle}\nError checking Melli Payamak API:\n {notreach}\n{e}"
        print(error_message)
        await send_telegram_alert(error_message)
        return False

async def main():
    global last_api_state
    while True:
        api_reachable = await check_api()

        if api_reachable:
            if last_api_state == False:  # If the API was previously unreachable
                resolved_message = f"{green_circle}\nMelli Payamak API is reachable again.\n{reach}"
                await send_telegram_alert(resolved_message)
            last_api_state = True
            print("API is reachable")
        else:
            if last_api_state != False:  # If the API was previously reachable or this is the first check
                last_api_state = False
                print("API is not reachable. Alert sent to Telegram.")

        # Sleep for 5 minutes
        print("Waiting for 2 minutes before checking again...")
        await asyncio.sleep(120)  # 300 seconds = 5 minutes

# Run the main function
asyncio.run(main())


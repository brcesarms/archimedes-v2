import sys
import os
import asyncio

sys.path.insert(0, '/home/brn/.hermes/hermes-agent')
from dotenv import load_dotenv
load_dotenv('/home/brn/.hermes/.env')

from gateway.config import PlatformConfig
from plugins.platforms.telegram.adapter import TelegramAdapter

async def main():
    token = os.getenv("TELEGRAM_BOT_TOKEN")
    pconfig = PlatformConfig(enabled=True, token=token)
    adapter = TelegramAdapter(pconfig)
    print("🤖 Hermes Telegram Bot Polling Iniciado com Sucesso!")
    await adapter.start()
    while True:
        await asyncio.sleep(3600)

if __name__ == "__main__":
    asyncio.run(main())

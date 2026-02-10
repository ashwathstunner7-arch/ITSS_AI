import os
import asyncio
from openai import AsyncOpenAI
from dotenv import load_dotenv

load_dotenv()

async def test_key():
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        print("Error: No OPENAI_API_KEY found in environment.")
        return
    
    print(f"Testing key: {api_key[:10]}...{api_key[-5:]}")
    client = AsyncOpenAI(api_key=api_key)
    try:
        response = await client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role": "user", "content": "hi"}],
            max_tokens=5
        )
        print("Success: API key is valid and working.")
        print(f"Response: {response.choices[0].message.content}")
    except Exception as e:
        print(f"Error: API key test failed: {e}")

if __name__ == "__main__":
    asyncio.run(test_key())

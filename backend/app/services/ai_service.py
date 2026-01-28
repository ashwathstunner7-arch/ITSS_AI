import os
import google.generativeai as genai
from openai import OpenAI
from typing import List, Dict, Any
from dotenv import load_dotenv

load_dotenv()

class BaseAIProvider:
    async def generate_response(self, prompt: str, history: List[Dict[str, Any]] = None, model: str = None) -> str:
        raise NotImplementedError

class GeminiProvider(BaseAIProvider):
    def __init__(self):
        api_key = os.getenv("GOOGLE_API_KEY")
        self.available_models = []
        if api_key:
            genai.configure(api_key=api_key)
            try:
                self.available_models = [m.name for m in genai.list_models() if 'generateContent' in m.supported_generation_methods]
                print(f"Discovered Gemini models: {self.available_models}")
            except Exception as e:
                print(f"Warning: Could not list Gemini models: {e}")
        
        self.default_model = "gemini-1.5-flash"

    async def generate_response(self, prompt: str, history: List[Dict[str, Any]] = None, model: str = None) -> str:
        try:
            model_name = model or self.default_model
            
            # 1. Clean the model name
            clean_name = model_name.replace("models/", "")
            
            # 2. Check if the specified model is in our discovered list, if not, find a similar one
            full_model_name = f"models/{clean_name}"
            
            if self.available_models and full_model_name not in self.available_models:
                # Try to find the closest match
                matches = [m for m in self.available_models if clean_name in m]
                if matches:
                    full_model_name = matches[0]
                elif self.available_models:
                    # Prefer any flash model if available
                    flash_fallback = [m for m in self.available_models if "flash" in m]
                    full_model_name = flash_fallback[0] if flash_fallback else self.available_models[0]
            elif not self.available_models:
                # If we couldn't list models, try common stable names as a blind fallback
                print("No models discovered, using blind fallback names.")
                full_model_name = "models/gemini-1.5-flash-latest" 

            print(f"Attempting to use Gemini model: {full_model_name}")
            chat_model = genai.GenerativeModel(full_model_name)
            
            # Gemini expects roles: 'user', 'model'
            formatted_history = []
            if history:
                for h in history:
                    if not h.get("parts") or not h["parts"][0]:
                        continue
                    role = "user" if h["role"] == "user" else "model"
                    formatted_history.append({"role": role, "parts": h["parts"]})
            
            chat = chat_model.start_chat(history=formatted_history)
            response = chat.send_message(prompt)
            return response.text
        except Exception as e:
            return f"Gemini Error: {str(e)}"

class OpenAIProvider(BaseAIProvider):
    def __init__(self):
        api_key = os.getenv("OPENAI_API_KEY")
        self.client = None
        if api_key:
            self.client = OpenAI(api_key=api_key)
        self.default_model = "gpt-4o"

    async def generate_response(self, prompt: str, history: List[Dict[str, Any]] = None, model: str = None) -> str:
        if not self.client:
            return "OpenAI Error: API Key not configured"
        try:
            model_name = model or self.default_model
            # OpenAI history format is standard: [{"role": "user", "content": "..."}]
            messages = []
            if history:
                for h in history:
                    messages.append({"role": h["role"], "content": h["parts"][0] if isinstance(h["parts"], list) else h["parts"]})
            
            messages.append({"role": "user", "content": prompt})
            
            response = self.client.chat.completions.create(
                model=model_name,
                messages=messages
            )
            return response.choices[0].message.content
        except Exception as e:
            return f"OpenAI Error: {str(e)}"

class AIService:
    def __init__(self):
        self.providers = {
            "gemini": GeminiProvider(),
            "openai": OpenAIProvider()
        }

    async def generate_response(self, prompt: str, provider: str = "gemini", model: str = None, history: List[dict] = None) -> str:
        provider_instance = self.providers.get(provider.lower())
        if not provider_instance:
            return f"Error: Provider '{provider}' not supported."
        
        return await provider_instance.generate_response(prompt, history=history, model=model)

ai_service = AIService()

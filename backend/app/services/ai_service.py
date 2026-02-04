import os
import google.generativeai as genai
from openai import OpenAI
from typing import List, Dict, Any
from dotenv import load_dotenv

load_dotenv()

class BaseAIProvider:
    async def generate_response(self, prompt: str, history: List[Dict[str, Any]] = None, model: str = None, attachments: List[Dict[str, Any]] = None) -> str:
        raise NotImplementedError

    async def generate_stream(self, prompt: str, history: List[Dict[str, Any]] = None, model: str = None, attachments: List[Dict[str, Any]] = None):
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

    async def generate_response(self, prompt: str, history: List[Dict[str, Any]] = None, model: str = None, attachments: List[Dict[str, Any]] = None) -> str:
        try:
            model_name = model or self.default_model
            
            # 1. Clean the model name
            clean_name = model_name.replace("models/", "")
            
            # 2. Check if the specified model is in our discovered list
            full_model_name = f"models/{clean_name}"
            # ... (rest of model selection logic remains)
            if self.available_models and full_model_name not in self.available_models:
                matches = [m for m in self.available_models if clean_name in m]
                if matches:
                    full_model_name = matches[0]
                elif self.available_models:
                    flash_fallback = [m for m in self.available_models if "flash" in m]
                    full_model_name = flash_fallback[0] if flash_fallback else self.available_models[0]
            elif not self.available_models:
                full_model_name = "models/gemini-1.5-flash-latest" 

            chat_model = genai.GenerativeModel(full_model_name)
            
            formatted_history = []
            if history:
                for h in history:
                    if not h.get("parts") or not h["parts"][0]:
                        continue
                    role = "user" if h["role"] == "user" else "model"
                    formatted_history.append({"role": role, "parts": h["parts"]})
            
            # Prepare message parts (text + images)
            message_parts = [prompt]
            if attachments:
                import base64
                for at in attachments:
                    if at.get("type") == "image" and "content" in at:
                        try:
                            # Handle data URL: "data:image/png;base64,iVBOR..."
                            content = at["content"]
                            if "," in content:
                                header, encoded = content.split(",", 1)
                                mime_type = header.split(";")[0].split(":")[1]
                                data = base64.b64decode(encoded)
                                message_parts.append({
                                    "mime_type": mime_type,
                                    "data": data
                                })
                        except Exception as img_err:
                            print(f"Error processing image attachment: {img_err}")

            chat = chat_model.start_chat(history=formatted_history)
            response = chat.send_message(message_parts)
            return response.text
        except Exception as e:
            return f"Gemini Error: {str(e)}"

    async def generate_stream(self, prompt: str, history: List[Dict[str, Any]] = None, model: str = None, attachments: List[Dict[str, Any]] = None):
        try:
            model_name = model or self.default_model
            clean_name = model_name.replace("models/", "")
            full_model_name = f"models/{clean_name}"
            
            # Simple model check logic (reused from generate_response)
            if self.available_models and full_model_name not in self.available_models:
                matches = [m for m in self.available_models if clean_name in m]
                if matches: full_model_name = matches[0]
                elif self.available_models:
                    flash_fallback = [m for m in self.available_models if "flash" in m]
                    full_model_name = flash_fallback[0] if flash_fallback else self.available_models[0]
            elif not self.available_models:
                full_model_name = "models/gemini-1.5-flash-latest"

            chat_model = genai.GenerativeModel(full_model_name)
            
            formatted_history = []
            if history:
                for h in history:
                    if not h.get("parts") or not h["parts"][0]: continue
                    role = "user" if h["role"] == "user" else "model"
                    formatted_history.append({"role": role, "parts": h["parts"]})

            message_parts = [prompt]
            if attachments:
                import base64
                for at in attachments:
                    if at.get("type") == "image" and "content" in at:
                        try:
                            content = at["content"]
                            if "," in content:
                                header, encoded = content.split(",", 1)
                                mime_type = header.split(";")[0].split(":")[1]
                                data = base64.b64decode(encoded)
                                message_parts.append({"mime_type": mime_type, "data": data})
                        except: pass

            chat = chat_model.start_chat(history=formatted_history)
            # asynchronous streaming
            response = await chat_model.generate_content_async(message_parts, stream=True)
            async for chunk in response:
                if chunk.text:
                    yield chunk.text
        except Exception as e:
            yield f"Gemini Stream Error: {str(e)}"

class OpenAIProvider(BaseAIProvider):
    def __init__(self):
        api_key = os.getenv("OPENAI_API_KEY")
        self.client = None
        if api_key:
            from openai import AsyncOpenAI
            self.client = AsyncOpenAI(api_key=api_key)
        self.default_model = "gpt-4o"

    async def generate_response(self, prompt: str, history: List[Dict[str, Any]] = None, model: str = None, attachments: List[Dict[str, Any]] = None) -> str:
        if not self.client:
            return "OpenAI Error: API Key not configured"
        try:
            model_name = model or self.default_model
            messages = []
            if history:
                for h in history:
                    messages.append({"role": h["role"], "content": h["parts"][0] if isinstance(h["parts"], list) else h["parts"]})
            
            user_content = [{"type": "text", "text": prompt}]
            if attachments:
                for at in attachments:
                    if at.get("type") == "image" and "content" in at:
                        user_content.append({
                            "type": "image_url",
                            "image_url": {"url": at["content"]}
                        })
            
            messages.append({"role": "user", "content": user_content})
            
            response = await self.client.chat.completions.create(
                model=model_name,
                messages=messages
            )
            return response.choices[0].message.content
        except Exception as e:
            return f"OpenAI Error: {str(e)}"

    async def generate_stream(self, prompt: str, history: List[Dict[str, Any]] = None, model: str = None, attachments: List[Dict[str, Any]] = None):
        if not self.client:
            yield "OpenAI Error: API Key not configured"
            return
        try:
            model_name = model or self.default_model
            messages = []
            if history:
                for h in history:
                    messages.append({"role": h["role"], "content": h["parts"][0] if isinstance(h["parts"], list) else h["parts"]})
            
            user_content = [{"type": "text", "text": prompt}]
            if attachments:
                for at in attachments:
                    if at.get("type") == "image" and "content" in at:
                        user_content.append({
                            "type": "image_url",
                            "image_url": {"url": at["content"]}
                        })
            messages.append({"role": "user", "content": user_content})
            
            stream = await self.client.chat.completions.create(
                model=model_name,
                messages=messages,
                stream=True
            )
            async for chunk in stream:
                if chunk.choices[0].delta.content:
                    yield chunk.choices[0].delta.content
        except Exception as e:
            yield f"OpenAI Stream Error: {str(e)}"

class AIService:
    def __init__(self):
        self.providers = {
            "gemini": GeminiProvider(),
            "openai": OpenAIProvider()
        }

    async def generate_response(self, prompt: str, provider: str = "gemini", model: str = None, history: List[dict] = None, attachments: List[Dict[str, Any]] = None) -> str:
        provider_instance = self.providers.get(provider.lower())
        if not provider_instance:
            return f"Error: Provider '{provider}' not supported."
        
        return await provider_instance.generate_response(prompt, history=history, model=model, attachments=attachments)

    async def generate_stream(self, prompt: str, provider: str = "gemini", model: str = None, history: List[dict] = None, attachments: List[Dict[str, Any]] = None):
        provider_instance = self.providers.get(provider.lower())
        if not provider_instance:
            yield f"Error: Provider '{provider}' not supported."
            return
        
        async for chunk in provider_instance.generate_stream(prompt, history=history, model=model, attachments=attachments):
            yield chunk

ai_service = AIService()

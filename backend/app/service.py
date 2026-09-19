
from langchain_google_genai import ChatGoogleGenerativeAI

from .config import GOOGLE_API_KEY, GEMINI_MODEL
from .guardrails import GeminiGuardrails


class ChatService:

    def __init__(self):

        self.guardrails = GeminiGuardrails()

        self.llm = ChatGoogleGenerativeAI(
            model=GEMINI_MODEL,
            google_api_key=GOOGLE_API_KEY,
            temperature=0.3,
        )

    @staticmethod
    def extract_text(content) -> str:

        if isinstance(content, str):
            return content.strip()

        if isinstance(content, list):

            text_parts = []

            for item in content:

                if isinstance(item, str):
                    text_parts.append(item)

                elif isinstance(item, dict):

                    text = item.get("text")

                    if text:
                        text_parts.append(str(text))

            return "\n".join(text_parts).strip()

        return str(content).strip()

    async def chat(self, message: str):

        # ----------------------------------------
        # INPUT GUARDRAIL
        # ----------------------------------------

        allowed, guardrail_reason = (
            await self.guardrails.check(message)
        )

        if not allowed:

            return {
                "allowed": False,
                "response": (
                    "I can't help with that request. "
                    "Please ask a safe, legitimate question."
                ),
                "guardrail_reason": guardrail_reason,
            }

        # ----------------------------------------
        # GEMINI RESPONSE
        # ----------------------------------------

        result = await self.llm.ainvoke(
            f"""
You are a helpful customer-support assistant.

Answer the user's question clearly and safely.

User:
{message}
"""
        )

        response_text = self.extract_text(result.content)

        # ----------------------------------------
        # OUTPUT SAFETY CHECK
        # ----------------------------------------

        if not response_text:

            return {
                "allowed": False,
                "response": "Unable to generate a response.",
                "guardrail_reason": (
                    "Gemini returned an empty response."
                ),
            }

        return {
            "allowed": True,
            "response": response_text,
            "guardrail_reason": guardrail_reason,
        }


# Gemini Guardrails + FastAPI + SwiftUI MVS

This starter project contains:
1. FastAPI backend
2. Gemini 3.5 Flash guardrail classifier
3. LangChain + langchain-google-genai
4. SwiftUI MVS client
5. MessageKit integration boundary

## Flow

SwiftUI / MessageKit
        |
        v
ChatViewModel
        |
        v
APIClient
        |
        v
FastAPI /api/v1/chat
        |
        +--> Gemini Guardrails
        |       |
        |       +--> BLOCK -> safe refusal
        |
        +--> Gemini 3.5 Flash
                |
                +--> response

## Run backend

```bash
cd backend
cp .env.example .env
# edit .env
uv sync
uv run uvicorn app.main:app --reload
```

## Important

The Gemini API key stays on the server. Never put GOOGLE_API_KEY in the iOS app.

Gemini model is configured as `gemini-3.5-flash`.

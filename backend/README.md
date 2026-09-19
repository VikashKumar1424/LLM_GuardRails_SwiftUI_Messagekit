# Gemini Guardrails FastAPI Backend

## Setup

```bash
cd backend
cp .env.example .env
# Put your Google AI Studio API key in .env

uv sync
uv run uvicorn app.main:app --reload
```

API:
- GET http://127.0.0.1:8000/health
- POST http://127.0.0.1:8000/api/v1/chat

Example:

```bash
curl -X POST http://127.0.0.1:8000/api/v1/chat   -H 'Content-Type: application/json'   -d '{"message":"How can I reset my password?"}'
```

# Gemini Guardrails + FastAPI + SwiftUI + MessageKit

A starter project for building a secure AI chat experience with a FastAPI backend, Gemini guardrails, and an iOS frontend that combines SwiftUI with MessageKit.

## What this project contains

- **FastAPI backend** for chat requests and server-side Gemini access
- **Gemini guardrail classifier** to detect unsafe or disallowed prompts
- **LangChain + `langchain-google-genai`** for Gemini integration
- **SwiftUI frontend** for app structure, navigation, and state management
- **MessageKit chat UI** for message bubbles, input controls, avatars, and conversation rendering
- **MVVM/MVS-style separation** between the chat screen, view model, and networking layer

## Frontend highlight: MessageKit + SwiftUI

The frontend uses SwiftUI for the application experience and MessageKit as the dedicated chat interface layer. This keeps the chat UI focused on conversation rendering while SwiftUI manages the surrounding screen and app state.

### Frontend responsibilities

- Render incoming and outgoing messages with MessageKit
- Provide a familiar chat composer and send interaction
- Display loading, error, and guardrail-refusal states
- Convert API responses into MessageKit-compatible message models
- Keep API and Gemini credentials out of the iOS application
- Allow the MessageKit chat view to be embedded at the SwiftUI integration boundary

### Frontend request flow

1. The user enters a message in the MessageKit composer.
2. `ChatViewModel` manages the send action and conversation state.
3. `APIClient` sends the message to `POST /api/v1/chat`.
4. The backend evaluates the message with Gemini guardrails.
5. The response, including a safe refusal when blocked, is mapped back into the MessageKit conversation UI.

This separation makes it possible to customize the MessageKit presentation without coupling the chat UI directly to the networking or guardrail implementation.

## Architecture flow

```text
SwiftUI screen
      |
      v
MessageKit chat interface
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
```

## Run the backend

```bash
cd backend
cp .env.example .env
# Edit .env and add your Google AI Studio API key
uv sync
uv run uvicorn app.main:app --reload
```

## Run the frontend

1. Open the iOS project in Xcode.
2. Resolve the Swift package dependencies, including MessageKit.
3. Start the FastAPI backend locally.
4. Configure the frontend API base URL to point to the running backend.
5. Select an iOS simulator or device and run the app.
6. Send a message through the MessageKit composer and confirm that the response appears in the conversation.

When testing on a physical device, use a backend address reachable from the device instead of `127.0.0.1`.

## Important security notes

- The Gemini API key stays on the server. Never put `GOOGLE_API_KEY` in the iOS app.
- The Gemini model is configured as `gemini-3.5-flash`.
- The frontend should communicate only with the backend API and should not call Gemini directly.

## Backend API

- `GET http://127.0.0.1:8000/health`
- `POST http://127.0.0.1:8000/api/v1/chat`

Example request:

```bash
curl -X POST http://127.0.0.1:8000/api/v1/chat \
  -H 'Content-Type: application/json' \
  -d '{"message":"How can I reset my password?"}'
```

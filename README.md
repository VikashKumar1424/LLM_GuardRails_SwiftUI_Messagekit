# Gemini Guardrails + FastAPI + SwiftUI + MessageKit

A starter project for building a secure AI chat experience with a FastAPI backend, Gemini guardrails, and an iOS frontend that combines SwiftUI with MessageKit.

> **Note:** The backend is responsible for communicating with Gemini. The iOS app communicates only with the backend API, so sensitive credentials remain server-side.

## Features

- **FastAPI backend** for chat requests and server-side Gemini access.
- **Gemini guardrail classifier** to detect unsafe or disallowed prompts before they reach the chat model.
- **LangChain and `langchain-google-genai`** for Gemini integration.
- **SwiftUI frontend** for application structure, navigation, and state management.
- **MessageKit chat interface** for message bubbles, input controls, avatars, and conversation rendering.
- **MVVM architecture** that separates the chat screen, view model, and networking layer.
- **Safe refusal responses** when a message is blocked by the guardrails.

## Project structure

```text
.
├── backend/                 # FastAPI application and Gemini integration
│   ├── app/                 # API routes, models, and guardrail logic
│   ├── .env.example         # Environment variable template
│   └── pyproject.toml       # Python dependencies and project settings
├── frontend/                # SwiftUI and MessageKit iOS application
└── README.md                # Project documentation
```

> The exact frontend directory and Xcode project names may vary depending on the local project configuration.

## How the frontend works

The frontend uses SwiftUI for the application experience and MessageKit as the dedicated chat interface layer. This keeps the chat UI focused on conversation rendering while SwiftUI manages the surrounding application flow and state.

### Frontend responsibilities

- Render incoming and outgoing messages with MessageKit.
- Provide a familiar chat composer and send interaction.
- Display loading, error, and guardrail-refusal states.
- Convert API responses into MessageKit-compatible message models.
- Keep API and Gemini credentials out of the iOS application.
- Embed the MessageKit chat view at the SwiftUI integration boundary.

### Frontend request flow

1. The user enters a message in the MessageKit composer.
2. `ChatViewModel` validates the input and manages conversation state.
3. `APIClient` sends the message to `POST /api/v1/chat`.
4. The backend evaluates the message with Gemini guardrails.
5. Safe messages are sent to the chat model; blocked messages receive a safe refusal.
6. The response is mapped back into the MessageKit conversation UI.

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
      +--> Gemini chat model
              |
              +--> response
```

## Prerequisites

Before running the project, install or configure:

- Python 3.11 or a compatible Python version supported by the backend.
- [`uv`](https://docs.astral.sh/uv/) for Python dependency management.
- Xcode and an iOS simulator or physical iOS device.
- A Google AI Studio API key with access to the configured Gemini model.

## Configure the backend

From the repository root, copy the environment template and add your API key:

```bash
cd backend
cp .env.example .env

# Open .env and set your Google AI Studio API key.
# Keep this file local and do not commit it to source control.
```

For example, the environment file should contain the variable expected by the backend:

```dotenv
GOOGLE_API_KEY=your_google_ai_studio_api_key
```

> Use the variable name required by the backend configuration. Never place this key in the iOS project, source code, or a client-side configuration file.

## Run the backend

```bash
cd backend

# Install or synchronize the Python dependencies.
uv sync

# Start the development server with automatic reload enabled.
uv run uvicorn app.main:app --reload
```

The API should now be available at `http://127.0.0.1:8000`.

## Run the frontend

1. Open the iOS project in Xcode.
2. Resolve the Swift package dependencies, including MessageKit.
3. Confirm that the FastAPI backend is running locally.
4. Configure the frontend API base URL to point to the backend.
5. Select an iOS simulator or connected device and run the app.
6. Send a message through the MessageKit composer and confirm that the response appears in the conversation.

When testing on a physical device, use a backend address reachable from the device instead of `127.0.0.1`. You may also need to configure local network permissions and an appropriate transport security setting for development.

## Backend API

### Health check

```http
GET http://127.0.0.1:8000/health
```

Example:

```bash
# Verify that the backend is running.
curl http://127.0.0.1:8000/health
```

### Send a chat message

```http
POST http://127.0.0.1:8000/api/v1/chat
Content-Type: application/json
```

Example request:

```bash
# Send a message to the guardrail-protected chat endpoint.
curl -X POST http://127.0.0.1:8000/api/v1/chat \
  -H 'Content-Type: application/json' \
  -d '{"message":"How can I reset my password?"}'
```

The endpoint evaluates the message before generating a response. If the guardrails classify the message as unsafe or disallowed, the API returns a safe refusal instead of forwarding the request to the chat model.

## Security notes

- Keep `GOOGLE_API_KEY` on the server. Never include it in the iOS app.
- Do not commit `.env` files or API keys to the repository.
- The frontend should communicate only with the backend API and should not call Gemini directly.
- Add authentication, authorization, rate limiting, logging controls, and production CORS rules before deploying publicly.
- Use HTTPS and a properly configured production host instead of the local development server.

## Troubleshooting

### The iOS app cannot connect to the backend

- Confirm that the backend is running and that `GET /health` responds successfully.
- On a simulator, use the host address supported by the simulator configuration.
- On a physical device, replace `127.0.0.1` with the development machine's LAN IP address.
- Verify that the device and development machine are connected to the same network.

### The backend cannot access Gemini

- Confirm that `.env` exists inside the `backend` directory.
- Verify that the API key variable name matches the backend configuration.
- Check that the API key is valid and has access to the configured Gemini model.
- Restart the backend after changing environment variables.

## License

Add the project's license information here before publishing or distributing the application.

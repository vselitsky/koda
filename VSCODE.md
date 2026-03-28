# Visual Studio Code Integration

This guide explains how to use your local LLM server from within Visual Studio Code.

## Recommended Extensions

Since the server is OpenAI-compatible, you can use several popular extensions:

### [Continue](https://marketplace.visualstudio.com/items?itemName=Continue.continue)

Continue is a popular open-source AI autopilot for VS Code.

1.  **Install:** Search for "Continue" in the VS Code Extensions Marketplace and install it.
2.  **Configure:** Open the `config.json` file for Continue (click the gear icon in the Continue sidebar).
3.  **Add Model:** Add a new model entry pointing to your local server:

    ```json
    {
      "title": "Local Model (koda)",
      "model": "qwen3.5-27b",
      "apiBase": "http://localhost:8080/v1",
      "completionOptions": {
        "temperature": 0.6,
        "topP": 0.95
      },
      "provider": "openai"
    }
    ```

### [Roo Code](https://marketplace.visualstudio.com/items?itemName=RooCode.roocode)

Roo Code (formerly Roo Cline) is an autonomous coding agent.

1.  **Install:** Search for "Roo Code" in the Marketplace and install it.
2.  **Configure:** Click the "Settings" button in the Roo Code sidebar.
3.  **API Provider:** Select **OpenAI Compatible**.
4.  **Base URL:** Enter `http://localhost:8080/v1`.
5.  **Model ID:** Enter the model name from your `.env` file (e.g., `qwen3.5-27b`).

## Manual Interaction

You can also use the **REST Client** extension or just a terminal inside VS Code to interact with the API:

```bash
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

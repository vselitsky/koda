# OpenCode Integration

This guide explains how to use OpenCode with the local inference server provided by this project.

## Configuration

1. **Start the server:** First, ensure you have a model serving via `make serve ENV=<your-env-file>`.
2. **Open OpenCode:** Launch the OpenCode application.
3. **Select Provider:** In the settings, select **llama.cpp** as the provider.
4. **Specify Model:** Enter the model name as defined in your environment file.

### Backend Settings

OpenCode typically looks for the API at `http://127.0.0.1:8080/v1`. This is configured in `~/.config/opencode/opencode.json`.

### Compatibility

Since the server is OpenAI-compatible, any client can use the same base URL (`http://localhost:8080/v1`) with any non-empty API key to interact with the running model.

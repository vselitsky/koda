# Local LLM Inference Tooling (Koda)

This project provides a standardized environment and set of commands for running GGUF models locally using `llama.cpp` with a built-in browser WebUI and an OpenAI-compatible API server.

## Docker Compose Usage

Koda provides a containerized deployment path via `compose.yaml`.

### 1. Default Startup
With the defaults in `.env`, you can check the status or start the default model:
```bash
docker compose ps
docker compose up
```

### 2. Using Model Profiles
To run a specific model profile via Docker Compose, the most idiomatic way in this project is using the `ENV_FILE` variable, which is listed in `compose.yaml`:

```bash
ENV_FILE=.env-Qwen3.5-27B.Q4_K_M docker compose up
```

This loads the profile's variables (like `MODEL_FILE`) into the container. Note that for **host-side interpolation** (the `MODEL_DIR` used for the volume mount), Docker Compose automatically loads the local `.env`. If you need to override `MODEL_DIR` for the host mount as well, use the `--env-file` flag:

```bash
docker compose --env-file .env-Qwen3.5-27B.Q4_K_M up
```

### 3. Volume Sharing
The `compose.yaml` now mounts two key directories:
- `/models`: Mapped to `${MODEL_DIR}` from your host.
- `/root/.cache/huggingface`: Mapped to your host's default Hugging Face cache (`~/.cache/huggingface`).

## Key Commands

`make download`, `make serve`, and `make chat` require an `ENV` variable pointing to a model's `.env` file. `make check` does not.

| Command | Description |
| --- | --- |
| `make download ENV=<file>` | Downloads the model file from HuggingFace. |
| `make serve ENV=<file>` | Starts the built-in WebUI and OpenAI-compatible HTTP server. |
| `make chat ENV=<file>` | Launches an interactive terminal chat session. |
| `make check` | Verifies required binaries are installed and on `PATH`. |

### Common Overrides

Overrides can be passed inline to any `make` target:
- `PORT=9090`: Change the server port.
- `CTX=0`: Use model's native context size (default).
- `CTX=16384`: Set a specific context window size to save RAM.
- `GPU_LAYERS=0`: Disable GPU offloading.
- `METRICS=1`: Enable `llama-server` metrics.
- `PROMPT_FORMAT=template`: Use an explicit chat template instead of the model's embedded Jinja template.
- `RPC=10.0.0.12:50052`: Pass a remote RPC backend through as `--rpc`.
- `SERVER_EXTRA_ARGS='...'`: Append advanced `llama-server` flags without editing the Makefile.

## Development & Integrations

- **Adding Models:** Create `.env-<name>.<quant>` with `HF_REPO`, `MODEL_DIR`, and `MODEL_FILE`. Add `DOWNLOAD_INCLUDE` for sharded GGUF models.
- **Integrations:**
  - [OpenCode](./OPENCODE.md)
  - [Tailscale + Koda (via llama.cpp)](./TAILSCALE.md)
  - [VS Code](./VSCODE.md) (Continue, Roo Code)
- **Learning:**
  - [Bundled Profiles](./PROFILES.md)
  - [GGUF & Local LLMs](./GGUF.md)

## Dependencies

- `llama-server`, `llama-cli`, `hf`, `make`.

## Runtime Defaults

- `PROMPT_FORMAT=jinja` uses the GGUF model's embedded chat template by default
- `RPC` is empty by default and only applied when explicitly set
- `METRICS=0` keeps metrics off unless explicitly enabled
- `BATCH=512` and `UBATCH=512` are conservative server batching defaults
- `CTX=0` keeps the model's native context window unless explicitly overridden

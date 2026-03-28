# Local LLM Inference via llama.cpp

Run [GGUF models](./GGUF.md) locally using llama.cpp with a built-in browser WebUI and an OpenAI-compatible API server.

## Requirements

### llama.cpp

[Installation docs](https://github.com/ggml-org/llama.cpp/blob/master/docs/install.md)

### hf CLI

[Installation docs](https://huggingface.co/docs/huggingface_hub/en/guides/cli)

## Adding a Model

Create an env file named `.env-<model>.<quant>` with these required variables:

```bash
# link to the model page for reference
HF_REPO=<org>/<repo>-GGUF
MODEL_DIR=$(HOME)/models/<name>
MODEL_FILE=<filename>.gguf
```

Then run `make download ENV=.env-<model>.<quant>` to fetch it.

### Bundled profiles

| File | Model |
| --- | --- |
| `.env-Qwen3.5-27B.Q4_K_M` | [Qwen3.5-27B Claude 4.6 Opus Reasoning Distilled](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled) |
| `.env-Qwen3.5-27B.Q8_0` | [Qwen3.5-27B Claude 4.6 Opus Reasoning Distilled](https://huggingface.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled) |
| `.env-Qwen3.5-35B-A3B.Q4_K_M` | [Qwen3.5-35B-A3B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive) |
| `.env-Qwen3.5-35B-A3B.Q8_0` | [Qwen3.5-35B-A3B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive) |
| `.env-Qwen3.5-35B-A3B-Qwen.Q4_K_M` | [Qwen3.5-35B-A3B](https://huggingface.co/Qwen/Qwen3.5-35B-A3B) |
| `.env-Qwen3.5-35B-A3B-Qwen.Q8_0` | [Qwen3.5-35B-A3B](https://huggingface.co/Qwen/Qwen3.5-35B-A3B) |
| `.env-Qwen3.5-9B.Q4_K_M` | [Qwen3.5-9B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive) |
| `.env-Qwen3.5-9B.Q8_0` | [Qwen3.5-9B Uncensored](https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive) |

## Usage

```bash
make serve    ENV=.env-Qwen3.5-27B.Q4_K_M   # start API server + WebUI
make chat     ENV=.env-Qwen3.5-27B.Q4_K_M   # interactive terminal chat
make download ENV=.env-Qwen3.5-27B.Q4_K_M   # download the model
```

Inline overrides also work:

```bash
make serve ENV=.env-Qwen3.5-27B.Q4_K_M PORT=9090
```

When `make serve` is running:

- WebUI: `http://localhost:8080`
- OpenAI-compatible API: `http://localhost:8080/v1/chat/completions`

### Opinionated defaults

Koda keeps the public interface small and wraps the useful llama.cpp defaults for you:

- `PROMPT_FORMAT=jinja` uses the GGUF model's embedded chat template by default
- `CTX=0` uses the model's native context size
- `BATCH=512` and `UBATCH=512` provide a conservative starting point for server throughput
- `GPU_LAYERS=99` offloads as much as possible by default

If a model needs an explicit template, switch to `PROMPT_FORMAT=template` and set `CHAT_TPL=<name>`.

### Runtime variables

Set in the env file or inline. Model-specific variables (`HF_REPO`, `MODEL_DIR`, `MODEL_FILE`) are required and have no defaults.

| Variable | Default | Description |
| --- | --- | --- |
| `HF_REPO` | — | HuggingFace repo (`org/repo-GGUF`) |
| `MODEL_DIR` | — | Local model directory |
| `MODEL_FILE` | — | Model filename (e.g. `model.Q4_K_M.gguf`) |
| `CTX` | `0` | Context window size (`0` = model native) |
| `HOST` | `0.0.0.0` | Server bind address |
| `PORT` | `8080` | Server port |
| `GPU_LAYERS` | `99` | Layers offloaded to GPU |
| `PROMPT_FORMAT` | `jinja` | `jinja` uses the GGUF's embedded chat template; `template` uses `CHAT_TPL` |
| `CHAT_TPL` | `chatml` | Fallback explicit chat template when `PROMPT_FORMAT=template` |
| `BATCH` | `512` | Prompt processing batch size |
| `UBATCH` | `512` | Micro-batch size used during prompt processing |
| `TEMP` | `0.6` | Sampling temperature (chat) |
| `TOP_P` | `0.95` | Top-p sampling (chat) |
| `SERVER_EXTRA_ARGS` | empty | Extra flags appended to `llama-server` |
| `CHAT_EXTRA_ARGS` | empty | Extra flags appended to `llama-cli` |

> **Note on CTX:** Setting `CTX=0` (default) uses the model's native context window. You can manually set this to a lower value to save RAM/VRAM, or a higher value if the model and your hardware support it. Use inline overrides to test different sizes: `make serve ENV=.env-file CTX=16384`.

> **Note on memory:** You do not need to fit the full model in VRAM to get useful performance. If you run into memory pressure, lower `CTX` first and then tune `GPU_LAYERS`, `BATCH`, or `UBATCH`.

## Learning Resources

- [What is GGUF and Why Run Locally?](./GGUF.md)

## Integrations

- [OpenCode Integration](./OPENCODE.md)
- [VS Code Integration](./VSCODE.md)

## License

Model weights: see individual model pages.

# Agent Guide

## What This Project Does

Provides commands and configuration for running GGUF models locally via llama.cpp. No application code — just inference tooling and documentation.

## Key Binaries

Installed via Homebrew at `/opt/homebrew/bin/`:

| Binary | Purpose |
| --- | --- |
| `llama-cli` | Interactive terminal chat |
| `llama-server` | OpenAI-compatible HTTP server |
| `hf` | HuggingFace model downloader |

## Configuration & Defaults

Defaults are defined in the root `.env` file and loaded by the `Makefile`. Model-specific settings are in `.env-<model>.<quant>` files.

| Variable | Default | Description |
| --- | --- | --- |
| `CTX` | `0` | Context window size (`0` = model native) |
| `HOST` | `0.0.0.0` | Server bind address |
| `PORT` | `8080` | Server port |
| `GPU_LAYERS` | `99` | Layers offloaded to GPU |

## Running the Model

Use `make` targets — do not invoke `llama-cli` or `llama-server` directly:

| Target | Description |
| --- | --- |
| `make serve` | Start OpenAI-compatible API server on port 8080 |
| `make chat` | Interactive terminal chat |
| `make download` | Download the model via hf CLI |

All targets require an env file: `make serve ENV=.env-Qwen3.5-27B.Q4_K_M`

## No Build Steps

llama.cpp is pre-built via Homebrew. There is nothing to compile or install beyond what's in the Requirements section of README.md.

## Model Behavior Notes

- Uses ChatML chat template (`--chat-template chatml`)
- Reasoning output appears in `<think>...</think>` blocks before the final answer
- Recommended sampling: `--temp 0.6 --top-p 0.95`
- Context window: uses native size by default (`CTX=0`). Use `CTX=` as an inline override to adjust for RAM/VRAM constraints.

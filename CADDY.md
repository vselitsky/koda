# Caddy HTTPS for Native `make serve`

Caddy provides HTTPS termination for the native `make serve` path — the case where you cannot use Docker because GPU acceleration is not available inside containers (Apple Silicon, Windows).

| Scenario | Use |
| :--- | :--- |
| Apple Silicon (Metal) | `make serve` + Caddy |
| Windows (native GPU) | `make serve` + Caddy |
| Linux with NVIDIA/AMD | Docker + Traefik, or `make serve` + Caddy |

---

## Install

**macOS / Linux**
```bash
brew install caddy
```

**Windows (WSL)**
```bash
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update && sudo apt install caddy
```

---

## Start

First, start your model server:
```bash
make serve ENV=profiles/.env-gemma-4-31B-it.Q4_K_M
```

Then start Caddy in front of it. Choose the `--from` address based on where your client is:

**Same machine (e.g. Cursor on localhost)**
```bash
caddy reverse-proxy --from https://localhost:8443 --to localhost:8080
```

**LAN access (e.g. Cursor on another machine on the same network)**
```bash
caddy reverse-proxy --from https://192.168.1.100:8443 --to localhost:8080
```

**Private remote access (Tailscale)**
```bash
caddy reverse-proxy --from https://my-machine.tail1234.ts.net --to localhost:8080
```
> Caddy will obtain a TLS certificate automatically when using a real hostname. For `localhost`, it issues a locally-trusted certificate via its built-in CA (requires trusting Caddy's root cert).

---

## Trust the Local Certificate (localhost only)

When using `localhost`, Caddy issues a self-signed cert from its own CA. Trust it once:

```bash
caddy trust
```

This installs Caddy's root certificate into your system trust store so browsers and tools like Cursor accept it without warnings.

---

## Use the HTTPS URL in Cursor

Once Caddy is running, use the HTTPS URL as the base URL in Cursor:

- **localhost:** `https://localhost:8443/v1`
- **LAN:** `https://192.168.1.100:8443/v1`
- **Tailscale:** `https://my-machine.tail1234.ts.net/v1`

See [CURSOR.md](./CURSOR.md) for the full Cursor configuration steps.

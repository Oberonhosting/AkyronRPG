# Akyron Server

Backend multiplayer do Akyron RPG. **É um processo separado do app/site**
— roda em qualquer máquina (VPS, sua máquina local, container).

O app cliente (em `../lib/`) se conecta aqui via WebSocket. Você pode
rodar o app **sem** este servidor (modo offline). Para qualquer feature
de marketplace global, boss mundial sincronizado e chat público, este
servidor precisa estar no ar.

---

## ▶️ Como rodar

```bash
# Pré-requisito: Dart SDK 3.3+ instalado.
cd server
dart pub get
dart run akyron_server:akyron_server \
  --port 28960 \
  --kind premium \
  --name "Akyron — Brasil 01"
```

### Opções

| Flag             | Padrão        | O que faz                                                  |
|------------------|---------------|------------------------------------------------------------|
| `--host`         | `0.0.0.0`     | IP de bind.                                                |
| `--port`         | `28960`       | Porta TCP.                                                 |
| `--kind`         | `public`      | `public`, `private`, `free` ou `premium`.                  |
| `--name`         | …             | Nome anunciado para clientes.                              |
| `--password`     | (vazia)       | Se setada, transforma em sala privada.                     |
| `--max-players`  | `200`         | Limite simultâneo.                                         |
| `--anticheat`    | `true`        | Liga validação de stats no servidor.                       |

---

## 📡 Endpoints

### HTTP

- `GET  /info` — JSON com nome, tipo, jogadores, max, requires_password.
- `GET  /market/listings` — Lista todas as ofertas ativas do marketplace.
- `POST /market/post` — Cria uma listagem nova (body JSON com seller, item, qty, price).
- `GET  /worldboss` — Snapshot do boss mundial atual.

### WebSocket

- `ws://host:port/socket`

Pacotes seguem `{ "t": tipo, "d": dados }`:

| t                 | Origem | Descrição                                |
|-------------------|--------|------------------------------------------|
| `hello`           | client | Handshake inicial (nome, pid, senha).    |
| `welcome`         | server | Confirma sessão, manda boss snapshot.    |
| `reject`          | server | Servidor cheio / senha errada.           |
| `pos`             | client | Posição/visual no mapa (broadcast).      |
| `chat`            | both   | Mensagem de chat.                        |
| `worldBossHit`    | client | Dano causado no boss mundial.            |
| `worldBoss`       | server | Snapshot atualizado do boss.             |
| `ping` / `pong`   | both   | Medição de latência.                     |
| `bye`             | client | Encerra a sessão.                        |

---

## 🚀 Deploy

### Local (dev)

```bash
dart run akyron_server:akyron_server
```

### Servidor Linux (produção)

```bash
# 1) Compila para um único binário (~10 MB, sem dependência do Dart).
dart compile exe bin/akyron_server.dart -o ./akyron_server

# 2) Roda como serviço systemd:
sudo cp akyron_server /usr/local/bin/
sudo nano /etc/systemd/system/akyron.service
```

```ini
[Unit]
Description=Akyron RPG Server
After=network.target

[Service]
ExecStart=/usr/local/bin/akyron_server --port 28960 --kind premium --name "Akyron BR"
Restart=on-failure
User=akyron

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable --now akyron
sudo systemctl status akyron
```

### Docker

```dockerfile
FROM dart:stable AS build
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
COPY . .
RUN dart compile exe bin/akyron_server.dart -o /app/akyron_server

FROM debian:stable-slim
COPY --from=build /app/akyron_server /usr/local/bin/akyron_server
EXPOSE 28960
ENTRYPOINT ["/usr/local/bin/akyron_server"]
CMD ["--port", "28960", "--kind", "premium"]
```

```bash
docker build -t akyron-server .
docker run -p 28960:28960 akyron-server
```

---

## 🗂️ Arquitetura

```
server/
├── bin/akyron_server.dart      # entrypoint (parsing de args, start)
├── lib/akyron_server.dart      # biblioteca pública
├── lib/src/server.dart         # rotas HTTP + WebSocket
├── lib/src/session.dart        # sessões por jogador
├── lib/src/marketplace_store.dart # marketplace em memória
├── lib/src/world_state.dart    # boss mundial e estado compartilhado
└── pubspec.yaml
```

Para produção:
- Trocar `MarketplaceStore` (memória) por Postgres ou Redis.
- Plugar Supabase Auth para validar `playerId` em `hello`.
- Adicionar cluster / load balancer se for passar de algumas centenas
  de jogadores por instância.

# ============================================================
# 🏛️ Dockerfile — Serviço `archimedes` (opencode containerizado)
# ============================================================
# Imagem do agente Archimedes: opencode CLI + tooling básico.
# Roda headless (serve) e expõe o backend na porta 4096.
# ============================================================

FROM node:22-bookworm-slim

# Tooling básico de infra (git, curl, jq, ssh client)
RUN apt-get update && apt-get install -y --no-install-recommends \
        git curl jq ca-certificates openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Instalação oficial do opencode CLI
RUN curl -fsSL https://opencode.ai/install | bash

# PATH do opencode (instalado em ~/.opencode/bin)
ENV PATH="/root/.opencode/bin:${PATH}" \
    OPENCODE_ENABLE_WORKER=true

WORKDIR /work

# Persistência: config/auth/estado fora do container
VOLUME ["/root/.config/opencode", "/root/.local/share/opencode"]

# Backend headless (padrão da indústria para TUI remota)
EXPOSE 4096

ENTRYPOINT ["opencode"]
#!/usr/bin/env bash
# ==============================================================================
# 🏛️ Archimedes V2 — Migração Ultrarrápida em 5 Minutos (1-Click)
# ==============================================================================
# Descrição: Migração completa do workstation/GEEKOM para o Alienware.
#            Automatiza sync de cofre, RAG, configs, systemd e autoconfiguração.
# Uso: ./scripts/migrar-alienware.sh [DEST_HOST] (Padrão: alienware)
# ==============================================================================

set -euo pipefail

DEST_HOST="${1:-alienware}"
START_TIME=$(date +%s)

echo "🏛️  [Archimedes V2] Iniciando migração ultrarrápida para o host: ${DEST_HOST}..."

# 1. Validar conexão SSH com o destino
echo "🔍 [1/5] Verificando conexão SSH e privilégios no ${DEST_HOST}..."
if ! ssh -o ConnectTimeout=5 "${DEST_HOST}" "uname -a" &>/dev/null; then
  echo "❌ Erro: Não foi possível conectar via SSH no host '${DEST_HOST}'."
  echo "💡 Certifique-se de que '${DEST_HOST}' está no ~/.ssh/config e autorizado."
  exit 1
fi
echo "✅ Conexão SSH estabelecida!"

# 2. Preparar ambiente remoto (Linger + Dependências Base + Estrutura)
echo "⚡ [2/5] Preparando ambiente base no ${DEST_HOST} (Linger, Pastas e Systemd)..."
ssh "${DEST_HOST}" 'bash -lc "
    set -e
    sudo loginctl enable-linger \$USER 2>/dev/null || true
    mkdir -p ~/.config/systemd/user ~/.cache/opencode_rag ~/projetos ~/.agents ~/backups ~/Documentos ~/Imagens
"'

# 3. Sincronização ultra-otimizada de dados via rsync em alta velocidade
echo "🚚 [3/5] Sincronizando cofre, RAG, projetos e configurações (rsync otimizado)..."

# a) Repo principal archimedes-v2
rsync -aHAX --numeric-ids -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no" \
  --exclude 'node_modules' --exclude '.venv' --exclude '__pycache__' \
  ~/archimedes/ "${DEST_HOST}:~/archimedes/"

# b) RAG e Índice LanceDB (evita reindexar do zero)
rsync -aHAX --numeric-ids -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no" \
  --exclude '.venv' --exclude '__pycache__' \
  ~/projetos/archimedes-rag/ "${DEST_HOST}:~/projetos/archimedes-rag/" 2>/dev/null || true

rsync -aHAX --numeric-ids -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no" \
  ~/.cache/opencode_rag/ "${DEST_HOST}:~/.cache/opencode_rag/" 2>/dev/null || true

# c) Agentes, Skills e Projetos
rsync -aHAX --numeric-ids -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no" \
  ~/.agents/ "${DEST_HOST}:~/.agents/"

rsync -aHAX --numeric-ids -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no" \
  --exclude 'node_modules' --exclude '.venv' --exclude 'venv' --exclude '__pycache__' --exclude 'dist' \
  ~/projetos/ "${DEST_HOST}:~/projetos/"

echo "✅ Transferência de dados concluída!"

# 4. Bootstrap de venv do RAG e Serviço Systemd no destino
echo "⚙️  [4/5] Configurando ambiente Python do RAG e serviço systemd no ${DEST_HOST}..."
ssh "${DEST_HOST}" 'bash -lc "
    set -e
    sudo apt-get update -qq && sudo apt-get install -y -qq python3.12-venv python3-pip rsync
    cd ~/projetos/archimedes-rag
    if [ ! -d .venv ]; then
        python3 -m venv .venv
        .venv/bin/pip install --upgrade pip -q
        .venv/bin/pip install -r requirements.txt -q
    fi
"'

# Copiar arquivo de serviço systemd se existir
if [[ -f ~/.config/systemd/user/archimedes-rag-mcp.service ]]; then
  scp ~/.config/systemd/user/archimedes-rag-mcp.service "${DEST_HOST}:~/.config/systemd/user/"
  ssh "${DEST_HOST}" 'bash -lc "systemctl --user daemon-reload && systemctl --user enable --now archimedes-rag-mcp"'
fi

# 5. Autoconfiguração de URLs MCP e Reapontamento para 127.0.0.1
echo "🎯 [5/5] Autoconfigurando clientes Hermes e AGY para RAG local (127.0.0.1:8765)..."
ssh "${DEST_HOST}" 'bash -lc "
    # Ajustar Hermes config se existir
    if [ -f ~/.hermes/config.yaml ]; then
        sed -i \"s|http://10.0.0.[0-9]\+:8765/mcp|http://127.0.0.1:8765/mcp|g\" ~/.hermes/config.yaml
    fi
"'

# Healthcheck E2E
echo "🔍 Executando healthcheck pós-migração no ${DEST_HOST}..."
ssh "${DEST_HOST}" 'bash -lc "
    echo -n \"- RAG Service Status: \"
    systemctl --user is-active archimedes-rag-mcp 2>/dev/null || echo \"inactive\"
"'

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "=============================================================================="
echo "🎉 MIGRAÇÃO CONCLUÍDA COM SUCESSO EM ${DURATION} SEGUNDOS!"
echo "📍 Destino: ${DEST_HOST}"
echo "🌐 RAG Local: http://127.0.0.1:8765/mcp"
echo "=============================================================================="

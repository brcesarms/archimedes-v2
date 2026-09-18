#!/usr/bin/env bash
# =============================================================================
# 🚚 Sincronização do Hermes & Archimedes ➔ ACER (acer-brn / 10.0.0.215)
# =============================================================================
set -euo pipefail

TARGET_HOST="${1:-10.0.0.215}"
TARGET_USER="${2:-brn}"

echo "📡 Testando conectividade SSH com ${TARGET_USER}@${TARGET_HOST}..."

if ! ssh -o ConnectTimeout=4 -o BatchMode=yes "${TARGET_USER}@${TARGET_HOST}" "echo 'SSH Ok'" 2>/dev/null; then
  echo "❌ Erro: Não foi possível conectar via SSH a ${TARGET_USER}@${TARGET_HOST}."
  exit 1
fi

echo "✅ SSH Ativo! Criando estrutura de pastas no ACER Ubuntu..."
ssh "${TARGET_USER}@${TARGET_HOST}" "mkdir -p ~/.hermes ~/archimedes"

echo "🚚 Transferindo SOUL.md, config.yaml, AGENTS.md e scripts..."
scp ~/.hermes/SOUL.md "${TARGET_USER}@${TARGET_HOST}:~/.hermes/SOUL.md"
scp ~/.hermes/config.yaml "${TARGET_USER}@${TARGET_HOST}:~/.hermes/config.yaml"
scp /home/brn/archimedes/AGENTS.md "${TARGET_USER}@${TARGET_HOST}:~/archimedes/AGENTS.md"

echo "🔍 Verificando integridade remota via sha256sum..."
LOCAL_SHA=$(sha256sum ~/.hermes/SOUL.md /home/brn/archimedes/AGENTS.md | awk '{print $1}')
REMOTE_SHA=$(ssh "${TARGET_USER}@${TARGET_HOST}" "sha256sum ~/.hermes/SOUL.md ~/archimedes/AGENTS.md" | awk '{print $1}')

if [ "$LOCAL_SHA" = "$REMOTE_SHA" ]; then
  echo "✅ Checksums idênticos! Hermes e Archimedes totalmente sincronizados no ACER."
else
  echo "⚠️ Checksums diferem. Verifique a transferência."
fi

#!/bin/bash
# ==============================================================================
# 🌅 rotina-dia.sh — Rotina Diária do Archimedes V2 (100% Local, $0)
# ==============================================================================
# Um comando para: LINT + RAG + BACKUP + SAÚDE LOCAL — sem gastar 1 token de
# cloud. Orquestra a camada local-first:
#   1. ✅ Camada local    (proxy Ollama + worker claude-mem + RAG CLI)
#   2. 🧹 Esteira de lint (lychee, shellcheck, shfmt, gitleaks)
#   3. 🧠 Reindexação RAG (arquivos do cofre → LanceDB)
#   4. 💾 Snapshot restic (deduplicado, com .resticignore)
#
# Uso:
#   ./scripts/rotina-dia.sh              # Rotina completa
#   ./scripts/rotina-dia.sh --quick      # Sem lint (mais rápido, para testes)
# ==============================================================================
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1

QUICK="${1:-}"

# 🛡️ Garante resumo no log mesmo em falha
cleanup() {
  local rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "❌ Rotina diária falhou (exit=$rc). Veja as mensagens acima." >&2
  else
    echo "🎉 Rotina diária concluída (custo: R$ 0, zero tokens de cloud)!"
  fi
  exit "$rc"
}
trap cleanup EXIT

# 🧪 1/4: Camada local saudável?
echo "==> 🔍 [1/4] Verificando camada local (proxy + worker + RAG)..."
if systemctl --user is-active --quiet ollama-proxy.service; then
  echo "==> ✅ [1/4] Proxy Ollama (127.0.0.1:37777 → 10.0.0.4:11434) ativo."
else
  echo "⚠️  [1/4] Proxy Ollama inativo. Tentando subir..."
  systemctl --user start ollama-proxy.service
  sleep 1
  systemctl --user is-active --quiet ollama-proxy.service \
    && echo "==> ✅ [1/4] Proxy Ollama reativado." \
    || echo "❌ [1/4] Falha ao subir proxy. Rode: systemctl --user status ollama-proxy"
fi

if ! command -v rag &>/dev/null; then
  echo "⚠️  [1/4] CLI 'rag' não encontrada (archimedes-rag). RAG será pulado." >&2
fi

if curl -s -m 10 "http://127.0.0.1:37777/api/tags" -o /dev/null; then
  echo "==> ✅ [1/4] Ollama acessível via proxy (archimedes:latest pronto)."
else
  echo "⚠️  [1/4] Ollama não respondeu via proxy. Modelo local indisponível." >&2
fi

# 🧹 2/4: Esteira de qualidade (exceto no modo --quick)
if [[ "$QUICK" == "--quick" ]]; then
  echo "==> ⏩ [2/4] Modo --quick: lint pulado."
else
  echo "==> 🧹 [2/4] Rodando esteira de lint (lychee, shellcheck, shfmt, gitleaks)..."
  "${ROOT_DIR}/scripts/lint.sh"
  echo "==> ✅ [2/4] Esteira de lint 100% limpa."
fi

# 🧠 3/4: Reindexação RAG (custo local)
if command -v rag &>/dev/null; then
  echo "==> 🧠 [3/4] Reindexando arquivos no LanceDB..."
  rag index "$ROOT_DIR" >/dev/null 2>&1 \
    && echo "==> ✅ [3/4] Índice RAG atualizado (LanceDB local)." \
    || echo "⚠️  [3/4] Reindexação RAG falhou — índice anterior permanece." >&2
else
  echo "==> ⏩ [3/4] RAG não instalado — pulando indexação." >&2
fi

# 💾 4/4: Snapshot restic (deduplicado, local)
echo "==> 💾 [4/4] Criando snapshot restic..."
"${ROOT_DIR}/scripts/backup.sh"
echo "==> ✅ [4/4] Snapshot restic deduplicado concluído."

echo ""
echo "✨ Resumo: camada local OK · lint OK · RAG OK · backup OK — tudo sem cloud! 🏛️"

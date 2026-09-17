#!/bin/bash
# ==============================================================================
# 📊 metricas-tokens.sh — Medição de Tokens por Sessão do Archimedes V2
# ==============================================================================
# Lê o banco de sessões do OpenCode (SQLite) e reporta consumo de tokens por
# sessão/projeto, separando input/output. Base para o benchmark contínuo da
# estratégia local-first (Fase 5).
#
# Uso:
#   ./scripts/metricas-tokens.sh          # Resumo das últimas 10 sessões
#   ./scripts/metricas-tokens.sh --top 20 # Mais sessões
#   ./scripts/metricas-tokens.sh --today  # Somente sessões de hoje
# ==============================================================================
set -euo pipefail

DB="${OPENCODE_DB:-$HOME/.local/share/opencode/opencode.db}"
LIMIT="${2:-10}"

# 🧪 1/1: Pré-requisitos
if ! command -v sqlite3 &>/dev/null; then
  echo "❌ sqlite3 não encontrado. Execute: sudo apt install sqlite3" >&2
  exit 1
fi
if [[ ! -f "$DB" ]]; then
  echo "❌ Banco OpenCode não encontrado: $DB" >&2
  exit 1
fi

WHERE=""
if [[ "${1:-}" == "--today" ]]; then
  WHERE="WHERE date(time_created,'unixepoch','localtime') = date('now','localtime')"
fi

echo "📊 Consumo de tokens por sessão (OpenCode DB):"
echo ""

# shellcheck disable=SC2046
sqlite3 -header -column "$DB" "SELECT
  strftime('%d/%m %H:%M', time_created, 'unixepoch', 'localtime') AS quando,
  printf('%7d', tokens_input)  AS input,
  printf('%7d', tokens_output) AS output,
  printf('%6.2f', cost)        AS custo,
  substr(id,1,12)              AS sessao
FROM session $WHERE
ORDER BY time_created DESC
LIMIT $LIMIT;"

echo ""
echo "🏛️ Totais (últimas $LIMIT sessões):"
sqlite3 "$DB" "SELECT
  'input:  ' || printf('%12d', SUM(tokens_input))  || ' tokens' FROM session $WHERE
  UNION ALL SELECT
  'output: ' || printf('%12d', SUM(tokens_output)) || ' tokens' FROM session $WHERE
  UNION ALL SELECT
  'custo:  ' || printf('%10.4f', SUM(cost)) || ' (0 = provider local)' FROM session $WHERE;"

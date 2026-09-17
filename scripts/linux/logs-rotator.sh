#!/usr/bin/env bash
# ============================================================
# 🗑️ logs-rotator.sh — Limpeza automática de logs do cofre
# ============================================================
# @author: Archimedes
# @version: v1.0.0 (2026-09-08)
# @description: Remove logs com mais de 14 dias, mantendo apenas os recentes
# @usage:
#   ./logs-rotator.sh          # roda uma vez
#   systemctl --user start logs-rotator.service
# @security:
#   - Usa variáveis de ambiente (COFRE_DIR)
#   - Valida caminhos antes de operações
#   - NÃO expõe senhas em logs
# ============================================================
set -euo pipefail

# 🎯 Configurações
COFRE_DIR="${COFRE_DIR:-$HOME/archimedes-v2}"
LOG_DIR="$COFRE_DIR/docs/cerebrum/logs"
DAYS_TO_KEEP=14

# 🚨 Verificações iniciais
if [ ! -d "$LOG_DIR" ]; then
  echo "⚠️  Alerta: diretório de logs não encontrado: $LOG_DIR"
  exit 0 # Não é erro crítico, apenas aviso
fi

echo "⏳ [logs-rotator] Iniciando limpeza de logs com mais de $DAYS_TO_KEEP dias..."

# 🗑️ Remover logs antigos (apenas .log, não .md ou outros)
COUNT_OLD="$(find "$LOG_DIR" -name "*.log" -mtime +$DAYS_TO_KEEP 2>/dev/null | wc -l)"

if [ "$COUNT_OLD" -gt 0 ]; then
  echo "🗑️  [logs-rotator] Removendo $COUNT_OLD log(s) antigo(s)..."
  find "$LOG_DIR" -name "*.log" -mtime +$DAYS_TO_KEEP -delete
  echo "✅ [logs-rotator] Limpeza concluída: $COUNT_OLD arquivo(s) removido(s)"
else
  echo "✅ [logs-rotator] Nenhum log com mais de $DAYS_TO_KEEP dias encontrado."
fi

# 📊 Relatório final
COUNT_REMAINING="$(find "$LOG_DIR" -name "*.log" 2>/dev/null | wc -l)"
echo "📊 [logs-rotator] Total de logs restantes: $COUNT_REMAINING"

# ✅ Sucesso
echo "🎯 [logs-rotator] Limpeza concluída com sucesso!"
exit 0

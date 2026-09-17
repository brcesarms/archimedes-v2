#!/usr/bin/env bash
# ============================================================
# 🔄 backup-cofre.sh — Backup automático do Archimedes Vault
# ============================================================
# @author: Bruno César Medeiros Siqueira
# @version: v2.0.0 (2026-09-10)
# @description: Cria snapshot datado, verifica integridade e aplica rotação
# @changelog:
#   - v2.0.0 (2026-09-10): Migração para Archimedes Vault e caminhos dinâmicos
#   - v1.3.0 (2026-09-08): Adiciona shebang completo e headers
#   - v1.2.0 (2026-09-01): Adiciona verificação de integridade
#   - v1.1.0 (2026-08-25): Adiciona rotação de backups
# @usage:
#   ./backup-cofre.sh          # roda uma vez
#   systemctl --user start backup-cofre.service
# @security:
#   - Usa variáveis de ambiente (COFRE_DIR, BACKUP_BASE)
#   - Valida existência de COFRE_DIR
#   - Exclui .git, node_modules, caches
# ============================================================
set -euo pipefail

# 🎯 Configurações
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COFRE_DIR="${COFRE_DIR:-$(cd "${SCRIPT_DIR}/../../.." && pwd)}"
COFRE_NAME="$(basename "$COFRE_DIR")"
PARENT_DIR="$(dirname "$COFRE_DIR")"
BACKUP_BASE="${BACKUP_BASE:-$HOME/backups/archimedes-v2}"
KEEP=7                      # 🔁 quantas cópias manter (rotação)
STAMP="$(date +%Y-%m-%d_%H%M%S)"
ARCHIVE="$BACKUP_BASE/archimedes-v2_$STAMP.tar.gz"

# 🚨 Verificações iniciais
if [ ! -d "$COFRE_DIR" ]; then
    echo "❌ Erro: diretório do cofre não encontrado: $COFRE_DIR"
    exit 1
fi

mkdir -p "$BACKUP_BASE"

echo "🔍 Criando snapshot de $COFRE_DIR ..."

# 💾 Compacta o cofre (exclui lixo, caches e backups internos se existirem)
tar -czf "$ARCHIVE" \
    --exclude="$COFRE_NAME/docs/cerebrum/logs/*.log" \
    --exclude="$COFRE_NAME/.git" \
    --exclude="$COFRE_NAME/.opencode/node_modules" \
    --exclude="$COFRE_NAME/.obsidian/workspace*" \
    --exclude="$COFRE_NAME/.obsidian/cache" \
    --exclude="*.bak" \
    -C "$PARENT_DIR" "$COFRE_NAME"

# ✅ Verificação de integridade
if tar -tzf "$ARCHIVE" > /dev/null 2>&1; then
    echo "✅ Backup íntegro: $ARCHIVE"
    echo "📦 Tamanho: $(du -h "$ARCHIVE" | cut -f1)"
else
    echo "❌ Backup corrompido ou incompleto: $ARCHIVE"
    exit 1
fi

# 🔄 Rotação: mantém as K cópias mais recentes
COUNT="$(find "$BACKUP_BASE" -maxdepth 1 -name 'archimedes-v2_*.tar.gz' | wc -l)"
if [ "$COUNT" -gt "$KEEP" ]; then
    REMOVE=$((COUNT - KEEP))
    echo "🗑️ Rotação: removendo $REMOVE backup(s) antigo(s)..."
    find "$BACKUP_BASE" -maxdepth 1 -name 'archimedes-v2_*.tar.gz' \
        -printf '%T@ %p\n' | sort -n | head -n "$REMOVE" | cut -d' ' -f2- \
        | xargs rm -f
fi

echo "🎯 Backup concluído com sucesso!"
echo "📁 Pasta: $BACKUP_BASE"
#!/usr/bin/env bash
# ============================================================
# 🐚 verificar-scripts.sh — Varredura de qualidade dos scripts
# ============================================================
# @author: Bruno César Medeiros Siqueira
# @version: v1.1.0 (2026-09-08)
# @description: Verifica sintaxe e shellcheck em todos os scripts .sh
# @changelog:
#   - v1.1.0 (2026-09-08): Adiciona shebang completo e headers
#   - v1.0.0 (2026-08-15): Versão inicial
# @usage:
#   bash verificar-scripts.sh
# @security:
#   - Usa variáveis de ambiente (COFRE_DIR)
#   - Verifica apenas scripts do próprio cofre
# ============================================================
set -euo pipefail

# 🎯 Localizar o cofre (configurável via COFRE_DIR)
COFRE_DIR="${COFRE_DIR:-$HOME/archimedes-v2}"

# 🔍 Localizar o shellcheck (PATH ou ~/.local/bin)
SHELLCHECK_BIN="$(command -v shellcheck || command -v "$HOME/.local/bin/shellcheck" || true)"

# 📋 Se não encontrar scripts, encerra
mapfile -t SCRIPTS < <(find "$COFRE_DIR" -type f -name "*.sh" ! -name "*.bak*" 2>/dev/null)
if [ "${#SCRIPTS[@]}" -eq 0 ]; then
    echo "❌ Nenhum script .sh encontrado em: $COFRE_DIR"
    exit 1
fi

# ⚙️ Cabeçalho
echo "=============================================="
echo "🐚 Varredura de scripts do Archimedes"
echo "📁 Cofre: $COFRE_DIR"
echo "🛠️  Scripts encontrados: ${#SCRIPTS[@]}"
if [ -n "$SHELLCHECK_BIN" ]; then
    echo "🐚 ShellCheck: $($SHELLCHECK_BIN --version | head -1)"
else
    echo "⚠️  ShellCheck não encontrado — instalável via: sudo apt install shellcheck (ou brew install shellcheck)"
fi
echo "=============================================="
echo ""

# 🔢 Contadores
ERROS=0
OK=0

# 🔍 Varredura
for script in "${SCRIPTS[@]}"; do
    NOME_REL="${script#"$COFRE_DIR"/}"
    FALHAS=""

    # 1️⃣ Sintaxe
    if bash -n "$script" 2>/dev/null; then
        SINTAXE="✅"
    else
        SINTAXE="❌"
        FALHAS="$FALHAS sintaxe"
        ERROS=$((ERROS + 1))
    fi

    # 2️⃣ ShellCheck
    SHELLCHECK_RESULT=""
    if [ -n "$SHELLCHECK_BIN" ]; then
        if SHELLCHECK_OUT="$($SHELLCHECK_BIN "$script" 2>&1)"; then
            SHELLCHECK_STATUS="✅"
        else
            SHELLCHECK_STATUS="❌"
            SHELLCHECK_RESULT=$(echo "$SHELLCHECK_OUT" | head -5)
            FALHAS="$FALHAS shellcheck"
            ERROS=$((ERROS + 1))
        fi
    else
        SHELLCHECK_STATUS="⚠️"
    fi

    # ✅ Contabiliza sucesso
    if [ -z "$FALHAS" ]; then
        OK=$((OK + 1))
    fi

    # 📝 Resultado do script
    echo "$SINTAXE Sintaxe | $SHELLCHECK_STATUS ShellCheck | 📄 $NOME_REL"
    if [ -n "$SHELLCHECK_RESULT" ]; then
        echo "      └────────── $SHELLCHECK_RESULT"
    fi
done

echo ""
echo "=============================================="
echo "📊 Resumo: $OK limpos | $ERROS com falhas | Total: ${#SCRIPTS[@]}"
echo "=============================================="

# 🚦 Exit code final
if [ "$ERROS" -gt 0 ]; then
    echo "❌ $ERROS script(s) precisam de correção."
    exit 1
else
    echo "✅ Todos os scripts estão limpos! 🎉"
    exit 0
fi
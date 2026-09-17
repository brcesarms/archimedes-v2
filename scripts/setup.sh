#!/bin/bash
# ==============================================================================
# 🚀 setup.sh — Setup Rápido do Archimedes (< 1 min)
# ==============================================================================
# Substitui o antigo bootstrap artesanal de 260 linhas por ferramentas de ponta:
#   1. Homebrew Bundle (Brewfile) -> Instala todas as ferramentas consolidadas
#   2. Chezmoi -> Aplica dotfiles e configurações de SSH (com backup)
#   3. Lint -> Valida integridade e segurança
#
# Uso:
#   ./scripts/setup.sh
# ==============================================================================
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1
BREWFILE="${ROOT_DIR}/Brewfile"

# 🛡️ Garante limpeza no log mesmo em falha
cleanup() {
  local rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "❌ Setup falhou (exit=$rc). Verifique as mensagens acima." >&2
  fi
  exit "$rc"
}
trap cleanup EXIT

# 🧪 Pré-requisitos
echo "==> 🔍 [0/3] Verificando pré-requisitos..."
if ! command -v brew &>/dev/null; then
  echo "❌ [0/3] Homebrew não encontrado. Instale em: https://brew.sh" >&2
  exit 1
fi
if ! command -v chezmoi &>/dev/null; then
  echo "❌ [0/3] Chezmoi não encontrado. Execute: brew install chezmoi" >&2
  exit 1
fi
if [[ ! -f "$BREWFILE" ]]; then
  echo "❌ [0/3] Brewfile não encontrado: $BREWFILE" >&2
  exit 1
fi
echo "==> ✅ [0/3] Pré-requisitos OK"

echo ""
echo "📦 1/3: Instalando ferramentas consolidadas via Brewfile..."
brew bundle check --file="$BREWFILE" >/dev/null 2>&1 || brew bundle install --file="$BREWFILE"
echo "==> ✅ [1/3] Ferramentas prontas!"

echo ""
echo "🔌 2/3: Aplicando dotfiles via Chezmoi (com backup)..."
chezmoi apply --backup --source "${ROOT_DIR}/dotfiles"
echo "==> ✅ [2/3] Dotfiles e SSH configurados (backup em ~/.local/share/chezmoi)!"

echo ""
echo "🩺 3/3: Validando esteira Archimedes..."
bash "${ROOT_DIR}/scripts/lint.sh"

echo ""
echo "✨ Ambiente Archimedes configurado com sucesso!"

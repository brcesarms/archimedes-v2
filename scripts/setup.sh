#!/usr/bin/env bash
# ==============================================================================
# 🚀 setup.sh — Setup Rápido do Archimedes V2 (< 1 min)
# ==============================================================================
# Substitui o antigo bootstrap artesanal de 260 linhas por ferramentas de ponta:
#   1. Homebrew Bundle (Brewfile) -> Instala todas as ferramentas consolidadas
#   2. Chezmoi -> Aplica dotfiles e configurações de SSH
#   3. Lint -> Valida integridade e segurança
# ==============================================================================
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "📦 1/3: Instalando ferramentas consolidadas via Brewfile..."
brew bundle check --file=Brewfile >/dev/null 2>&1 || brew bundle install --file=Brewfile
echo "✔ Ferramentas prontas!"

echo ""
echo "🔌 2/3: Aplicando dotfiles via Chezmoi..."
chezmoi apply --source "${ROOT_DIR}/dotfiles"
echo "✔ Dotfiles e SSH configurados!"

echo ""
echo "🩺 3/3: Validando esteira Archimedes V2..."
"${ROOT_DIR}/scripts/lint.sh"

echo ""
echo "✨ Ambiente Archimedes V2 configurado com sucesso!"

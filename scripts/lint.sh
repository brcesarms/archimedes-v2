#!/bin/bash
# ==============================================================================
# 🩺 lint.sh — Esteira de Qualidade e Segurança do Archimedes
# ==============================================================================
# Executa:
#   1. lychee (validação de links markdown em Rust)
#   2. shellcheck (linter estático de scripts bash)
#   3. shfmt (formatador oficial de shell)
#   4. gitleaks (auditoria de credenciais e segredos em Git)
#
# Uso:
#   ./scripts/lint.sh        # Esteira completa
# ==============================================================================
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1

# 🧪 0/4: Ferramentas obrigatórias
check_tool() {
  local tool=$1
  if ! command -v "$tool" &>/dev/null; then
    echo "❌ Ferramenta '$tool' não encontrada. Execute: brew install $tool" >&2
    exit 1
  fi
}
check_tool lychee
check_tool shellcheck
check_tool shfmt
check_tool gitleaks

echo "🔍 1/4: Validando links Markdown com Lychee (Rust)..."
lychee --offline .
echo "==> ✅ [1/4] Links 100% íntegros!"

echo ""
echo "🐧 2/4: Auditando scripts Bash com ShellCheck..."
find "${ROOT_DIR}/scripts" -type f -name "*.sh" -exec shellcheck -S warning {} +
echo "==> ✅ [2/4] Shell scripts 100% em conformidade!"

echo ""
echo "🎨 3/4: Formatando shell scripts com shfmt (padrão do cofre)..."
find "${ROOT_DIR}/scripts" -type f -name "*.sh" -exec shfmt -i 2 -ci -bn -w {} +
echo "==> ✅ [3/4] Shell scripts formatados conforme shfmt!"

echo ""
echo "🛡️ 4/4: Verificando segredos e credenciais com Gitleaks..."
gitleaks detect --source . --no-banner
echo "==> ✅ [4/4] Repositório 100% blindado!"

echo ""
echo "✨ Todos os testes da esteira Archimedes passaram com sucesso!"

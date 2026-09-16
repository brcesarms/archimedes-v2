#!/usr/bin/env bash
# ==============================================================================
# 🩺 lint.sh — Esteira de Qualidade e Segurança do Archimedes V2
# ==============================================================================
# Executa:
#   1. lychee (validação de links markdown em Rust)
#   2. shellcheck (linter estático de scripts bash)
#   3. gitleaks (auditoria de credenciais e segredos em Git)
# ==============================================================================
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "🔍 1/3: Validando links Markdown com Lychee (Rust)..."
lychee --offline .
echo "✔ Links 100% íntegros!"

echo ""
echo "🐧 2/3: Auditando scripts Bash com ShellCheck..."
find scripts -type f -name "*.sh" -exec shellcheck -S warning {} +
echo "✔ Shell scripts 100% em conformidade!"

echo ""
echo "🛡️ 3/3: Verificando segredos e credenciais com Gitleaks..."
gitleaks detect --source . --no-banner
echo "✔ Repositório 100% blindado!"

echo ""
echo "✨ Todos os testes da esteira Archimedes V2 passaram com sucesso!"

#!/usr/bin/env bash
# ============================================================
# 🔗 verificar-links-parado.sh — Verifica links markdown em um arquivo
# ============================================================
# @author: Bruno César Medeiros Siqueira
# @version: v1.1.0 (2026-09-08)
# @description: Verifica links markdown em um arquivo e reporta quebrados
# @changelog:
#   - v1.1.0 (2026-09-08): Adiciona shebang completo e headers
#   - v1.0.0 (2026-08-01): Versão inicial
# @usage:
#   ./verificar-links-parado.sh caminho/arquivo.md
#   ./verificar-links-parado.sh ~/wikisidian/t.i/linux/README.md
# @security:
#   - Usa variáveis de ambiente (arquivo, dir, base)
#   - Limita verificações a 50 links para evitar travamento
# ============================================================
set -euo pipefail

if [ -z "$1" ]; then
  echo "❌ Uso: $0 <arquivo.md>"
  echo "📝 Exemplo: $0 ~/wikisidian/t.i/linux/README.md"
  exit 1
fi

arquivo="$1"

# Verifica se arquivo existe
if [ ! -f "$arquivo" ]; then
  echo "❌ Arquivo não encontrado: $arquivo"
  exit 1
fi

# Muda para o diretório do arquivo (links são relativos!)
dir=$(dirname "$arquivo")
base=$(basename "$arquivo")

echo "📂 Verificando links em: $base"
echo "📍 Localização: $dir"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Conta links internos
links_internos=$(grep -o '\[[^]]*\]([^)]*)' "$arquivo" 2>/dev/null | grep -v 'http' | wc -l)

echo "🔗 Total de links internos: $links_internos"
echo ""

# Verifica cada link (com limite para não travar)
count=0
grep -o '\[[^]]*\]([^)]*)' "$arquivo" 2>/dev/null | grep -v 'http' | sed 's/.*(\([^)]*\)).*/\1/' | while read -r link; do
  count=$((count + 1))
  # Limita a 50 verificações para evitar travamento
  if [ $count -gt 50 ]; then
    echo "... (limite de 50 links atingido)"
    break
  fi

  if [ -e "$dir/$link" ]; then
    echo "✅ [$count] $link"
  else
    echo "❌ [$count] $link (QUEBRADO)"
  fi
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Verificação concluída!"

exit 0

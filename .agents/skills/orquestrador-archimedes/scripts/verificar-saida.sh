#!/usr/bin/env bash
# ============================================================
# 🔍 verificar-saida.sh — Verificação pós-execução do Orquestrador
# Uso: verifica se arquivos/artefatos realmente existem e têm conteúdo
# Autor: Archimedes 🤖 · Versão: 1.0.0
# ============================================================
set -euo pipefail

# Verifica arquivo(s) por glob
verificar_glob() {
  local desc="$1" glob="$2" minimo="$3"
  echo "🔍 [${desc}] procurando: ${glob}"

  # Expandir glob (pode falhar se não houver match)
  local arquivos
  arquivos=$(ls -la ${glob} 2>/dev/null || true)

  if [[ -z "${arquivos}" ]]; then
    echo "   ❌ NENHUM arquivo encontrado para: ${glob}"
    return 1
  fi

  echo "   ✅ Arquivos encontrados:"
  echo "${arquivos}"
  echo "   ✅ ${desc}: OK"
  return 0
}

# Verifica arquivo específico existe e tem conteúdo mínimo de linhas
verificar_arquivo() {
  local desc="$1" path="$2" min_linhas="${3:-1}"
  echo "🔍 [${desc}] verificando: ${path}"

  if [[ ! -f "${path}" ]]; then
    echo "   ❌ Arquivo não existe: ${path}"
    return 1
  fi

  local linhas
  linhas=$(wc -l < "${path}")

  if (( linhas < min_linhas )); then
    echo "   ❌ Arquivo com conteúdo insuficiente (${linhas} linhas, mínimo ${min_linhas}): ${path}"
    return 1
  fi

  echo "   ✅ ${desc}: OK (${linhas} linhas)"
  return 0
}

# Verifica que não há segredos em um arquivo
verificar_sem_segredos() {
  local desc="$1" path="$2"
  echo "🔍 [${desc}] verificando ausência de segredos: ${path}"

  if [[ ! -f "${path}" ]]; then
    echo "   ⚠️ Arquivo não existe, pulando: ${path}"
    return 0
  fi

  local segredos
  segredos=$(grep -nE '(senha|password|token|secret|api[_-]?key|BEGIN (RSA|OPENSSH|PRIVATE) KEY)' "${path}" || true)

  if [[ -n "${segredos}" ]]; then
    echo "   ❌ Possíveis segredos encontrados:"
    echo "${segredos}"
    echo "   🚨 NÃO commitar este arquivo!"
    return 1
  fi

  echo "   ✅ ${desc}: sem segredos"
  return 0
}

# ============================================================
# 🏁 MAIN
# ============================================================
echo "======================================================"
echo " 🔍 ORQUESTRADOR — Verificação de Saída"
echo "======================================================"

FALHAS=0

# Executa verificações passadas como argumentos:
#   --glob "desc|glob|minimo"
#   --file "desc|path|min_linhas"
#   --no-secrets "desc|path"
for arg in "$@"; do
  case "${arg}" in
    --glob=*)
      IFS='|' read -r desc glob minimo <<< "${arg#--glob=}"
      verificar_glob "${desc}" "${glob}" "${minimo:-1}" || ((FALHAS++))
      ;;
    --file=*)
      IFS='|' read -r desc path min_linhas <<< "${arg#--file=}"
      verificar_arquivo "${desc}" "${path}" "${min_linhas:-1}" || ((FALHAS++))
      ;;
    --no-secrets=*)
      IFS='|' read -r desc path <<< "${arg#--no-secrets=}"
      verificar_sem_segredos "${desc}" "${path}" || ((FALHAS++))
      ;;
    *)
      echo "⚠️ Argumento desconhecido: ${arg}"
      ((FALHAS++))
      ;;
  esac
done

echo "======================================================"
if (( FALHAS > 0 )); then
  echo " ❌ VERIFICAÇÃO FALHOU: ${FALHAS} problema(s) encontrado(s)"
  echo " 🆘 Regra anti-alucinação: NÃO declarar sucesso. Marcar #falha."
  exit 1
fi

echo " ✅ TODAS AS VERIFICAÇÕES PASSARAM"
exit 0
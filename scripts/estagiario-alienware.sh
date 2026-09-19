#!/bin/bash
# ==============================================================================
# 🧑‍💻 estagiario-alienware.sh — Delegação Local-First ao Hermes Agent (Alienware)
# ==============================================================================
# Delega uma tarefa ATÔMICA ao Hermes Agent rodando 100% local (modelo
# qwen3.5:9b na GPU RTX 5060) dentro do Alienware, via SSH. Custo: R$ 0.
#
# Aplica automaticamente as regras validadas por benchmark:
#   1. Toolset restrito  — evita que o modelo 8B se perca entre dezenas de tools
#   2. Prompt anti-alucinação — comando explícito, proibido inventar comandos
#   3. --yolo            — execução headless (sem confirmação interativa)
#
# Pré-requisitos:
#   - SSH sem senha para o Alienware (runbook ssh-bootstrap-ubuntu.md)
#   - Hermes Agent + qwen3.5:9b (runbook hermes-agent-alienware.md)
#
# Uso:
#   ./scripts/estagiario-alienware.sh "tarefa atômica aqui"
#   ./scripts/estagiario-alienware.sh -t file "crie /tmp/nota.txt com oi"
#   ./scripts/estagiario-alienware.sh -t terminal "rode df -h / e diga o livre"
#   echo "tarefa" | ./scripts/estagiario-alienware.sh -
#
# Variáveis de ambiente:
#   ESTAGIARIO_HOST     host SSH          (padrão: alienware)
#   ESTAGIARIO_MODEL    modelo Ollama     (padrão: qwen3.5:9b)
#   ESTAGIARIO_TOOLSET  toolset restrito  (padrão: terminal)
#   ESTAGIARIO_TIMEOUT  timeout em segs   (padrão: 300)
# ==============================================================================
set -euo pipefail

HOST="${ESTAGIARIO_HOST:-alienware}"
MODEL="${ESTAGIARIO_MODEL:-qwen3.5:9b}"
TOOLSET="${ESTAGIARIO_TOOLSET:-terminal}"
TIMEOUT="${ESTAGIARIO_TIMEOUT:-300}"

usage() {
  cat <<'EOF'
🧑‍💻 estagiario-alienware — delega tarefa atômica ao Hermes local (Alienware)

Uso:
  estagiario-alienware.sh [opções] "tarefa"
  echo "tarefa" | estagiario-alienware.sh [opções] -

Opções:
  -t, --toolset <terminal|file>  Toolset restrito (padrão: terminal)
  -m, --model <modelo>           Modelo Ollama (padrão: qwen3.5:9b)
  -h, --help                     Mostra esta ajuda

Exemplos:
  estagiario-alienware.sh "rode docker ps e liste os containers"
  estagiario-alienware.sh -t file "crie /tmp/nota.txt com: teste"
EOF
}

# --- Parse de argumentos ------------------------------------------------------
PROMPT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -t | --toolset)
      TOOLSET="${2:?❌ Informe o toolset (terminal|file)}"
      shift 2
      ;;
    -m | --model)
      MODEL="${2:?❌ Informe o modelo}"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    -)
      PROMPT="$(cat)"
      shift
      ;;
    -*)
      echo "❌ Opção desconhecida: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      PROMPT="$1"
      shift
      ;;
  esac
done

if [[ -z "${PROMPT// /}" ]]; then
  echo "❌ Informe a tarefa. Use -h para ajuda." >&2
  exit 1
fi

# --- Pré-checagens ------------------------------------------------------------
if ! command -v ssh &>/dev/null; then
  echo "❌ ssh não encontrado no PATH." >&2
  exit 1
fi

if ! ssh -o BatchMode=yes -o ConnectTimeout=5 "$HOST" true 2>/dev/null; then
  echo "❌ Não consegui conectar em '$HOST' via SSH (chave configurada?)." >&2
  exit 1
fi

# --- Monta prompt anti-alucinação --------------------------------------------
FULL_PROMPT="Voce e um estagiario de TI executando tarefas no host alienware.
Execute EXATAMENTE a tarefa abaixo usando as ferramentas disponiveis.
Regras obrigatorias: (1) NUNCA invente comandos — use apenas comandos reais e conhecidos; (2) responda de forma factual e concisa (maximo 6 linhas); (3) se nao conseguir concluir, responda 'NAO CONSEGUI'.
TAREFA: ${PROMPT}"

PROMPT_B64="$(printf '%s' "$FULL_PROMPT" | base64 -w0)"

# base64 evita qualquer inferno de escaping entre bash local -> ssh -> hermes
REMOTE_CMD="export PATH=\"\$HOME/.local/bin:\$PATH\"; P=\$(printf '%s' '${PROMPT_B64}' | base64 -d); hermes -z \"\$P\" -t '${TOOLSET}' -m '${MODEL}' --yolo"

# --- Delega -------------------------------------------------------------------
echo "🧑‍💻 Delegando ao estagiário local — modelo: ${MODEL} · toolset: ${TOOLSET}"
echo "📋 Tarefa: ${PROMPT}"
echo "──────────────────────────────────────────────────────────────────────"

rc=0
timeout "$TIMEOUT" ssh "$HOST" "$REMOTE_CMD" || rc=$?

echo "──────────────────────────────────────────────────────────────────────"
if [[ "$rc" -eq 0 ]]; then
  echo "✅ [estagiário] tarefa concluída (custo R$ 0)"
else
  echo "❌ [estagiário] falha ou timeout (rc=${rc})" >&2
fi
exit "$rc"

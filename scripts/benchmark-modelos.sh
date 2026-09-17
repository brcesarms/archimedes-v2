#!/usr/bin/env bash
# ==============================================================================
# 🧪 Benchmark de Modelos Ollama — J.A.R.V.I.S.
# ------------------------------------------------------------------------------
# Mede de forma padronizada: contexto utilizado, eval tokens/s, load time,
# uso de GPU e memória de cada modelo via API do Ollama.
#
# Uso:
#   ./benchmark-modelos.sh                       # roda em todos os modelos
#   ./benchmark-modelos.sh qwen3-coder:30b      # roda em um modelo específico
#   OLLAMA_URL=http://10.0.0.3:11434 ./benchmark-modelos.sh
#
# Saídas:
#   docs/benchmarks/resultados/<modelo>.json   # resposta crua da API
#   docs/benchmarks/BENCHMARKS.md              # tabela comparativa
# ==============================================================================
set -euo pipefail

# ── Configuração ──────────────────────────────────────────────────────────────
OLLAMA_URL="${OLLAMA_URL:-http://10.0.0.3:11434}"
PROMPT_DEFAULT="Explique em detalhes como funciona um sistema MoE (Mixture of Experts) em modelos de linguagem, citando exemplos de uso prático em agentes de IA. Escreva cerca de 300 palavras."
NUM_PREDICT=256
TEMPERATURE=0.2
CONTEXT_SIZE=65536
DIR_RESULTADOS="$(cd "$(dirname "$0")/../docs/benchmarks" && pwd)/resultados"
ARQUIVO_MD="$(cd "$(dirname "$0")/../docs/benchmarks" && pwd)/BENCHMARKS.md"
TIMEOUT_GERAL=600

# ── Modelos padrão (usados quando nenhum argumento é passado) ─────────────────
MODELOS_PADRAO=(
  "qwen3-coder:30b"
  "gpt-oss:20b"
  "qwen2.5-coder:7b"
  "laguna-xs-2.1-64k"
)

# ── Help ───────────────────────────────────────────────────────────────────────
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  sed -n '1,20p' "$0" | grep '^#' | sed 's/^# \{0,1\}//'
  exit 0
fi

# ── Modelos alvo ───────────────────────────────────────────────────────────────
if [[ $# -gt 0 ]]; then
  MODELOS=("$@")
else
  MODELOS=("${MODELOS_PADRAO[@]}")
fi

# ── Verificações ───────────────────────────────────────────────────────────────
if ! command -v curl >/dev/null 2>&1; then
  echo "❌ curl não encontrado. Instale com: sudo dnf install curl"
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "❌ jq não encontrado. Instale com: sudo dnf install jq"
  exit 1
fi
if ! curl -sf "$OLLAMA_URL/api/version" >/dev/null; then
  echo "❌ Ollama não acessível em $OLLAMA_URL"
  echo "   Dica: use OLLAMA_URL=http://127.0.0.1:11434 se estiver na mesma máquina"
  exit 1
fi
mkdir -p "$DIR_RESULTADOS"

# ── Funções ────────────────────────────────────────────────────────────────────
formata_duracao() {
  # Recebe nanosegundos, devolve segundos legíveis
  local ns="$1"
  awk -v n="$ns" 'BEGIN { printf "%.2fs", n/1000000000 }'
}

tok_s() {
  # Recebe count e duration(ns), devolve tokens/s
  local count="$1" duration="$2"
  awk -v c="$count" -v d="$duration" 'BEGIN {
        if (d > 0) printf "%.1f tok/s", c/(d/1000000000)
        else printf "n/a"
    }'
}

# ── Benchmark individual ───────────────────────────────────────────────────────
benchmark_modelo() {
  local modelo="$1"
  local json_raw
  local ts_inicio ts_fim
  local exit_code=0

  echo ""
  echo "══════════════════════════════════════════════════════════════"
  echo "🧪 Testando: $modelo"
  echo "══════════════════════════════════════════════════════════════"

  # ── Passo 1: AQUECIMENTO ── carrega o modelo e descarta a resposta.
  #    Garante que a medição real (passo 2) rode com modelo QUENTE,
  #    refletindo o uso real (não penalizado pelo tempo de carga).
  echo "⏳ [1/3] Aquecendo (carregando modelo...) — pode demorar na 1ª vez"
  curl -s --max-time "$TIMEOUT_GERAL" "$OLLAMA_URL/api/generate" \
    -H "Content-Type: application/json" \
    -d "{
            \"model\": \"$modelo\",
            \"prompt\": \"$PROMPT_DEFAULT\",
            \"stream\": false,
            \"keep_alive\": \"30m\",
            \"options\": {
                \"num_predict\": 5,
                \"temperature\": $TEMPERATURE,
                \"num_ctx\": $CONTEXT_SIZE
            }
        }" >/dev/null || {
    echo "❌ Falha no aquecimento de $modelo"
    return 1
  }

  # ── Passo 2: MEDIÇÃO ── executa a geração real e coleta métricas
  echo "⏳ [2/3] Medindo (gerando ${NUM_PREDICT} tokens com modelo quente)..."
  ts_inicio=$(date +%s)
  json_raw=$(curl -s --max-time "$TIMEOUT_GERAL" "$OLLAMA_URL/api/generate" \
    -H "Content-Type: application/json" \
    -d "{
            \"model\": \"$modelo\",
            \"prompt\": \"$PROMPT_DEFAULT\",
            \"stream\": false,
            \"options\": {
                \"num_predict\": $NUM_PREDICT,
                \"temperature\": $TEMPERATURE,
                \"num_ctx\": $CONTEXT_SIZE
            }
        }") || exit_code=$?
  ts_fim=$(date +%s)

  if [[ $exit_code -ne 0 ]] || [[ -z "$json_raw" ]]; then
    echo "❌ Falha ao gerar resposta do modelo $modelo (exit=$exit_code)"
    return 1
  fi

  # Salva JSON cru
  echo "$json_raw" >"$DIR_RESULTADOS/$(echo "$modelo" | tr ':/' '__').json"

  # ── Extrai métricas ─────────────────────────────────────────────────────
  local prompt_eval_count eval_count prompt_eval_duration eval_duration \
    load_duration total_duration erro
  prompt_eval_count=$(echo "$json_raw" | jq -r '.prompt_eval_count // 0')
  eval_count=$(echo "$json_raw" | jq -r '.eval_count // 0')
  prompt_eval_duration=$(echo "$json_raw" | jq -r '.prompt_eval_duration // 0')
  eval_duration=$(echo "$json_raw" | jq -r '.eval_duration // 0')
  load_duration=$(echo "$json_raw" | jq -r '.load_duration // 0')
  total_duration=$(echo "$json_raw" | jq -r '.total_duration // 0')
  erro=$(echo "$json_raw" | jq -r '.error // empty')

  if [[ -n "$erro" ]]; then
    echo "❌ Erro do modelo: $erro"
    return 1
  fi

  # ── Passo 3: CAPTURA GPU/PS ── modelo ainda carregado (keep_alive 30m)
  echo "⏳ [3/3] Capturando uso de GPU/memória..."
  local ps_json ps_gpu_df ps_cpu_df ps_total_df ps_proc
  ps_json=$(curl -s "$OLLAMA_URL/api/ps")
  ps_gpu_df=$(echo "$ps_json" | jq -r --arg m "$modelo" \
    '.models[] | select(.name == $m) | .size_vram // 0' 2>/dev/null)
  ps_cpu_df=$(echo "$ps_json" | jq -r --arg m "$modelo" \
    '.models[] | select(.name == $m) | .size // 0' 2>/dev/null)
  ps_total_df="$ps_cpu_df"
  ps_proc=$(echo "$ps_json" | jq -r --arg m "$modelo" \
    '.models[] | select(.name == $m) | .processor // empty' 2>/dev/null)

  # Determina o processador real: API retorna processor=null,
  # então inferimos comparando size_vram vs size total.
  if [[ -z "$ps_proc" ]]; then
    if [[ -n "$ps_gpu_df" && "$ps_gpu_df" != "0" && -n "$ps_cpu_df" && "$ps_cpu_df" != "0" ]]; then
      if [[ "$ps_gpu_df" == "$ps_cpu_df" ]]; then
        ps_proc="100% GPU"
      else
        ps_proc="GPU+CPU"
      fi
    elif [[ -n "$ps_gpu_df" && "$ps_gpu_df" != "0" && "$ps_gpu_df" != "null" ]]; then
      ps_proc="100% GPU"
    else
      ps_proc="CPU"
    fi
  fi

  # ── Exibe resultado ─────────────────────────────────────────────────────
  echo ""
  echo "📊 Resultado: $modelo"
  echo "──────────────────────────────────────────────────"
  echo "⏱️  Load time:        $(formata_duracao "$load_duration")"
  echo "🧠 Contexto prompt:  $prompt_eval_count tokens (meta: $CONTEXT_SIZE)"
  echo "⚡ Tokens gerados:   $eval_count"
  echo "🚀 Velocidade eval:  $(tok_s "$eval_count" "$eval_duration")"
  echo "📥 Prompt eval:      $(tok_s "$prompt_eval_count" "$prompt_eval_duration")"
  echo "⌛ Total request:    $(formata_duracao "$total_duration") (wall: $((ts_fim - ts_inicio))s)"
  echo "🎮 Processador:      $ps_proc"
  if [[ -n "$ps_gpu_df" && "$ps_gpu_df" != "0" && "$ps_gpu_df" != "null" ]]; then
    echo "🎮 Em VRAM/GPU:      $(numfmt --to=iec "$ps_gpu_df" 2>/dev/null || echo "${ps_gpu_df}B")"
  fi
  if [[ -n "$ps_total_df" && "$ps_total_df" != "0" && "$ps_total_df" != "null" ]]; then
    echo "🧮 Alocado total:    $(numfmt --to=iec "$ps_total_df" 2>/dev/null || echo "${ps_total_df}B")"
  fi

  # ── Descarrega o modelo para o próximo teste começar limpo ────────────
  curl -s "$OLLAMA_URL/api/generate" -H "Content-Type: application/json" \
    -d "{\"model\": \"$modelo\", \"prompt\": \"\", \"stream\": false, \"keep_alive\": 0}" \
    >/dev/null 2>&1 || true

  # ── Devolve métricas separadas por | para a tabela ─────────────────────
  echo "__MÉTRICAS__$modelo|$(formata_duracao "$load_duration")|$prompt_eval_count|$(tok_s "$eval_count" "$eval_duration")|$(tok_s "$prompt_eval_count" "$prompt_eval_duration")|$((ts_fim - ts_inicio))|$ps_proc|$(numfmt --to=iec "$ps_total_df" 2>/dev/null || echo '-')"
}

# ── Coleção de resultados ──────────────────────────────────────────────────────
echo "ℹ️  Ollama: $(curl -s "$OLLAMA_URL/api/version" | jq -r '.version')"
echo "ℹ️  URL:    $OLLAMA_URL"
echo "ℹ️  Prompt: ${#PROMPT_DEFAULT} chars, num_predict=$NUM_PREDICT, ctx=$CONTEXT_SIZE"
echo "ℹ️  Data:   $(date '+%d/%m/%Y %H:%M:%S')"
echo ""

declare -A TABELA
TABELA["header"]="Modelo|Load|Ctx Prompt|Eval|Prompt Eval|Wall (s)|Processador|Alocado"

for modelo in "${MODELOS[@]}"; do
  if saida=$(benchmark_modelo "$modelo"); then
    # Captura linha de métricas (evita repetir toda a saída)
    linha=$(echo "$saida" | grep '^__MÉTRICAS__' | sed 's/^__MÉTRICAS__//')
    TABELA["$modelo"]="$linha"
  else
    TABELA["$modelo"]="$modelo|FALHOU|-|-|-|-|-|-"
  fi
done

# ── Gera tabela do BENCHMARKS.md ──────────────────────────────────────────────
{
  echo "# 🧪 Benchmarks de Modelos — J.A.R.V.I.S."
  echo ""
  echo "> Principais métricas dos modelos disponíveis na GEEKOM."
  echo "> Executado em: $(date '+%d/%m/%Y %H:%M:%S') · Ollama $(curl -s "$OLLAMA_URL/api/version" | jq -r '.version')"
  echo ""
  echo "## ⚙️ Parâmetros do teste"
  echo ""
  echo "- 🌐 URL Ollama: \`$OLLAMA_URL\`"
  echo "- 📝 Tamanho da prompt: ${#PROMPT_DEFAULT} caracteres"
  echo "- 🔢 \`num_predict\`: $NUM_PREDICT · \`num_ctx\`: $CONTEXT_SIZE · \`temperature\`: $TEMPERATURE"
  echo ""
  echo "## 📊 Resultados"
  echo ""
  echo "| Modelo | Load | Ctx Prompt | Eval | Prompt Eval | Wall (s) | Processador | Alocado |"
  echo "|--------|------|-----------|------|-------------|----------|-------------|---------|"
  for modelo in "${MODELOS[@]}"; do
    linha="${TABELA[$modelo]}"
    nome="${linha%%|*}"
    resto="${linha#*|}"
    echo "| $nome | ${resto//|/ | } |"
  done
  echo ""
  echo "## 🔗 Fontes"
  echo "- [Ollama API docs](https://github.com/ollama/ollama/blob/main/docs/api.md)"
  echo "- [Guia de modelos locais](../MY-SETUP.md)"
  echo ""
  echo "---"
  echo "_Gerado automaticamente por \`benchmark-modelos.sh\` — rode novamente para atualizar._"
} >"$ARQUIVO_MD"

echo ""
echo "✅ Benchmark concluído! Resultados salvos em:"
echo "   📄 $ARQUIVO_MD"
echo "   📂 $DIR_RESULTADOS/"

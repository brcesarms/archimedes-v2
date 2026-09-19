#!/bin/bash
# ============================================================
# 📊 Benchmark de Modelos MoE - GEEKOM A7 MAX
# ============================================================
# Descrição: Script para benchmark de modelos Mixture of Experts
# Autor: Archimedes (Bruno César)
# Data: 2026-09-07
# ============================================================

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 📁 Resultados DENTRO do cofre (portabilidade) — NÃO usar /tmp
RESULTADOS_FILE="$HOME/archimedes-vault/guia-ia-local/tests/benchmark-results.json"
mkdir -p "$(dirname "$RESULTADOS_FILE")"

# Função para log colorido
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✔ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}✖ $1${NC}"; }
log_header() {
  echo -e "\n${CYAN}═══════════════════════════════════════════════════════════${NC}"
  echo -e "${CYAN} $1${NC}"
  echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}\n"
}

# Verificar se Ollama está rodando
check_ollama() {
  log_header "🔍 Verificando Ollama"
  if curl -s http://localhost:11434/api/version >/dev/null 2>&1; then
    local version
    version=$(curl -s http://localhost:11434/api/version | jq -r '.version')
    log_success "Ollama versão $version ativo"
  else
    log_error "Ollama não está respondendo!"
    exit 1
  fi
}

# Listar modelos MoE disponíveis
list_moe_models() {
  log_header "📦 Modelos MoE Disponíveis"
  echo -e "${CYAN}Modelos instalados:${NC}"
  ollama list | grep -E "(deepseek-coder-v2|olmoe|qwen.*moe)" || log_warning "Nenhum modelo MoE encontrado"
  echo ""
}

# Benchmark de um modelo específico
benchmark_model() {
  local model=$1
  local prompt=$2
  local test_name=$3

  log_header "🧪 Teste: $test_name"
  log_info "Modelo: $model"
  log_info "Prompt: $(echo "$prompt" | head -1)..."

  # Medir tempo de início
  local start_time
  start_time=$(date +%s%N)

  # Executar inferência
  local response
  response=$(ollama run "$model" "$prompt" 2>/dev/null)

  # Medir tempo de fim
  local end_time
  end_time=$(date +%s%N)
  local duration=$(((end_time - start_time) / 1000000)) # em milissegundos

  # Contar tokens (aproximado: 1 token ≈ 4 caracteres)
  local char_count
  char_count=${#response}
  local token_count=$((char_count / 4))

  # Calcular tokens por segundo
  local tokens_per_second
  tokens_per_second=$(echo "scale=2; $token_count / ($duration / 1000)" | bc)

  # Exibir resultados
  echo -e "${GREEN}📊 Resultados:${NC}"
  echo -e "   ⏱️  Tempo: ${duration}ms"
  echo -e "   📝 Tokens estimados: ${token_count}"
  echo -e "   🚀 Tokens/segundo: ${tokens_per_second}"
  echo -e "   📄 Resposta (primeiros 200 chars):"
  echo -e "   ${response:0:200}..."
  echo ""

  # Salvar resultados em JSON
  echo "{\"model\":\"$model\",\"test\":\"$test_name\",\"duration_ms\":$duration,\"tokens\":$token_count,\"tokens_per_second\":$tokens_per_second}" >>"$RESULTADOS_FILE"
}

# Benchmark completo de um modelo
run_full_benchmark() {
  local model=$1

  log_header "🚀 Benchmark Completo: $model"

  # Prompt 1: Geração de código Python
  benchmark_model "$model" \
    "Escreva uma função Python que calcule o fatorial de um número usando recursão. Inclua tratamento de erros." \
    "Geração de Código (Python)"

  # Prompt 2: Raciocínio lógico
  benchmark_model "$model" \
    "Resolva: Se 3 máquinas produzem 3 widgets em 3 minutos, quantas máquinas são necessárias para produzir 100 widgets em 100 minutos? Explique o raciocínio." \
    "Raciocínio Lógico"

  # Prompt 3: Explicação técnica
  benchmark_model "$model" \
    "Explique a diferença entre TCP e UDP, quando usar cada um, e dê exemplos práticos de aplicações." \
    "Explicação Técnica (Redes)"

  # Prompt 4: Resumo de texto
  benchmark_model "$model" \
    "Resuma em 3 pontos principais: A arquitetura Mixture of Experts (MoE) permite que modelos de IA sejam mais eficientes ao ativar apenas uma parte dos parâmetros para cada tarefa, economizando recursos computacionais enquanto mantêm alta qualidade nas respostas." \
    "Resumo de Texto"

  # Prompt 5: Debug de código
  benchmark_model "$model" \
    "Encontre e corrija o erro neste código bash: #!/bin/bash\nfor i in {1..10}\ndo\necho \"Número: \$i\"\ndone\nif [ \$i -eq 5 ]; then\n  echo \"Parou no 5\"\nfi" \
    "Debug de Código (Bash)"
}

# Coletar informações do sistema
collect_system_info() {
  log_header "🖥️  Informações do Sistema"

  echo -e "${CYAN}CPU:${NC}"
  lscpu | grep -E "Model name|CPU\(s\)|Thread" | head -3
  echo ""

  echo -e "${CYAN}Memória:${NC}"
  free -h | grep -E "Mem|Swap"
  echo ""

  echo -e "${CYAN}GPU:${NC}"
  if command -v nvidia-smi &>/dev/null; then
    nvidia-smi --query-gpu=name,memory.total,memory.used --format=csv,noheader,nounits 2>/dev/null || echo "GPU não detectada"
  else
    echo "nvidia-smi não encontrado"
  fi
  echo ""
}

# Relatório final
generate_report() {
  log_header "📊 Relatório Final"

  if [ -f "$RESULTADOS_FILE" ]; then
    echo -e "${GREEN}Resultados salvos em: ${RESULTADOS_FILE}${NC}"
    echo ""
    jq -r '.' "$RESULTADOS_FILE"
  else
    log_warning "Nenhum resultado de benchmark encontrado"
  fi
}

# Função principal
main() {
  log_header "🎯 Benchmark de Modelos MoE - GEEKOM A7 MAX"

  # Verificar Ollama
  check_ollama

  # Listar modelos
  list_moe_models

  # Informações do sistema
  collect_system_info

  # Limpar resultados anteriores
  rm -f "$RESULTADOS_FILE"

  # Benchmark do DeepSeek-Coder-V2:16b (principal)
  run_full_benchmark "deepseek-coder-v2:16b"

  # Benchmark comparativo dos outros modelos MoE
  log_header "📊 Benchmark Comparativo"

  # Apenas teste rápido para comparação
  benchmark_model "sam860/olmoe-1b-7b-0924" \
    "Escreva uma função Python que calcule o fatorial de um número usando recursão." \
    "Comparativo - OlMoE (Código)"

  benchmark_model "recall704/qwen:7b-moe-q4_k_m" \
    "Escreva uma função Python que calcule o fatorial de um número usando recursão." \
    "Comparativo - Qwen MoE (Código)"

  # Relatório final
  generate_report

  log_success "Benchmark concluído! 🎉"
}

# Executar
main "$@"

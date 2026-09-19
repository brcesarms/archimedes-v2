# 🧪 Benchmark Comparativo — Hermes Agent

> **Modelos:** `qwen3-nothink:latest` vs `qwen3.5:9b`
> **Data de Execução:** 2026-09-18 21:33:23

---

## 1. ⚡ Desempenho Bruto (API Ollama)

| Métrica | qwen3-nothink:latest | qwen3.5:9b |
|---|---|---|---|
| Velocidade de Geração (Eval) | 28.07 tok/s | 37.13 tok/s |
| Processamento de Prompt | 167.58 tok/s | 203.76 tok/s |
| Tempo Total da Requisição | 9.4s | 7.13s |
| Tempo de Carga (Load) | 0.00s | 0.00s |
| Uso de VRAM | 6328 MB | 5630 MB |

## 2. 🤖 Desempenho Funcional no Hermes Agent

### 🎯 Consulta de Sistema (Tool Call)

**Prompt:** *Qual é a distribuição Linux, versão do Kernel e uptime deste servidor? Responda de forma direta.*

| Modelo | Status | Tempo (s) | Resposta Resumida |
|---|---|---|---|
| `qwen3-nothink:latest` | ✅ Sucesso | 17.04s | Distribuição Linux: Ubuntu   Versão do Kernel: 7.0.0-31-generic   Uptime: Não foi possível determinar o uptime diretamen... |
| `qwen3.5:9b` | ✅ Sucesso | 10.72s | Vou verificar as informações solicitadas usando comandos de terminal.  ```bash uname -r lsb_release 2>/dev/null || cat /... |

### 🎯 Raciocínio & Arquitetura

**Prompt:** *Explique a diferença entre OSPF v2 e BGP em termos de algoritmo de roteamento e escala de rede.*

| Modelo | Status | Tempo (s) | Resposta Resumida |
|---|---|---|---|
| `qwen3-nothink:latest` | ✅ Sucesso | 23.93s | OSPF v2 (Open Shortest Path First version 2) utiliza o algoritmo de Dijkstra para calcular os caminhos mais curtos em um... |
| `qwen3.5:9b` | ✅ Sucesso | 48.61s | # OSPF v2 vs BGP: Diferenças Principais  ## 🔄 Algoritmo de Roteamento  ### OSPF v2 (Open Shortest Path First - Versão 2)... |

### 🎯 Geração de Script Shell

**Prompt:** *Escreva um script bash idempotente com set -euo pipefail para verificar a saúde do disco em / e emitir alerta se > 85%.*

| Modelo | Status | Tempo (s) | Resposta Resumida |
|---|---|---|---|
| `qwen3-nothink:latest` | ✅ Sucesso | 36.59s | O script foi executado em segundo plano com sucesso. Para verificar o resultado, use `process(action="poll")` ou `proces... |
| `qwen3.5:9b` | ✅ Sucesso | 17.03s | Vou criar o script bash com as melhores práticas:  ```bash #!/bin/bash  # Ativa modos de falha rigoroso set -euo pipefai... |

## 3. 📋 Conclusão e Recomendação

- **Velocidade de Incerteza/Geração:** `qwen3.5:9b` vs `qwen3-nothink:latest` teve variação de **+32.3%** em tok/s.
- **Integração Hermes:** Ambas as chamadas de ferramentas e comportamentos no Hermes Agent foram validados.

# 📈 Histórico de Benchmarks — Archimedes

> Registro permanente das execuções de benchmark para comparação ao longo do tempo.
> O `BENCHMARKS.md` (snapshot atual) é sobrescrito pelo script — este arquivo preserva o histórico.

## 🎛️ Execução 2026-09-16 · Fine-Tuning `archimedes:latest` (Qwen3-4B no estilo do cofre)

**Contexto:** PoC de fine-tuning para dar "voz" local ao Archimedes. Base `Qwen/Qwen3-4B-Instruct-2507`, LoRA (r=16) sobre 54 exemplos de estilo extraídos do cofre, merge em bf16 e quantização GGUF Q4_K_M. Treinado no LXC 104 (GPU Radeon 780M, ROCm 6.3).

**O grande obstáculo — GPU Hang:** Unsloth/bnb 4-bit, PEFT+bnb e até LoRA bf16 puro travavam no step 1 (`HW Exception by GPU node-1 ... GPU Hang`; dmesg `MES failed to respond to msg=REMOVE_QUEUE`). **Não era memória** (VRAM/UMA não resolve). Solução: **fp16 + `AMD_SERIALIZE_KERNEL=3` + `AMD_SERIALIZE_COPY=3`** (evita o timeout do MES na gfx1103→gfx1100). Detalhes em [`docs/finetune/`](../finetune/README.md).

**Treino:** 60 steps · ~16 min · `train_loss` **6.77** (loss por step: 14.26 → **3.65**).

**Benchmark (256 tokens, temp 0.2):**

| Métrica | `qwen3:4b` (base) | `archimedes` (fine-tuned) | Δ |
|---------|:---:|:---:|:---:|
| ⚡ Velocidade | 26.8 tok/s | 26.2 tok/s | -2% |
| 🔢 Prompt eval | 177.5 tok/s | **346.2 tok/s** | +95% |
| 🧠 TTFT | 130 ms | 407 ms | +277 ms |
| ⏱️ Wall time | 12.8 s | 7.9 s | -38% |
| 🎨 Estilo Archimedes | ❌ | ✅ emojis + tabelas + pt-BR | ✅ |

**Validação de estilo:** respostas com emojis (`📋 🏛️ ✅`), pt-BR técnico e **tabelas markdown** (ex.: comparação MikroTik × Ubiquiti) — padrão do cofre.

**Ferramentas:** `llama.cpp` clonado em `/opt/llama.cpp` (build `llama-quantize`); artefatos em `/root/finetune/`.

---

## 🧪 Execução 2026-09-16 · Servidor Ollama LXC 104 — `qwen3:4b` (GPU ROCm ativada!)

**Contexto:** benchmark do novo **servidor Ollama dedicado** (`10.0.0.4:11434`, LXC 104 no Proxmox GEEKOM, Ubuntu 24.04, Ollama 0.34.1). Durante a medição inicial descobriu-se que o Ollama rodava **100% CPU** (`size_vram=0`). Diagnóstico via log: `dropping ROCm device — no rocblas support for gfx target gfx1103`. Correção aplicada no systemd do LXC:

```ini
Environment=OLLAMA_IGPU_ENABLE=1          # habilita iGPU (780M)
Environment=HSA_OVERRIDE_GFX_VERSION=11.0.0  # mapeia gfx1103 → gfx1100 (suportado ROCm)
```

Resultado: `inference compute id=0 library=ROCm compute=gfx1100 name="AMD Radeon 780M Graphics" type=iGPU` — **GPU 100% ativa** (backup do unit: `ollama.service.bak-2026-09-16`).

**Parâmetros:** prompt 173 chars · `num_predict: 256` · `temperature: 0.2` · modelo em GPU

| Métrica | CPU (antes) | GPU ROCm (depois) | Δ |
|---------|:---:|:---:|:---:|
| ⚡ Velocidade @ctx 4096 | 19.3 tok/s | **26.8 tok/s** | +39% |
| ⚡ Velocidade @ctx 65536 | 16.2 tok/s | **26.7 tok/s** | +65% |
| 🔢 Prompt eval @4096 | 93.0 tok/s | **292.6 tok/s** | +215% |
| 🔢 Prompt eval @65536 | 81.8 tok/s | **305.0 tok/s** | +273% |
| 🧠 Concorrência (3× 128 tok) | ~19.8 tok/s c/u | **~27 tok/s c/u** | +36% |
| ⏱️ TTFT (modelo quente) | 4325 ms | **1465 ms** | -66% |
| 🔄 Load @ctx 65536 | 20.0 s | **3.4 s** | -82% |
| 💾 Alocação VRAM | 0 (CPU) | **3.17 GB** (ctx 4096) / **12.23 GB** (ctx 65536) | ✅ |
| 🤖 Tool calling | — | ✅ `get_capital({"pais":"Brazil"})` | ✅ |

### 🎯 Conclusões

- 🏆 **Fix GPU validado**: `HSA_OVERRIDE_GFX_VERSION=11.0.0` + `OLLAMA_IGPU_ENABLE=1` resolveram o descarte da iGPU gfx1103 (Radeon 780M) pelo ROCm 7.2.
- ⚡ **Ganho principal é em prompt eval (3x)** — o contexto carrega muito mais rápido; ideal para uso agêntico.
- 📈 No CPU o ctx 65536 **perdia 20%** de velocidade; na GPU a perda é ≈0 (26.8 → 26.7).
- 🧠 Concorrência: 3 requisições paralelas mantêm ~27 tok/s cada — escalável na iGPU.
- 🤖 `qwen3:4b` faz tool calling real (pensa + chama com JSON válido). Observação: o modo thinking consome muitos tokens antes da chamada — usar `num_predict` generoso.

## 🧪 Execução 2026-09-06 (tarde) · Validação Agêntica — `gemma4:26b` (Decisão Final)

**Contexto:** validação em **uso real agêntico** (não apenas benchmark sintético) após definir a regra de boas práticas: iGPU de **16GB com sobra mínima de 5GB** (orçamento ~11GB) — nunca trabalhar no limite do hardware (evita trashing/offload/alucinações).

**Configuração testada:** `num_ctx: 65536` · keep-alive 30m · 100% GPU · Radeon 780M via Vulkan · Ollama 0.33.3 (container Podman)

| Métrica | Resultado |
|---------|-----------|
| 💾 Alocação (`ollama ps` SIZE) | **2.0 GB** — estável durante todo o teste |
| 🎨 Processador | **100% GPU** (sem offload CPU) |
| 🧠 Sobra de RAM (available) | **35Gi** (baseline 44Gi → consumo ~9Gi) |
| 🔄 Swap | **0B** (sem trashing) |
| 🤖 Tool-calling | ✅ `criar_nota` chamada com JSON estruturado |
| ⚡ Geração longa | ~21 tok/s · 1024 tokens · memória estável do início ao fim |

### 🎯 Conclusões da validação

- 🥇 **`gemma4:26b` ADOTADO como modelo padrão** do OpenCode.
- ✅ Cumpre a regra dos 16GB com **7x a sobra pedida** (35Gi vs 5GB).
- ✅ 64k de contexto funcionando (256k nativo).
- ✅ MoE esparso A4B: só os experts ativos em VRAM (~2GB) — perfeito para iGPU com memória compartilhada.
- ❌ `qwen3-coder:30b` (24G @64k) e `qwen2.5-coder:7b` (13G @64k) ficam de fora da regra dos 16GB/5GB (comparação em [BENCHMARKS.md](./BENCHMARKS.md)).
- 🔄 `qwen3:14b` (9.3GB, 40k ctx) baixado em 06/09 — candidato futuro p/ OpenCode.

## 🧪 Execução 2026-09-06 · Ollama 0.33.3 (2ª — com novos modelos)

**Parâmetros:** prompt 176 chars · `num_predict: 256` · `num_ctx: 65536` · `temperature: 0.2` · modelo quente (2ª chamada)

| Modelo | Load | Eval | Prompt Eval | Wall (s) | Processador | Alocado |
|--------|------|------|-------------|----------|-------------|---------|
| 🌀 qwen3-coder:30b | 0.00s | **33.4 tok/s** | 1881.4 tok/s | 7 | **100% GPU** | 24G |
| 🐐 gpt-oss:20b | 0.00s | 20.4 tok/s | 145.7 tok/s | 13 | **100% GPU** | 12G |
| 📱 qwen3.6:27b | 0.00s | 9.4 tok/s | 60.1 tok/s | 28 | **100% GPU** | 20G |
| 🟢 gemma4:26b | 0.00s | 25.3 tok/s | 11.7 tok/s | 15 | **100% GPU** | ~3,3G* |
| ⚡ qwen2.5-coder:7b | 0.00s | 12.1 tok/s | 1372.9 tok/s | 21 | **100% GPU** | 13G |
| 📉 laguna-xs-2.1-64k | 0.00s | 34.3 tok/s | 31.2 tok/s | 11 | CPU | - |

\* gemma4:26b = MoE **A4B** esparso: o Ollama mapeia só os pesos ativos em VRAM (3,3GB), o restante fica em memória mapeada. É o modelo mais eficiente em VRAM dos grandes.

### 🎯 Análise dos novos modelos

- 📱 **`qwen3.6:27b`**: 9.4 tok/s — **o mais lento** para geração longa por ser **dense** (ativa 100% dos 27B). Qualidade/agente excelente (68.9% SWE-bench), mas pena na iGPU da GEEKOM. Melhor uso: tarefas únicas sem loop longo.
- 🟢 **`gemma4:26b`**: 25.3 tok/s — **surpreendente eficiente em VRAM** (MoE A4B esparso, só 3,3G em VRAM ativa). Ótimo tool calling multimodal, 256K ctx. Excelente para agente geral + visão.
- 🌀 **`qwen3-coder:30b` continua campeão**: 33.4 tok/s, 100% GPU, 24G — melhor velocidade para código e agentes na GEEKOM.
- ⚡ qwen2.5-coder:7b caiu para 12.1 tok/s nesta rodada (medição mais justa com todos carregando; anterior 17.7).

### 💡 Conclusões atualizadas

1. ✅ **`qwen3-coder:30b` = escolha principal** para o OpenCode (velocidade + contexto + tool calling).
2. ✅ **`gemma4:26b` = melhor 2º modelo** — esparso, leve em VRAM, multimodal; ideal para visão/tool general.
3. ✅ **`qwen3.6:27b`** vale para tarefas de qualidade única (não loops) — mas 9 tok/s é frustrante em uso agêntico.
4. ❌ **laguna-xs-2.1-64k permanece aposentado** (CPU + trashing).

## 🧪 Execução 2026-09-06 · Ollama 0.33.3

**Parâmetros:** prompt 176 chars · `num_predict: 256` · `num_ctx: 65536` · `temperature: 0.2` · modelo quente (2ª chamada)

| Modelo | Load | Eval | Prompt Eval | Wall (s) | Processador | Alocado |
|--------|------|------|-------------|----------|-------------|---------|
| 🌀 qwen3-coder:30b | 0.00s | **33.5 tok/s** | 1870.9 tok/s | 8 | **100% GPU** | 24G |
| 🐐 gpt-oss:20b | 0.00s | 20.4 tok/s | 145.7 tok/s | 13 | **100% GPU** | 12G |
| ⚡ qwen2.5-coder:7b | 0.00s | 17.7 tok/s | 1367.7 tok/s | 14 | **100% GPU** | 13G |
| 📉 laguna-xs-2.1-64k | 0.00s | 34.5 tok/s | 31.2 tok/s | 10 | CPU | - |

### 🎯 Análise dos resultados

- 🏆 **`qwen3-coder:30b` é o campeão**: 33.5 tok/s (mais rápido que o 7B!) rodando **100% GPU** com apenas 24G alocados — **sem trashing**, 36Gi livres durante o teste. Contexto native 256K, perfeito para contexto longo (64k+).
- 🐐 **`gpt-oss:20b`**: 20.4 tok/s, 100% GPU, **apenas 12G** — o mais leve dos grandes. Ótimo para tarefas que não exigem coder.
- ⚡ **`qwen2.5-coder:7b`**: 17.7 tok/s foi o mais lento na geração por ser dense (ativa 100% dos parâmetros). Prompt eval rápido (1367 tok/s) — bom para chat rápido, mas não para geração longa.
- 📉 **`laguna-xs-2.1-64k`**: rápido na geração (34.5 tok/s) mas roda **em CPU** (não cabe na iGPU) → é exatamente isso que causava trashing com contexto longo. Confirmado: não usar.

### 💡 Conclusões

1. ✅ **`qwen3-coder:30b` é o modelo recomendado para o OpenCode** — velocidade de MoE pequeno + qualidade de 30B + contexto native 256K.
2. ✅ **`gpt-oss:20b` é ótima alternativa leve** — 12G alocados, 100% GPU, ótimo para usar junto com o qwen3 (alternância sem estourar RAM).
3. ❌ **Abandonar o laguna-xs-2.1-64k** — embora gere rápido, roda em CPU e causava trashing com contexto longo.

## 🧪 Execução 2026-09-09 · Benchmark Agêntico — `hermes3:8b` vs `deepseek-coder-v2:16b`

**Contexto:** teste agêntico real via OpenCode (`opencode run --auto`) no GEEKOM, 24k de contexto (`num_ctx: 24576`), 5 tarefas de TI do dia a dia — pedido do Bruno para avaliar uso diário com OpenCode.

**Método:** para cada modelo, 5 tarefas independentes em sandbox próprio (`~/benchmark-teste/<modelo>/t<N>`); tempo medido por tarefa; verificação de arquivos criados no disco; teste de velocidade pura via Ollama API (200 tokens, prompt 176 chars).

### 📊 Resultado da Velocidade Pura

| Modelo | Velocidade | Alocação | Processador |
|--------|-----------|----------|-------------|
| 🌀 hermes3:8b | 18.1 tok/s | 7.8GB | 100% GPU |
| 🔴 deepseek-coder-v2:16b | **47.9 tok/s** | ~8.9GB | 100% GPU |

### ⚠️ Suporte a Tool Calling (crítico p/ OpenCode)

| Modelo | Capabilities | Tool calling |
|--------|-------------|:---:|
| ✅ hermes3:8b | completion + **tools** | ✅ (instável) |
| ❌ deepseek-coder-v2:16b | completion + insert | ❌ **NÃO SUPORTA** |

> 🚫 `deepseek-coder-v2:16b` falhou **100% das tarefas** com: `Error: does not support tools`. Incompatível com OpenCode agêntico — serve apenas p/ autocompletar código (`insert`).

### 📋 Tarefas Agênticas (hermes3:8b)

| Tarefa | Resultado | Arquivos | Tempo |
|--------|-----------|----------|-------|
| 1. Estrutura de pastas + nota | ❌ Alucinou `/path/to/your/README.md` | 0 | 45s |
| 2. Script bash + executar | ❌ Chamadas bash confusas, nada persistiu | 0 | 195s |
| 3. Listar modelos + resumo | 🟡 Criou `models.md` vazio (0B) | 1 | 56s |
| 4. Python fatorial + testes | ✅ Código correto + execução | 1 | 58s |
| 5. Info do sistema | ❌ Alucinou `mkdir /path/to` | 0 | 55s |

**✅ 1/5 tarefas completas · 🟡 1 parcial · ❌ 3 falhas** — tool calling instável e alucinações de caminhos placeholder.

### 🎯 Conclusão

- **`deepseek-coder-v2:16b`: DESCARTADO para OpenCode** (sem tool calling = incompatível total)
- **`hermes3:8b`: não recomendado** — 18.1 tok/s lento + tool calling instável (só 1/5 OK)
- ✅ Manter `qwen3-coder:30b` (33.4 tok/s, agêntico ✅) ou `gemma4:26b` (25.3 tok/s, esparso) como principais
- 💡 Para modelo MENOR funcional: testar `qwen2.5-coder:7b` (17.7 tok/s, com tools ✅)

## 🧪 Execução 2026-09-09 (2ª) · Benchmark Agêntico — `qwen3-coder:30b` (Validação Final)

**Contexto:** validação agêntica do `qwen3-coder:30b` via OpenCode (`opencode run --auto`) no GEEKOM, 24k de contexto (`num_ctx: 24576`), 5 tarefas de TI do dia a dia — mesmo método do benchmark hermes3 vs deepseek p/ comparação justa. O teste do `qwen3:14b` (concorrente dense) foi **cancelado por inviabilidade**: 572s só na tarefa 1 (vs 69s do coder) e README com placeholder — modelo dense não compete na iGPU do GEEKOM.

### 📋 Tarefas Agênticas (qwen3-coder:30b)

| Tarefa | Resultado | Arquivos | Tempo |
|--------|-----------|----------|-------|
| 1. Estrutura de pastas + nota | ✅ README com conteúdo REAL (Sistema de Monitoramento) | 1 | 69s |
| 2. Script bash + executar | ✅ `saudacao.sh` correto com `exit 0` | 1 | 70s |
| 3. Listar modelos + resumo | ✅ `modelos.md` com análise real dos modelos | 1 | 69s |
| 4. Python fatorial + testes | ✅ Código correto + tratamento de erro + execução | 1 | 69s |
| 5. Info do sistema | ✅ `sistema.md` com dados reais (RAM, disco, GPU) | 1 | 105s |

**🎯 5/5 tarefas completas · 0 falhas · conteúdo real (zero placeholder/alucinação)**

### 📊 Comparativo com rodadas anteriores

| Modelo | Tarefas OK | Tempo médio | Tool calling |
|--------|:---:|:---:|:---:|
| 🌀 **qwen3-coder:30b** | **5/5** | **76s** | ✅ estável |
| 🌀 hermes3:8b | 1/5 | 82s | ⚠️ instável |
| ❌ deepseek-coder-v2:16b | 0/5 | 1.5s (falha) | 🚫 sem tools |
| ❌ qwen3:14b (dense) | cancelado | 572s+ | inviável |

### 🎯 Conclusão

- 🏆 **`qwen3-coder:30b` CONFIRMADO como o modelo oficial** do OpenCode no GEEKOM — 5/5 tarefas, conteúdo real, tool calling estável, 33.4 tok/s.
- ✅ MoE (A3B) → apenas 3B ativos: velocidade de modelo pequeno + qualidade de 30B.
- 💡 Próximo passo: buscar modelo MoE candidato a superar o qwen3-coder:30b (ver pesquisa no final do dia).

## 🧪 Execução 2026-09-09 (3ª) · Benchmark Agêntico — `gemma4:26b` (ultra-leve)

**Contexto:** validação agêntica do `gemma4:26b` via OpenCode (`opencode run --auto`) no GEEKOM, 24k de contexto (`num_ctx: 24576`), mesmas 5 tarefas de TI dos testes anteriores — pedido do Bruno para achar um modelo **mais leve** que o qwen3-coder:30b (~21GB) e testar com contexto 24k. Modelo baixado em 09/09 (18GB, ID `08ae7ec1744b`). `hermes3:8b`, `qwen3:8b` e `qwen3:14b` removidos do Ollama na mesma data (~10GB liberados).

### 📋 Tarefas Agênticas (gemma4:26b)

| Tarefa | Resultado | Arquivos | Tempo |
|--------|-----------|----------|-------|
| 1. Estrutura de pastas + nota | ✅ `projeto/docs/README.md` (Sistema de Monitoramento) | 1 | 96s |
| 2. Script bash + executar | ✅ `saudacao.sh` correto + execução | 1 | 95s |
| 3. Listar modelos + resumo | ✅ `modelos.md` com análise real | 1 | 122s |
| 4. Python fatorial + testes | ✅ Código correto + execução | 1 | 293s |
| 5. Info do sistema | ✅ `sistema.md` com dados reais | 1 | 387s |

**🎯 5/5 tarefas completas · 0 falhas · conteúdo real · média 198.6s/tarefa**

### 📊 Medições (24k ctx)

| Métrica | Resultado |
|---------|-----------|
| 💾 Alocação (`ollama ps` SIZE) | **1.0 GB** — 100% GPU |
| ⚡ Velocidade pura (@24k, 200 tok) | **29.9 tok/s** |
| 🧠 Sobra de RAM (available) | **39Gi** durante uso |

### 🎯 Conclusão

- 🟢 **`gemma4:26b` = MoE esparso ultra-leve**: 1GB alocado @24k (vs 21GB do qwen3-coder) com 5/5 tarefas ✅.
- ⚠️ **Porém 2.6x mais lento em tarefas agênticas** (198.6s vs 76s) — gera mais tokens/passos por tarefa apesar de tok/s similar.
- 🖼️ Bônus: multimodal (visão) — único dos 3 com essa capacidade.
- ✅ Cumpre folgadamente a regra 16GB/5GB (sobra ~39Gi reais).

## 🧪 Execução 2026-09-09 (4ª) · Benchmark Agêntico — `gpt-oss:20b` (meio-termo)

**Contexto:** pesquisa do Bruno por um modelo MoE **intermediário** — mais rápido que o gemma4:26b (198.6s/tarefa) e que consuma **mais que 1GB e menos que 21GB**, sem ser 2x mais lento que o qwen3-coder:30b (76s → limite ~152s). Candidato escolhido: `gpt-oss:20b` (OpenAI, MoE 3.6B ativos, 21B totais, tools nativos, ~12GB). Baixado em 09/09 (13GB, ID `17052f91a42e`).

### 📋 Tarefas Agênticas (gpt-oss:20b)

| Tarefa | Resultado | Arquivos | Tempo |
|--------|-----------|----------|-------|
| 1. Estrutura de pastas + nota | 🟡 `project/docs/README.md` (inglês, não `projeto/`) — conteúdo real | 1 | 89s |
| 2. Script bash + executar | 🟡 `saudacao.sh` correto + executado, **sem `exit 0` explícito** | 1 | 155s |
| 3. Listar modelos + resumo | ✅ `modelos.md` com análise real e detalhada | 1 | 115s |
| 4. Python fatorial + testes | 🟡 `fatorial.py` código impecável (docstring/erro) mas **não executou** (só sugeriu) | 1 | 146s |
| 5. Info do sistema | 🟡 `system.md` (inglês) com dados reais (RAM/disco/GPU) | 1 | 192s |

**🎯 5/5 exit 0 · conteúdo real · média 139.4s/tarefa** — mas com tendência a **inglesar nomes** (`project`/`system.md`) e **não executar** comandos quando pode só descrever.

### 📊 Medições (24k ctx)

| Métrica | Resultado |
|---------|-----------|
| 💾 Alocação (`ollama ps` SIZE) | **12 GB** — 100% GPU |
| ⚡ Velocidade pura (@24k, 200 tok) | **9.2 tok/s** ⚠️ (o mais lento dos 3; MXFP4 mal acelerado no backend Vulkan) |
| 🧠 Sobra de RAM (available) | **42Gi** durante uso |

### 🎯 Conclusão

- ✅ **É o "meio do caminho" pedido**: 12GB (entre 1GB e 21GB), 139.4s/tarefa (1.83x o qwen3 — não chega a 2x; 1.42x mais rápido que o gemma4).
- ⚠️ **Velocidade pura decepciona** (9.2 tok/s) — mas rende bem em tarefas por fazer tool calling direto (menos tokens).
- 🟡 **Fidelidade à instrução inferior**: inglesa nomes de arquivo e prefere "dizer" a "fazer" quando pode.
- 📌 `gpt-oss:20b` = alternativa de **consumo moderado**; `qwen3-coder:30b` continua o mais rápido (76s); `gemma4:26b` o mais leve (1GB) e multimodal.

## 🧪 Execução 2026-09-09 (5ª) · Benchmark Agêntico — `lfm2:24b` (último teste — FALHOU)

**Contexto:** último teste da série (decidido pelo Bruno). O `lfm2:24b` (Liquid AI, 24B MoE híbrido com **2B ativos**, GGUF Q4_K_M 14GB, tools, on-device) foi escolhido como substituto do `gpt-oss:20b` (removido por MXFP4 mal acelerado no Vulkan — 9.2 tok/s). Baixado em 09/09 (14GB, ID `d6c816d74887`).

### 📋 Tarefas Agênticas (lfm2:24b) — ✅ Exit=0 mas ❌ CONTEÚDO FALSO

| Tarefa | Resultado Real | Tempo |
|--------|----------------|-------|
| 1. Estrutura + nota | ❌ **NADA criado** (só imprimiu `> build`) | 27s |
| 2. Script bash | 🟡 Escreveu em `/tmp/` (fora do sandbox) | 26s |
| 3. Listar modelos | ❌ Descreveu o comando, **não executou** | 33s |
| 4. Python fatorial | 🟡 Errou comando (`3 /tmp/fatorial.py`) e **afirmou resultado sem rodar** | 35s |
| 5. Info do sistema | ❌ **Alucinou GPU** ("Radeon Instinct MI250" — é 780M!) e dados incorretos | 40s |

**🎯 5/5 "Exit=0" mas ZERO arquivos reais no sandbox** — alucinação total de execução.

### 📊 Medições (24k ctx)

| Métrica | Resultado |
|---------|-----------|
| ⚡ Velocidade pura | **49.6 tok/s** 🥇 (o MAIS rápido de toda a série!) |
| 💾 Alocação (`ollama ps` SIZE) | **15 GB** — 100% GPU |

### 🎯 Conclusão (lição valiosa)

- 🚨 **Velocidade pura NÃO garante agente funcional**: 49.6 tok/s (2B ativos) seria o campeão, mas o **tool calling é quebrado** — o modelo **alucina sucesso** (diz que fez, não faz).
- ⚠️ **Exit=0 não é critério**: todos os modelos deram Exit=0; o que diferencia é **conteúdo real no disco** (verificar `find` após cada tarefa).
- ❌ **`lfm2:24b` DESCARTADO e removido do Ollama em 09/09.**
- 💡 Conclusão definitiva: para OpenCode agêntico no GEEKOM, **`qwen3-coder:30b` (5/5 real, 76s) + `gemma4:26b` (5/5 real, 198s, 1GB, multimodal)** são os únicos aprovados da série.

## 🔗 Fontes
- [Benchmark atual (BENCHMARKS.md)](./BENCHMARKS.md)
- [Documentação de Benchmarks](./README.md)
- [Ollama API docs](https://github.com/ollama/ollama/blob/main/docs/api.md)

---
_Histórico manual — adicione novas execuções aqui (não sobrescreve)._
## 📊 Execução 2026-09-17 · Integração Local-First (Fases 1–4)

**Contexto:** Estratégia de economia de tokens — camada local ativa (proxy Ollama systemd, RAG LanceDB, claude-mem), estagiário local como surface layer, rotina diária sem cloud.

**Infra ativada:**
- Proxy `127.0.0.1:37777 → 10.0.0.4:11434` via `ollama-proxy.service` (systemd user)
- `archimedes-rag` reindexado: 49 arquivos, 93 chunks (LanceDB)
- `claude-mem` worker (PID, porta 37700) com provider `archimedes:latest` (100% local)
- Modelo `estagiario` criado no Ollama (`FROM archimedes:latest`, persona júnior, ctx 8K)

**Benchmark estagiário local (`estagiario`, tool calling ✅):**

| Teste | Tempo | Tokens | Custo |
|-------|:---:|:---:|:---:|
| "pct list?" | **3,6 s** | 421 | R$ 0 |
| "restic saudável?" | **6,9 s** | ~250 | R$ 0 |
| "O que é MikroTik?" | **~5 s** | ~300 | R$ 0 |
| Arquitetura complexa | 45-180 s | ~585 | ⚠️ aceito (deve delegar) |

**Rotina sem cloud (`./scripts/rotina-dia.sh`):** lint (lychee 114 OK, shellcheck, shfmt, gitleaks) + RAG + restic snapshot `aaf83d48` — custo R$ 0.

**Medição de tokens (OpenCode DB, sessões reais):** totais de 10 sessões recentes = `input 6.803.192` · `output 1.753.738` · custo `0.0000` (provider local).

**Ferramentas novas:** `scripts/metricas-tokens.sh` (leitura SQLite do OpenCode) · `scripts/rotina-dia.sh` (1 comando local).

---
_Registrado em 2026-09-17 · Commit `0c24a59`_

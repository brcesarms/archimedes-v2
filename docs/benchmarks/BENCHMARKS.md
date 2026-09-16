# 🧪 Benchmarks de Modelos — J.A.R.V.I.S.

> Principais métricas dos modelos disponíveis na GEEKOM.
> Executado em: 06/09/2026 09:26:10 · Ollama 0.33.3

## ⚙️ Parâmetros do teste

- 🌐 URL Ollama: `http://127.0.0.1:11434`
- 📝 Tamanho da prompt: 176 caracteres
- 🔢 `num_predict`: 256 · `num_ctx`: 65536 · `temperature`: 0.2

## 📊 Resultados

| Modelo | Load | Ctx Prompt | Eval | Prompt Eval | Wall (s) | Processador | Alocado |
|--------|------|-----------|------|-------------|----------|-------------|---------|
| 🌀 qwen3-coder:30b | 0.00s | 57 | **33.4 tok/s** | 1881.4 tok/s | 7 | 100% GPU | 24G |
| 🐐 gpt-oss:20b | 0.00s | 109 | 20.4 tok/s | 145.7 tok/s | 13 | 100% GPU | 12G |
| 📱 qwen3.6:27b | 0.00s | 54 | 9.4 tok/s | 60.1 tok/s | 28 | 100% GPU | 20G |
| 🟢 gemma4:26b | 0.00s | 59 | 25.3 tok/s | 11.7 tok/s | 15 | 100% GPU | 3,3G* |
| ⚡ qwen2.5-coder:7b | 0.00s | 78 | 12.1 tok/s | 1372.9 tok/s | 21 | 100% GPU | 13G |
| 📉 laguna-xs-2.1-64k | 0.00s | 98 | 34.3 tok/s | 31.2 tok/s | 11 | CPU | - |

## 🧪 Novos modelos testados (2026-09-09 · Agêntico via OpenCode)

> Teste agêntico real (`opencode run --auto`) + velocidade pura (Ollama API, 200 tokens, 24k ctx).

| Modelo | Velocidade (tok/s) | Tool calling | Tarefas OK | Tempo médio | Alocação @24k | Veredicto |
|--------|:---:|:---:|:---:|:---:|:---:|-----------|
| 🌀 **qwen3-coder:30b** | 33.4 | ✅ estável | **5/5 REAL** | **76s** | 21G | 🏆 **OFICIAL** |
| 🟢 **gemma4:26b** | 29.9 | ✅ estável | **5/5 REAL** | **198.6s** | **1G** | 🟢 leve/multimodal |
| 🟠 ~~gpt-oss:20b~~ | 9.2 ⚠️ | ✅ estável | 5/5 (139s) | 139.4s | 12G | ❌ MXFP4 ruim Vulkan |
| 🧪 ~~lfm2:24b~~ | **49.6** 🥇 | ❌ **alucina sucesso** | 0/5 REAL | 32s (falso) | 15G | ❌ Não executa |
| 🌀 hermes3:8b | 18.1 | ⚠️ instável | 1/5 | 82s | - | ❌ Não recomendado |
| 🔴 deepseek-coder-v2:16b | 47.9 | 🚫 não suporta | 0/5 | 1.5s (falha) | - | ❌ **Incompatível** |
| 🔴 qwen3:14b (dense) | - | ✅ | cancelado | **572s+** | - | ❌ **Inviável** |

> ⚠️ **Importantíssimo:** o `deepseek-coder-v2:16b` **NÃO suporta tool calling** (capabilities: completion+insert apenas). O OpenCode depende 100% de tools → modelo inutilizável para uso agêntico. **Removido do Ollama em 09/09.**
>
> 🔴 **qwen3:14b** é **dense** (ativa 100% dos parâmetros) → 572s só na tarefa 1, contra 69s do MoE. Dense não compete na iGPU do GEEKOM. **Removido do Ollama em 09/09.**
>
> 🏆 **qwen3-coder:30b** = único com **5/5 tarefas**, conteúdo real (zero alucinação), tool calling estável. Confirmado como **modelo oficial**.
>
> 🟠 **gpt-oss:20b** (12G, 139.4s) = formato **MXFP4 nativo mal acelerado no Vulkan** (9.2 tok/s vs 26 no ROCm) → removido em 09/09 mesmo com 5/5 no agêntico, por velocidade pura pobre.
>
> 🧪 **lfm2:24b** (15G, **49.6 tok/s** — o mais rápido da série!) = **tool calling quebrado**: alucina sucesso (Exit=0 mas zero arquivos reais, GPU inventada). Lição: velocidade pura não garante agente funcional. **Removido em 09/09.**
>
> ✅ **CONCLUSÃO FINAL DA SÉRIE:** apenas 2 modelos aprovados para OpenCode agêntico no GEEKOM → **qwen3-coder:30b** (🏆 oficial, 5/5 real, 76s, 21G) + **gemma4:26b** (🟢 leve, 5/5 real, 198.6s, **1G**, multimodal).

> 🏆 **Mais rápido: qwen3-coder:30b** · 🟢 gemma4:26b = MoE A4B esparso (só pesos ativos em VRAM)
> Veja análise completa em [HISTORICO.md](./HISTORICO.md).

## 🎯 Decisão Final (06/09/2026 — tarde)

> **Regra de boas práticas:** iGPU de **16GB com sobra mínima de 5GB** → orçamento de ~11GB para o modelo. Não trabalhar no limite do hardware evita trashing, offload e alucinações.

| Critério | qwen3-coder:30b | 🏆 **gemma4:26b** | gpt-oss:20b |
|----------|:---------------:|:------------------:|:-----------:|
| ⚡ Velocidade | 33.4 tok/s (🥇) | 25.3 tok/s | 20.4 tok/s |
| 💾 Alocação @64k | 24G ❌ | **~2,0G** ✅ | 12G ⚠️ |
| 📏 Sobra (16GB − alocação) | — | **~14GB** ✅ | ~4GB ⚠️ |
| 🤖 Tool-calling validado | ✅ | ✅ (agêntico real) | ✅ |

**🏆 ADOTADO: `gemma4:26b`** — o mais rápido que cumpre a regra dos 16GB com sobra ENORME (~35Gi reais). Config atualizado em 06/09/2026 (opencode.json); backups `.bak-*` mantidos localmente.

## 🎯 Decisão Final Atualizada (09/09/2026 — validação agêntica completa)

> **Após teste agêntico real (5 tarefas TI, 24k ctx) dos 3 modelos finais:**

| Critério | 🏆 **qwen3-coder:30b** | 🟠 gpt-oss:20b | 🟢 gemma4:26b |
|----------|:---:|:---:|:---:|
| ⚡ Velocidade pura | **33.4 tok/s** | 9.2 tok/s | 29.9 tok/s |
| ⚙️ Tarefas agênticas | **5/5** | 5/5 | 5/5 |
| ⏱️ Tempo médio/tarefa | **76s** | 139.4s | 198.6s |
| 💾 Alocação @24k | 21G | 12G | **1G** |
| 🤖 Tool calling | ✅ estável | ✅ estável | ✅ estável |
| 🖼️ Multimodal | ❌ | ❌ | ✅ |
| 📏 Regra 16GB/5GB | ❌ estoura | ✅ cumpre (sobra 4G) | ✅ cumpre (sobra 15G) |

**🏆 OFICIAL: `qwen3-coder:30b`** — campeão de velocidade + 5/5 agêntico com conteúdo real. MoE A3B é a prova de que modelos esparsos (MoE) são superiores na iGPU do GEEKOM.

**🟢 Melhor leve: `gemma4:26b`** — 1GB @24k, 5/5, multimodal; ideal para uso diário/conversa/visão.

**🟠 Meio-termo: `gpt-oss:20b`** — 12GB + 139.4s (1.83x o qwen3); consumo moderado com boa precisão em tarefas, mas inglesa nomes e não executa comandos quando pode só descrever.

## 🔗 Fontes
- [Ollama API docs](https://github.com/ollama/ollama/blob/main/docs/api.md)
- [Guia de modelos locais](../perfis/my-setup.md)

---
_Gerado automaticamente por `benchmark-modelos.sh` — rode novamente para atualizar._

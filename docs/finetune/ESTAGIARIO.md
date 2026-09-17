# 🧑‍💻 Estagiário Archimedes — Camada Local de Tarefas Rotineiras

> **Objetivo:** responder FAQs, runbooks e diagnósticos simples **sem custo de cloud** — o "estagiário" do Archimedes V2.
> **Data:** 2026-09-17 (atualização: promoção 8B) · **Base:** `qwen3:8b` (Q4_K_M) · **Derivado:** `estagiario` via Modelfile
> **Fallback:** `estagiario4b` (antigo, base `archimedes:latest` fine-tuned 4B)

---

## 🎯 Motivação

| | Archimedes cloud | 🧑‍💻 Estagiário local |
|------|:---:|:---:|
| 💸 Custo por resposta | tokens | **R$ 0** |
| ⏱️ Latência | rede + API | 7 s (iGPU local) |
| 🧠 Raciocínio profundo | ✅ ✅ ✅ | ❌ delega |
| 📋 FAQs / runbooks / resumos | ✅ | ✅ 80% do caso |
| 🔧 Tool calling | ✅ (OpenCode) | ✅ (/v1, testado) |

---

## 🔧 Como foi criado

```bash
# v1 (2026-09-17 08:5x): derivado do fine-tune 4B — alucinava números/preços
# v2 (2026-09-17 10:2x): PROMOVIDO para qwen3:8b (Q4_K_M, 5.2GB) — sem alucinação
ollama create estagiario -f /root/Modelfile-estagiario-8b
# fallback (v1 preservado):
ollama cp estagiario:latest estagiario4b:latest   # feito antes do upgrade
```

Arquivos versionados: [`Modelfile-estagiario`](./Modelfile-estagiario) (4B/fallback) e [`Modelfile-estagiario-8b`](./Modelfile-estagiario-8b) (8B/produção)

## 🚀 Uso (via proxy local)

> 🔴 **IMPORTANTE (upgrade 8B):** o endpoint mudou de `/v1/chat/completions` para `/api/chat` — o Ollama injeta "reasoning" do Qwen3 no `/v1`, deixando `content` vazio. O `/api/chat` com o template custom do Modelfile responde direto (sem thinking).

```bash
curl http://127.0.0.1:37777/api/chat \
  -H 'Content-Type: application/json' \
  -d '{"model":"estagiario","stream":false,"messages":[{"role":"user","content":"Como verifico o restic?"}],"options":{"temperature":0.4}}'
```

Proxy systemd: `ollama-proxy.service` (127.0.0.1:37777 → 10.0.0.4:11434, timeout de stream aumentado p/ 300s)

## 🧪 Testes (2026-09-17)

| Teste | Resultado | Tempo |
|-------|-----------|-------|
| FAQ "O que é MikroTik?" (v1/4B) | ✅ estilo + tabela | ~5 s |
| FAQ "Proxmox vs ESXi" (v1/4B) | 🔴 **inventou "Proxmox R$12k/mês"** | ~7 s |
| FAQ "Proxmox vs ESXi" (v2/8B) | ✅ **sem alucinação, tabela correta** | 30-60 s (cold) |
| Arquitetura complexa | ⚠️ respondeu bem, mas delegável | 40-90 s |
| Tool calling /v1 (4B) | ✅ nativo | — |
| `/api/chat` via proxy (8B) | ✅ modelo quente: ~35 s | — |

## 🔒 Limitações (conhecidas e aceitas)

1. **Latência cold-start ~30-60s** no 8B (carrega 6.3GB na iGPU) — com modelo quente cai p/ ~35s. Opcional: `keep_alive` maior no Ollama se incomodar.
2. **8B usa 6.3GB RAM do LXC** (vs 2.5GB do 4B) — LXC 104 subiu p/ 16GB para folga.
3. **Não substitui Archimedes cloud** em refatoração, planejamento multi-step, pesquisa.
4. Números/versões exatas: anti-alucinação no system prompt, mas **Archimedes confere** cifras críticas.
5. Tool calling: o `/v1` do Ollama injeta reasoning no Qwen3 — se precisar tool calling com o 8B, usar `/v1` com `think:false` **via request** (testado, mas o template custom do Modelfile já elimina o reasoning no `/api/chat`).

## 📊 Fonte de dados

- Persona: `AGENTS.md` + regras de estagiário no `Modelfile-estagiario-8b`
- Base de conhecimento local: `archimedes-rag` (LanceDB) quando precisar de contexto do cofre
- Memória persistente: `claude-mem` worker local (provider **archimedes:latest 4B**, $0 — o `/v1` não é usado pelo estagiário 8B)

## 🔗 Relacionados

- [README do fine-tune](./README.md)
- [BENCHMARKS.md](../benchmarks/BENCHMARKS.md)
- PLANO: `.planning/2026-09-17-integracao-local-primeiro-estagiario/`
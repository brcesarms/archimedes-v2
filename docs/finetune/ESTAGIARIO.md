# 🧑‍💻 Estagiário Archimedes — Camada Local de Tarefas Rotineiras

> **Objetivo:** responder FAQs, runbooks e diagnósticos simples **sem custo de cloud** — o "estagiário" do Archimedes V2.
> **Data:** 2026-09-17 · **Base:** `archimedes:latest` (fine-tune estilo) · **Derivado:** `estagiario` via Modelfile (sem novo treino)

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
# 1. System prompt de estagiário definido em Modelfile-estagiario
# 2. Derivado direto do fine-tune já validado (zero novo treino):
ollama create estagiario -f /root/finetune/Modelfile-estagiario
```

Arquivo versionado: [`Modelfile-estagiario`](./Modelfile-estagiario)

## 🚀 Uso (via proxy local)

```bash
curl http://127.0.0.1:37777/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{"model":"estagiario","messages":[{"role":"user","content":"Como verifico o restic?"}]}'
```

Proxy systemd: `ollama-proxy.service` (127.0.0.1:37777 → 10.0.0.4:11434)

## 🧪 Testes (2026-09-17)

| Teste | Resultado | Tempo |
|-------|-----------|-------|
| FAQ "O que é MikroTik?" | ✅ estilo + tabela | ~5 s |
| Arquitetura complexa | ⚠️ respondeu bem, mas delegável | 40-90 s |
| FAQ "restic saudável?" | ✅ comandos + tabela | **6,9 s** |
| Persona complexa → limite | ⚠️ tende a ajudar em vez de delegar | — |
| Tool calling /v1 | ✅ nativo (listar_modelos) | — |

## 🔒 Limitações (conhecidas e aceitas)

1. **Tende a "ajudar" em arquitetura** em vez de delegar ao cloud — aceitável, mas monitorar.
2. Modelo 4B Q4_K_M: contexto 8K (não 32K), sem memória de longo prazo nativa.
3. Não substitui Archimedes cloud em refatoração, planejamento multi-step, pesquisa.

## 📊 Fonte de dados

- Persona: `AGENTS.md` + regras de estagiário no `Modelfile-estagiario`
- Base de conhecimento local: `archimedes-rag` (LanceDB) quando precisar de contexto do cofre
- Memória persistente: `claude-mem` worker local (agora com provider **archimedes:latest**, $0)

## 🔗 Relacionados

- [README do fine-tune](./README.md)
- [BENCHMARKS.md](../benchmarks/BENCHMARKS.md)
- PLANO: `.planning/2026-09-17-integracao-local-primeiro-estagiario/`
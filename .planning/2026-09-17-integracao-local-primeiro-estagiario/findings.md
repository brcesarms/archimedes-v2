# 🔍 Findings — Integração Local-First

## Fase 1 — Auditoria de Tokens (2026-09-17)

### Inventário de consumo (bytes por arquivo de instrução)

| Fonte | Bytes | Linhas | Custo quando carrega |
|-------|------:|-------:|----------------------|
| AGENTS.md (cofre) | 3.564 | 59 | ~900 tok/sessão (sempre) |
| ~/.config/opencode/AGENTS.md | ~300 | 5 | ~80 tok/sessão (sempre) |
| planner SKILL.md | 38.148 | 506 | ~9.5k tok (sob demanda) |
| notas-atomicas SKILL.md | 2.856 | 68 | sob demanda |
| script-linux SKILL.md | 2.458 | 67 | sob demanda |
| consultar-rag SKILL.md | 1.993 | 56 | sob demanda |
| estudante.md | 3.572 | 94 | subagente |
| resumidor.md | 2.609 | 70 | subagente |
| executor.md | 1.644 | 42 | subagente |
| README.md | 8.608 | 118 | não injetado por padrão |

### Os 5 maiores vazamentos de contexto repetido

1. **❌ claude-mem worker offline + proxy 37777 morto** — quando ativo e apontando para cloud, a compressão de memória consome tokens por observação. Config atual aponta `127.0.0.1:37777` com modelo `cursor` (inválido no Ollama).
2. **⚠️ AGENTS.md + system prompt de plataforma** — fixo (~1k tok/sessão), já enxuto, sem ganho adicional sem perder qualidade.
3. **⚠️ planning-with-files SKILL.md 38KB** — pesado, mas só quando invocado; manter sob demanda.
4. **⚠️ Respostas verbosas em tarefas rotineiras** — custo de OUTPUT (mais caro que input); mitigar com estagiário local.
5. **✅ RAG já ativo** — maior economia existente (busca cirúrgica, ~95% menos contexto); manter e ampliar.

### Decisão: Roteador local vs cloud (regra simples)

| Gatilho na pergunta do Bruno | Rota | Por quê |
|-----------------------------|------|---------|
| "buscar", "onde está", "achar função" | 🔍 RAG local | archimedes-rag MCP |
| FAQ de infra, explicação curta, resumo | 🦙 Ollama local (estagiário) | 4B basta, $0 |
| Rotina/lint/backup/rotina-dia | ⚡ executor + scripts | sem LLM |
| "resuma", "transforme em notas" | 📊 subagente resumidor (cloud leve) | qualidade de síntese |
| Planejamento multi-step, refatoração, arquitetura | 🏛️ Archimedes cloud (eu) | raciocínio profundo |
| Compressão de memória (claude-mem) | 🦙 Ollama local via proxy 37777 | worker deve usar `archimedes:latest` |

### Achados técnicos claude-mem (Fase 2)

- Worker runtime = processo local ouvindo `127.0.0.1:37700` (não usa Docker)
- settings.json: `CLAUDE_MEM_PROVIDER=openrouter`, `base_url=127.0.0.1:37777/v1`, `model=cursor`
- `npx claude-mem start` sobe o worker; proxy 37777 precisa existir antes
- bun ✅, uv ✅, plugin ✅ — apenas worker/proxy estão parados
- SOCAT para proxy: `socat TCP-LISTEN:37777,fork,reuseaddr TCP:10.0.0.4:11434`
## Benchmark Qwen3-8B como candidato a Estagiário (2026-09-17)

| Modelo | Tamanho | RAM LXC | Tok/s | Alucinação | Veredicto |
|--------|:---:|:---:|:---:|:---:|:---:|
| Qwen3-4B (atual, fine-tuned) | 2.5GB | 12GB | 26.2 | 🔴 Preço: "Proxmox R$12k/mês" (inventou) | base |
| **Qwen3-8B** (novo) | 5.2GB | **9.8GB @ GPU 100%** | **14.2** | 🟢 Sem alucinação (tabela correta) | 🏆 upgrade |

- Contexto automático: 32768 (vs 8192 do estagiário atual)
- `think:false` funciona → respostas diretas, sem verbose ✅
- Cabe nos 12GB atuais, mas folga apertada (~2GB livres) → para promover: aumentar LXC p/ 16GB dá folga e permite modelos maiores
- Host Proxmox: 38GB RAM livres → aumentar LXC é trivial
- Ainda precisa de Modelfile com persona/doc do cofre p/ obter estilo (emoji, tom, tabelas) e fine-tune round 2 opcional
- Backup em nuvem (restic) roda no 4B fine-tuned hoje — 8B é só para o estagiário de FAQ

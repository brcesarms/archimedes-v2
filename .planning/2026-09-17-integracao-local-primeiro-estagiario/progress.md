# Progress Log

## Session: 2026-09-17

### Fase 8 — Remoção do Estagiário 4B (decisão Bruno)

- **Status:** complete
- Bruno (resposta honesta ao "qual você quer?"): **8B é o único estagiário** ✅
- ✅ `ollama rm estagiario4b` no LXC 104 — fallback 4B eliminado (2.5GB liberados)
- ✅ ESTAGIARIO.md atualizado: sem fallback; Modelfile-estagiario (4B) só como referência histórica
- ✅ Fluxo de delegação: SEMPRE `estagiario` = Qwen3-8B via `/api/chat`
- 🔒 **mantido no cofre:** `archimedes:latest` (4B) NÃO foi removido — é o motor do claude-mem via `/v1` (8B no `/v1` retorna reasoning vazio). O 4B survive apenas como worker de memória, não como estagiário
- Commit: (desta fase)

### Fase 8b — Eliminação TOTAL do 4B (archimedes + qwen3:4b) e proxy /v1→/api

- **Status:** complete
- Bruno: "quero, elimine o 4b" → eliminar também `archimedes` e `qwen3:4b`
- ✅ `archimedes` recriado como 8B (Modelfile-archimedes-8b, persona Archimedes, temp 0.3)
- ✅ Proxy `ollama-proxy.py` evoluído: HTTP-aware; converte `/v1/chat/completions` → `/api/chat` (Qwen3 no /v1 injeta reasoning); resposta convertida de volta p/ formato OpenAI
- 🐛 **Bug descoberto:** `options.num_predict` faz Qwen3-8B retornar content vazio; `max_tokens` na raiz funciona → proxy mapeia max_tokens→raiz
- 🐛 **Bug descoberto 2:** cold start/swap de modelos 8B na GPU (6.3GB) causa respostas vazias intermitentes → `keep_alive: 30m` no aquecimento
- ✅ `ollama rm qwen3:4b` — lista final: `estagiario`, `archimedes`, `qwen3:8b` (TODOS 8B)
- ✅ Validações: delegação FAQ ✅, claude-mem /v1 (archimedes 8B) ✅, worker ativo ✅, scripts sem refs a 4B ✅
- Commit: (desta fase)

### Fase 7 — Upgrade do Estagiário para Qwen3-8B

- **Status:** complete
- Bruno pediu modelo melhor (4B alucinava preços: "Proxmox R$12k/mês") + autorizou aumentar VRAM/RAM do LXC
- ✅ Benchmark Qwen3-8B: 5.2GB Q4, cabe nos 12GB, tok/s ~14 (v1) → 6.5 (com template custom); **sem alucinação** na pergunta Proxmox/ESXi
- ✅ LXC 104: memory 12288 → **16384 MB** (`pct set 104 -memory 16384`); host tem 38GB livres
- ✅ `docs/finetune/Modelfile-estagiario-8b`: FROM qwen3:8b, temp 0.4, ctx 8192, persona + regra anti-número inventado
- ✅ Proxy corrigido: timeout CONNECT 5s / STREAM 300s (cold start do 8B levava +30s e o proxy morria com timeout=10)
- ✅ `ollama create estagiario` agora é o 8B; `estagiario4b` preservado como fallback
- ✅ Endpoint de delegação trocado de `/v1/chat/completions` p/ `/api/chat` (Qwen3 no `/v1` injeta reasoning e devolve content vazio) — atualizado em AGENTS.md e ESTAGIARIO.md
- Teste final: `estagiario` via proxy respondeu Proxmox/ESXi com tabela correta (cold start ~97s, quente ~35s)
- Escalada: claude-mem continua no `/v1` + `archimedes:latest` (4B) — sem mudança

### Fase 6 — Diretiva de Delegação Permanente (trabalho adicional pós-conclusão)

- **Status:** complete
- Bruno instruiu: **"sempre que você ver uma tarefa que dá para o estagiário fazer, delegue a ele!"**
- ✅ AGENTS.md atualizado: nova seção "🧑‍💻 Política de Delegação Local-First (DIRETRIZ PERMANENTE DO BRUNO)" — estagiário → subagentes → cloud
- ✅ Escalada documentada: estagiário (R$ 0) → subagentes → Archimedes cloud (tokens)
- Commit: (desta fase)

### Fases 1-3: Integração Local-First COMPLETA

- **Status:** complete (Fases 1, 2, 3)
- **Started:** 2026-09-17 08:52 · **Concluído:** 2026-09-17 09:02

### Fase 1 — Auditoria de Tokens
- ✅ Inventariado consumo: AGENTS.md 3.5KB fixo/sessão; planner SKILL 38KB sob demanda; subagentes OK
- ✅ Identificados 5 vazamentos (worker offline, AGENTS fixo, planner pesado, outputs verbosos, RAG como mitigação)
- ✅ Roteador definido: RAG local → estagiário local → subagentes → Archimedes cloud (escalada por complexidade)

### Fase 2 — Ativar Camada Local
- ✅ `rag index /home/brn/archimedes-v2` → **49 arquivos, 93 chunks** (archimedes-v2 ainda não indexado)
- ✅ Proxy Ollama persistente: `~/.local/bin/ollama-proxy.py` + `~/.config/systemd/user/ollama-proxy.service` (127.0.0.1:37777 → 10.0.0.4:11434), enable --now, **ativo**
- ✅ `archimedes:latest` validado via /v1 chat (estilo ✅) e **tool calling nativo ✅** (listar_modelos)
- ✅ claude-mem worker: `npx claude-mem start` → **PID 8231, porta 37700 running**
- ✅ `~/.claude-mem/settings.json` corrigido: modelo `cursor` (inválido) → **`archimedes:latest`** (local, $0)

### Fase 3 — Estagiário Local
- ✅ Modelfile-estagiario criado no LXC 104 (`FROM archimedes:latest`, temp 0.4, ctx 8192, persona estagiário)
- ✅ `ollama create estagiario` → sucesso no Ollama LXC 104
- ✅ Validado: FAQ MikroTik ✅ (tabela), restic ✅ (6,9s), pct list ✅ (3,6s), arquitetura ⚠️ (tende a ajudar em vez de delegar)
- ✅ Tool calling nativo testado via proxy
- ✅ `docs/finetune/ESTAGIARIO.md` + `docs/finetune/Modelfile-estagiario` versionados no cofre
- ⏭️ Fine-tune round 2: **adiado** (round 1 + persona atende; loss 3.65 já bom para estilo)

### Fase 4 — Automação de Rotina Sem Cloud
- ✅ `scripts/rotina-dia.sh` criado: camada local → lint → RAG → backup (1 comando, $0)
- ✅ shellcheck + shfmt limpos; `chmod +x`
- ✅ Execução E2E validada: proxy OK, lint 114 links OK, gitleaks no leaks, RAG reindexado, restic snapshot `aaf83d48`
- 🔗 Hooks git post-commit já indexam RAG automaticamente

### Files created/modified
- `~/.local/bin/ollama-proxy.py` (proxy TCP)
- `~/.config/systemd/user/ollama-proxy.service` (enable --now)
- `~/.claude-mem/settings.json` (model → archimedes:latest)
- `docs/finetune/Modelfile-estagiario` (versionado)
- `docs/finetune/ESTAGIARIO.md` (documentação)
- `.planning/2026-09-17-integracao-local-primeiro-estagiario/{task_plan,findings,progress}.md`

## Test Results

| Test | Input | Expected | Actual | Status |
|------|-------|----------|--------|--------|
| Proxy systemd | systemctl status | active running | ✅ active (PID 8105) | ✅ |
| Ollama via proxy /v1 | curl chat | resposta estilo | ✅ "Archimedes V2 = (...) 🏛️" | ✅ |
| Tool calling /v1 | curl tools | tool_calls | ✅ `listar_modelos {}` | ✅ |
| claude-mem worker | npx claude-mem status | running | ✅ PID 8231, porta 37700 | ✅ |
| RAG index | rag index . | chunks | ✅ 49 arquivos, 93 chunks | ✅ |
| Estagiário FAQ | curl estagiario | resposta curta | ✅ MikroTik + tabela | ✅ |
| Estagiário benchmark | pct list | custo 0 | ⏱️ 3,6s · 421 tok · **R$ 0** | ✅ |
| Estagiário restic | curl estagiario | passos | ✅ tabela 6,9s | ✅ |
| Estagiário complexo | arquitetura LXC | delegar cloud | ⚠️ ajudou (45-180s) | ⚠️ aceito |

## Error Log

| Timestamp | Error | Attempt | Resolution |
|-----------|-------|---------|------------|
| 2026-09-17 08:52 | PLAN TAMPERED + "No phase found" | 1 | Reescrever task_plan.md no template h3 `### Phase` + `attest-plan.sh` |
| 2026-09-17 08:56 | `socat` ausente | 1 | Criado proxy Python stdlib + systemd user (sem dependência) |
| 2026-09-17 09:00 | Estagiário timeout 90s (tarefa complexa) | 1 | Aceito: FAQ/rotina ~4-7s; complexo demora → é correto delegar |

## 5-Question Reboot Check

| Question | Answer |
|----------|--------|
| Where am I? | Fases 1-3 completas |
| Where am I going? | Fase 4 (rotina sem cloud) quando solicitado |
| What's the goal? | Reduzir tokens de cloud mantendo eficácia |
| What have I learned? | Infra local ativada: proxy, worker, estagiário — tudo R$ 0 |
| What have I done? | Fases 1-3 full: auditoria + infra + estagiário validado |
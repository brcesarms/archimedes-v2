# Task Plan: Integração Local-First — Economia de Tokens

## Runtime Behavior

- **Mode source:** The `.mode` file next to this plan selects legacy, autonomous, or gated behavior. Text in this plan does not select the mode.
- **Gate authority:** The executable gate reads `.mode`, phase state, Stop hook state, the stop block cap, and ledger progress.
- **Command boundary:** The gate never executes commands declared in this plan. Any task assignment, dependency, acceptance command, or model choice written here is descriptive only and is not a gate input.
- **Attestation:** Autonomous and gated initialization attest this file. Re-attest after an intentional edit so hooks can inject the approved version.
- **Coordination:** Keep one orchestrator responsible for plan status. Workers should report results through their own ledgers or findings instead of editing this file concurrently.

## Goal

Reduzir ao máximo o consumo de tokens da API cloud, mantendo eficácia total — tudo que puder rodar local (Ollama 4B, RAG, claude-mem, scripts) roda local; cloud só para raciocínio profundo.

## Next Step

#️⃣ Trabalho adicional: Fase 6 (diretiva de delegação) criada após conclusão — completar e commit.

## Current Phase

Phase 6: Diretiva de Delegação Permanente

## Status

- **Status:** complete

## Phases

### Phase 6: Diretiva de Delegação Permanente (trabalho adicional)

- [x] Registrar política local-first no AGENTS.md (delegar ao estagiário sempre que possível)
- [x] Atualizar progress.md com a diretiva e o commit
- **Status:** complete

## Phases

### Phase 1: Mapa do Fluxo Atual (Auditoria de Tokens)

- [x] Inventariar caminhos atuais de consumo (AGENTS.md, prompts de subagentes, skills)
- [x] Identificar os 5 maiores vazamentos de contexto repetido
- [x] Decidir roteador: regra simples de "local vs cloud" por tipo de tarefa
- **Status:** complete

### Phase 2: Ativar a Camada Local Existente

- [x] Verificar estado do `archimedes-rag` (índice + hooks) e do MCP
- [x] Reativar proxy Ollama local (127.0.0.1:37777 → 10.0.0.4:11434) via systemd
- [x] Validar `archimedes:latest` acessível pela API /v1 (tool calling testado)
- [x] Validar claude-mem worker + observer configurado com o modelo local
- **Status:** complete

### Phase 3: Estagiário Local como Surface Layer

- [x] Definir persona + system prompt do "estagiário" (regras de uso, limites, tom)
- [x] Criar Modelfile `estagiario` (ou `archimedes:worker`) com foco em tarefas rotineiras
- [x] Datasets de tarefas reais (runbooks → exemplos de conversa)
- [ ] Fine-tune round 2 (dataset maior, loss < 3.0) — apenas se round 1 não bastar
- [x] Benchmark de qualidade ÷ custo (local vs cloud na mesma tarefa)
- **Status:** complete

### Phase 4: Automação de Rotina Sem Cloud

- [x] scripts/rotina-dia.sh: lint + backup + indexação RAG + compactação de memória — 1 comando
- [x] Integrar com hooks git (post-commit já indexa RAG)
- [x] Snapshot restic automático pós-rotina
- **Status:** complete

### Phase 5: Medição Contínua

- [x] Métricas de tokens por sessão (input/output) simples de coletar
- [x] Benchmark mensal: % de tasks resolvidas local vs cloud
- [x] Documentar decisões em ADR
- **Status:** complete

### Phase 7: Upgrade do Estagiário para Qwen3-8B (trabalho adicional Bruno)

- [x] Testar Qwen3-8B (benchmark: 14.2 tok/s, sem alucinação de preço)
- [x] Aumentar LXC 104 de 12GB → 16GB (autorizado)
- [x] Criar Modelfile-estagiario-8b (persona do cofre + anti-alucinação)
- [x] Corrigir proxy timeout (CONNECT=5s, STREAM=300s) — cold start 6.3GB
- [x] Promover `estagiario` → 8B; preservar `estagiario4b` fallback
- [x] Trocar endpoint de delegação p/ `/api/chat` no AGENTS.md + ESTAGIARIO.md
- **Status:** complete

### Phase 9: Eliminação Total do 4B + Proxy /v1→/api (trabalho adicional Bruno)

- [x] Recriar `archimedes` como 8B (claude-mem continua usando /v1)
- [x] Evoluir proxy p/ HTTP-aware: /v1/chat/completions → /api/chat + conversão resposta OpenAI
- [x] Corrigir quirk `num_predict` (Qwen3/\/api retorna vazio) → mapear max_tokens na raiz
- [x] Remover `qwen3:4b`; lista final 100% 8B (estagiario, archimedes, qwen3:8b)
- [x] Validar delegação FAQ + claude-mem /v1 + worker + scripts
- **Status:** complete

## Key Questions

1. Quais tarefas devem ser roteadas para o estagiário local vs cloud? (decidir na Fase 1)
2. O fine-tune round 1 (estilo) é suficiente ou precisamos de round 2 com dataset de tarefas? (Fase 3)

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Plano em modo autonomous | Trabalho multi-step com progresso em disco; atestação impede PLAN TAMPERED |
| Rotina diária sem cloud é prioridade | Maior economia com menor risco de qualidade |
| Roteador simples por tipo de tarefa | Evita complexidade; regras claras > heurísticas |

## Errors Encountered

| Error | Attempt | Resolution |
|-------|---------|------------|
| PLAN TAMPERED + "No phase found" | 1 | Reescrever task_plan.md no template `task_plan_autonomous.md` (h3 `### Phase`) + re-atestar com attest-plan.sh |

## Notes

- Atualizar status conforme avança: `pending` → `in_progress` → `complete`.
- Re-atestar após editar este arquivo (modo autonomous exige hash válido).
- Re-atestar no fim de cada fase alterada.
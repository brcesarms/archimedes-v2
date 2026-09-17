# Progress Log

Use this file as the chronological record of work performed, files changed, validation results, and errors.

## Session: 2026-09-17 (retomada pós PLAN TAMPERED)

### Fase 1: Construir bundle portátil `archimedes-agent` — COMPLETA ✅

- **Status:** complete
- **Started:** 13:00 · **Finished:** ~13:45
- **Recuperação PLAN TAMPERED:** re-atestado com `attest-plan.sh` (PLAN_ID=2026-09-17-agy-hermes-com-forca-opencode) — hash 13:00 divergia das edições 13:16; novo digest `6eee2987...` gravado.
- **Correções estruturais no bundle:**
  - Removidas duplicatas aninhadas: `skills/<skill>/<skill>/` (consultar-rag, notas-atomicas, script-linux, planning-with-files)
  - Subagentes movidos de `skills/` → `agents/` (formato markdown+YAML do agy): estudante.md, resumidor.md, executor.md
  - Criado `rules/AGENTS.md` (persona Archimedes enxuta, pt-BR, delegação local-first, permissões, segurança)
  - Links `../../../AGENTS.md` → `../../rules/AGENTS.md` (caminho raiz não resolve no bundle)
  - `plugin.json` (manifest agy) e `mcp_config.json` (serverUrl http://10.0.0.10:8765/mcp) já existiam — validados
- **Validação:** lychee offline 11 OK / 0 erros · gitleaks 0 leaks · shellcheck exit 0 (avisos upstream planning-with-files não alterados)
- **Commit:** `33bdcb4` no linux-toolbox-tui (41 files, +10.958) — `feat(plugins): bundle portatil archimedes-agent`
- Files created/modified: `plugins/archimedes-agent/` (skills ×4, agents ×3, rules/AGENTS.md, plugin.json, mcp_config.json)

### Fase 2: RAG remoto — transporte HTTP no archimedes-rag — COMPLETA ✅

- **Status:** complete
- **Started:** ~14:00 · **Finished:** 18:32 (retomada pós-crash do sistema — validação + commit)
- **Retomada pós-crash:** o trabalho já estava ~90% feito antes do travamento: transporte streamable-http já adicionado ao `mcp_server.py` (14:03) e systemd service criado/habilitado (14:06), mas NADA commitado nem validado.
- **Validação via curl (streamable-http, porta 8765):**
  - `initialize` → 200 OK, session id `9fae8a04...`, capabilities tools OK
  - `notifications/initialized` → OK
  - `tools/list` → 2 tools: `search_codebase_rag`, `index_codebase_rag` ✅
  - `tools/call search_codebase_rag` (project_dir=/home/brn/archimedes-v2) → retornou chunks semânticos reais ✅
  - `tools/call index_codebase_rag` (project_dir=/home/brn/projetos/archimedes-rag) → "5 arquivos e 28 chunks vetoriais" ✅
- **systemd:** `~/.config/systemd/user/archimedes-rag-mcp.service` — Type=simple, ExecStart com `--transport streamable-http --host 0.0.0.0 --port 8765 --path /mcp`, Restart=on-failure, ProtectSystem=full, PrivateTmp. `enabled` + `active (running)` desde 14:27:37.
- **Verificação de escuta:** `ss -tlnp` → `0.0.0.0:8765` (python pid 2280) ✅
- **Commit:** `58de2c8` no archimedes-rag (main, push OK) — `feat(mcp): transporte streamable-http no servidor (porta 8765, LAN)`
- **Files created/modified:** `archimedes-rag/src/mcp_server.py` (+22 -1), `~/.config/systemd/user/archimedes-rag-mcp.service` (novo)

### Fase 3: Deploy no Alienware — agy — COMPLETA ✅

- **Status:** complete
- **Started:** ~18:40 · **Finished:** ~19:00
- **Descobertas:**
  - O `agy` JÁ estava instalado no Alienware (`~/.local/bin/agy`, v1.2.5) — não estava visível via `ssh` não-login; com `bash -lc` resolve.
  - `linux-toolbox-tui` não existia → clonado via HTTPS (repo público): `~/linux-toolbox-tui/`
  - `agy plugin validate` → 4 skills ✔, 3 agents ✔, 1 mcpServers ✔
  - `agy plugin install` → `archimedes-agent` importado (skills + agents + mcpServers), habilitado no `~/.gemini/config/config.json`
  - Import NÃO registrou o MCP no config global → `agy mcp add archimedes-rag http://10.0.0.10:8765/mcp` → STATUS enabled ✅
  - Connectividade Alienware→RAG: curl initialize a `http://10.0.0.10:8765/mcp` → 200 + session id ✅
  - Artefatos estagiados: `~/.gemini/config/plugins/archimedes-agent/` (skills ×4, agents ×3, rules/AGENTS.md, plugin.json, mcp_config.json)
- **PENDÊNCIA (registrada p/ Fase 5):** agy pede autenticação em modo print — "authentication required. Run 'agy' to log in". No SSH headless precisa login interativo do Bruno OU `GEMINI_API_KEY` no env. Não é blocker estrutural.
- **Testes Fase 3 documentados abaixo.**

### Fase 4: Deploy no Alienware — Hermes Agent — COMPLETA ✅

- **Status:** complete
- **Started:** ~19:05 · **Finished:** ~19:20
- **Config aplicado** em `~/.hermes/config.yaml` (Alienware):
  - `skills.external_dirs: [~/linux-toolbox-tui/plugins/archimedes-agent/skills]` (read-only)
  - `mcp_servers.archimedes_rag.url: http://10.0.0.10:8765/mcp` (timeout 120)
  - Preservado o bloco `model` (qwen3-nothink custom) e `tools.tool_search.enabled: off`
- **Validação skills:** `hermes skills list` → consultar-rag, notas-atomicas, planning-with-files, script-linux (source=local, enabled) ✅
- **Validação MCP:** `hermes --cli -z "use o MCP archimedes_rag ..."` → conectou e chamou `search_codebase_rag`; retorno real: fonte `src/mcp_server.py` ✅
- **ACHADO IMPORTANTE (p/ runbook):** o RAG remoto indexa projetos **da workstation** (source of truth). Clientes remotos (hermes/agy) devem passar `project_dir` com paths EXISTENTES NA WORKSTATION (ex: `/home/brn/projetos/<proj>`), NÃO paths locais do Alienware. Path local do Alienware (ex: `/home/brn/linux-toolbox-tui`) não existe no host do RAG → sem resultados.
- **Files modified:** `~/.hermes/config.yaml` (Alienware)

### Fase 5: Documentação e finalização — COMPLETA ✅

- **Status:** complete
- **Started:** ~19:25 · **Finished:** ~19:40
- **Runbook criado:** `runbooks/agy-hermes-forca-opencode.md` no linux-toolbox-tui (216 linhas, + link no README).
  - Seções: Arquitetura, Pré-requisitos, Parte A (servidor RAG systemd na workstation), Parte B (clone do bundle), Parte C (agy: install/plugin/mcp add/auth), Parte D (hermes config), Validação, Regra de ouro do `project_dir`, Troubleshooting, Segurança.
- **Validação de publicação:** lychee --offline 6 OK / 0 erros · gitleaks no leaks.
- **Commit:** `869ea29` no linux-toolbox-tui (push OK) — `docs(runbooks): força do Archimedes no agy + Hermes Agent`.
- **Testes E2E:**
  - ✅ **hermes usa skill nota-atômica:** `hermes --cli -s notas-atomicas -z "crie nota atômica..." -t file --yolo` → criou `/tmp/nota-e2e.md` (1485 bytes) com título+emoji, seções e fontes — padrão da skill seguido.
  - ⚠️ **agy consulta RAG:** bloqueado por auth (`authentication required. Run 'agy' to log in`) — depende do **login interativo do Bruno** (keyring/Google Sign-In) ou `GEMINI_API_KEY`. Estrutura validada (plugin + MCP enabled).

### Encerramento

- **Todas as 5 fases concluídas.** Objetivo atingido: agy e Hermes com skills, subagentes, persona e RAG do Archimedes.
- **Pendência única (Bruno):** autenticar o `agy` no Alienware (`agy` interativo) para liberar o uso do CLI e o E2E de RAG.
- **Nota operacional:** em SSH não-interativo use `bash -lc "..."` para carregar `~/.local/bin` no PATH.
- **Nota RAG:** `project_dir` deve ser o path DA WORKSTATION (índice LanceDB single-source).

## Test Results

Record each validation command or scenario, its expected result, and the observed outcome.

| Test | Input | Expected | Actual | Status |
|------|-------|----------|--------|--------|
| lychee offline | `lychee --offline plugins/archimedes-agent` | 0 errors | 0 errors (11 OK, 7 excluded) | ✅ |
| gitleaks | `gitleaks detect --source .` | no leaks | no leaks found | ✅ |
| shellcheck | `shellcheck .../planning-with-files/scripts/*.sh` | exit 0 | exit 0 (avisos upstream) | ✅ |
| MCP initialize | `curl POST :8765/mcp` | 200 + session id | 200 OK, session `9fae8a04...`, tools caps | ✅ |
| MCP tools/list | curl após initialized | 2 tools | search_codebase_rag + index_codebase_rag | ✅ |
| MCP search | tools/call search (archimedes-v2, top_k 2) | chunks semânticos | Retornou fontes reais (servidor-arquivos-proxmox, matriz-de-substituicao) | ✅ |
| MCP index | tools/call index (archimedes-rag) | reindexação OK | "5 arquivos e 28 chunks vetoriais" | ✅ |
| systemd | `systemctl --user status archimedes-rag-mcp` | active | active (running) desde 14:27:37, bind 0.0.0.0:8765 | ✅ |
| porta | `ss -tlnp \| grep 8765` | LISTEN | LISTEN 0.0.0.0:8765 | ✅ |
| SSH Alienware | `ssh alienware 'bash -lc "agy --version"'` | v1.2.5 | v1.2.5 (mesma da workstation) | ✅ |
| clone repo | `git clone linux-toolbox-tui` no Alienware | `~/linux-toolbox-tui` | clonado, plugin presente | ✅ |
| plugin validate | `agy plugin validate ~/linux-toolbox-tui/plugins/archimedes-agent` | OK | 4 skills ✔ 3 agents ✔ 1 mcpServers ✔ | ✅ |
| plugin install | `agy plugin install ...` | imported | archimedes-agent importado + enabled | ✅ |
| mcp add | `agy mcp add archimedes-rag http://10.0.0.10:8765/mcp` | enabled | STATUS enabled | ✅ |
| RAG remoto (Alienware) | curl initialize a 10.0.0.10:8765 | 200 + session | 200 OK, session id | ✅ |
| agy print | `agy --print "lista as skills"` | responde | erro de auth (esperado em SSH headless; p/ Bruno logar ou GEMINI_API_KEY) | ⚠️ |
| hermes skills | `hermes skills list` | 4 skills Archimedes | consultar-rag/notas-atomicas/planning-with-files/script-linux (local, enabled) | ✅ |
| hermes MCP | `hermes --cli -z "use MCP archimedes_rag"` | tool call + resultado | conectou, chamou search_codebase_rag, fonte `src/mcp_server.py` | ✅ |
| E2E hermes skill | `hermes --cli -s notas-atomicas -z "crie nota..."` | nota criada no padrão | `/tmp/nota-e2e.md` (1485 B, título+emoji, seções, fontes) | ✅ |
| E2E agy RAG | `agy --print "consulte o RAG"` | resposta com fonte | bloqueado: `authentication required` (login interativo pendente) | ⚠️ |
| lychee runbook | `lychee --offline runbooks/agy-hermes-forca-opencode.md README.md` | 0 erros | 6 OK, 0 erros, 1 excluded | ✅ |
| gitleaks runbook | `gitleaks detect --source .` | no leaks | no leaks found | ✅ |

## Error Log

Record errors promptly, including the attempt number and resolution. Change the approach before retrying a failed action.

| Timestamp | Error | Attempt | Resolution |
|-----------|-------|---------|------------|
| 13:00→13:16 | PLAN TAMPERED: task_plan/findings editados pós-atestacão | 1 | `attest-plan.sh` com PLAN_ID explícito — re-gravou hash `6eee2987` |

## 5-Question Reboot Check

Use this table when resuming to confirm the current phase, destination, goal, findings, and completed work.

| Question | Answer |
|----------|--------|
| Where am I? | Concluído — todas as 5 fases completas |
| Where am I going? | Pendência única: login interativo do `agy` no Alienware (Bruno) |
| What's the goal? | MESMA força do opencode no agy + Hermes (skills, subagentes, persona, RAG) — ATINGIDO |
| What have I learned? | See findings.md (agy plugins/skills, hermes external_dirs, RAG streamable-http) |
| What have I done? | Fases 1-5: bundle `33bdcb4` · RAG `58de2c8` · reveal agy+hermes no Alienware · runbook `869ea29` |

---

*Update this file after completing a phase, running validation, or encountering an error.*

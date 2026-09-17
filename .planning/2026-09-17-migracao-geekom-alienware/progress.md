# Progress Log — Migração GEEKOM (10.0.0.10) → Alienware (10.0.0.208)

## Session: 2026-09-17

### Phase 1: Sincronizar cofre archimedes-v2 no Alienware

- **Status:** complete
- Actions taken:
  - Backup de `docker/docker-compose.yml`, `docker/archimedes/Dockerfile` e `docker/.env` em `/tmp/migracao-backup/`.
  - Confirmado Dockerfile idêntico ao do repo (md5 `1c31af1b…`); descartadas edições locais do compose e do Dockerfile untracked.
  - `git fetch` (HTTPS OK) → `git pull --ff-only` `77bb85d..84b12bd`.
- Files modified: `~/archimedes-v2` (Alienware) → HEAD `84b12bd`, working tree limpo, `docker/.env` preservado.

### Phase 2: Migrar archimedes-rag + systemd na 8765

- **Status:** complete
- Actions taken:
  - `rsync` do repo (excl. `.venv`/`__pycache__`); instalado `python3.12-venv` via sudo NOPASSWD; venv recriado; `pip install -r requirements.txt` (mcp 2.2.0, lancedb 0.38.0, fastembed 0.8.0).
  - Índice LanceDB migrado: `~/.cache/opencode_rag` (23M, 8 projetos).
  - systemd service copiado da VM (`~/.config/systemd/user/archimedes-rag-mcp.service`), `enable --now`.
- Files created/modified: `~/projetos/archimedes-rag/.venv`, `~/.config/systemd/user/archimedes-rag-mcp.service`, `~/.cache/opencode_rag/`.

### Phase 3: Migrar projetos e dados

- **Status:** complete
- Actions taken:
  - `rsync ~/projetos` (1.229 arquivos; exc. build artifacts) → Alienware. `~/projetos` = 614M (inclui o `.venv` novo do RAG).
  - `rsync` de `~/archimedes-vault` (conteúdo integral; `.venv` de 54M excluído), `~/wikisidian`, `~/backups`, `~/Documentos`, `~/Imagens`.
- Files modified: árvores acima no Alienware.

### Phase 4: Migrar configs de agente

- **Status:** complete
- Actions taken:
  - `rsync ~/.agents` (rules + skills).
  - `~/.gemini`: copiado **somente** `GEMINI.md` (configs da VM com paths linuxbrew/bun/claude-mem não são portáveis).

### Phase 5: Reapontar clientes para o RAG local

- **Status:** complete
- Actions taken:
  - hermes: `mcp_servers.archimedes_rag.url` → `http://127.0.0.1:8765/mcp`; `skills.external_dirs` → `~/projetos/linux-toolbox-tui/plugins/archimedes-agent/skills`.
  - agy: `agy mcp add archimedes-rag http://127.0.0.1:8765/mcp` (enabled).
  - `mcp_config.json` do bundle `archimedes-agent` portabilizado para `127.0.0.1` (repo + plugin instalado).
  - opencode (container): `extra_hosts: host-gateway` + `docker/archimedes/opencode.json` versionado montado read-only; container recriado.
  - Consolidação: clone antigo `~/linux-toolbox-tui` removido; canônico = `~/projetos/linux-toolbox-tui` (remote → HTTPS).
- Commits: `archimedes-v2 d11acc8`; `linux-toolbox-tui ac73802`.

### Phase 6: Validação, documentação e commit

- **Status:** complete
- Actions taken:
  - Smoke test RAG: `initialize` OK, `tools/list` OK (com session id), `search_codebase_rag` retornou trechos do índice migrado.
  - Container opencode alcança o host: HTTP 200 em `host.docker.internal:8765/mcp`.
  - hermes: 4 skills do Archimedes `enabled`.
  - Runbook publicado: `runbooks/migracao-geekom-alienware.md` + link no README (`linux-toolbox-tui 2060994`).
  - `gitleaks detect`: no leaks; `lychee --offline`: 0 erros.

### Phase 7 (pós-fechamento): Auditoria exaustiva do HOME — "nada ficou para trás"

- **Status:** complete
- Motivação: o 1º relatório era escopo-do-plano e deixou itens do HOME fora; Bruno cobrou auditoria real (*"não acredito que vc estava deixando tudo isso para trás"*).
- **Audit #1 (dados):** comparação VM 1837 × AW 1820 arquivos → 18 ausentes: `docker/.env.example` (bug do `.gitignore`), 12× `.pytest_cache/*` (irrelevante), runbook (AW atrás), `.ssh/*.bak` (backups locais).
- **Audit #2 (`.config/.gemini/.local/bin`):** 2737 ausentes → **2725 = estado interno do `agy-cli`** (não portável, análogo ao `~/.opencode`); **12 reais**.
- Ações tomadas (gaps reais):
  - Migrados: `~/.config/btop/btop.conf`, `~/.config/enchant/pt_BR.{dic,exc}`.
  - Migrados do agente `agy`: `~/.gemini/config/hooks.json` (claude-mem via `bun`, paths idênticos) e `~/.gemini/antigravity/mcp_config.json` — adaptado: `claude-mem` de node/linuxbrew → `/home/brn/.bun/bin/bun`.
  - **Estagiário restaurado no AW:** `~/.local/bin/ollama-proxy.py` + `~/.config/systemd/user/ollama-proxy.service` (37777 → `10.0.0.4:11434`), `enable --now` → **active** e `/api/tags` HTTP OK.
  - Correção de infra: `.gitignore` `!.env.example` (linha 35) + `git add docker/.env.example`.
  - Sincronização: `archimedes-v2 d11acc8→325873d`; `linux-toolbox-tui ac73802→2060994` (runbook presente).
- **Skipped (intencional, documentado):** `.gemini/antigravity-cli/**` (estado/binário local), `~/.config/monitors.xml` (hardware-específico da VM), `~/.config/ibus/bus/*` (sockets runtime), `~/.local/bin/gh` (já instalado via apt), `*.old`/`*.bak`.
- Commits: `archimedes-v2 325873d`.

## Test Results

| Test | Input | Expected | Actual | Status |
|------|-------|----------|--------|--------|
| systemd RAG | `systemctl --user is-active archimedes-rag-mcp` | active | active; listen 0.0.0.0:8765 | ✅ |
| MCP initialize | curl POST `/mcp` | serverInfo archimedes-rag | OK | ✅ |
| MCP tools/list | curl + `mcp-session-id` | 2 tools (search/index) | OK | ✅ |
| Busca RAG | `search_codebase_rag` `project_dir=~/projetos/linux-toolbox-tui` | trechos reais | trechos retornados | ✅ |
| hermes skills | `hermes skills list` | 4 enabled | 4 enabled (local) | ✅ |
| container→host | curl dentro do container | HTTP 200 | HTTP 200 | ✅ |
| gitleaks | `detect --source .` | no leaks | no leaks | ✅ |
| lychee | `--offline .` | 0 errors | 0 errors (21 OK) | ✅ |
| estagiário AW | `systemctl --user is-active ollama-proxy` + curl 37777 | active + HTTP OK | active + `/api/tags` OK | ✅ |
| agy mcp_config | `python3 -m json.tool` + deps | JSON válido + deps presentes | válido; venv/mcp-server/claude-mem OK | ✅ |
| agy hooks | bun em `/home/brn/.bun/bin/bun` | executável | `bun 1.4.2` OK | ✅ |
| paridade dados | `comm -23` VM vs AW (fora agy-cli) | 0 gaps reais | 12 → todos resolvidos/skipped | ✅ |

## Error Log

| Timestamp | Error | Attempt | Resolution |
|-----------|-------|---------|------------|
| Phase 2 | `ensurepip is not available` (venv) | 1 | `sudo -n apt-get install -y python3.12-venv` |
| Phase 5 | SyntaxError no `python3 -c` via ssh | 1 | trocar para heredoc `ssh alienware bash -s` |
| Phase 5 | `Missing session ID` no MCP | 1 | capturar header `mcp-session-id` do `initialize` |
| Phase 5 | `git pull` abortado (mcp_config local) | 1 | `git checkout --` do arquivo (idêntico ao commit) |
| Phase 7 | `ssh alienware bash -lc '<multi>'` → "erro de sintaxe" | 1 | usar sempre heredoc `ssh alienware bash -s <<'REMOTE'` |
| Phase 7 | `.gitignore` linha 34 `.env.*` ignorava `docker/.env.example` | 1 | adicionar `!.env.example` |

## 5-Question Reboot Check

| Question | Answer |
|----------|--------|
| Where am I? | Phase 7 — complete (auditoria exaustiva do HOME fechada) |
| Where am I going? | Concluído; pendência externa única: login interativo do `agy` (keyring/Google) |
| What's the goal? | Consolidar todo o Archimedes V2 no Alienware, sem deixar nada para trás |
| What have I learned? | Ver findings.md |
| What have I done? | Migração completa + runbook + commits/push |

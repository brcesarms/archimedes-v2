# Findings — Força do OpenCode no agy + Hermes

## Pesquisa (17/09/2026)

### Google Antigravity CLI (`agy`) — extensibilidade

- **Plugins** (bundle): estagiado em `~/.gemini/antigravity-cli/plugins/<nome>/` com estrutura:
  - `plugin.json` (obrigatório — marker), `mcp_config.json`, `hooks.json`, `skills/`, `agents/`, `rules/`
  - Gerenciar: `agy plugin list` / `agy plugin install <path>` / disable/enable
- **Skills**:
  - Workspace: `.agents/skills/<nome>/SKILL.md` (mesmo formato do opencode!) → vira slash command
  - Global: `~/.gemini/antigravity-cli/skills/` (auto-importadas em qualquer diretório)
  - Frontmatter: `name` (opcional), `description` (obrigatório, 3ª pessoa)
- **Subagentes custom (markdown + YAML)**:
  - Workspace: `.agents/agents/<nome>.md` ou `.agents/agents/<nome>/agent.md`
  - Global: `~/.gemini/config/agents/<nome>.md` ou `.../agents/<nome>/agent.md`
  - Plugin: `plugins/<plugin_name>/agents/`
  - Frontmatter: `name` (req), `description` (req), `tools[]`, `mainAgent`, `subagent`, `model`, `commandExecutionPolicy` (off/auto/eager/sandbox), `mcpServers[]`, `skills/plugins[]`
  - Corpo markdown = system prompt
- **MCP**:
  - Global: `~/.gemini/config/mcp_config.json` · Workspace: `.agents/mcp_config.json`
  - Formato: `{"mcpServers": { nome: {command, args, env} ou {serverUrl, headers} }}`
  - CLI: `agy mcp add` / `list` / `enable` / `disable` / `remove` (editam o mcp_config.json global)
  - Permissão MCP: padrão Ask; política `mcp(server/*)` etc.
- **AGENTS.md** é lido como Rules no workspace (também GEMINI.md legado)

### Hermes Agent (Nous Research)

- **Skills**: `~/.hermes/skills/<categoria>/<nome>/SKILL.md` (padrão agentskills.io).
  - `skills.external_dirs: [~/.agents/skills, ...]` no `~/.hermes/config.yaml` — varre diretórios externos
  - **Projeto-local**: `<project>/.hermes/skills/` E `<project>/.agents/skills/` (mesma convenção!) — precisa `hermes skills trust`
  - Precedência: project → local → external_dirs
- **MCP**: `mcp_servers:` no config.yaml — stdio (`command`/`args`) ou remoto (`url:` http/streamable). Tools viram `mcp__<server>__<tool>`
- **AGENTS.md**: lido como contexto no workspace (mencionado como "sempre carregado por turno" junto com tool schemas)
- **Config atual do Alienware** (`~/.hermes/config.yaml`): só model qwen3-nothink custom Ollama + tool_search off — mínimo, fácil de estender

### archimedes-rag (MCP)

- `src/mcp_server.py`: `MCPServer("archimedes-rag")` com tools `search_codebase_rag` e `index_codebase_rag`
- Hoje: `server.run(transport="stdio")` SOMENTE — precisa transporte HTTP para acesso remoto
- Config opencode: `/home/brn/projetos/archimedes-rag/.venv/bin/python src/mcp_server.py`
- CLI: `archimedes-rag` (index/run/info/install-hooks/list-projects/clean)
- LanceDB local do projeto → auto-indexa JIT se não existir

### Inventário Alienware (via SSH 10.0.0.208)

- **Não tem** linux-toolbox-tui, não tem archimedes, não tem ~/projetos
- **Tem**: ~/.hermes (config mínima), docker, linuxbrew, cua-driver
- Ubuntu 24.04.5 x86_64 · `~/linux-toolbox-tui` ausente (vamos clonar)

### Decisões de arquitetura

1. **Bundle único portátil** `plugins/archimedes-agent/` no linux-toolbox-tui (repo público = veículo de deploy já usado nos outros runbooks)
2. **Skills do opencode portam quase íntegras** (padrão agentskills.io comum aos 3)
3. **RAG remoto via streamable-http** no workstation 10.0.0.10:8765 → agy (`serverUrl`) e hermes (`url:`) apontam pra lá (single source of truth do índice)
4. **Persona**: rules/AGENTS.md pro agy; Hermes via external_dirs de skills + (opcional) context/personality
5. **Subagentes**: formato markdown+YAML do agy (estudante/resumidor/executor); para hermes, o equivalente = skills de persona (o hermes tem `delegate_task` nativo, sem formato de subagentes custom em .md)
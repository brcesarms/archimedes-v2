# Task Plan: Força do OpenCode no agy + Hermes Agent (Alienware)

## Goal

Dar ao Google Antigravity CLI (`agy`) **e** ao Hermes Agent (estagiário do Alienware) a MESMA força que o opencode tem no Archimedes: skills (notas-atomicas, script-linux, consultar-rag, planning-with-files), subagentes (estudante, resumidor, executor), persona/regras do Archimedes e acesso ao RAG semântico (archimedes-rag MCP).

## Descoberta-Chave (Design)

opencode, agy (Antigravity) e hermes (Nous) compartilham o **mesmo padrão de skills**: `.agents/skills/<nome>/SKILL.md` com frontmatter YAML (`name`, `description`) — open standard agentskills.io. As skills do Archimedes são portáveis quase como-estão.

**Arquitetura:** bundle portátil `plugins/archimedes-agent/` no repo público `linux-toolbox-tui` (veículo oficial de deploy), instalado no Alienware via `agy plugin install` + config externa no Hermes.

## Runtime Behavior

- **Mode source:** o arquivo `.mode` junto ao plano seleciona o comportamento. Texto neste plano não seleciona modo.
- **Gate authority:** o gate executável lê `.mode`, estado das fases, estado do Stop hook, cap de stop blocks e progresso do ledger.
- **Command boundary:** o gate nunca executa comandos declarados neste plano. Atribuições de tarefa, dependências, comandos de aceitação ou escolhas de modelo aqui são descritivas e não são entrada do gate.
- **Attestation:** modos autonomous e gated atestam este arquivo. Re-ateste após edição intencional.

## Next Step

Todas as fases concluídas. Pendência única: login interativo do `agy` no Alienware (Bruno) para habilitar o E2E de consulta ao RAG.

## Current Phase

Phase 5: Documentação e finalização (complete)

## Phases

### Phase 1: Construir bundle portátil `archimedes-agent` (linux-toolbox-tui)

- [x] Criar `plugins/archimedes-agent/` com plugin.json (manifest agy)
- [x] Portar skills: notas-atomicas, script-linux, consultar-rag, planning-with-files (formato agentskills.io)
- [x] Criar subagentes agy (markdown+YAML): estudante.md, resumidor.md, executor.md
- [x] Criar rules/AGENTS.md (persona Archimedes enxuta) + mcp_config.json (servidor RAG)
- [x] Commit + push no linux-toolbox-tui (`33bdcb4`)
- **Status:** complete

### Phase 2: RAG remoto — transporte HTTP no archimedes-rag

- [x] Adicionar transporte streamable-http ao `mcp_server.py` (porta 8765, host LAN)
- [x] Subir systemd user service do MCP RAG no workstation (10.0.0.10)
- [x] Validar ferramentas search/index via HTTP (MCP inspector ou curl)
- **Status:** complete

### Phase 3: Deploy no Alienware — agy

- [x] Clonar linux-toolbox-tui no Alienware
- [x] `agy plugin install ~/linux-toolbox-tui/plugins/archimedes-agent`
- [x] Validar: /skills (4 skills), /agents (estudante/resumidor/executor), /mcp (archimedes-rag conectado)
- **Status:** complete

### Phase 4: Deploy no Alienware — Hermes Agent

- [x] Configurar `skills.external_dirs` no `~/.hermes/config.yaml` (apontando pro bundle)
- [x] Configurar `mcp_servers.archimedes_rag` (url http://10.0.0.10:8765/mcp)
- [x] Validar: hermes lista as skills e chama MCP RAG
- **Status:** complete

### Phase 5: Documentação e finalização

- [x] Runbook `agy-hermes-forca-opencode.md` no linux-toolbox-tui + link README
- [x] Testes E2E: agy consulta RAG; hermes usa skill nota-atômica
- [x] Log completo em progress.md
- **Status:** complete
- **Nota:** E2E do hermes OK (usou skill `notas-atomicas`). E2E do agy fica **pendente do login interativo do Bruno** (`agy` → keyring/Google Sign-In) — em SSH headless retorna `authentication required`.
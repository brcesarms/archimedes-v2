# Task Plan: Migração GEEKOM (10.0.0.10) → Alienware (10.0.0.208)

## Goal

Consolidar **tudo** o que vive no `10.0.0.10` (VM no Proxmox GEEKOM) dentro do **Alienware** — cofre `archimedes-v2`, RAG (`archimedes-rag` + índice), projetos, vault, wikisidian, backups e configs de agente — deixando o Alienware como máquina única do Archimedes V2.

## Runtime Behavior

- **Mode source:** o arquivo `.mode` junto ao plano seleciona o comportamento. Texto neste plano não seleciona modo.
- **Gate authority:** o gate executável lê `.mode`, estado das fases, estado do Stop hook, cap de stop blocks e progresso do ledger.
- **Command boundary:** o gate nunca executa comandos declarados neste plano.
- **Attestation:** modos autonomous e gated atestam este arquivo.

## Next Step

Fase 1: sincronizar o cofre `archimedes-v2` no Alienware (git pull preservando o build docker local).

## Current Phase

Phase 1: Sincronizar cofre archimedes-v2 no Alienware

## Phases

### Phase 1: Sincronizar cofre archimedes-v2 no Alienware

- [ ] Salvar/discardar edições locais do docker no Alienware (idênticas ao repo)
- [ ] `git pull --ff-only` até o HEAD de origem
- [ ] Confirmar `docker compose` ainda válido
- **Status:** in_progress

### Phase 2: Migrar archimedes-rag + systemd na 8765

- [ ] rsync do repo `archimedes-rag` (sem .venv/__pycache__)
- [ ] Recriar `.venv` + instalar `requirements.txt` no Alienware
- [ ] Instalar systemd user service `archimedes-rag-mcp` (path idêntico)
- [ ] Validar curl initialize/tools a `127.0.0.1:8765`
- **Status:** pending

### Phase 3: Migrar projetos e dados

- [ ] rsync `~/projetos` (excl. node_modules/.venv/__pycache__)
- [ ] rsync `~/archimedes-vault`, `~/wikisidian`, `~/backups`
- [ ] rsync `~/Documentos`, `~/Imagens`
- [ ] Conferir tamanhos/integridade
- **Status:** pending

### Phase 4: Migrar configs de agente

- [ ] rsync `~/.agents` (rules + skills)
- [ ] `~/.gemini`: copiar seletivamente (GEMINI.md, settings de permissões) sem auth
- **Status:** pending

### Phase 5: Reapontar clientes para o RAG local

- [ ] hermes: `mcp_servers.archimedes_rag.url` → `http://127.0.0.1:8765/mcp`
- [ ] agy: `agy mcp add archimedes-rag http://127.0.0.1:8765/mcp`
- [ ] hermes: `skills.external_dirs` → path consolidado
- [ ] opencode (container): configurar MCP apontando ao host
- **Status:** pending

### Phase 6: Validação, documentação e commit

- [ ] Smoke test RAG (search/index) no Alienware
- [ ] Atualizar runbook + README
- [ ] Commit/push e log final
- **Status:** pending

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Escopo = TUDO (cofre+projetos+dados) | Resposta do Bruno (17/09) |
| RAG systemd nativo na 8765 | Resposta do Bruno (mesmo endpoint do workstation) |
| 10.0.0.10 mantido intacto | Resposta do Bruno (só migrar) |
| Não copiar `.venv`/`node_modules` | Específicos da máquina; recriar no destino |

## Notes

- Origem: `10.0.0.10` (VM Proxmox GEEKOM). Destino: Alienware `10.0.0.208`.
- Paths preservados (`/home/brn/...`) → services e configs reaproveitáveis.
- Alienware: 41G livres; payload ~1 GB.

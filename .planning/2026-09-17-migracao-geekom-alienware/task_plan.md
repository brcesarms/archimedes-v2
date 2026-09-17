# Task Plan: Migração GEEKOM (10.0.0.10) → Alienware (10.0.0.208)

## Goal

Consolidar **tudo** o que vive no `10.0.0.10` (VM no Proxmox GEEKOM) dentro do **Alienware** — cofre `archimedes`, RAG (`archimedes-rag` + índice), projetos, vault, wikisidian, backups e configs de agente — deixando o Alienware como máquina única do Archimedes.

## Runtime Behavior

- **Mode source:** o arquivo `.mode` junto ao plano seleciona o comportamento. Texto neste plano não seleciona modo.
- **Gate authority:** o gate executável lê `.mode`, estado das fases, estado do Stop hook, cap de stop blocks e progresso do ledger.
- **Command boundary:** o gate nunca executa comandos declarados neste plano.
- **Attestation:** modos autonomous e gated atestam este arquivo.

## Next Step

Concluído. Pendência externa (não bloqueante): login interativo do `agy` no Alienware.

## Current Phase

Concluído — 6/6 fases

## Phases

### Phase 1: Sincronizar cofre archimedes no Alienware

- [x] Salvar/discardar edições locais do docker no Alienware (idênticas ao repo)
- [x] `git pull --ff-only` até o HEAD de origem
- [x] Confirmar `docker compose` ainda válido
- **Status:** complete

### Phase 2: Migrar archimedes-rag + systemd na 8765

- [x] rsync do repo `archimedes-rag` (sem .venv/__pycache__)
- [x] Recriar `.venv` + instalar `requirements.txt` no Alienware (mcp 2.2.0, lancedb 0.38.0)
- [x] Instalar systemd user service `archimedes-rag-mcp` (path idêntico)
- [x] Validar curl initialize/tools a `127.0.0.1:8765` + índice (23M) migrado
- **Status:** complete

### Phase 3: Migrar projetos e dados

- [x] rsync `~/projetos` (excl. node_modules/.venv/__pycache__)
- [x] rsync `~/archimedes-vault`, `~/wikisidian`, `~/backups`
- [x] rsync `~/Documentos`, `~/Imagens`
- [x] Conferir tamanhos/integridade (só build artifacts excluídos)
- **Status:** complete

### Phase 4: Migrar configs de agente

- [x] rsync `~/.agents` (rules + skills)
- [x] `~/.gemini`: copiado só `GEMINI.md` (configs com path da VM não são portáveis)
- **Status:** complete

### Phase 5: Reapontar clientes para o RAG local

- [x] hermes: `mcp_servers.archimedes_rag.url` → `http://127.0.0.1:8765/mcp`
- [x] agy: `agy mcp add archimedes-rag http://127.0.0.1:8765/mcp`
- [x] hermes: `skills.external_dirs` → `~/projetos/linux-toolbox-tui/...`
- [x] opencode (container): `host-gateway` + `opencode.json` versionado (HTTP 200)
- **Status:** complete

### Phase 6: Validação, documentação e commit

- [x] Smoke test RAG (search/index) no Alienware
- [x] Publicar runbook de migração + README
- [x] Commit/push e fechar plano
- **Status:** complete

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

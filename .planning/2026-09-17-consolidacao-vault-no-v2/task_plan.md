# Task Plan: Consolidação `archimedes-vault` → `archimedes-v2` (repo único)

## Goal

Mover **todo** o conteúdo único do repositório `archimedes-vault` para `archimedes-v2` (seguindo a estrutura do V2), corrigir todas as referências de runtime, eliminar as duplicatas e **remover o vault** — deixando o Alienware (e a VM) com **um único repositório Archimedes**, sem perda de informação.

## Next Step

Phase 7 — commit final + push, `git pull` no Alienware e arquivar o repo remoto `archimedes-vault` (`gh repo archive`).

## Current Phase

Phase 7

## Phases

### Phase 1: Backup & Higiene (pré-requisito de segurança)

- [x] Commitar as 4 skills modificadas + `.lychee.toml` / `.resticignore` / `restic-vault.sh` (untracked) no vault
- [x] `git push` do vault (garantir remoto íntegro = backup do histórico)
- [x] Gerar `~/backups/archimedes-vault-<data>.tar.gz` (com `.git`, sem node_modules/.venv)
- [x] Confirmar `archimedes-v2` limpo e sincronizado com origin
- **Status:** complete

### Phase 2: Migração estrutural (conteúdo único → estrutura do V2)

- [x] `guia-ia-local/cerebrum/` (menos `rotinas/` e `logs/`) → `docs/cerebrum/`
- [x] `guia-ia-local/notas/` → `docs/notas/`
- [x] `guia-ia-local/instintos/` → `docs/instintos/`
- [x] `guia-ia-local/scripts/{linux,python,windows}` → `scripts/{linux,python,windows}/`
- [x] `guia-ia-local/dotfiles/` → `dotfiles/` (convenção `dot_*`)
- [x] `guia-ia-local/*.md` (ME, MY-SETUP, DEPENDENCIAS, IA-RESTORE, README-manual, README) → `docs/guia-ia-local/`
- [x] `.opencode/skills/*` (18 não duplicadas) → `.agents/skills/`
- [x] `.opencode/convencoes/*` (13) → `docs/convencoes/`
- [x] `bootstrap.sh` + `install.sh` → `scripts/`
- [x] **Skip (duplicatas; V2 vence):** `cerebrum/rotinas/*` (8), `benchmarks/*`, `perfis/*`, `docker/*`, `.opencode/agents/*`, `.opencode/commands/*`, `AGENTS.md`, `README.md`, `opencode.json`, `.editorconfig`, `.gitignore`, `.lychee.toml`, `.resticignore`, `cerebrum/logs/*`
- **Status:** complete

### Phase 3: Correção de paths internos

- [x] `docs/cerebrum/systemd/*.service` → `%h/archimedes-vault/guia-ia-local/` ⇒ `%h/archimedes-v2/`
- [x] `dotfiles/dot_bashrc` → `COFRE_DIR=$HOME/archimedes-v2`, skills em `.agents/skills`
- [x] `dotfiles/dot_aliases` → fundir aliases úteis do vault (`bancada`, `ollama-*`, `oc`, docker) com V2 vence nos conflitos
- [x] Atualizar referências `archimedes-vault` dentro de skills/docs migrados
- **Status:** complete

### Phase 4: Runtime do sistema (VM + Alienware)

- [x] `~/.bashrc`: source de `~/archimedes-v2/dotfiles/dot_bashrc`
- [x] `~/.bash_aliases`: `cofre`/`cofre-status`/`git-cofre` ⇒ `archimedes-v2`
- [x] Repetir na VM **e** no AW (paths idênticos)
- **Status:** complete

### Phase 5: Documentação do V2

- [x] Atualizar `README.md` e `AGENTS.md` do V2 (nova árvore + link do vault arquivado)
- [x] Atualizar docs que citam `~/archimedes-vault/`
- **Status:** complete

### Phase 6: Validação

- [x] `shellcheck -S warning` nos scripts movidos
- [x] `lychee --offline .` (0 erros)
- [x] `gitleaks detect` (no leaks)
- [x] Reindexar RAG (`archimedes-v2`) e remover índice do vault
- [x] Smoke test: funções/aliases `cofre`/`cofre-status` funcionam (shell interativo)
- **Status:** complete

### Phase 7: Commit, push e propagação

- [ ] Commit no V2 + push → `git pull` no Alienware
- [ ] Arquivar repo remoto `archimedes-vault` no GitHub (`gh repo archive`)
- **Status:** pending

### Phase 8: Remoção do vault

- [ ] `rm -rf ~/archimedes-vault` na VM e no AW (após confirmação de paridade)
- [ ] Verificação final: home com apenas `archimedes-v2`
- **Status:** pending

## Key Questions

1. Onde alocar o conteúdo do vault no V2? → **Resposta:** `docs/` (conhecimento), `scripts/` (código), `dotfiles/` (shell), `.agents/` (skills/agentes) — segue a estrutura já existente do V2.
2. Quem vence nas duplicatas divergentes? → **Resposta:** o V2 (sucessor; o próprio V2 já marca os runbooks do vault como "LEGADO V1").
3. Remover o repo remoto do vault? → **Resposta:** **arquivar** (reversível), não deletar — é o backup do histórico de 47 commits.

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| V2 vence em todo arquivo duplicado | É o sucessor ativo; os runbooks do vault já estão marcados "LEGADO V1" no V2 |
| Mapear para `docs/`, `scripts/`, `dotfiles/`, `.agents/` | Segue a estrutura já consolidada do V2; evita criar árvore paralela |
| Arquivar (não deletar) o repo remoto do vault | Preserva 47 commits de histórico sem risco irreversível |
| Manter `.agents/` versionado no V2 | O `.gitignore` do vault ignorava `.agents/`, mas o V2 o trata como conteúdo |
| Tarball + commit/push antes de remover | O vault é fonte única de conteúdo; zero tolerância a perda |

## Errors Encountered

| Error | Attempt | Resolution |
|-------|---------|------------|
| `join` por caminho completo retornou 0 pares | 1 | Comparar por **basename** (`awk sub`) em vez de caminho |
| `find scripts` incluiu `.venv` (55M) | 1 | Usar `git ls-files` para o conjunto versionado |

## Notes

- Backup obrigatório antes de qualquer `rm`.
- O vault **não** possui `.obsidian/` (é Obsidian-compatible, mas sem config versionada).
- `~/wikisidian/` **não** faz parte desta consolidação (estudos pessoais, fora dos repos).
- Runtime que referencia o vault: `~/.bashrc` (source), `~/.bash_aliases` (aliases), 8 runbooks do V2, skills do próprio vault.

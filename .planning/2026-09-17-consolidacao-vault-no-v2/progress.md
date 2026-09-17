# Progress Log

## Session: 2026-09-17 — Consolidação vault → v2

### Phase 1: Backup & Higiene

- **Status:** complete
- **Started:** 2026-09-17
- Actions taken:
  - Commitadas as pendências do vault (4 skills modificadas + `.lychee.toml` / `.resticignore` / `restic-vault.sh` untracked) → commit `86c1e05` + push (histórico remoto íntegro = backup).
  - Gerado tarball de segurança `~/backups/archimedes-vault-2026-09-17.tar.gz` (1,1 MB, 101 `.md`, com `.git`, sem node_modules/.venv).
  - Confirmado `archimedes-v2` limpo e sincronizado com origin em `57c643d`.
- Files created/modified:
  - `~/backups/archimedes-vault-2026-09-17.tar.gz`

### Phase 2: Migração estrutural

- **Status:** complete
- Actions taken:
  - Inventário versionado do vault re-enumerado (checagem `awk -F/ 'NF==2'` confirmou os 7 arquivos raiz de `guia-ia-local/` **versionados** e zero `UNTRACKED`).
  - Copiado (rsync) conteúdo único para a estrutura do V2 — **123 arquivos** (69 `docs/`, 28 `scripts/`, 22 `.agents/`, 4 `dotfiles/`).
  - Duplicatas puladas (V2 vence): `cerebrum/rotinas/*` → confirmado = os 8 `docs/runbooks/runbook-*.md` do V2; `benchmarks/`, `perfis/`, `docker/`, `.opencode/{agents,commands}`.
  - `ssh-config` do vault descartado: o `dotfiles/dot_ssh/config` do V2 já contém todos os hosts (alienware, pve-vm, pve-win11, pve-ollama).
  - `tests/` **não existe** no vault (refs em `padroes-detectados.md`/`vault-health-report.md` apontavam para estrutura já removida) → nenhuma migração faltante.
- Files created/modified:
  - `docs/cerebrum/` (+`prompts/`, `systemd/`), `docs/notas/`, `docs/instintos/`, `docs/convencoes/`, `docs/guia-ia-local/`
  - `scripts/{linux,linux/validacoes,python,python/tests,windows}/`, `scripts/{benchmark-moe,install,bootstrap}.sh`
  - `.agents/skills/` (18 novas skills, total 22)
  - `dotfiles/{dot_bashrc,dot_prompt}`

### Phase 3: Correção de paths internos

- **Status:** complete
- Actions taken:
  - Passada 1 (60 arquivos): `archimedes-vault/<path>` → `archimedes-v2/<path>`; `.opencode/skills` → `.agents/skills`.
  - Passada 2 (12 arquivos operacionais): `brcesarms/archimedes-vault` → `…-v2`, `~/backups/archimedes-vault` → `…-v2`, `archimedes-vault_<stamp>` → `archimedes-v2_<stamp>`.
  - Passada 3 (56 arquivos): `guia-ia-local/<sub>` → novo path (`scripts/`, `docs/notas/`, `docs/cerebrum/`, `docs/instintos/`, `dotfiles/`, `docs/guia-ia-local/`).
  - `dotfiles/dot_bashrc`: `COFRE_DIR=$HOME/archimedes-v2`, `ALIASES_FILE=…/dotfiles/dot_aliases`, `PROMPT_FILE=…/dotfiles/dot_prompt`, título "Status do Archimedes V2".
  - `dotfiles/dot_aliases`: merge V2+legado (V2 vence nos conflitos; adicionados `bancada`, `ollama-*`, `oc`, docker, `tree`, `duh`, `topcpu/topmem`, `git-*`, `find-*`); removidos `dot_aliases.vault-legado` e `README.vault-legado.md` (merge no `README.md`).
  - `docs/cerebrum/{estrutura-cofre.md,README.md}` e `.agents/skills/organizar-cofre/SKILL.md`: árvore reescrita para a estrutura V2 consolidada.
  - `docs/cerebrum/logs/.gitkeep` criado (scripts escrevem logs aí).
  - `.agents/skills/atualizar-ssh/SKILL.md`: clone do repo corrigido para `archimedes-v2`.
  - Lint: `backup-logs.sh` (SC2088 til), `validar-teia.sh`/`validar-runbooks.sh` (variáveis mortas), `benchmark-moe.sh` (5× SC2155).
  - Preservados intencionalmente: menções "LEGADO V1 (`archimedes-vault`)" nos runbooks do V2 e relatórios históricos datados (`docs/notas/audit-*`, `licoes-*`, `MOC-*`).
- Files created/modified:
  - `dotfiles/{dot_bashrc,dot_aliases,README.md}`, `docs/cerebrum/{estrutura-cofre.md,README.md}`, `.agents/skills/{organizar-cofre,atualizar-ssh}/SKILL.md`, `scripts/linux/{backup-logs.sh,validacoes/validar-teia.sh,validacoes/validar-runbooks.sh}`, `scripts/benchmark-moe.sh`

## Test Results

| Test | Input | Expected | Actual | Status |
|------|-------|----------|--------|--------|
| Inventário versionado guia-ia-local | `awk -F/ 'NF==2'` | 7 arquivos raiz | 7 arquivos, 0 untracked | ✅ |
| Colisão em `scripts/` | comparação V2 vs vault | 0 colisões | 0 | ✅ |
| Sintaxe dotfiles | `bash -n` (dot_bashrc, dot_aliases, dot_prompt) | 0 erro | 0 | ✅ |
| Shellcheck scripts migrados | `shellcheck -S warning` | 0 warning | 0 warning | ✅ |
| Sintaxe scripts | `bash -n` (todos) | 0 erro | 0 | ✅ |
| Python compila | `py_compile validar_links.py` | OK | OK | ✅ |
| Refs residuais `docs/docs` | `rg 'docs/docs'` | 0 | 0 (2 corrigidas) | ✅ |

## Error Log

| Timestamp | Error | Attempt | Resolution |
|-----------|-------|---------|------------|
| 2026-09-17 | `grep -v '/'` ocultou que os 7 arquivos raiz estavam versionados | 1 | Usar `awk -F/ 'NF==2'` + `git ls-files --error-unmatch` |
| 2026-09-17 | sed gerou `docs/docs/guia-ia-local` em 2 arquivos | 1 | Guardar `docs/guia-ia-local/` como placeholder antes das substituições |
| 2026-09-17 | `perl -0pi` com backrefs (`$1local $2`) corrompeu `benchmark-moe.sh` (SC1046) | 1 | Restaurar do vault (`cp`) e refazer com a ferramenta Edit (6 edits precisos) |

## 5-Question Reboot Check

| Question | Answer |
|----------|--------|
| Where am I? | Phase 4 (runtime do sistema) |
| Where am I going? | Phases 4→8: runtime dotfiles (VM+AW), docs, validação, commit/push+archive, remoção do vault |
| What's the goal? | Repo único `archimedes-v2`, sem duplicação e sem perda de informação |
| What have I learned? | Ver `findings.md` |
| What have I done? | Fases 1–3 completas (backup, migração de 123 arquivos, correção de paths + lint) |

# 🔍 Findings — Refatoração Archimedes

## Data: 2026-09-16

---

## 1. Scripts (`scripts/*.sh`)

### backup.sh
- 🔴 **L8,19** — `$PASS_FILE` falha se `~/.config/restic/password` não existir
- 🔴 **L20** — `--exclude-file` falha se `.resticignore` não existir
- 🔴 **L7,18** — Repositório não inicializado → falha sem instrução
- 🟠 **L17-21** — Sem `trap` para erros → encerra silenciosamente antes do log `❌`
- 🟡 **L1** — Shebang `#!/usr/bin/env bash` vs convenção `#!/bin/bash`
- 🟡 **L16,23** — Logs não usam formato `==> [x/y]`

### lint.sh
- 🔴 **L16,21,26** — Sem `command -v` para lychee, shellcheck, gitleaks
- 🟠 **L21** — Omissão do `shfmt -i 2 -ci -bn` (obrigatório por convenção)
- 🟡 **L13** — SC2164: `cd` sem `|| exit`
- 🟡 **L21** — Escopo relativo `find scripts` (deveria ser `${ROOT_DIR}/scripts`)
- 🟡 **L17,22,27** — Usa `✔` em vez de `✅`

### setup.sh
- 🔴 **L16** — Sem verificação de `brew` instalado
- 🟠 **L21** — `chezmoi apply` pode sobrescrever dotfiles sem backup
- 🟡 **L13** — SC2164: `cd` sem `|| exit`
- 🟡 **L16** — `--file=Brewfile` relativo vs `${ROOT_DIR}/Brewfile`
- 🟡 **L26** — Invoca `lint.sh` sem garantir `chmod +x`

## 2. Configurações

### .editorconfig
- 🟠 **L11-12** — `indent_size = 4` em `[*]` conflita com `shfmt -i 2` para `.sh`
- **Correção:** Adicionar seção `[*.sh]` com `indent_size = 2`

### .resticignore
- 🟠 — Omite dezenas de filtros do `.gitignore`: caches, logs, `.cache`, `db-wal`, `*.log`, `*.bak`, `*.tmp`

### .lychee.toml
- 🟡 — Falta `exclude_path` para `.planning`, `.cache`
- 🟡 — Falta exclusão de `localhost`/`127.0.0.1`
- 🟡 — Falta `include_mail = false`

### .gitignore
- 🟡 — Falta `.vscode/`, `.idea/`, `dist/`, `.coverage`

## 3. Agents & Skills (`.agents/`)

### Inconsistências Sistêmicas
- 🚨 **opencode.json** — Agente `auditor` declarado sem arquivo `.md`; agente `executor` existe mas NÃO está no opencode.json
- 🚨 **notas-atomicas/SKILL.md L42,59** — Link quebrado `../../AGENTS.md` (deveria ser `../../../AGENTS.md`)
- ⚠️ **executor.md** — `mode: primary` no frontmatter, mas é subagente no AGENTS.md → corrigir para `mode: subagent`
- ⚠️ **notas-atomicas/SKILL.md L58** — Link placeholder `https://link-valido.org`
- 🟡 **estudante.md, resumidor.md** — Falta campo `name:` no frontmatter YAML
- 🟡 **executor.md** — Falta campo `name: executor` no frontmatter

### Runbooks Legados
- ⚠️ **runbook-auditoria-cofre.md L92** — Referência a `.opencode/skills/auditar-cofre/SKILL.md` (inexistente)
- ⚠️ **runbook-delegacao.md** — Comandos apontam para `~/archimedes-vault/` (V1 legado)

### planning-with-files
- 🟡 **SKILL.md hooks** — Fallback para `~/.claude/skills/` (caminho inexistente na máquina)

## 4. Documentação (`docs/`)

### docs/perfis/ — 🔴 CRÍTICO
- 🔴 **geekom.md** — Descreve Fedora Atomic, mas máquina é Proxmox VE 9.2. Recomenda `qwen3:14b` (descartado)
- 🔴 **acer-paula.md** — Recomenda `gpt-oss:20b` (12GB) em máquina com 12GB RAM total (OOM garantido)
- 🟠 **alienware.md** — `qwen3-coder:30b` sem explicar offload VRAM/RAM na RTX 5060 (8GB VRAM)
- 🟠 **my-setup.md L71-73** — Links com barra duplicada `././alienware.md`
- 🟠 **README.md** — Totalmente defasado: cita J.A.R.V.I.S., scripts V1, `archimedes-vault`
- 🟡 **me.md L88** — Referência legada `guia-ia-local/ME.md`
- ❌ Todos perfis: backup via `tar.gz` em vez de `restic`; caminhos `archimedes-vault`

### docs/benchmarks/
- 🟡 **BENCHMARKS.md L1** — Título com nome legado "J.A.R.V.I.S."
- 🟡 **HISTORICO.md L1** — Título com nome legado "J.A.R.V.I.S."
- 🟡 **BENCHMARKS.md L52-63** — Decisão superada sem marcação histórica
- 🟡 **resultados/qwen3-coder_30b-agenico.json** — Typo: "agenico" → "agentico"

### docs/runbooks/ — 🔴 8 RUNBOOKS LEGADOS V1
- 🔴 **8 runbooks fantasma** referenciando `~/archimedes-vault/guia-ia-local/scripts/linux/*.sh` (inexistente)
- 🔴 **runbook-maquina-nova.md** — Instrui clonar `archimedes-vault` e rodar `bootstrap.sh` (extinto)
- 🔴 **preparar-maquina-windows.md L55** — URL aponta para `archimedes-orquestrador` (pode ser 404)
- 🟠 **README.md** — 4 runbooks não indexados
- 🟠 **Links falsos** — Seções `## 🔗 Fontes` com auto-referências mascaradas

### docs/arquitetura/ — ✅ BOM ESTADO
- 🟡 **adr-001 L61** — Cita ShellCheck para `.ps1` (deveria ser PSScriptAnalyzer)

## 5. Docs & Config (consolidação final)

### README.md
- 🟠 **L34-60** — Árvore de diretórios incompleta: falta `scripts/setup.sh`, `.planning/`
- 🟠 **L19-29** — `repomix` e `ast-grep` listados como adotados, mas com status "Em planejamento" e ausentes do Brewfile
- 🟡 **L108** — Comando restic manual sem `--exclude-file` e `--tag`
- 🔴 **L41** — `config/` descrito como "Configurações centralizadas (MCP, hooks, linters)" → diretório VAZIO

### Brewfile
- 🟠 — `tesseract` e `tesseract-lang` sem uso documentado em nenhum lugar do cofre
- 🟠 — Faltam `ast-grep`, `jq`; `pyinfra` sem instrução de instalação via `pipx`
- 🟡 — `fastfetch` no Brewfile mas perfis usam `neofetch` (obsoleto)

### opencode.json
- 🔴 — Agente `auditor` declarado sem `.md`; `executor` omitido
- 🟠 **L3** — `version: "2.0.0 (2026-09-16)"` quebra validadores SemVer
- 🟡 — Permissões bash não incluem `docker`, `git status/diff/log`

### docker/docker-compose.yml
- 🔴 **L52** — `WEBUI_SECRET_KEY` hardcoded no arquivo versionado (violação AGENTS.md)
- 🟠 **L35-39** — Healthcheck usa `curl` (pode não existir no container ollama)
- 🟡 — Sem suporte a iGPU AMD/ROCm (GEEKOM)

### dotfiles/
- 🟠 **dot_aliases** — Caminhos hardcoded `/home/brn/archimedes` (anti-portabilidade)
- 🟠 **dot_ssh/config** — Omite nós Proxmox: VM `10.0.0.10`, Win11 `10.0.0.217`, CT `10.0.0.4`
- 🟡 — Falta alias `v2-setup`
- 🟠 **README.md** — Instruções com caminho hardcoded `/home/brn/archimedes/dotfiles`

### config/
- 🔴 — Diretório **100% VAZIO** apesar de documentado no README.md

### Links Mascarados nos Runbooks
- 🔴 — 16+ links com destinos forçados para `./README.md` ou auto-referências para passar no lychee



# Progress Log

## Session: 2026-09-16

### Current Status
- **Phase 7 COMPLETA ✅ — Memória Longa (claude-mem) e servidor Ollama**
- **Started:** 2026-09-16 · **Concluído:** 2026-09-16

### Phase 7 Actions
- ✅ LXC 104 criado no Proxmox (10.0.0.4): 8vCPU/12GB/132GB, privilegiado, GPU AMD ROCm 7.2, Ubuntu 24.04
- ✅ Ollama v0.34.1 instalado e validado (http://10.0.0.4:11434, /v1 OpenAI-compatible)
- ✅ Modelo qwen3:4b baixado (~2.6GB) e testado via chat
- ✅ claude-mem 13.25.1 instalado (npx, plugin OpenCode registrado)
- ✅ Provider host observer: proxy TCP 127.0.0.1:37777 → 10.0.0.4:11434 (mini-proxy Python em /tmp/opencode/, substituir por socat quando houver sudo)
- ✅ Worker ativo (porta 37700), SQLite + Chroma em ~/.claude-mem
- ✅ Via de compressão validada (chat qwen3:4b via proxy)
- ✅ docs/perfis/geekom.md e dot_ssh/config atualizados; commit 99056d5 pushado

### Actions Taken
- Fase 1 completa: auditoria dos 4 domínios consolidada em findings.md
- Verificação in loco dos achados críticos (opencode.json, docker-compose secret, config/ vazio)
- **Frente Segurança (Fase 5 parcial):**
  - ✅ docker-compose.yml: WEBUI_SECRET_KEY hardcoded removida → derivada do .env
  - ✅ docker/.env.example criado com instruções seguras
  - ✅ config/: README.md criado definindo propósito do hub (diretório era vazio/órfão)
  - ✅ README.md: linha config/ atualizada (removido "(em planejamento)")
  - ✅ opencode.json: version SemVer válido (2.0.0), executor adicionado, auditor removido (global), permissões docker/git status/diff/log
  - ✅ gitleaks: no leaks found nos arquivos atuais
  - ✅ **Purga do histórico (autorizada):** git-filter-repo 2.47.0 instalado, bundle de backup criado, placeholder removido de todos os commits, force push para GitHub concluído (0afaf66), stash restaurado
  - 🔐 Backup: `/tmp/opencode/archimedes-v2-backup-2026-09-16.bundle`
- **Fase 2 completa (Scripts):**
  - ✅ backup.sh reescrito: trap cleanup, validação de PASS_FILE/.resticignore/repo init, dicas de erro, formato ==> [x/y]
  - ✅ lint.sh ampliado: 4 etapas (lychee + shellcheck + shfmt + gitleaks), command -v com dica de instalação, escopo absoluto ROOT_DIR
  - ✅ setup.sh reescrito: check de brew/chezmoi/Brewfile, chezmoi --backup, caminhos absolutos, trap
  - ✅ chmod +x em todos; shellcheck 100% limpo; shfmt -i 2 -ci -bn aplicado; esteira lint.sh passou (161 links, 0 erros)
- **Fase 3 completa (Documentação):**
  - ✅ Perfis: geekom (Proxmox VE 9.2 + offload CPU/RAM), acer-paula (gpt-oss:20b removido → qwen2.5-coder:7b), alienware (nota offload VRAM 8GB), my-setup (links ././ → ./), me.md
  - ✅ Benchmarks: títulos J.A.R.V.I.S. → Archimedes V2; decisão superada marcada; typo agenico → agentico (arquivo renomeado via git mv + 3 JSONs)
  - ✅ Runbooks: aviso LEGADO V1 nos 4 restantes + comandos V2 reais (git pull/push, backup.sh, lint.sh, opencode run --auto), frontmatter script/logs → V2, links falsos das Fontes corrigidos
  - ✅ ADR-001: ShellCheck → PSScriptAnalyzer para .ps1
  - ✅ README: repomix/ast-grep marcados "em planejamento", .planning/ na árvore, restic com --exclude-file + --tag
  - ✅ lychee: 102 OK / 0 errors; zero referências archimedes-vault/guia-ia-local nos docs
- **Fase 4 completa (Agents & Skills):**
  - ✅ AGENTS.md alinhado com arquivos reais (3 subagentes + 4 skills)
  - ✅ Subagentes com name: no frontmatter, executor mode subagent
  - ✅ notas-atomicas SKILL.md: links corrigidos (../../../AGENTS.md), placeholder removido
  - ✅ planning-with-files: fallbacks agora incluem ~/archimedes-v2/.agents/skills (gate-stop.sh + plan-doctor.sh) + bash -n OK
- **Fase 5 completa (Config & Infra):**
  - ✅ .editorconfig: seção [*.sh] com indent_size = 2 (fim do conflito shfmt)
  - ✅ .gitignore: dist/, build/, .coverage, htmlcov/
  - ✅ .lychee.toml: include_mail = false
  - ✅ .resticignore: alinhado (.npm/.bun/dist/build/.coverage), duplicata .venv removida
  - ✅ dot_aliases: $HOME em vez de hardcoded, alias v2-setup, shfmt -i 2
  - ✅ dot_ssh/config: nós Proxmox adicionados (pve-vm 10.0.0.10, pve-win11 10.0.0.217, pve-ct 10.0.0.4)
  - ✅ dotfiles/README: instruções com $HOME
  - ✅ Brewfile: tesseract documentado, pyinfra via pipx comentado

### Test Results
| Test | Expected | Actual | Status |
|------|----------|--------|--------|
| opencode.json version SemVer | versão válida | 2.0.0 (2026-09-16) quebra validadores | ❌ → ✅ corrigido |
| docker-compose sem segredo | sem chave hardcoded | WEBUI_SECRET_KEY exposta no L52 | ❌ → ✅ corrigido |
| config/ populado | conter arquivos | diretório vazio | ❌ → ✅ README criado |
| JSON opencode válido | parsear sem erro | json.tool OK | ✅ |
| gitleaks full scan | sem leaks | no leaks found (10 commits reescritos) | ✅ |
| Histórico git | sem segredo | placeholder removido via filter-repo, force push OK | ✅ |
| Backup bundle | criado antes da purga | /tmp/opencode/archimedes-v2-backup-2026-09-16.bundle (224K) | ✅ |
| Stash restaurado | 16 mudanças WIP de volta | stash pop OK | ✅ |

### Errors
| Error | Resolution |
|-------|------------|
| (nenhum encontrado) | — |

### Phase 8 Actions (Benchmark Ollama LXC)
- ✅ Descoberta: Ollama no LXC 104 rodava 100% CPU (size_vram=0) — env "Intel/SYCL" copiado e GPU gfx1103 descartada pelo ROCm
- ✅ Fix aplicado no systemd do LXC: `OLLAMA_IGPU_ENABLE=1` + `HSA_OVERRIDE_GFX_VERSION=11.0.0` (gfx1103 → gfx1100)
- ✅ GPU ativa: `inference compute library=ROCm compute=gfx1100 AMD Radeon 780M type=iGPU`
- ✅ Benchmark (qwen3:4b): CPU 19.3 → GPU 26.8 tok/s @4096; 16.2 → 26.7 @65536; prompt eval 93→293 tok/s (3x); TTFT 4.3s→1.5s; concorrência ~27 tok/s c/u; tool calling real ✅
- ✅ Docs atualizados: BENCHMARKS.md (seção LXC 104), HISTORICO.md (execução 2026-09-16), geekom.md (fix GPU, monitoramento, troubleshooting)
- ✅ Acesso remoto usado: SSH `root@10.0.0.3` (Proxmox host) + `pct exec 104`

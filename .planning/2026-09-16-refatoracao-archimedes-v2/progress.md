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
  - 🔐 Backup: `/tmp/opencode/archimedes-backup-2026-09-16.bundle`
- **Fase 2 completa (Scripts):**
  - ✅ backup.sh reescrito: trap cleanup, validação de PASS_FILE/.resticignore/repo init, dicas de erro, formato ==> [x/y]
  - ✅ lint.sh ampliado: 4 etapas (lychee + shellcheck + shfmt + gitleaks), command -v com dica de instalação, escopo absoluto ROOT_DIR
  - ✅ setup.sh reescrito: check de brew/chezmoi/Brewfile, chezmoi --backup, caminhos absolutos, trap
  - ✅ chmod +x em todos; shellcheck 100% limpo; shfmt -i 2 -ci -bn aplicado; esteira lint.sh passou (161 links, 0 erros)
- **Fase 3 completa (Documentação):**
  - ✅ Perfis: geekom (Proxmox VE 9.2 + offload CPU/RAM), acer-paula (gpt-oss:20b removido → qwen2.5-coder:7b), alienware (nota offload VRAM 8GB), my-setup (links ././ → ./), me.md
  - ✅ Benchmarks: títulos J.A.R.V.I.S. → Archimedes; decisão superada marcada; typo agenico → agentico (arquivo renomeado via git mv + 3 JSONs)
  - ✅ Runbooks: aviso LEGADO V1 nos 4 restantes + comandos V2 reais (git pull/push, backup.sh, lint.sh, opencode run --auto), frontmatter script/logs → V2, links falsos das Fontes corrigidos
  - ✅ ADR-001: ShellCheck → PSScriptAnalyzer para .ps1
  - ✅ README: repomix/ast-grep marcados "em planejamento", .planning/ na árvore, restic com --exclude-file + --tag
  - ✅ lychee: 102 OK / 0 errors; zero referências archimedes-vault/guia-ia-local nos docs
- **Fase 4 completa (Agents & Skills):**
  - ✅ AGENTS.md alinhado com arquivos reais (3 subagentes + 4 skills)
  - ✅ Subagentes com name: no frontmatter, executor mode subagent
  - ✅ notas-atomicas SKILL.md: links corrigidos (../../../AGENTS.md), placeholder removido
  - ✅ planning-with-files: fallbacks agora incluem ~/archimedes/.agents/skills (gate-stop.sh + plan-doctor.sh) + bash -n OK
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
| Backup bundle | criado antes da purga | /tmp/opencode/archimedes-backup-2026-09-16.bundle (224K) | ✅ |
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

### Dotfile Sync (pós-Fase 8)
- ✅ ~/.ssh/config real sincronizado com dotfiles/dot_ssh/config (backup: config.bak-2026-09-16)
- ✅ BUG corrigido: host geekom usava User brn (Permission denied) → User root (validado: proxmox OK)
- ✅ Chave ed25519 do Bruno instalada no LXC 104 via pct exec (ssh pve-ollama sem senha, ollama 0.34.1 active)
- ✅ Hosts offline confirmados (esperado): alienware 10.0.0.2, laptop-brn 10.0.0.5, pve-vm 10.0.0.10, pve-win11 10.0.0.217
- ✅ geekom.md atualizado: SSH por chave + re-autorização documentada

### Phase 9 Actions (PoC Fine-Tuning — Modo Archimedes)
- ✅ Dataset de estilo: 54 exemplos ShareGPT (~5.3k tokens) gerados do cofre (`dataset.jsonl`)
- ✅ Ambiente: venv `/opt/finetune` (Python 3.12.3) + `torch 2.9.1+rocm6.3` no LXC 104
- ✅ Fix crítico Triton: remover `triton` do PyPI e reinstalar `pytorch-triton-rocm==3.5.1` (senão `hipDrvLaunchKernelEx` falha)
- ✅ Diagnóstico do **GPU Hang**: dmesg mostrou `MES failed to respond to msg=REMOVE_QUEUE` → timeout do MES, **não** falta de memória (VRAM/UMA no BIOS não resolve)
- ✅ Combinação vencedora: **fp16 + `AMD_SERIALIZE_KERNEL=3` + `AMD_SERIALIZE_COPY=3`** (+ `HSA_OVERRIDE_GFX_VERSION=11.0.0`)
- ✅ Treino completo: 60 steps, ~16 min, **loss 14.26 → 3.65** (`train_loss` 6.77)
- ✅ Merge LoRA (CPU) → `archimedes-merged` (bf16, 8GB)
- ✅ `llama.cpp` clonado + `llama-quantize` compilado → GGUF f16 → **Q4_K_M (2.4GB)**
- ✅ `ollama create archimedes` → `archimedes:latest` (2.5GB) no LXC 104
- ✅ Estilo validado: emojis (📋 🏛️ ✅), pt-BR e **tabelas markdown** (ex.: MikroTik × Ubiquiti)
- ✅ Benchmark: 26.2 tok/s (base 26.8) · prompt eval 346 tok/s (+95%) · wall 7.9s (-38%)
- ✅ Docs: `docs/finetune/README.md` + BENCHMARKS.md + HISTORICO.md + geekom.md

### Test Results (Fase 9)
| Test | Expected | Actual | Status |
|------|----------|--------|--------|
| Treino LoRA fp16 (60 steps) | sem GPU Hang | loss 14.26→3.65, 951.5s | ✅ |
| Merge LoRA | modelo bf16 válido | `model.safetensors` 8.0GB | ✅ |
| GGUF Q4_K_M | gerar quantizado | 2.4GB (4.95 BPW) | ✅ |
| `ollama create` | modelo listado | `archimedes:latest` 2.5GB | ✅ |
| Estilo Archimedes | emojis+tabelas+pt-BR | ✅ validado (2 prompts) | ✅ |
| Velocidade vs base | sem regressão | 26.2 vs 26.8 tok/s (-2%) | ✅ |

# 🏛️ Refatoração Archimedes

## Goal
Refatorar o cofre `archimedes` para máxima robustez, consistência e eficiência. Eliminar erros, melhorar scripts, documentação e configurações.

## Next Step
Todas as fases concluídas. Próximos passos sugeridos: integrar `archimedes:latest` como observer/voz local do claude-mem e avaliar novo ciclo de fine-tune com dataset maior.

## Phases

### Phase 1: Auditoria Completa
**Status:** complete
- [x] Inicializar sessão de planejamento
- [x] Lançar 4 subagentes de pesquisa paralelos
- [x] Consolidar findings de scripts (shellcheck, shfmt, boas práticas)
- [x] Consolidar findings de docs & config
- [x] Consolidar findings de agents & skills
- [x] Consolidar findings de runbooks & docs técnicos

### Phase 2: Correção de Scripts
**Status:** complete
- [x] Aplicar correções shellcheck em scripts/*.sh
- [x] Padronizar shebang, set flags, emojis nos logs
- [x] Ampliar lint.sh para cobrir todo o cofre
- [x] Validar backup.sh e setup.sh

### Phase 3: Correção de Documentação
**Status:** complete
- [x] Corrigir links quebrados (lychee)
- [x] Atualizar README.md
- [x] Padronizar formatação markdown
- [x] Remover referências obsoletas

### Phase 4: Correção de Agents & Skills
**Status:** complete
- [x] Alinhar AGENTS.md com arquivos reais
- [x] Melhorar definições de subagentes
- [x] Revisar skills SKILL.md

### Phase 5: Correção de Config & Infra
**Status:** complete
- [x] Revisar opencode.json (SemVer, executor, permissões)
- [x] Remover secret hardcoded do docker-compose → .env.example
- [x] Purgar segredo do histórico git (filter-repo + force push)
- [x] Definir propósito de config/ (README.md)
- [x] Atualizar dotfiles (aliases $HOME, v2-setup, nós Proxmox SSH, shfmt -i 2)
- [x] Verificar .editorconfig ([*.sh] = 2), .gitignore (dist/coverage), .lychee.toml (include_mail=false), .resticignore (alinhado)

### Phase 6: Validação Final
**Status:** complete
- [x] Rodar lint.sh completo (163 links / 102 OK / 0 erros, shellcheck, shfmt, gitleaks)
- [x] Rodar gitleaks (no leaks found)
- [x] Rodar lychee (102 OK / 0 errors)
- [x] Commit e push (ef5f79c → main)

### Phase 7: Memória Longa (claude-mem)
**Status:** complete
- [x] Instalar claude-mem (npx 13.25.1, plugin OpenCode)
- [x] Configurar SQLite + Chroma (~/.claude-mem)
- [x] Integrar ao opencode (plugin registrado)
- [x] Validar memória persistente (worker ativo, observer via Ollama local)
- [x] Criar servidor Ollama no Proxmox (LXC 104, 10.0.0.4, qwen3:4b)

### Phase 8: Benchmark Ollama LXC
**Status:** complete
- [x] Medir velocidade pura (tok/s, prompt eval, wall time) via API
- [x] Verificar alocação GPU (size_vram) vs CPU no LXC
- [x] Testar concorrência / latência (3× reqs paralelas, TTFT)
- [x] Testar agêntico (tool calling ✅ get_capital)
- [x] **Fix GPU aplicado no LXC** (OLLAMA_IGPU_ENABLE=1 + HSA_OVERRIDE_GFX_VERSION=11.0.0) — size_vram 0 → 3.17GB/12.23GB
- [x] Documentar resultados em docs/benchmarks/ e docs/perfis/geekom.md
- [x] Commit e push

### Phase 9: PoC Fine-Tuning — Modo Archimedes (LoRA)
**Status:** complete
- [x] Preparar dataset de estilo (54 exemplos reais do cofre, formato ShareGPT)
- [x] Instalar ambiente de treino no LXC 104 (PyTorch ROCm + PEFT)
- [x] Treinar LoRA fp16 (Qwen3-4B, r=16, 60 steps) — loss 14.26→3.65
- [x] Exportar adaptador → merge bf16 → GGUF Q4_K_M
- [x] Carregar no Ollama LXC 104 (`archimedes:latest`) e validar estilo
- [x] Benchmark comparativo base vs fine-tuned (26.2 vs 26.8 tok/s)
- [x] Documentar (`docs/finetune/`) e commit

> ⚠️ **Desvio do plano:** QLoRA 4-bit abandonado — bitsandbytes na Radeon 780M causa GPU Hang (ROCm 6.4 vs 6.3). Solução final: **LoRA fp16 + `AMD_SERIALIZE_KERNEL=3`**.

### Phase 10: Ciclo 2 — Dataset Ampliado (reduzir alucinação)
**Status:** in_progress
- [ ] Mapear corpus do cofre (docs/runbooks/scripts/AGENTS) para extração
- [ ] Criar gerador de Q&A fiel aos trechos (LLM local, sem inventar fatos)
- [ ] Gerar e validar dataset v2 (300+ exemplos, dedup, formato ShareGPT)
- [ ] Treinar Ciclo 2 (LoRA fp16, mais steps, `max_seq` maior)
- [ ] Merge + GGUF Q4_K_M + deploy `archimedes:v2`
- [ ] Avaliar estilo + teste factual (base vs v1 vs v2) e benchmark
- [ ] Documentar e commit

## Decisions Made
| Decision | Rationale |
|----------|-----------|
| Usar subagentes paralelos para auditoria | Eficiência: cobrir 4 áreas simultaneamente |
| Seguir planning-with-files | Persistência e rastreabilidade |
| LoRA fp16 em vez de QLoRA 4-bit | bitsandbytes causa GPU Hang na 780M (binário ROCm 6.4 ≠ runtime 6.3) |
| `AMD_SERIALIZE_KERNEL=3` obrigatório no treino | Sem serialização de kernels, o MES estoura timeout (GPU Hang) na gfx1103→gfx1100 |
| Não aumentar VRAM/UMA no BIOS | O hang é timeout de fila do MES, não falta de memória |
| Quantizar em Q4_K_M (2.4GB) | Equilíbrio ideal tamanho/velocidade para a iGPU |

## Errors Encountered
| Error | Attempt | Resolution |
|-------|---------|------------|
| GPU Hang no step 1 (Unsloth/bnb/bf16) | Unsloth+b nb 4-bit, PEFT+bnb, LoRA bf16 puro | `fp16=True` + `AMD_SERIALIZE_KERNEL=3` + `AMD_SERIALIZE_COPY=3` ✅ |
| `hipDrvLaunchKernelEx` em libamdhip64.so | Triton 3.7.1 do PyPI sobre ROCm 3.5.1 | Reinstalar `pytorch-triton-rocm==3.5.1` sem deps ✅ |
| `cannot import name 'ScalingType'` | torchao 0.18.0 × torch 2.9.1 | Remover torchao ✅ |
| `model did not return a loss` | transformers 5.x | `LossTrainer` com cross-entropy deslocada ✅ |
| `MES failed to respond to msg=REMOVE_QUEUE` | Aumentar VRAM (BIOS) | Não é memória — serialização de kernels resolveu ✅ |

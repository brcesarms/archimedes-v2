# 🏛️ Refatoração Archimedes V2

## Goal
Refatorar o cofre `archimedes-v2` para máxima robustez, consistência e eficiência. Eliminar erros, melhorar scripts, documentação e configurações.

## Next Step
Benchmark do servidor Ollama LXC 104 (10.0.0.4) — velocidade pura, alocação GPU vs CPU, teste agêntico.

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
- [ ] Commit e push

## Decisions Made
| Decision | Rationale |
|----------|-----------|
| Usar subagentes paralelos para auditoria | Eficiência: cobrir 4 áreas simultaneamente |
| Seguir planning-with-files | Persistência e rastreabilidade |

## Errors Encountered
| Error | Attempt | Resolution |
|-------|---------|------------|
| (nenhum ainda) | — | — |

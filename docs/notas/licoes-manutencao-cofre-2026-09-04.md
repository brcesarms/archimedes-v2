# 🧠 Lições de Manutenção do Cofre — 2026-09-04

> Registro da sessão de auditoria: o que descobrimos, corrigimos e aprendemos durante a limpeza e verificação do cofre.

## 📌 Resumo da sessão

Nesta sessão executamos: varredura de scripts (ShellCheck), criação de skills de revisão e auditoria, dieta de meta (exclusão de skill órfã), correção de links e otimização de backups.

## 🐛 Lição 1: O `rg` ignora pastas ocultas por padrão

- A pasta `.opencode/` começa com ponto = **oculta**
- `rg` **NÃO procura em arquivos/pastas ocultas sem `--hidden`**
- 🔴 Erro cometido: auditoria de skills contou referências sem `--hidden` → subestimou as contagens
- ✅ Correção: **sempre usar `--hidden`** ao contar referências cruzadas
- 📍 Consequência: lição documentada na skill [`auditar-skills`](../../.agents/skills/auditar-skills/SKILL.md)

## 🐛 Lição 5: Links são relativos ao diretório do arquivo

- Links markdown são **relativos à pasta onde o arquivo está** (ex: nota em `notas/` usa `../.opencode/...`)
- 🔴 Erro cometido: validei links de uma nota a partir da **raiz** do cofre → todos quebraram por engano (falso alarme)
- ✅ Correção: validar com `cd "$(dirname nota.md)"` antes do grep de links
- 📍 Consequência: lição documentada na convenção [`auditoria-vault.md`](../convencoes/auditoria-vault.md) e na skill [`gerenciar-links`](../../.agents/skills/gerenciar-links/SKILL.md)

## 🐛 Lição 2: Backup dentro do cofre = backup aninhado

- `utils/backups/` fica **dentro** do cofre
- Cada `tar` do cofre inteiro incluía os backups anteriores **dentro dele**
- 🔴 Inflação observada: 105K → 11M → **31M** (efeito bola de neve)
- ✅ Correção: `--exclude='archimedes/docs/guia-ia-local/utils/backups/*.tar.gz'` + `--exclude='archimedes-vault/.opencode/node_modules'`
- 📍 Resultado: backup limpo de **124K** (99,6% menor)
- 📍 Consequência: lição documentada na skill [`backup-cofre`](../../.agents/skills/backup-cofre/SKILL.md)

## 🧼 Lição 3: Dieta de meta — nem toda tarefa vira skill

- O cofre tinha **10 skills**; a auditoria mostrou `otimizar-tokens` órfã (1 ref, 2 links quebrados)
- Assunto dela já era coberto pelas **convenções** (`scpp-cache.md` e `contexto-eficiente.md`)
- 🗑️ Excluída (movida para lixeira `/tmp`, recuperável)
- ✅ Regra: **só criar skill após o padrão repetir 2-3x**; auditar periodicamente com [`auditar-skills`](../../.agents/skills/auditar-skills/SKILL.md)

## 🐚 Lição 4: Tratamento de achados do ShellCheck

- `SC2034` (variável morta) → **corrigir** (remover/usar)
- `SC2016` (aspas simples) e `SC1091` (source externo) → **suprimir** com `# shellcheck disable=...` + comentário explicando
- ✅ Regra: nunca ignore um aviso — ou corrija, ou documente

## ✅ Entregas da sessão

| Item | Onde |
|------|------|
| 🩺 Skill `revisar-scripts` (11 passos) | [`revisar-scripts`](../../.agents/skills/revisar-scripts/SKILL.md) |
| 🧼 Skill `auditar-skills` (auditoria + exclusão segura) | [`auditar-skills`](../../.agents/skills/auditar-skills/SKILL.md) |
| 🐚 Script `verificar-scripts.sh` (bash -n + shellcheck) | [`scripts/linux/verificar-scripts.sh`](../../scripts/linux/verificar-scripts.sh) |
| 🔧 5 scripts corrigidos (install, setup, 3x usar-*) | [`docs/guia-ia-local/`](../guia-ia-local/README.md) |
| 📦 Backup limpo e íntegro | [`backup-cofre.sh`](../../scripts/linux/backup-cofre.sh) |

## 🔗 Relacionadas

- [Skill de revisão de scripts](../../.agents/skills/revisar-scripts/SKILL.md)
- [Skill de auditoria de skills](../../.agents/skills/auditar-skills/SKILL.md)
- [Skill de backup do cofre](../../.agents/skills/backup-cofre/SKILL.md)
- [Skill de scripts Linux](../../.agents/skills/script-linux/SKILL.md)
- [Guia da IA local (README)](../guia-ia-local/README.md)

---

## 🔗 Fontes
- [ShellCheck — Shell script analysis tool](https://www.shellcheck.net/)
- [ripgrep — Como procurar em arquivos ocultos](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md)
- Sessão executada por J.A.R.V.I.S. em 2026-09-04
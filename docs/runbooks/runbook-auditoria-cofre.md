---
title: "Runbook — Auditoria do Cofre (Vault Health)"
tipo: auditoria
frequencia: semanal
script: (skill auditar-cofre — 4 checagens)
logs: guia-ia-local/cerebrum/logs/
tags:
  - runbook
  - executor
  - auditoria
  - saude
status: pronto
---

# 🏥 Runbook — Auditoria do Cofre (Vault Health)

> 🚨 **PARA O EXECUTOR — siga APENAS os passos abaixo. Não invente. Não pule.**

## 🎯 Contexto

Auditoria semanal de saúde do **sistema do cofre** (raiz + `guia-ia-local/` + `.opencode/`): detecta links quebrados, notas órfãs e propõe novos MOCs. Mantém o cofre consistente e conectado. Você executa os **4 passos mecânicos** abaixo e gera o relatório.

> ⚠️ **ESCOPO IMPORTANTE:** NÃO auditar os estudos pessoais (`~/wikisidian/` — conteúdo privado, fora do repositório, geram muito ruído de links relativos/planejados). Focar **somente** no sistema:
> - `~/archimedes-vault/*.md` (raiz)
> - `~/archimedes-vault/guia-ia-local/**`
> - `~/archimedes-vault/.opencode/**`

## ⚙️ Passos (executar na ordem)

### Passo 1 — Links Quebrados

Execute **exatamente** este comando (já exclui submódulos e ignora âncoras):

```bash
grep -rEn --include="*.md" '\[[^]]*\]\([^)#]*\)' ~/archimedes-vault/*.md ~/archimedes-vault/guia-ia-local ~/archimedes-vault/.opencode -h | grep -oP '\]\(\K[^)#]+' | sort -u
```

**VALIDE cada caminho listado:** considere apenas links que sejam **relativos ao cofre ou ao sistema**. Ignore:
- URLs externas (`http`, `mailto`, `github.com/...`)
- Links para estudos pessoais (`~/wikisidian/...`)
- Links para notas **planejadas** (fazem parte do workflow de notas atômicas)
- Caminhos de scripts/documentação que existam em disco

Um link só é **quebrado de verdade** se o destino **deveria existir** e **não existe**. Se nenhum link quebrado real for encontrado → anote `✅ Links OK`.

### Passo 2 — Notas Órfãs

Liste os arquivos do sistema e identifique os que **não recebem nenhum `[link](...)`** de outras notas do sistema:

```bash
find ~/archimedes-vault/guia-ia-local ~/archimedes-vault/.opencode -name "*.md" -not -path "*/node_modules/*" | sort
```

> 💡 Dica: cruze os nomes de arquivo com a lista de links da saída do Passo 1. Uma nota **não recebe backlink** se seu caminho nunca aparece como destino de outro `.md` do sistema. Se houver dúvida, anote como **candidata a órfã** (o Cérebro valida depois).

### Passo 3 — Proposta de MOCs

Execute e conte a frequência de tags no frontmatter (só do sistema):

```bash
grep -rEn --include="*.md" '^  - [a-z-]+$|^tags:' ~/archimedes-vault/guia-ia-local ~/archimedes-vault/.opencode
```

**VALIDE:** se uma tag tiver **mais de 7 notas** do sistema e ainda **não existir MOC** para ela → anotar sugestão de MOC.

### Passo 4 — Gerar Relatório

Escreva o relatório em `guia-ia-local/notas/vault-health-report.md`, seguindo o formato da skill (emojis, tabelas, `## 🔗 Fontes`):
- ✅ Links OK
- ❌ Links quebrados (com caminho)
- 🕸️ Notas órfãs
- 🗺️ MOCs propostos

## ✅ Checklist de Validação

- [ ] Passos 1–3 executados e saídas registradas
- [ ] Relatório criado em `guia-ia-local/notas/vault-health-report.md`
- [ ] Relatório contém as 4 seções (✅/❌/🕸️/🗺️) + `## 🔗 Fontes`

## 🆘 Tratamento de Erros

| Sintoma | Ação do Executor |
|---------|------------------|
| Comando do Passo 1 retorna erro de sintaxe | Marque **ESTA nota** com tag `#falha` e **PARE**. |
| Não foi possível criar o relatório (permissão/caminho) | Marque `#falha` e **PARE**. |
| Qualquer ambiguidade nos resultados | Marque `#falha` e **PARE**. **Nunca improvise.** |

---

## 🔗 Fontes

- 🏥 Skill: [`.opencode/skills/auditar-cofre/SKILL.md`](./runbook-auditoria-cofre.md)
- 🗺️ Master Plan: [`master-plan.md`](./README.md)
- 📝 Template: [`template-runbook.md`](./README.md)

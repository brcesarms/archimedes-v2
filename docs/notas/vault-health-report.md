# 🏥 Vault Health Report — 2026-09-09

> 📊 Auditoria do cofre J.A.R.V.I.S. — verificação de links, notas órfãs e MOCs.  
> **Executor:** 🦾 J.A.R.V.I.S. (supervisor)  
> **Data:** 2026-09-09  
> **Status:** ⚠️ **ATENÇÃO — 89 links quebrados detectados**

---

## 🎯 Resumo

| Item | Resultado |
|------|:---------:|
| 🔍 Links markdown encontrados (sistema) | 280 |
| ❌ Links quebrados (reais, v2 filtrada) | **89** |
| 🕸️ Notas órfãs (sem backlinks) | **15** |
| 🗺️ MOCs existentes | 2 |
| 🗺️ MOCs propostos | 1 |

> **Veredito:** ⚠️ Há problemas de links que **precisam correção** (muitos são consequência da reestruturação de 08/09 — caminhos relativos desatualizados).

---

## 🔍 1. Links Quebrados (89)

> Links internos relativos cujo destino **não existe**. Maioria em notas antigas de auditoria (referências à estrutura antiga) e skills com `../` incorreto.

### 📄 Arquivos com mais links quebrados

| Arquivo | Qtd | Causa provável |
|---------|:---:|----------------|
| `docs/notas/RELATORIO-FINAL-AUDITORIA-2026-09-08.md` | ~18 | Referências à estrutura antiga (`docs/perfis/`, `docs/guia-ia-local/DEPENDENCIAS.md`) que não existe mais |
| `docs/notas/MOC-auditoria-2026-09-08.md` | ~9 | Caminhos `./` incorretos + `../AGENTS.md` errado |
| `docs/notas/licoes-manutencao-cofre-2026-09-04.md` | ~10 | Caminhos `../` referenciando estrutura nova de onde não deveria |
| `.opencode/skills/revisar-scripts/SKILL.md` | 4 | `../../` para AGENTS.md/skill quando deveria ser `../../../` |
| `.opencode/skills/orquestrar-tarefa/SKILL.md` | 2 | `../../.opencode/...` incorreto |
| `docs/notas/README.md` | 2 | `../AGENTS.md` quando deveria ser `../../AGENTS.md` |
| Outros (padroes-detectados, propostas-moc, MOC-teia, audit-*) | restante | Padrão similar |

### 🔧 Correções recomendadas (prioridade)

1. **Skills `revisar-scripts` e `orquestrar-tarefa`** → corrigir `../../` para `../../../` (são ativas, usadas)
2. **`docs/notas/README.md`** → `../AGENTS.md` → `../../AGENTS.md`
3. **Notas antigas de auditoria (08/09)** → decidir: atualizar ou arquivar (são relatórios históricos, talvez manter como registro e aceitar links quebrados OU corrigir)

> ⚠️ Alguns "links" detectados são **exemplos didáticos** (code blocks com `./nome-da-nota.md`) — **não são quebrados de verdade**. Já filtrados na v2.

---

## 🕸️ 2. Notas Órfãs (15)

> Notas que **não recebem nenhum link** de outras notas (zero backlinks).

| Arquivo | Sugestão de conexão |
|---------|---------------------|
| `docs/notas/teste-bateria-2026.md` | Conectar ao `BENCHMARKS.md` |
| `docs/notas/MOC-teia-conexoes-2026-09-08.md` | Conectar ao `vault-health-report.md` (MOCs) |
| `docs/notas/RELATORIO-FINAL-AUDITORIA-2026-09-08.md` | Conectar ao `MOC-auditoria-2026-09-08.md` |
| `docs/notas/agents-md-atualizado-2026-09-08.md` | Conectar ao AGENTS.md |
| `docs/notas/fluxo-trabalho-executor-2026-09-08.md` | Conectar ao `cerebrum/master-plan.md` |
| `docs/notas/opencode-json-fontes-2026-09-08.md` | Conectar ao opencode.json docs |
| `docs/notas/setup-timer-manutencao-cofre.md` | Conectar ao `README.md` (guia-ia-local) |
| `docs/guia-ia-local/tests/resultados-velocidade.md` | Conectar ao `BENCHMARKS.md` |
| `docs/cerebrum/rotinas/runbook-*.md` (6) | Conectar ao `cerebrum/README.md` (MOC dos runbooks) |
| `docs/cerebrum/logs/estado-falhas.md` | Conectar ao `master-plan.md` |

---

## 🗺️ 3. MOCs

### ✅ MOCs existentes

| MOC | Status |
|-----|--------|
| `MOC-auditoria-2026-09-08.md` | ✅ Existe |
| `MOC-teia-conexoes-2026-09-08.md` | 🕸️ Órfão — **não recebe links** |

### 💡 MOC proposto

| MOC | Motivo |
|-----|--------|
| **MOC-Runbooks** (`cerebrum/MOC-runbooks.md`) | Existem **8 runbooks** em `cerebrum/rotinas/` sem índice central — todos órfãos. Criar MOC agrupando: auditoria-cofre, backup-limpeza, backup-semanal, delegacao, git-sync, monitoramento, saude-sistema. |

---

## 📝 Recomendações de ação

1. 🔧 **Corrigir links das skills ativas** (revisar-scripts, orquestrar-tarefa) — prioridade alta
2. 🔗 **Corrigir `docs/notas/README.md`** — prioridade média
3. 📂 **Criar MOC-Runbooks** — agrupa 8 runbooks órfãos
4. 🧹 **Decidir destino das notas antigas de auditoria** (atualizar caminhos ou aceitar como histórico)
5. 🔄 Rodar `gerenciar-links` skill para as correções em lote

---

## 🔗 Fontes

- Skill: [auditar-cofre](../../.agents/skills/auditar-cofre/SKILL.md)
- Convenções: [auditoria-vault.md](../convencoes/auditoria-vault.md)
- Auditoria executada: 2026-09-09 (scripts `check-links2.sh`, `check-orphans2.sh`)
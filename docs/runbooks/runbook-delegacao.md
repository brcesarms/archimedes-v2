---
title: "Runbook — Delegação ao Executor (opencode run --auto)"
tipo: delegacao
frequencia: diaria
script: opencode run --auto
logs: .planning/logs/
tags:
  - runbook
  - executor
  - delegacao
  - headless
status: pronto
---

# 🤖 Runbook — Delegação ao Executor (opencode run --auto)

> [!CAUTION]
> **⚠️ LEGADO V1** — Este runbook contém procedimentos do Archimedes V1 (`archimedes-vault`) que foram substituídos no V2. Scripts referenciados podem não existir. Consulte `scripts/backup.sh`, `scripts/lint.sh` e `scripts/setup.sh` para os procedimentos atualizados.

> 🚨 **PARA O EXECUTOR — siga APENAS os passos abaixo. Não invente. Não pule. Não edite scripts.**

## 🎯 Contexto

Delega a execução das rotinas ao modelo local via `opencode run --auto` (headless). É o mecanismo da **Fase 3 (Delegação Total)**: a IA local lê os Runbooks, executa os comandos exatos e reporta. O wrapper faz **todo** o trabalho — você apenas executa e valida.

## ⚙️ Comandos (copiar/colar exatos)

### Rotina diária (backup + limpeza + saúde + monitoramento)

```bash
opencode run --auto
```

### Auditoria semanal (links + órfãs + MOCs + backup semanal)

```bash
./scripts/lint.sh
```

**LEIA a saída inteira.** A execução bem-sucedida termina com:

```
🎯 Delegação [MODO] concluída com sucesso! ✅
📋 Log: ...
```

## ✅ Checklist de Validação

- [ ] Saída termina com `🎯 Delegação ... concluída com sucesso! ✅`
- [ ] Nenhuma mensagem `❌` nem `#falha` no final
- [ ] Log criado em `.planning/logs/delegacao-*.log`

## 🆘 Tratamento de Erros

| Sintoma | Ação do Executor |
|---------|------------------|
| `❌ opencode CLI não encontrado` | Marque **ESTA nota** com tag `#falha` e **PARE**. |
| `❌ opencode run retornou código <n>` | Marque `#falha` e **PARE**. Não tente corrigir. |
| `❌ Prompt não encontrado` | Marque `#falha` e **PARE**. |
| Modelo demorou muito / timeout | Marque `#falha` e **PARE** (recursos do GEEKOM). |
| Qualquer dúvida | Marque `#falha` e **PARE**. **Nunca improvise.** |

---

## 🔗 Fontes

- 💾 Backup: [`backup.sh`](../../scripts/backup.sh)
- 🩺 Saúde: [`runbook-saude-sistema.md`](./runbook-saude-sistema.md)
- 🏥 Auditoria: [`runbook-auditoria-cofre.md`](./runbook-auditoria-cofre.md)
- 📝 Template: [`README.md`](./README.md)

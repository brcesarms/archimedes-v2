---
title: "Runbook — Delegação ao Executor (opencode run --auto)"
tipo: delegacao
frequencia: diaria
script: guia-ia-local/scripts/linux/delegar-executor.sh
logs: guia-ia-local/cerebrum/logs/
tags:
  - runbook
  - executor
  - delegacao
  - headless
status: pronto
---

# 🤖 Runbook — Delegação ao Executor (opencode run --auto)

> 🚨 **PARA O EXECUTOR — siga APENAS os passos abaixo. Não invente. Não pule. Não edite scripts.**

## 🎯 Contexto

Delega a execução das rotinas ao modelo local via `opencode run --auto` (headless). É o mecanismo da **Fase 3 (Delegação Total)**: a IA local lê os Runbooks, executa os comandos exatos e reporta. O wrapper faz **todo** o trabalho — você apenas executa e valida.

## ⚙️ Comandos (copiar/colar exatos)

### Rotina diária (backup + limpeza + saúde + monitoramento)

```bash
~/archimedes-vault/guia-ia-local/scripts/linux/delegar-executor.sh
```

### Auditoria semanal (links + órfãs + MOCs + backup semanal)

```bash
~/archimedes-vault/guia-ia-local/scripts/linux/delegar-executor.sh auditoria
```

**LEIA a saída inteira.** A execução bem-sucedida termina com:

```
🎯 Delegação [MODO] concluída com sucesso! ✅
📋 Log: ...
```

## ✅ Checklist de Validação

- [ ] Saída termina com `🎯 Delegação ... concluída com sucesso! ✅`
- [ ] Nenhuma mensagem `❌` nem `#falha` no final
- [ ] Log criado em `guia-ia-local/cerebrum/logs/delegacao-*.log`

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

- 🐚 Script: [`delegar-executor.sh`](./runbook-delegacao.md)
- 📄 Prompts: [`prompts/prompt-executor-diario.md`](./runbook-saude-sistema.md) · [`prompts/prompt-executor-auditoria.md`](./runbook-auditoria-cofre.md)
- 📝 Template: [`template-runbook.md`](./README.md)

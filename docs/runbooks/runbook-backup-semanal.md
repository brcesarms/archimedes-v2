---
title: "Runbook — Backup Semanal (Snapshot + Push GitHub)"
tipo: backup-semanal
frequencia: semanal
script: guia-ia-local/scripts/linux/backup-semanal-executor.sh
logs: guia-ia-local/cerebrum/logs/
tags:
  - runbook
  - executor
  - backup
  - git
status: pronto
---

# 💾 Runbook — Backup Semanal (Snapshot + Push GitHub)

> 🚨 **PARA O EXECUTOR — siga APENAS os passos abaixo. Não invente. Não pule. Não edite scripts.**

## 🎯 Contexto

Rotina semanal que (1) cria snapshot local do cofre e (2) publica commits locais pendentes no GitHub. Mantém o projeto com **2 cópias** (local + remoto). O script faz **todo** o trabalho — você apenas executa e valida a saída.

## ⚙️ Comandos (copiar/colar exatos)

1. Abra o terminal e execute **exatamente** este comando:

   ```bash
   ~/archimedes-vault/guia-ia-local/scripts/linux/backup-semanal-executor.sh
   ```

2. **LEIA a saída inteira.** A execução bem-sucedida termina com:

   ```
   ===== 🎯 Backup semanal concluído com sucesso =====
   📋 Log: ...
   ```

3. Se a saída estiver conforme → **✅ tarefa concluída.** Não faça mais nada.

## ✅ Checklist de Validação

- [ ] Saída termina com `🎯 Backup semanal concluído com sucesso`
- [ ] Nenhuma mensagem `❌` nem `✖`
- [ ] Log criado em `guia-ia-local/cerebrum/logs/`

## 🆘 Tratamento de Erros

| Sintoma | Ação do Executor |
|---------|------------------|
| `❌ Snapshot FALHOU` | Marque **ESTA nota** com tag `#falha` e **PARE**. |
| `❌ git fetch FALHOU` | Marque `#falha` e **PARE** (sem rede?). |
| `❌ Push FALHOU` | Marque `#falha` e **PARE**. Não tente resolver conflitos. |
| `⚠️ Existem alterações NÃO commitadas` | **NÃO commite.** Registre no log e **PARE** — aguardar revisão. |
| Qualquer dúvida | Marque `#falha` e **PARE**. **Nunca improvise.** |

---

## 🔗 Fontes

- 🐚 Script: [`backup-semanal-executor.sh`](../../scripts/backup.sh)
- 💾 Snapshot: [`backup-cofre.sh`](../../scripts/backup.sh)
- 🌿 Conveções git: [`.opencode/convencoes/convencoes-git.md`](./runbook-git-sync.md)
- 📝 Template: [`template-runbook.md`](./README.md)

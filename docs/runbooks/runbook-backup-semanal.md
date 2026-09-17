---
title: "Runbook — Backup Semanal (Snapshot + Push GitHub)"
tipo: backup-semanal
frequencia: semanal
script: scripts/backup.sh + git push
logs: .planning/logs/
tags:
  - runbook
  - executor
  - backup
  - git
status: pronto
---

# 💾 Runbook — Backup Semanal (Snapshot + Push GitHub)

> [!CAUTION]
> **⚠️ LEGADO V1** — Este runbook contém procedimentos do Archimedes V1 (`archimedes-vault`) que foram substituídos no V2. Scripts referenciados podem não existir. Consulte `scripts/backup.sh`, `scripts/lint.sh` e `scripts/setup.sh` para os procedimentos atualizados.

> 🚨 **PARA O EXECUTOR — siga APENAS os passos abaixo. Não invente. Não pule. Não edite scripts.**

## 🎯 Contexto

Rotina semanal que (1) cria snapshot local do cofre e (2) publica commits locais pendentes no GitHub. Mantém o projeto com **2 cópias** (local + remoto). O script faz **todo** o trabalho — você apenas executa e valida a saída.

## ⚙️ Comandos (copiar/colar exatos)

1. Abra o terminal na raiz do cofre (`~/archimedes`) e execute **exatamente** este comando:

   ```bash
   ./scripts/backup.sh && git add -A && git commit -m "chore(backup): snapshot semanal" && git push origin main
   ```

2. **LEIA a saída inteira.** A execução bem-sucedida termina com:

   ```
   ==> ✅ [2/2] Snapshot concluído e deduplicado com sucesso!
   📋 Log: ...
   ```

3. Se a saída estiver conforme → **✅ tarefa concluída.** Não faça mais nada.

## ✅ Checklist de Validação

- [ ] Saída termina com `🎯 Backup semanal concluído com sucesso`
- [ ] Nenhuma mensagem `❌` nem `✖`
- [ ] Log criado em `.planning/logs/`

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

- 💾 Snapshot: [`backup.sh`](../../scripts/backup.sh) (restic)
- 🌿 Git sync: [`runbook-git-sync.md`](./runbook-git-sync.md)
- 📝 Template: [`README.md`](./README.md)

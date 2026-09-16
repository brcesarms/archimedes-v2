---
title: "Runbook — Backup e Limpeza de Temporários"
tipo: manutencao-diaria
frequencia: diaria
script: guia-ia-local/scripts/linux/manutencao-diaria-executor.sh
logs: guia-ia-local/cerebrum/logs/
tags:
  - runbook
  - executor
  - manutencao
  - backup
status: pronto
---

# 🧹 Runbook — Backup e Limpeza de Arquivos Temporários

> 🚨 **PARA O EXECUTOR — siga APENAS os passos abaixo. Não invente. Não pule. Não edite scripts.**

## 🎯 Contexto

Rotina diária que (1) faz backup offline do cofre e (2) remove temporários regeneráveis (caches, `__pycache__`, lixo de mais de uma semana). Mantém o projeto seguro e o disco limpo. O script faz **todo** o trabalho — você apenas executa e valida a saída.

## ⚙️ Comandos (copiar/colar exatos)

1. Abra o terminal e execute **exatamente** este comando:

   ```bash
   ~/archimedes-vault/guia-ia-local/scripts/linux/manutencao-diaria-executor.sh
   ```

2. **LEIA a saída inteira.** A execução bem-sucedida termina com:

   ```
   ===== 🎯 Manutenção diária concluída com sucesso =====
   📋 Log: guia-ia-local/cerebrum/logs/manutencao-<data>.log
   ```

3. Se a saída estiver conforme → **✅ tarefa concluída.** Não faça mais nada.

## ✅ Checklist de Validação

- [ ] Script executou sem mensagens `❌` nem `✖`
- [ ] Saída termina com `concluída com sucesso`
- [ ] Log criado em `guia-ia-local/cerebrum/logs/`

## 🆘 Tratamento de Erros

| Sintoma | Ação do Executor |
|---------|------------------|
| Saída contém `❌ Backup FALHOU` | Marque **ESTA nota** com tag `#falha` e **PARE**. Não tente corrigir. |
| Saída contém `✖` no final | Marque `#falha` e **PARE**. |
| Script não encontrado / sem permissão | Marque `#falha` e **PARE**. |
| Qualquer dúvida ou saída inesperada | Marque `#falha` e **PARE**. **Nunca improvise.** |

---

## 🔗 Fontes

- 🐚 Script: [`manutencao-diaria-executor.sh`](./runbook-saude-sistema.md)
- 💾 Backup: [`backup-cofre.sh`](../../scripts/backup.sh)
- 📝 Template: [`template-runbook.md`](./README.md)

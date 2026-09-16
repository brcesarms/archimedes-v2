---
title: "Runbook — Backup e Limpeza de Temporários"
tipo: manutencao-diaria
frequencia: diaria
script: scripts/backup.sh
logs: .planning/logs/
tags:
  - runbook
  - executor
  - manutencao
  - backup
status: pronto
---

# 🧹 Runbook — Backup e Limpeza de Arquivos Temporários

> [!CAUTION]
> **⚠️ LEGADO V1** — Este runbook contém procedimentos do Archimedes V1 (`archimedes-vault`) que foram substituídos no V2. Scripts referenciados podem não existir. Consulte `scripts/backup.sh`, `scripts/lint.sh` e `scripts/setup.sh` para os procedimentos atualizados.

> 🚨 **PARA O EXECUTOR — siga APENAS os passos abaixo. Não invente. Não pule. Não edite scripts.**

## 🎯 Contexto

Rotina diária que (1) faz backup offline do cofre e (2) remove temporários regeneráveis (caches, `__pycache__`, lixo de mais de uma semana). Mantém o projeto seguro e o disco limpo. O script faz **todo** o trabalho — você apenas executa e valida a saída.

## ⚙️ Comandos (copiar/colar exatos)

1. Abra o terminal na raiz do cofre (`~/archimedes-v2`) e execute **exatamente** este comando:

   ```bash
   ./scripts/backup.sh
   ```

2. **LEIA a saída inteira.** A execução bem-sucedida termina com:

   ```
   ===== 🎯 Manutenção diária concluída com sucesso =====
   📋 Log: .planning/logs/manutencao-<data>.log
   ```

3. Se a saída estiver conforme → **✅ tarefa concluída.** Não faça mais nada.

## ✅ Checklist de Validação

- [ ] Script executou sem mensagens `❌` nem `✖`
- [ ] Saída termina com `concluída com sucesso`
- [ ] Log criado em `.planning/logs/`

## 🆘 Tratamento de Erros

| Sintoma | Ação do Executor |
|---------|------------------|
| Saída contém `❌ Backup FALHOU` | Marque **ESTA nota** com tag `#falha` e **PARE**. Não tente corrigir. |
| Saída contém `✖` no final | Marque `#falha` e **PARE**. |
| Script não encontrado / sem permissão | Marque `#falha` e **PARE**. |
| Qualquer dúvida ou saída inesperada | Marque `#falha` e **PARE**. **Nunca improvise.** |

---

## 🔗 Fontes

- 💾 Backup: [`backup.sh`](../../scripts/backup.sh) (restic)
- 🩺 Lint: [`lint.sh`](../../scripts/lint.sh)
- 📝 Template: [`README.md`](./README.md)

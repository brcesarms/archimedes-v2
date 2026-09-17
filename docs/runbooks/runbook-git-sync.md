---
title: "Runbook — Sincronização Git (ACER ⇄ GEEKOM)"
tipo: git-sync
frequencia: diaria
script: scripts/backup.sh + git pull/push
logs: .planning/logs/
tags:
  - runbook
  - executor
  - git
  - sincronizacao
status: pronto
---

# 🔄 Runbook — Sincronização Git (ACER ⇄ GEEKOM)

> [!CAUTION]
> **⚠️ LEGADO V1** — Este runbook contém procedimentos do Archimedes V1 (`archimedes-vault`) que foram substituídos no V2. Scripts referenciados podem não existir. Consulte `scripts/backup.sh`, `scripts/lint.sh` e `scripts/setup.sh` para os procedimentos atualizados.

> 🚨 **PARA O EXECUTOR — siga APENAS os passos abaixo. Não invente. Não pule. Não edite scripts.**

## 🎯 Contexto

Mantém a ACER (máquina local) sincronizada com o GEEKOM (cofre principal). Executa `sync-cofre.sh` em modo `pull` (padrão, seguro) para trazer os commits. O script faz **todo** o trabalho — você apenas executa e valida a saída.

## ⚙️ Comandos (copiar/colar exatos)

1. Abra o terminal na raiz do cofre (`~/archimedes`) e execute **exatamente** estes comandos:

   ```bash
   git pull --rebase origin main
   git push origin main
   ```

2. **LEIA a saída inteira.** A execução bem-sucedida termina com:

   ```
   🎯 Sincronização concluída com sucesso! ✅
   ```

3. Se a saída estiver conforme → **✅ tarefa concluída.** Não faça mais nada.

## ✅ Checklist de Validação

- [ ] Script terminou com "Sincronização pull concluída com sucesso! ✅"
- [ ] Nenhuma linha de erro `❌` nem `✖` no final

## 🆘 Tratamento de Erros

| Sintoma | Ação do Executor |
|---------|------------------|
| `❌ Sem conexão com geekom (ssh geekom)` | Marque **ESTA nota** com tag `#falha` e **PARE**. O GEEKOM está offline. |
| `✖ Operação falhou. Erro: <n>` | Marque `#falha` e **PARE**. Não tente corrigir. |
| O script pede "Continuar? [s/N]" | **NUNCA** digite `s`. Pressione Enter para cancelar e marque `#falha` + **PARE**. |
| Qualquer dúvida ou saída inesperada | Marque `#falha` e **PARE**. **Nunca improvise.** |

---

## 🔗 Fontes

- 💾 Snapshot: [`backup.sh`](../../scripts/backup.sh) (restic)
- 🔌 SSH: [`bancada-instrucoes.md`](./bancada-instrucoes.md)
- 📝 Template: [`README.md`](./README.md)

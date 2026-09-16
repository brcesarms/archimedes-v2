---
title: "Runbook — Sincronização Git (ACER ⇄ GEEKOM)"
tipo: git-sync
frequencia: diaria
script: guia-ia-local/scripts/linux/sync-cofre.sh
logs: guia-ia-local/cerebrum/logs/
tags:
  - runbook
  - executor
  - git
  - sincronizacao
status: pronto
---

# 🔄 Runbook — Sincronização Git (ACER ⇄ GEEKOM)

> 🚨 **PARA O EXECUTOR — siga APENAS os passos abaixo. Não invente. Não pule. Não edite scripts.**

## 🎯 Contexto

Mantém a ACER (máquina local) sincronizada com o GEEKOM (cofre principal). Executa `sync-cofre.sh` em modo `pull` (padrão, seguro) para trazer os commits. O script faz **todo** o trabalho — você apenas executa e valida a saída.

## ⚙️ Comandos (copiar/colar exatos)

1. Abra o terminal e execute **exatamente** este comando:

   ```bash
   ~/archimedes-vault/guia-ia-local/scripts/linux/sync-cofre.sh
   ```

2. **LEIA a saída inteira.** A execução bem-sucedida termina com:

   ```
   🎯 Sincronização pull concluída com sucesso! ✅
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

- 🐚 Script: [`sync-cofre.sh`](./runbook-git-sync.md)
- 🔌 Conveções SSH: [`.opencode/convencoes/convencoes-ssh.md`](./bancada-instrucoes.md)
- 📝 Template: [`template-runbook.md`](./README.md)

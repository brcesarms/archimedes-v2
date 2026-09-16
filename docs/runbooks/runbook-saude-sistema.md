---
title: "Runbook — Saúde do Sistema (RAM, disco, IA)"
tipo: saude-sistema
frequencia: semanal
script: scripts/lint.sh
logs: .planning/logs/
tags:
  - runbook
  - executor
  - saude
  - monitoramento
status: pronto
---

# 🩺 Runbook — Saúde do Sistema (RAM, disco, IA)

> [!CAUTION]
> **⚠️ LEGADO V1** — Este runbook contém procedimentos do Archimedes V1 (`archimedes-vault`) que foram substituídos no V2. Scripts referenciados podem não existir. Consulte `scripts/backup.sh`, `scripts/lint.sh` e `scripts/setup.sh` para os procedimentos atualizados.

> 🚨 **PARA O EXECUTOR — siga APENAS os passos abaixo. Não invente. Não pule. Não edite scripts.**

## 🎯 Contexto

Rotina semanal que coleta métricas de saúde do GEEKOM: **memória, disco, processos Ollama/OpenCode, carga**. Serve para detectar problemas antes que impactem o uso. O script faz **todo** o trabalho — você executa e valida.

## ⚙️ Comandos (copiar/colar exatos)

1. Execute **exatamente**:

   ```bash
   ./scripts/lint.sh
   ```

2. **LEIA a saída.** A coleta termina com:

   ```
   ===== 🎯 Saúde do sistema coletada — revisar log =====
   📋 Log: ...
   ```

3. Se a saída terminar como acima → **✅ tarefa concluída.**

## ✅ Checklist de Validação

- [ ] Saída termina com `🎯 Saúde do sistema coletada`
- [ ] Log criado em `.planning/logs/`
- [ ] Se aparecer `⚠️  Disco acima de 90%` ou `⚠️ Ollama NÃO está rodando` → **anotar no log para revisão** (não é falha)

## 🆘 Tratamento de Erros

| Sintoma | Ação do Executor |
|---------|------------------|
| Script não executa / sem permissão | Marque **ESTA nota** com tag `#falha` e **PARE**. |
| `❌` em qualquer passo | Marque `#falha` e **PARE**. |
| Avisos `⚠️` (disco/RAM/Ollama parado) | **NÃO é falha** — apenas registre e continue. Quem decide é o Cérebro/usuário. |
| Qualquer dúvida | Marque `#falha` e **PARE**. **Nunca improvise.** |

---

## 🔗 Fontes

- 🩺 Validação: [`lint.sh`](../../scripts/lint.sh) (lychee + shellcheck + shfmt + gitleaks)
- 📝 Template: [`README.md`](./README.md)

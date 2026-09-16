---
title: "Runbook — Monitoramento das Rotinas (estatísticas)"
tipo: monitoramento
frequencia: diaria
script: guia-ia-local/scripts/linux/monitorar-executor.sh
logs: guia-ia-local/cerebrum/logs/
tags:
  - runbook
  - executor
  - monitoramento
  - estatisticas
status: pronto
---

# 📊 Runbook — Monitoramento das Rotinas

> 🚨 **PARA O EXECUTOR — siga APENAS os passos abaixo. Não invente. Não pule. Não edite scripts.**

## 🎯 Contexto

Rotina diária que varre os logs de todas as rotinas (`manutencao`, `saude-sistema`, `backup-semanal`), classifica cada execução em ✅ sucesso / ❌ falha e detecta **2+ falhas consecutivas** na mesma rotina. O resultado é gravado em `estado-falhas.md` — que o **Cérebro** lê ao iniciar sessão. Você **apenas executa e valida**; quem decide é o Cérebro.

## ⚙️ Comandos (copiar/colar exatos)

1. Execute **exatamente**:

   ```bash
   ~/archimedes-vault/guia-ia-local/scripts/linux/monitorar-executor.sh
   ```

2. **LEIA a saída inteira.** A execução bem-sucedida termina com:

   ```
   ✅ Monitoramento concluído — snapshot em: .../estado-falhas.md
   📋 Alertas: manutencao=... · saude=... · backup=...
   ```

3. Se a saída estiver conforme → **✅ tarefa concluída.** Não faça mais nada.

## ✅ Checklist de Validação

- [ ] Saída contém `✅ Monitoramento concluído`
- [ ] `estado-falhas.md` foi atualizado (verificar com `ls -la .../estado-falhas.md`)

## 🆘 Tratamento de Erros

| Sintoma | Ação do Executor |
|---------|------------------|
| `❌ ERRO: pasta de logs não encontrada` | Marque **ESTA nota** com tag `#falha` e **PARE**. |
| Nenhum arquivo `*.log` encontrado | **NÃO é falha.** Apenas registre e **PARE** (rotinas ainda não rodaram). |
| `🚨 ALERTA` na saída | **NÃO é falha da sua execução.** Deixe o alerta em `estado-falhas.md` e **PARE** — o Cérebro decide. |
| Qualquer dúvida | Marque `#falha` e **PARE**. **Nunca improvise.** |

---

## 🔗 Fontes

- 🐚 Script: [`monitorar-executor.sh`](./runbook-monitoramento.md)
- 📝 Template: [`template-runbook.md`](./README.md)
- 🧠 Arquitetura: [`estrutura-cofre.md`](./README.md)

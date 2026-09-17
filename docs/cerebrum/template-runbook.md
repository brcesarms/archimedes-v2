---
title: "TEMPLATE — Runbook de Manutenção"
tipo: <tipo-da-tarefa>
frequencia: <diaria|semanal|mensal>
script: <caminho-do-script>
logs: docs/cerebrum/logs/
tags:
  - runbook
  - executor
status: rascunho
---

# <emoji> <Nome da Tarefa>

> 🚨 **PARA O EXECUTOR — siga APENAS os passos abaixo. Não invente. Não pule. Não edite scripts.**

## 🎯 Contexto

<O que a tarefa faz e por quê. 2-3 frases curtas. NÃO inclua instruções paralelas aqui — o Executor só precisa do "o quê" e do "porquê".>

## ⚙️ Comandos (copiar/colar exatos)

1. <comando exato, sem placeholders ambíguos>
2. <como ler a saída: "a saída deve conter: ...">

## ✅ Checklist de Validação

- [ ] <critério objetivo 1 (ex: saída sem ❌)>
- [ ] <critério objetivo 2 (ex: log criado em ...)>

## 🆘 Tratamento de Erros

| Sintoma | Ação do Executor |
|---------|------------------|
| <erro X na saída> | Marque **ESTA nota** com tag `#falha` e PARE. Não tente corrigir. |
| <erro Y> | `#falha` + PARE. |
| Qualquer dúvida | `#falha` + PARE. **Nunca improvise.** |

---

## 🔗 Fontes

- <link do script>
- <link do template ou nota correlata>
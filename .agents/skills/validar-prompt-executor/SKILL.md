---
name: validar-prompt-executor
description: Validação de prompts do Executor mecânico em docs/cerebrum/prompts/. Garante que os prompts obrigatórios existem e estão íntegros.
---

# ✅ Skill: validar-prompt-executor

## Validação de Prompts do Executor

Esta skill garante que prompts do Executor estão presentes e válidos.

## 📋 O que fazer

1. Verificar diretório de prompts (`docs/cerebrum/prompts/`)
2. Verificar prompts obrigatórios:
   - `prompt-executor-diario.md`
   - `prompt-executor-auditoria.md`
3. Verificar estrutura básica dos prompts

## 📝 Resultado esperado

- Log de cada verificação com ✅ ou ❌
- Resumo final com status total
- Confirmação de que o Executor pode começar a trabalhar

## 🔗 Fontes

- 📄 Processo definido em: [`../../../AGENTS.md`](../../../AGENTS.md)
- 📁 Script original: `scripts/linux/validacoes/validar-prompt-executor.sh`

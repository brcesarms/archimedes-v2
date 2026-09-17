---
name: validar-teia
description: Validação da integridade da teia de conexões entre perfis, documentação central e configurações do cofre.
---

# 🕸️ Skill: validar-teia

## Validação da Teia de Conexões do Cofre

Esta skill valida que todos os nós da teia estão conectados e funcionando.

## 📋 O que fazer

1. Verificar nó central (`docs/guia-ia-local/MY-SETUP.md`)
2. Verificar referências aos perfis em MY-SETUP.md
3. Verificar links reversos (perfis → MY-SETUP.md)
4. Verificar opencode.json ↔ perfis
5. Verificar sistema Cérebro
6. Verificar Docs Essenciais
7. Gerar relatório de resumo

## 📝 Resultado esperado

- Log de cada verificação com ✅ ou ❌
- Resumo final com status total
- Sugestão de ações se houver falhas

## 🔗 Fontes

- 📄 Processo definido em: [`AGENTS.md`](../../../AGENTS.md)
- 📁 Script original: `scripts/linux/validacoes/valida-teia.sh`

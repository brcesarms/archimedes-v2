---
name: validar-scripts-cofre
description: Validação de segurança, headers e boas práticas nos scripts Linux/Windows do cofre. Verifica pipefail, permissões e ausência de segredos.
---

# 🔒 Skill: validar-scripts-cofre

## Validação de Scripts do Cofre

Esta skill valida scripts em busca de problemas de segurança e qualidade.

## 📋 O que fazer

1. Verificar se scripts têm `set -euo pipefail`
2. Verificar se scripts têm headers completos (`@author`, `@version`)
3. Verificar se há credenciais expostas em scripts
4. Verificar se há `rm -rf` em caminhos absolutos
5. Gerar relatório de resumo

## 📝 Resultado esperado

- Log de cada verificação com ✅ ou ❌
- Resumo final com quantidade de problemas
- Sugestão de ações se houver falhas

## 🔗 Fontes

- 📄 Processo definido em: [`AGENTS.md`](../../../AGENTS.md)
- 📁 Script original: `scripts/linux/validacoes/verificar-seguranca.sh`

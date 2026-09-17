# 📋 Plano: Teste do Orquestrador — Validar Scripts Linux

**Criado em:** 2026-09-14 · **Modo:** validar · **ID:** demo-validar-001

## 🎯 Objetivo

> Testar a skill orquestrador-archimedes exercitando o Modo Validar nos scripts Linux do cofre (14 arquivos).

## Fases

### Fase 1: Validar scripts de manutenção (8 arquivos)
- [ ] Verificar `set -euo pipefail`
- [ ] Verificar headers (@author, @version)
- [ ] Verificar ausência de segredos
- [ ] Verificar ausência de `rm -rf /`
- [ ] Verificar sintaxe (bash -n)

### Fase 2: Validar scripts de sistema e validacoes (6 arquivos)
- [ ] Verificar `set -euo pipefail`
- [ ] Verificar headers (@author, @version)
- [ ] Verificar ausência de segredos
- [ ] Verificar ausência de `rm -rf /`
- [ ] Verificar sintaxe (bash -n)

## 📌 Restrições

- 🚫 NUNCA inventar comandos — usar apenas os documentados
- 📍 NUNCA chutar paths — usar apenas caminhos absolutos
- 🔍 SEMPRE verificar saída (ls/wc/exit code)
- 🆘 Em dúvida → PARE e marque `#falha`

## ✅ Próximo passo

> Iniciar Fase 1
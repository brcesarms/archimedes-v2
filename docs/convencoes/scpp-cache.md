# 💾 Orçamento de Tokens (SCPP Lite — calibrado 24k)

> Carregue este arquivo quando estiver criando AGENTS.md ou convenções novas, ou quando precisar otimizar o consumo de contexto.
> Inspirado no SCPP (Standardized Context Pruning Protocol) de 2026.
> **Calibrado para a margem real de 24k usada no OpenCode do GEEKOM.**

## 📊 Estrutura de orçamento (24k total)

Para manter o contexto enxuto e eficiente, siga esta hierarquia:

```
┌─────────────────────────────────────────┐
│  🔴 CORE (40% ≈ 9.600 tok) — sempre carrega
│  AGENTS.md, identidade, segurança       │
├─────────────────────────────────────────┤
│  🟡 AUXILIAR (35% ≈ 8.400 tok) — sob demanda
│  Convenções auxiliares, skills          │
├─────────────────────────────────────────┤
│  🟢 OPCIONAL (25% ≈ 6.000 tok) — quando necessário
│  Notas longas, artigos, documentação    │
├─────────────────────────────────────────┤
│  ✋ RESERVA (20% ≈ 4.800 tok) — NUNCA preencher
│  Espaço para resposta do modelo         │
└─────────────────────────────────────────┘
```

> ⚠️ **Útil para resposta:** dos 24k, apenas ~19.2k (80%) podem ser preenchidos com texto estático/entrada. Deixe os ~4.8k de reserva para a resposta do modelo.

## 🎯 Regras práticas

### CORE (40% ≈ 9.600 tokens de 24k)
- Identidade do agente
- Regras de segurança
- Permissões
- Comportamento
- Guia de emojis
- Dados sensíveis

### AUXILIAR (35% ≈ 8.400 tokens)
- Convenções (git, ssh, scripts, auditoria, etc.)
- Skills carregadas sob demanda
- Referências de usuário (`ME.md`, `MY-SETUP.md`)

### OPCIONAL (25% ≈ 6.000 tokens)
- Notas lidas para resumo
- Artigos buscados na web
- Conteúdo para flashcards/estudos
- Documentação externa

## ⚠️ Cuidados

- **NÃO exceder 80% do contexto (≈19.2k)** em texto estático (deixe a reserva)
- **Se o contexto estiver > 70% (≈16.8k)** → resuma ou re-leia só o essencial
- **AGENTS.md ideal**: 150-250 linhas (Core)
- **Skills ideais**: 50-80 linhas cada
- **Convenções ideais**: 20-40 linhas cada

## 🔍 Verificação de saúde

```bash
# Verificar tamanho do AGENTS.md (em tokens estimados)
echo "AGENTS.md: ~$(( $(wc -c < AGENTS.md) / 4 )) tokens"

# Verificar total de convenções
echo "Convenções: ~$(( $(cat .opencode/convencoes/*.md | wc -c) / 4 )) tokens"

# Verificar total de skills
echo "Skills: ~$(( $(cat .opencode/skills/*/SKILL.md | wc -c) / 4 )) tokens"
```

## 🔗 Fontes
- [SCPP 2026 — IEEE AI Standards](https://standards.ieee.org/standard/2026-SCPP-01.html)
- [Lost in the Middle — Stanford](https://arxiv.org/abs/2307.03172)
- [Contexto 24k — boas práticas](./contexto-24k.md)
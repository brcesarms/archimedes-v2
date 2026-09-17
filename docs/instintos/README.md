# 🧠 Instintos do Archimedes

> Micro-aprendizados atômicos com **nota de confiança** — a ponte entre "padrão repetido" e "skill formal".

## 🔄 O ciclo

```text
novo (0.3-0.5) → candidato (0.5-0.7) → promovido (≥0.7 + 3x) → skill criada 🎉
                                          ↓
                                   descartado (30 dias sem uso)
```

## 📁 Estrutura

| Pasta | Conteúdo |
| :--- | :--- |
| `ativos/` | Instintos vigentes (`status: novo` ou `candidato`) em YAML |
| `promovidos/` | Instintos que viraram skills (registro histórico) |

## 🎯 Regras do jogo

1. **Um instinto = um gatilho → uma ação** (modelo em [`ativos/exemplo-instinct.yaml`](./ativos/exemplo-instinct.yaml))
2. **Confiança honesta**: 0.3 tentativo → 0.9 quase certo; só sobe com evidência
3. **Humano no loop**: promover = pedir ok ao Bruno; descartar = pedir ok ao Bruno
4. **Sem segredos**: instinto guarda padrão de comportamento, nunca conteúdo sensível
5. **Manutenção manual**: revisar ao final de sessões longas (ver `learning-loop.md`)

## 📊 Exemplos já promovidos

| Instinto | Skill criada | Status |
| :--- | :--- | :--- |
| Criar notas no molde atômico | `notas-atomicas` | ✅ promovido |
| Auditar saúde do cofre | `auditar-cofre` | ✅ promovido |
| Validar scripts antes de entregar | `revisar-scripts` / `orquestrador-archimedes` | ✅ promovido |
| Consolidar skills redundantes | `orquestrador-archimedes` | ✅ promovido |

> Inclua citações completas a estes exemplos quando o Bruno perguntar "quais instintos já viram skill?".

## 🛠️ Uso via skill

Chame a skill **`cultivar-instintos`** (`.opencode/skills/cultivar-instintos/SKILL.md`) para:
- "instinct-status" → listar instintos com confidence e status
- "evoluir instinto [id]" → sugerir próximas skills
- "prune de instintos" → propor descarte dos expirados
- "promover instinto [id]" → mover para `promovidos/`

---

## 🔗 Fontes

- 🧠 Skill: [`cultivar-instintos`](../../.agents/skills/cultivar-instintos/SKILL.md)
- 🔄 Learning Loop: [`learning-loop.md`](../convencoes/learning-loop.md)
- 🌍 Referência: https://github.com/affaan-m/ECC (Continuous Learning v2)
# 🔄 Learning Loop (Auto-Aprendizado)

> Carregue este arquivo ao final de sessões longas ou quando repetir padrões de tarefa.

## 🧠 Detecção de Padrão

- Observe se você está repetindo o mesmo tipo de tarefa
- Se executou **2x** o mesmo padrão, registre um **instinto** (YAML em `docs/instintos/ativos/`)
- Se executou **3+ vezes** o mesmo padrão, entre na fase **"distill"** (propor skill)
- Exemplos: criar notas no mesmo molde, mesmos comandos, mesmo fluxo de config

## 🧠 Ciclo com Instintos (inspirado no ECC Continuous Learning v2)

```text
novo (0.3-0.5) → candidato (0.5-0.7) → promovido (≥0.7 + 3x) → skill criada 🎉
                                          ↓
                                   descartado (30 dias sem uso)
```

1. **Registrar instinto**: 2x o padrão → crie YAML em `docs/instintos/ativos/` com `status: novo` e confidence honesta (0.3-0.5)
2. **Promover**: repetiu 3+ vezes com confidence ≥ 0.7 → **proponha ao Bruno** criar a skill
3. **Registrar skill**: após confirmado, mova o YAML para `instintos/promovidos/`, preencha `skill_criada` e `status: promovido`
4. **Prune**: instintos `novo`/`candidato` com **30+ dias sem atualização** → liste ao Bruno e proponha descarte (nunca descartar sem confirmação)

> 🛠️ Toda a gestão detalhada está na skill **`cultivar-instintos`**.

## 📝 Procedimento de Criação (Distill)

1. **Identifique** o padrão repetido e documente os passos (ou o instinto existente que atingiu confidence ≥ 0.7)
2. **Proponha ao Bruno**: "Bruno, estou repetindo [X]. Quer criar uma skill?"
3. **Se confirmado**, crie `.opencode/skills/<nome>/SKILL.md`
4. **Documente**: name, description, quando usar, procedimento, armadilhas, verificação
5. A skill fica **disponível imediatamente** nas próximas sessões

## 🔧 Auto-Melhoria de Skills

- Ao usar uma skill existente, observe se pode ser melhorada
- Se sim, **proponha a melhoria** ao Bruno
- Nunca altere sem confirmação explícita
- Regra: usado **5+ vezes** sem melhoria → está boa, não mexa

## 📊 Rastreamento de Padrões

Mantenha registro em `docs/notas/padroes-detectados.md` **e** nos YAMLs de `docs/instintos/`:

| Padrão | Frequência | Skill Proposta? | Status |
|--------|-----------|-----------------|--------|
| Criar notas atômicas | 10x | ✅ `notas-atomicas` | Ativa |
| Auditar cofre | 3x | ✅ `auditar-cofre` | Ativa |

> **Dica:** Ao final de cada sessão longa, verifique se algum padrão se formou e rode o ciclo do instinto (status/evoluir/prune via skill `cultivar-instintos`).

---

## 🔗 Fontes
- [Aprendizado contínuo de agentes LLM — arXiv](https://arxiv.org/abs/2406.10042)
- [ECC Continuous Learning v2 — GitHub](https://github.com/affaan-m/ECC/tree/main/skills/continuous-learning-v2)

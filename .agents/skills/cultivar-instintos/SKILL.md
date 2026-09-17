---
name: cultivar-instintos
description: Gestão de instintos (micro-aprendizados atômicos com confidence score) do Archimedes. Use quando o usuário pedir "instinto", "cultivar instintos", "registrar padrão", "promover instinto", "prune de instintos", "instinct-status", "evoluir instinto" ou quando um padrão de tarefa se repetir e merecer virar skill. Cria/gerencia YAMLs em docs/instintos/ e promove para skills via learning-loop.
compatibility: opencode
metadata:
  audience: ia-local
  workflow: aprendizado
---

# 🧠 Cultivar Instintos do Archimedes

Sistema de aprendizado contínuo inspirado no **Continuous Learning v2** do projeto ECC, adaptado ao tamanho do vault: **manual, leve e com humano no loop**.

> 💡 Um **instinto** é um micro-aprendizado atômico: 1 gatilho → 1 ação, com **nota de confiança** e evidência. Quando um instinto se repete, vira **skill**.

## 📁 Onde ficam os instintos

```text
docs/instintos/
├── README.md            <-- Guia do ciclo completo
├── ativos/              <-- Instincts YAML válidos (status: novo|candidato)
└── promovidos/          <-- Registro de instintos que viraram skills
```

## 🎯 Quando criar um instinto

- Repetiu **2x** o mesmo padrão de tarefa → crie o instinto com confiança baixa (0.3-0.5)
- Padrão de erro recorrente ("toda vez que faço X, acontece Y")
- Correção do Bruno que se repetiu ("quando fizer X, prefira Y")
- Fluxo de trabalho que executou várias vezes na mesma sessão

## 📄 Formato do YAML (modelo obrigatório)

```yaml
---
id: nome-curto-do-instinto
titulo: "Título humano do instinto"
trigger: "quando <situação disparadora>"
action: "fazer <ação recomendada>"
domain: "script-linux | notas | git | ssh | bancada | redes | workflow"
confidence: 0.5
scope: "vault"
evidencia:
  - "2026-09-13: descrição da observação"
  - "2026-09-15: repetiu o padrão em nova sessão"
status: "novo"
criado_em: "2026-09-13"
atualizado_em: "2026-09-13"
skill_criada: ""
---
```

### Escala de confiança (adotada do ECC)

| Score | Significado | Comportamento |
| :--- | :--- | :--- |
| 0.3 | Tentativo | Apenas registrado, não aplicado |
| 0.5 | Moderado | Aplicado quando relevante |
| 0.7 | Forte | Vira candidato a skill |
| 0.9 | Quase certo | Comportamento central |

**Aumenta** quando: padrão se repete, Bruno não corrige, e evidências concordam.
**Diminui** quando: Bruno corrige, padrão some por muito tempo, ou há evidência contrária.

## 🔄 Ciclo de vida (instinto → skill)

```text
novo (0.3-0.5) → candidato (0.5-0.7) → promovido (≥0.7 + 3x) → skill criada 🎉
                                          ↓
                                   descartado (30 dias sem uso)
```

### Passo a passo

1. **Registrar**: crie o YAML em `ativos/` com `status: novo` e scoring honesto
2. **Revisar**: ao final de cada sessão longa, confira se algum instinto repetiu
3. **Promover**: se o instinto alcançou **confidence ≥ 0.7 com 3+ evidências**, proponha ao Bruno criar a skill (Regra do 2x do learning-loop)
4. **Registrar skill**: após criar a skill, mova o YAML para `promovidos/`, preencha `skill_criada` e marque `status: promovido`
5. **Prune**: instintos `novo`/`candidato` com **30+ dias sem atualização** → mostre ao Bruno e proponha descarte (nunca descartar sem confirmação)

## 📊 Comandos úteis (chamadas no chat)

| Pedido do Bruno | Ação |
| :--- | :--- |
| "instinct-status" | Listar todos os YAMLs de `ativos/` com confidence e status |
| "evoluir instinto [id]" | Analisar candidatos e sugerir próximas skills |
| "prune de instintos" | Listar instintos expirados (30d) e propor descarte |
| "promover instinto [id]" | Mover para `promovidos/` e registrar skill |

## 🛡️ Regras de segurança

- 🔒 Instintos NUNCA contêm segredos, senhas ou trechos de código sensível — só padrões de comportamento
- 🧑‍🤝‍🧑 NUNCA promover instinto para skill sem confirmação explícita do Bruno
- 🗑️ NUNCA descartar/remover YAML sem confirmação explícita
- 📝 Atualizar `learning-loop.md` e o mapa do `AGENTS.md` sempre que criar/mover instinto

---

## 🔗 Fontes

- 🔄 Learning Loop: [`learning-loop.md`](../../convencoes/learning-loop.md)
- 🧠 Referência ECC (Continuous Learning v2): [skills/continuous-learning-v2 — GitHub](https://github.com/affaan-m/ECC/tree/main/skills/continuous-learning-v2)
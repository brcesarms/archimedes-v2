---
name: orquestrar-tarefa
description: "Divide tarefas longas (muitos arquivos) em passes de até 8, salvando progresso para retomada. Use quando o usuário pedir para ler/validar/editar mais de 8 arquivos, ou quando uma tarefa exigir múltiplas etapas sequenciais."
---

# 🤖 Orquestrar Tarefa Longa

> Use esta skill quando a tarefa envolver **mais de 8 arquivos** ou múltiplas etapas que podem estourar o contexto do modelo.

## 🎯 Quando usar

- ✅ "Leia todos os arquivos e valide X"
- ✅ "Edite/crie múltiplas notas"
- ✅ "Audite toda a pasta Y"
- ✅ Qualquer tarefa com >8 arquivos para processar

## 📋 Procedimento

### 1. Planejamento (antes de executar)

1. **Liste todos os arquivos** necessários para a tarefa
2. **Divida em passes** de até 8 arquivos cada
3. **Crie o arquivo de progresso** em `docs/notas/.progresso-tarefa.md`
4. **Apresente o plano** ao usuário antes de executar

### 2. Execução por passes

Para cada pass:

1. **Leia o progresso** (`docs/notas/.progresso-tarefa.md`)
2. **Processe os arquivos** do passo atual (máx. 8)
3. **Salve o resultado** parcial no arquivo de progresso
4. **Atualize o status** (marque arquivos como concluídos)
5. **Confirme conclusão** do passo antes de prosseguir

### 3. Relatório final

Após todos os passes:

1. **Leia todo o progresso** salvo
2. **Gere relatório consolidado** com achados
3. **Delete o arquivo de progresso** (`rm docs/notas/.progresso-tarefa.md`)
4. **Apresente o relatório** ao usuário

## ⚠️ Armadilhas conhecidas

| Armadilha | Solução |
|-----------|---------|
| Modelo lê >8 arquivos e perde o fio | Dividir em passes, salvar progresso |
| Progresso não é salvo | SEMPRE atualizar `.progresso-tarefa.md` a cada pass |
| Modelo ignora limite e lê tudo | Interrompa, refaça com passes menores |
| Arquivo de progresso fica órfão | Delete ao final da tarefa |

## 🔧 Ferramentas úteis

- `read` — ler arquivos individuais
- `glob` — listar arquivos por padrão
- `grep` — buscar conteúdo específico
- `write` — salvar progresso
- `edit` — atualizar progresso

## 📊 Exemplo de uso

```
Usuário: "Leia todos os 20 arquivos da pasta X e valide Y"

Archimedes:
1. Lista arquivos: 20 encontrados
2. Divide em 3 passes (8+8+4)
3. Cria .progresso-tarefa.md
4. Executa Passo 1 → salva progresso
5. Executa Passo 2 → atualiza progresso
6. Executa Passo 3 → gera relatório final
7. Delete .progresso-tarefa.md
8. Apresenta relatório ao usuário
```

## 🔗 Fontes

- [Contexto Eficiente — Regra 5](../../convencoes/contexto-eficiente.md)
- [Learning Loop](../../convencoes/learning-loop.md)

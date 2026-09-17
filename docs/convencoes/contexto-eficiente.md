# 🎯 Regras de Contexto Eficiente

> Carregue este arquivo quando estiver criando/editando um AGENTS.md, ou quando o contexto estiver ficando grande demais.
> Baseado em pesquisas de 2026 sobre otimização de contexto para LLMs locais.

## 🔴 Regra 1: Info crítica no topo (Lost in the Middle)

**Pesquisas mostram:** Modelos atendem bem o início e fim do contexto, mas ignoram o meio. Para 7B, o limite prático é ~16k-32k tokens.

**Como aplicar:**
- Instruções de identidade, segurança e permissões: **SEMPRE no topo**
- Regras de comportamento: **logo abaixo**
- Informação menos crítica: **meio/fundo**

## 🟡 Regra 2: Arquivos sob demanda (Progressive Disclosure)

**Pesquisas mostram:** Carregar tudo de uma vez polui contexto. Ler sob demanda é mais eficiente.

**Como aplicar:**
- Convenções → ler só quando precisar (já fazemos com tabelas de links)
- Skills → o OpenCode carrega via `skill` tool (já fazemos)
- Notas → ler só quando pedido

## 🟢 Regra 3: Manter prefixo estável (Caching)

**Pesquisas mostram:** Se o prompt inicial (system) não muda entre sessões, o modelo pode "cachear" e responder mais rápido.

**Como aplicar:**
- **NÃO** alterar AGENTS.md sem necessidade real
- **NÃO** mover seções frequentemente
- **SIM** usar convenções auxiliares (fora do Core) para mudanças

## 🔵 Regra 4: Resumir antes de continuar

**Pesquisas mostram:** Quando o contexto está > 70%, o modelo começa a perder qualidade.

**Como aplicar:**
- Se o contexto estiver grande → resuma o que foi feito até agora
- Prefira re-leitura de arquivos ao invés de manter tudo em memória
- Use subagents para tarefas que leem muito conteúdo

## 🟠 Regra 5: Passes de Execução (anti-perda de contexto)

**Problema:** Quando o modelo lê muitos arquivos (>8) em tool-calling, o contexto enche e ele para no meio, perdendo o objetivo da tarefa.

**Como aplicar:**
- **Limite:** máximo **8 arquivos** por pass de execução
- **Memória:** salvar progresso em `docs/notas/.progresso-tarefa.md` antes de cada pass
- **Retomada:** se travar, reler `.progresso-tarefa.md` e continuar de onde parou
- **Tarefas longas:** dividir em passes sequenciais (8 → 8 → ... → relatório final)

**Template de progresso** (criar临时mente no início da tarefa):
```markdown
# 📊 Progresso da Tarefa
## 🎯 Objetivo: [descrição]
## 📁 Arquivos pendentes: [lista]
## ✅ Concluído: [lista]
## ⏳ Status: [passo X de Y]
```

**Exemplo de divisão:**
- Tarefa: "Leia 20 arquivos e gere relatório"
- Pass 1: arquivos 1-8 → salvar progresso
- Pass 2: arquivos 9-16 → atualizar progresso
- Pass 3: arquivos 17-20 + ler progresso → gerar relatório

**⚠️ Armadilha:** Se o modelo ignorar esta regra e ler tudo de uma vez, interrompa e refaça com passes menores.

## 📊 Referência rápida

| Tamanho AGENTS.md | Status | Ação |
|-------------------|--------|------|
| < 150 linhas | 🟢 Ótimo | Nada a fazer |
| 150-250 linhas | 🟡 Ideal | Meta a manter |
| 250-300 linhas | 🟠 Apertado | Considerar mover seções |
| > 300 linhas | 🔴 Muito grande | OTIMIZAR IMEDIATAMENTE |

## 🔗 Fontes
- [Lost in the Middle — Stanford](https://arxiv.org/abs/2307.03172)
- [SCPP 2026](https://standards.ieee.org/standard/2026-SCPP-01.html)
- [AGENTS.md Best Practices 2026](https://thepromptshelf.dev/blog/agents-md-best-practices-2026/)

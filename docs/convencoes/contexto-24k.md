# 🎯 Boas Práticas para 24k de Contexto

> Carregue este arquivo quando estiver trabalhando no OpenCode do GEEKOM/ACER (margem real: **24k**).
> Complementa [`contexto-eficiente.md`](./contexto-eficiente.md) (regras genéricas) e [`scpp-cache.md`](./scpp-cache.md) (orçamento).

## 🧮 Números que você deve decorar

| Métrica | Valor | Ação |
|---------|-------|------|
| 🔴 Limite total | 24.000 tokens | Nunca passar |
| 🟠 Limite estático | ~19.200 (80%) | Parar de carregar conteúdo |
| 🟡 Gatilho de resumo | ~16.800 (70%) | Resumir ANTES de continuar |
| 🟢 Reserva de resposta | ~4.800 (20%) | Deixar sempre livre |

## 📏 Passes de Execução (anti-perda de contexto)

> **Regra de ouro a 24k: máximo 5 arquivos por pass** (não 8 — contexto enche mais rápido).

- **Passes:** no máx. **5 arquivos** → salvar progresso em `docs/notas/.progresso-tarefa.md`
- **Retomada:** reler `.progresso-tarefa.md` e continuar de onde parou
- **Tarefas longas:** dividir em passes sequenciais (5 → 5 → ... → relatório final)
- **8+ arquivos:** delegar para subagent (`resumidor`/`estudante`) — isola o consumo de tokens

**Template de progresso** (criar temporariamente no início da tarefa):
```markdown
# 📊 Progresso da Tarefa
## 🎯 Objetivo: [descrição]
## 📁 Arquivos pendentes: [lista]
## ✅ Concluído: [lista]
## ⏳ Status: [passo X de Y]
```

## 🧹 Higiene de Leitura

- **NUNCA** despejar saída inteira de comando — truncar logs a **50 linhas** (`| tail -50`)
- **NUNCA** ler convenção + skill + nota na mesma etapa — **uma coisa por vez**
- Preferir `grep`/`glob` a `read` de arquivos grandes
- `read` com `limit`/`offset` para arquivos longos (não ler 2000 linhas de uma vez)
- **Re-leitura** de arquivos em vez de manter conteúdo em memória

## 🔌 Autonomia SSH (lição do teste 2026-09-09)

> O `qwen3-coder:30b` no modo `run` não-interativo **auto-rejeita permissões `ask`** → trava na primeira ação.

- **Modo `run` (autônomo):** usar permissões `allow` para ações determinísticas seguras (ex: `ssh laptop-brn *`)
- **Modo interativo:** `ask` ok (o Bruno aprova na hora)
- **Documentar** convenções SSH antes de testar — o modelo precisa "conhecer" o ambiente para resolver sozinho
- Verificar `~/.ssh/config` + `known_hosts` antes de delegar tarefas SSH

## ⚡ Outros Consumidores de Contexto

- `--print-logs` e `--format json` → **só em diagnóstico** (poluem muito)
- `--share` → nunca (envia contexto para nuvem)
- Sessão longa → preferir `-c` (continuar) sobre nova sessão (evita re-carregar system prompt)
- Skills de auditoria (`auditar-cofre`, `auditar-skills`) → delegar para subagent quando possível

## ✅ Checklist rápido antes de tarefa grande

- [ ] Orçamento estimado? (CORE + AUX + OP < 19.2k)
- [ ] Dividi em passes de ≤5 arquivos?
- [ ] Convenção necessária já carregada?
- [ ] Permissões adequadas ao modo (run/interativo)?
- [ ] Arquivo de progresso criado?

## 🔗 Fontes
- [Contexto Eficiente — regras gerais](./contexto-eficiente.md)
- [SCPP — orçamento de tokens](./scpp-cache.md)
- [Lost in the Middle — Stanford](https://arxiv.org/abs/2307.03172)
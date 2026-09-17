# ADR-002: Estratégia Local-First para Economia de Tokens

- **Data:** 2026-09-17
- **Status:** Aceita (implementada nas Fases 1-4, plan `2026-09-17-integracao-local-primeiro-estagiario`)
- **Autor:** Archimedes V2 + Bruno César

## Contexto

O Archimedes V2 opera como agente de IA no OpenCode com provider cloud. Cada
sessão consome tokens de entrada/saída. Grande parte das tarefas é rotineira
(FAQ de infra, runbooks, diagnósticos simples, resumos), não exigindo
raciocínio profundo. O hardware local (GEEKOM A7 MAX + LXC 104 com GPU ROCm)
já hospeda: `archimedes:latest` (fine-tune Qwen3-4B estilo do cofre), RAG
(LanceDB) e `claude-mem` (memória persistente).

## Decisão

Adotar **local-first** como arquitetura de execução: todo trabalho que puder
rodar local (Ollama 4B, RAG, claude-mem, scripts) roda local; a API cloud é
usada **somente** para raciocínio profundo (planejamento, arquitetura,
refatoração, pesquisa).

| Camada | Ferramenta | Custo |
|--------|-----------|:---:|
| Busca semântica | `archimedes-rag` (LanceDB) | R$ 0 |
| FAQ / runbooks / rotina | `estagiario` (Ollama LXC 104) | R$ 0 |
| Memória / compressão | `claude-mem` worker com `archimedes:latest` | R$ 0 |
| Rotina diária | `rotina-dia.sh` (lint + RAG + restic) | R$ 0 |
| Raciocínio profundo | Archimedes cloud (via OpenCode) | tokens |

## Roteador (regra simples)

| Gatilho na pergunta | Rota |
|---------------------|------|
| "buscar/onde está/achar função" | 🔍 RAG local |
| FAQ de infra, explicação curta, resumo | 🦙 estagiário local |
| Rotina/lint/backup | ⚡ executor + `rotina-dia.sh` |
| "resuma/transforme em notas" | 📊 subagente resumidor |
| Planejamento/refatoração/arquitetura | 🏛️ Archimedes cloud |

## Consequências

**Positivas:**
- Economia estimada de 30-50% dos tokens de cloud (FAQ/rotina = ~55% do trabalho)
- RAG reduz ~95% do contexto em buscas; claude-mem não custa tokens
- Sobrança: rotina diária 100% gratuita

**Negativas / riscos:**
- Estagiário 4B tende a responder perguntas de arquitetura em vez de delegar
  (aceito; monitorar)
- Contexto 8K do estagiário limita prompts longos
- Dependência do LXC 104 (se o Ollama cair, camada local degrada, mas scripts
  de rotina reportam e seguem)

## Alternativas consideradas

1. **Escalar tudo na cloud** — simples, porém 100% dos tokens pagos.
2. **Fine-tune round 2 com dataset maior** — adiado (round 1 + persona atende);
   reavaliar se o estagiário mostrar alucinação sistemática.
3. **Roteador heurístico completo** — complexo demais para o ganho; regra
   simples por gatilho já cobre o caso.

## Verificação

- `./scripts/rotina-dia.sh` — rodou completo (lint + RAG + restic) sem cloud
- `estagiario` respondeu FAQ em 3,6-6,9 s com tool calling nativo
- `./scripts/metricas-tokens.sh` — totais de 10 sessões: 6,8M input / 1,75M
  output, custo 0.0 (provider local)

## Referências

- Plan: `.planning/2026-09-17-integracao-local-primeiro-estagiario/`
- Docs: `docs/finetune/ESTAGIARIO.md` · `docs/benchmarks/HISTORICO.md`
- Commit: `0c24a59`
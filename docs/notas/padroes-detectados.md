# 🔄 Padrões Detectados — Gestão Git/GitHub

> Registro de padrões repetidos no fluxo de versionamento do cofre (atualizado 2026-09-07).

## 🧠 Padrão 1: Reestruturação modular (repo único + submódulos)

- **Frequência:** 1x (migração em 2026-09-07) — vai se repetir a cada formatação
- **Passos:** criar repos → `git init` nos submódulos → push → `git submodule add` → mover sistema para `docs/guia-ia-local/` → commit raiz → push
- **Skill/convenção:** ✅ [`convencoes-git.md`](../convencoes/convencoes-git.md)
- **Status:** ✅ Documentado

## 🧠 Padrão 2: Testes do modelo local com GitHub

- **Frequência:** 1x (2026-09-07) — recomendado repetir a cada novo modelo
- **5 testes:** git básico, submódulos, API GitHub, estrutura do cofre, segurança
- **Resultado (gemma4:26b no GEEKOM):** ✅ 5/5 corretos
- **Skill/convenção:** ✅ [`convencoes-git.md`](../convencoes/convencoes-git.md)
- **Status:** ✅ Documentado

## 🧠 Padrão 3: Token GitHub exposto em chat

- **Frequência:** 1x (2026-09-07) — ⚠️ evitar a todo custo
- **Lição:** nunca enviar token/senha no chat; usar variável de ambiente `GITHUB_TOKEN`
- **Skill/convenção:** ✅ [`convencoes-git.md`](../convencoes/convencoes-git.md) (seção Segurança)
- **Status:** ✅ Documentado (revogação ficou a critério do Bruno)

## 📊 Resumo

| Padrão | Frequência | Documentado? | Local |
|--------|-----------|:------------:|-------|
| Reestruturação modular | 1x | ✅ | `convencoes-git.md` |
| Teste modelo + GitHub | 1x | ✅ | `convencoes-git.md` |
| Token em chat (evitar) | 1x | ✅ | `convencoes-git.md` |
| Unificação de modelo local (gemma4:26b) | 1x | ✅ | `convencoes-git.md` |
| Benchmark tok/s ≠ comportamento agêntico | 1x | ✅ | `docs/guia-ia-local/tests/resultados-velocidade.md` |
| Falso sucesso opencode run headless + portabilidade | 1x | ✅ | `docs/guia-ia-local/tests/resultados-velocidade.md` |

## 🧠 Padrão 4: Unificação de modelo local (OpenCode)

- **Frequência:** 1x (2026-09-07) — recomendado sempre ao calibrar o GEEKOM
- **Problema:** configuração usava `gemma4:26b-64k` e OpenCode `gemma4:26b` → 2 registros no Ollama → troca de modelo = recarga de 18GB (minutos!)
- **Solução:** unificar tudo em `gemma4:26b` (32k) + `OLLAMA_KEEP_ALIVE=24h` + `OLLAMA_MAX_LOADED_MODELS=1`
- **Benchmark GEEKOM (iGPU 780M, 17.2GB VRAM):**
  - gemma4:26b: 23.8 tok/s, 3.7GB VRAM (MoE A4B) ✅ campeão folga
  - qwen3-coder:30b: 33.8 tok/s, 21.8GB ❌ estoura VRAM
  - qwen3:14b: 9.1 tok/s, 19.7GB ❌ denso + lento
  - gpt-oss:20b: 20.5 tok/s, 12.8GB ⚠️ intermediário
- **Conclusão pesquisa 2026:** Gemma 4 é "best general-purpose pick para 24GB VRAM" tool calling
- **Lições:** cold start estoura timeout 300s → manter quente; NUNCA `echo $TOKEN` no bash (modelo imprime!)

## 🧠 Padrão 5: Troca de modelo = gargalo silencioso

- **Frequência:** recorrente se houver múltiplos modelos
- **Sintoma:** agente trava, timeout no prefill, log fica parado
- **Causa:** `OLLAMA_MAX_LOADED_MODELS=1` + modelos diferentes entre ferramentas
- **Regra:** UMA ferramenta = UM modelo; evite duplicatas (-64k, -16k)
- **Status:** ✅ Documentado em `convencoes-git.md`

## 🧠 Padrão 6: Auditoria anti-gargalo do GEEKOM

- **Frequência:** 1x (2026-09-07) — recomendado re-auditar a cada 2 meses ou após mudança de modelo
- **Problemas encontrados fora do padrão recomendado:**
  1. `OLLAMA_FLASH_ATTENTION=0` (deveria ser 1) — causa prefill lento
  2. Modelos duplicados no Ollama (mesmo blob em várias tags): gemma4-64k, laguna-64k, laguna-16k
  3. `opencode.json` com modelo inexistente (`gpt-oss:20b-16k`) e sem timeout
  4. Skills duplicadas de auditoria (vault-auditor, vault-health-monitor, cofre-backup)
- **Correções:** flash attention ON (+36% tok/s), remoção de duplicatas, timeout 480s, consolidação de skills (15→12)
- **Resultado:** geração 23.8 → **32.3 tok/s**
- **Status:** ✅ Documentado em `auditoria-vault.md`

## 🧠 Padrão 7: Verificação de modelos derivados (-64k, -16k)

- **Frequência:** sempre que configurar novos modelos
- **Regra:** usar a TAG OFICIAL, NUNCA criar derivada como `gemma4:26b-64k` — cria 2º registro = recarga de modelo ao alternar entre ferramentas
- **Sintoma:** travamento silencioso, timeout no prefill, agente parado
- **Status:** ✅ Documentado em `convencoes-git.md`

## 🧠 Padrão 8: Benchmark de tok/s NÃO prevê comportamento agêntico (teste real!)

- **Frequência:** sempre ao trocar modelo padrão de ferramenta agêntica (OpenCode)
- **Causa raiz:** o `qwen3.6:35b-a3b` tinha tok/s bruto MAIOR (32 vs 25) que o `gemma4:26b`, então foi configurado como padrão do OpenCode — **mas no teste agêntico REAL travou em loop (>25min) em tarefa de escrita**, enquanto o `gemma4:26b` terminou em 4min.
- **Lição:** SEMPRE medir (1) velocidade de leitura e (2) velocidade de EXECUÇÃO + capacidade de CONCLUIR na ferramenta real, não só tok/s isolado.
- **Resultado (08/09):** `gemma4:26b` = melhor padrão p/ OpenCode (conclui tarefas, segue convenções com emojis e dentro do cofre). `qwen3.6:35b-a3b` = alternativa p/ leitura rápida/chat.
- **Ferramenta de teste:** `docs/guia-ia-local/tests/teste-velocidade-opencode.sh` + resultados em `docs/guia-ia-local/tests/resultados-velocidade.md`
- **Status:** ✅ Documentado + reverter config p/ `gemma4:26b`

## 🧠 Padrão 9: Falso sucesso no `opencode run` headless + portabilidade

- **Frequência:** sempre ao rodar OpenCode em modo headless (`run`)
- **Problema 1 (falso sucesso):** `opencode run` retorna `exit 0` mas NÃO executa `edit`/`bash` porque permissões `ask` são **auto-rejeitadas** em modo headless (sem usuário p/ aprovar). Resultado: arquivo não criado, mas exit 0 → parece que deu certo.
- **Problema 2 (portabilidade):** o modelo criou script apontando para `$HOME/...` (FORA do cofre) — viola a regra "tudo dentro do cofre".
- **Soluções:**
  - Para teste headless: usar `opencode run --auto` (aprova permissões; "dangerous" — usar só em tarefa controlada). Nunca interpretar exit 0 sem verificar o arquivo/logs.
  - Portabilidade: NUNCA criar/rodar nada fora de `~/archimedes`; testes vivem em `docs/guia-ia-local/tests/`.
- **Status:** ✅ Documentado + corrigido (`benchmark-moe.sh` agora salva dentro do cofre)

---

## 🔗 Fontes
- [Learning Loop — convenção](../convencoes/learning-loop.md)
- [Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
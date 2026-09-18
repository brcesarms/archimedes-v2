---
name: orquestrador-archimedes
description: "Orquestração unificada de tarefas longas do Archimedes com plano persistente em disco (task_plan.md, findings.md, progress.md). Use quando o usuário pedir 'orquestrar', 'tarefa longa', 'planejar execução', 'caderno de tarefas', 'auditar vários arquivos', 'bancada', 'executar bancada', 'validar scripts' ou quando a tarefa envolver mais de 8 arquivos ou múltiplas etapas sequenciais. Modos: padrão (qualquer tarefa complexa), bancada (orquestrador Python externo) e validar (scripts do cofre)."
compatibility: agy, hermes
metadata:
  audience: ia-local
  workflow: automacao
---

# 🤖 Orquestrador Archimedes

> **Missão:** "Planeja, executa, valida e reporta." — O caderno de anotações do funcionário que nunca esquece o que fazer. 🏛️
> **Substitui:** `orquestrar-tarefa`, `bancada-execucao` e `validar-scripts-cofre`.

---

## 🚨 REGRAS ANTI-ALUCINAÇÃO (OBRIGATÓRIAS)

> ⚠️ Estas camadas são **invioláveis**. Viola alguma → `#falha` imediatamente.

| # | Camada | Regra |
|:---:|---|---|
| 1 | **Regra restritiva** | 🚫 NUNCA invente comandos, flags ou parâmetros. Use APENAS os listados abaixo. |
| 2 | **Caminhos absolutos** | 📍 NUNCA chute paths. Use apenas os caminhos documentados nesta skill. |
| 3 | **Exemplos com saída** | 📋 Copie o formato dos exemplos — não crie estruturas novas. |
| 4 | **Verificação pós-ação** | 🔍 SEMPRE prove que fez: `ls`/`wc`/exit code. Relatório verbal NÃO é evidência. |
| 5 | **Modo degraded** | 🆘 Em dúvida sobre host, path, comando ou destino → **PARE** e marque `#falha`. |
| 6 | **Restrição de aliases** | ⚙️ Use apenas scripts reais com caminho documentado. NUNCA improvise equivalentes. |

> 🧠 **Lembrete:** Um bom funcionário anota e reconhece quando não sabe. Nunca "finge que sabe" para parecer útil.

---

## 🎯 Quando usar

- ✅ "Leia todos os arquivos e valide X" (>8 arquivos)
- ✅ "Audite toda a pasta Y"
- ✅ "Edite/crie múltiplas notas"
- ✅ "Bancada" / "executar bancada" → **Modo bancada**
- ✅ "Validar scripts" / "revisar cofre" → **Modo validar**
- ✅ Qualquer tarefa com múltiplas etapas sequenciais

## 🚫 Quando NÃO usar

- ❌ Tarefas simples (1-2 arquivos, uma ação)
- ❌ Esta skill não substitui as demais skills específicas (auditar-cofre, backup-cofre, etc.)

---

## 📓 O CADERNO (Padrão de 3 Arquivos)

### Onde o caderno é criado

```
<contexto-da-tarefa>/
├── task_plan.md      ← Plano: fases + checkboxes (o ponto de retomada)
├── findings.md       ← Descobertas: anotações de pesquisa e decisões
└── progress.md       ← Progresso: log de sessão e resultados
```

| Modo | Onde criar o caderno |
|---|---|
| **Padrão** | `docs/notas/.plano-tarefa/` (temporário — limpo ao final) |
| **Bancada** | NAO criar — orquestrador Python gerencia o fluxo completo |
| **Validar** | `docs/notas/.plano-tarefa/` (temporário — limpo ao final) |

### 📄 Formato dos arquivos (copie EXATAMENTE estes templates)

#### `task_plan.md`

```markdown
# 📋 Plano: <nome-da-tarefa>

**Criado em:** <data> · **Modo:** <padrao|bancada|validar>

## Fases

### Fase 1: <nome-da-fase>
- [ ] <tarefa 1>
- [ ] <tarefa 2>
- [ ] <tarefa 3>

### Fase 2: <nome-da-fase>
- [ ] <tarefa 1>
- [ ] <tarefa 2>

## Próximo passo
> <o que falta fazer — atualizado a cada sessão>
```

> Templates completos em: [templates/task_plan.md](./templates/task_plan.md)

---

## 🧭 OS 3 MODOS DE OPERAÇÃO

```
╔══════════════════════════════════════════════════════════╗
║  Modo PADRÃO: "Tarefa complexa qualquer"                 ║
║  Ex: auditar 20 scripts, criar 10 notas, revisar docs    ║
╠══════════════════════════════════════════════════════════╣
║  Modo BANCADA: "Fluxo operacional de cliente"            ║
║  Ex: inventário, backup robocopy, manifesto              ║
╠══════════════════════════════════════════════════════════╣
║  Modo VALIDAR: "Conferir scripts do cofre"               ║
║  Ex: verificar segurança, headers, segredos              ║
╚══════════════════════════════════════════════════════════╝
```

---

## ⚡ MODO PADRÃO — Execução por Passes

### Passo 1 — Planejamento (obrigatório antes de executar)

1. Liste TODOS os arquivos necessários (use `glob`)
2. Divida em passes de **até 8 arquivos**
3. Crie o caderno em `docs/notas/.plano-tarefa/` com os 3 arquivos
4. Apresente o plano ao usuário ANTES de executar

### Passo 2 — Execução por passes

Para cada pass, SEMPRE:

1. **Leia o progresso atual** (`progress.md`)
2. **Processe os arquivos** do pass atual (máx. 8)
3. **Atualize `progress.md`** após cada batch
4. **Atualize `task_plan.md`** (marque checkboxes concluídos)
5. **Anexe descobertas** em `findings.md` (decisões, erros, soluções)

### Passo 3 — Verificação (provar, não afirmar)

**NUNCA** declare "concluído" sem evidência:

| Verificação | Comando | Evidência esperada |
|---|---|---|
| Arquivo criado | `ls -la <path>` | Arquivo listado |
| Conteúdo completo | `wc -l <path>` | Linhas esperadas |
| Script válido | `bash -n <path>` | Saída vazia (sem erro de sintaxe) |
| Permissão correta | `ls -l <path>` | `-rwxr-xr-x` |

### Passo 4 — Relatório final

1. Leia TODO o progresso salvo
2. Gere relatório consolidado com: o que foi feito, o que encontrou, o que falta (se algo)
3. **Mova o caderno** para `docs/notas/historico/plano-<data>.md` (rastro permanente)
4. Delete a pasta temporária `.plano-tarefa/` se tiver sido movida
5. Apresente o relatório ao usuário em pt-BR com emojis

---

## 🏗️ MODO BANCADA — Operação de Cliente

> ⚠️ Este modo **NÃO cria caderno** — usa o orquestrador Python externo.

### Pré-requisitos (verificar ANTES de começar)

| Verificação | Comando EXATO |
|---|---|
| Projeto existe | `ls /home/brn/projetos/archimedes-operator/scripts/python/orquestrador.py` |
| Paramiko instalado | `python3 -c "import paramiko"` |
| Chave SSH | `ls ~/.ssh/id_ed25519` |

### Dados obrigatórios do usuário (pedir SEMPRE, nunca inventar)

| Dado | Flag | Obrigatório |
| :--- | :--- | :--- |
| IP/hostname da máquina | `--host` | ✅ |
| Usuário Windows | `--usuario` | ✅ |
| Nome do cliente | `--cliente` | ✅ |
| Storage central (UNC) | `--destino` | ⚠️ se omitir, pula backup |
| Caminho da chave | `--chave` | opt (padrão `~/.ssh/id_ed25519`) |

> 🆘 **Se faltar QUALQUER dado obrigatório → PARE e peça ao usuário. NUNCA adivinhe host.**

### Comando ÚNICO aceito (Camada 2 — caminho absoluto)

```bash
cd /home/brn/projetos/archimedes-operator && python3 /home/brn/projetos/archimedes-operator/scripts/python/orquestrador.py \
  --host <IP> \
  --usuario <USUARIO> \
  --cliente <CLIENTE> \
  --destino '\\storage-central\Bancada\<CLIENTE>' \
  --chave ~/.ssh/id_ed25519
```

> ⚠️ **Caminho UNC:** usar aspas simples — o shell interpreta contrabarras.

### Verificação obrigatória pós-execução

```bash
ls -la /home/brn/projetos/archimedes-operator/manifests/MANIFESTO_<CLIENTE>_*.md
wc -l /home/brn/projetos/archimedes-operator/manifests/MANIFESTO_<CLIENTE>_*.md
```

### Sinais de FALHA (Camada 5 — pare imediatamente)

| Sintoma | Ação |
|---|---|
| Inventário vazio | `#falha` — parar |
| Exit code robocopy >= 8 | Marcar falha no manifesto |
| Manifesto não existe | `#falha` — não fingir sucesso |
| Host não confirmado | Pedir ao usuário |

---

## 🔍 MODO VALIDAR — Scripts do Cofre

> ⚠️ Este modo NÃO inventa verificações. Use APENAS as listadas.

### Verificações padrão (copie esta lista)

| # | Verificação | Comando/Como | Esperado |
|:---:|---|---|---|
| 1 | Scripts têm `set -euo pipefail` | `grep -l "set -euo pipefail" <path>/*.sh` | Lista de scripts |
| 2 | Headers completos (`@author`, `@version`) | `grep -l "@author" <path>/*.sh` | Lista de scripts |
| 3 | Credenciais expostas | `grep -rn "senha\|password\|token\|secret" <path>/*.sh` | VAZIO |
| 4 | `rm -rf` em caminhos absolutos | `grep -rn "rm -rf /" <path>/*.sh` | VAZIO |
| 5 | Permissões de execução | `ls -l <path>/*.sh` | `-rwxr-xr-x` |

### Onde validar

| Alvo | Path EXATO |
|---|---|
| Scripts Linux | `/home/brn/archimedes/scripts/linux/` |
| Scripts Python | `/home/brn/archimedes/scripts/python/` |
| Scripts Windows | `/home/brn/archimedes/scripts/windows/` |

### Script de apoio (use este, não invente outro)

```bash
bash /home/brn/archimedes/.agents/skills/orquestrador-archimedes/scripts/verificar-saida.sh
```

### Relatório

Gere resumo com: ✅ passou / ❌ falhou, contagem de problemas, sugestão de correção.

---

## ⚠️ Armadilhas conhecidas

| ⚠️ Armadilha | ❌ Errado | ✅ Certo |
|---|---|---|
| Inventar comando para orquestrador | `python3 orquestrador.py --flag-nova` | Usar o comando ÚNICO documentado |
| Declarar sucesso sem prova | "Deu certo!" | `ls`/`wc` + evidência |
| Conectar host não confirmado | Conectar IP adivinhado | Pedir IP ao usuário |
| Caminho UNC no bash | `--destino "\\nas\Bancada\X"` | Aspas simples `'\\storage...'` |
| Perguntar progresso sem ler o caderno | "O que faltava mesmo?" | Ler `task_plan.md` |
| Continuar em dúvida | Improvisar | `#falha` + parar |

---

## 📊 Exemplo completo (Modo Padrão)

```
Usuário: "Leia os 20 arquivos da pasta X e valide Y"

Archimedes:
1. glob → 20 arquivos encontrados
2. Divide em 3 passes (8+8+4)
3. Cria caderno em docs/notas/.plano-tarefa/
   ├── task_plan.md  → Fase 1: 8 arquivos, Fase 2: 8, Fase 3: 4
   ├── findings.md   → vazio (aguardando descobertas)
   └── progress.md   → vazio
4. Apresenta plano ao usuário
5. Passo 1 → processa 8 → atualiza progress.md → ✅
6. Passo 2 → processa 8 → atualiza progress.md → ✅
7. Passo 3 → processa 4 → atualiza progress.md → ✅
8. Verificação pós-ação (ls/wc em cada resultado)
9. Move caderno para historico/
10. Relatório final em pt-BR com emojis
```

---

## ✅ Checklist antes de finalizar

- [ ] Caderno criado e usado durante toda a tarefa
- [ ] Nenhum comando inventado
- [ ] Todos os paths verificados (absolutos)
- [ ] Saída validada com `ls`/`wc`/exit code
- [ ] Nenhum host/credencial exposto
- [ ] Nenhum segredo em logs ou relatório
- [ ] Caderno movido para `historico/` (rastro)
- [ ] Sem `#falha` pendente

---

## 🔗 Fontes

- 📄 [Contexto Eficiente — Regra 5](../../convencoes/contexto-eficiente.md)
- 🔄 [Learning Loop](../../convencoes/learning-loop.md)
- 🏛️ [AGENTS.md](../../../AGENTS.md)
- 📖 Projeto Bancada (fora do vault): `/home/brn/projetos/archimedes-operator/docs/instrucoes.md`
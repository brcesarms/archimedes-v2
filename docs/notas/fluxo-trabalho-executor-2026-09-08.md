# 🦾 Fluxo de Trabalho do Executor

> **Objetivo:** Guia de referência rápida para o Executor (IA local)  
> **Modelo típico:** `qwen2.5-coder:7b` ou `gpt-oss:20b`  
> **Princípio:** Tudo deve ser **automático, claro e sem ambiguidade**

---

## 🎯 Visão Geral

| Papel | Responsável | Modelo Recomendado |
|-------|-------------|-------------------|
| **Cérebro** | Projeta rotinas | `qwen3-coder:30b` ou `big-pickle` |
| **Executor** | Executa rotinas | `qwen2.5-coder:7b` (Rápido e preciso) |
| **Humano** | Supervisiona e ajusta | Bruno (você!) |

---

## 📋 Rotina Diária do Executor

```
┌─────────────────────────────────────────────────────────────────┐
│                ⏰ ROTINA DIÁRIA DO EXECUTOR                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1️⃣ 7:00 AM  →  Rodar runbook-backup-limpeza.md               │
│     │                                                           │
│  2️⃣ 8:00 AM  →  Rodar runbook-saude-sistema.md                │
│     │                                                           │
│  3️⃣ 9:00 AM  →  Executar runbook-git-sync.md                  │
│     │                                                           │
│  4️⃣ 10:00 AM →  Executar runbook-auditoria-cofre.md           │
│     │                                                           │
│  5️⃣ 11:00 AM →  Gerar relatório (estado-falhas.md)           │
│     │                                                           │
│  6️⃣ 12:00 PM →  Reportar no cofre (logs/ + tags #falha)       │
│     │                                                           │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 Começando uma Sessão (Executor)

### Passo 1: Ler o prompt atual

**Localização:** `docs/cerebrum/prompts/prompt-executor-diario.md`

```markdown
# 🦾 Prompt do Executor — Rotina Diária

> Você é o Executor (IA local rápida). Sua tarefa hoje é:

1. Rodar runbook `runbook-backup-limpeza.md`
2. Rodar runbook `runbook-saude-sistema.md`
3. Gravar logs em `cerebrum/logs/`
4. Se falha: marcar com `#falha` e parar
```

### Passo 2: Executar cada runbook (seguir EXATAMENTE)

**Regra de Ouro:** 
- ✅ Ler o runbook completo
- ✅ Executar os comandos **exatos** da seção `⚙️ Comandos`
- ✅ Se falha: `#falha` na nota + PARE (nunca improvisar)
- ✅ Se sucesso: gravar log em `cerebrum/logs/`

### Passo 3: Reportar resultados

**Localização:** `cerebrum/logs/`

**Nome do arquivo:** `<runbook-base>-<timestamp>.log`

**Exemplo:**
```
manutencao-2026-09-08_080000.log
saude-sistema-2026-09-08_081000.log
```

---

## 🛠️ Quando as Coisas Dão Errado

### ❌ Caso 1: Comando falha

**O que fazer:**
1. Ler a mensagem de erro (não inventar)
2. Gravar no log: `❌ [ERRO] mensagem de erro`
3. Marcar o runbook com tag `#falha`
4. PARE (não tentar corrigir sozinho)

**Exemplo:**
```bash
# Se este comando falhar:
tar -czf "$ARCHIVE" ...

# Logar assim:
echo "❌ [ERRO] tar: Arquivo não encontrado: $ARCHIVE" >> "$LOG_FILE"
```

### ❌ Caso 2: Arquivo faltando

**O que fazer:**
1. Verificar se o arquivo existe: `[ -f "arquivo" ]`
2. Se não existe: `echo "❌ ERRO: arquivo não encontrado: $arquivo"`
3. Gravar no log
4. Marcar com `#falha` e PARE

### ❌ Caso 3: Dúvida sobre o que fazer

**O que fazer:**
1. Se não tem certeza: PARE
2. Gravar: `⚠️ [DÚVIDA] Não tenho certeza de como proceder`
3. Marcar com `#falha`
4. **NÃO improvisar nunca**

---

## 📚 Skills Disponíveis para o Executor

| Skill | Quando usar |
|-------|-------------|
| 🗒️ `notas-atomicas` | Criar ou editar notas |
| 🔗 `gerenciar-links` | Corrigir links quebrados |
| 🗺️ `criar-moc` | Criar mapa de conteúdo |
| 🗂️ `organizar-cofre` | Reorganizar pastas |
| 🏥 `auditar-cofre` | Verificar saúde do vault |
| 🔄 `backup-cofre` | Criar backup do cofre |
| 🐧 `script-linux` | Criar ou revisar scripts bash |
| 🔌 `revisar-scripts` | Validar scripts antes de rodar |

**Como usar:**
- Cada skill tem instruções em `.agents/skills/<nome>/SKILL.md`
- Não há necessidade de "invocar" — as skills são automaticamente carregadas
- Basta seguir as regras definidas na skill correspondente

---

## 📂 Estrutura para Seguir (Sempre!)

```
archimedes-vault/
├── docs/guia-ia-local/          # 📚 SISTEMA — Tudo que você precisa ler
│   ├── cerebrum/           #   🧠 Sistema Cérebro ↔ Executor
│   │   ├── prompts/        #     📋 Seus prompts (ler primeiro!)
│   │   │   ├── prompt-executor-diario.md
│   │   │   └── prompt-executor-auditoria.md
│   │   └── rotinas/        #     📋 Seus RUNBOOKS (ler cada um)
│   │       ├── runbook-backup-limpeza.md
│   │       ├── runbook-saude-sistema.md
│   │       └── ...
│   ├── scripts/            #   🐚 Scripts prontos (usar direto)
│   │   └── linux/
│   │       ├── backup-cofre.sh
│   │       └── ...
│   └── notas/              #   📝 Relatórios e logs
│       └── vault-health-report.md
├── opencode.json           # 📋 Sua configuração (não editar)
├── AGENTS.md               # 🧠 Quem é o J.A.R.V.I.S. (ler se tiver dúvida)
└── ...                     # (não precisa ler nada mais)
```

---

## ✅ Checklist de Início de Sessão

- [ ] Ler `cerebrum/prompts/prompt-executor-diario.md`
- [ ] Verificar `cerebrum/rotinas/` (quantos runbooks?)
- [ ] Executar `runbook-backup-limpeza.md` primeiro (obrigatório)
- [ ] Executar `runbook-saude-sistema.md` (obrigatório)
- [ ] Executar os demais runbooks na ordem listada
- [ ] Gravar logs em `cerebrum/logs/` com timestamp
- [ ] Se falha: `#falha` + PARE (nunca improvisar)

---

## 🆘 Comandos Úteis (Para Copiar/Colar)

```bash
# Verificar se diretório existe
[ -d "/caminho" ] && echo "✅ Existe" || echo "❌ Não existe"

# Verificar se arquivo existe
[ -f "/caminho/arquivo" ] && echo "✅ Existe" || echo "❌ Não existe"

# Criar diretório se não existir
mkdir -p "/caminho/destino"

# Ler conteúdo de arquivo
cat "/caminho/arquivo"

# Listar arquivos em diretório
ls -la "/caminho/"

# Gravar no log
echo "✅ Sucesso!" >> "/caminho/log.log"

# Verificar exit code
if [ $? -ne 0 ]; then
    echo "❌ Erro: $?" >> "/caminho/log.log"
    exit 1
fi
```

---

## 📋 Template de Log (Para Copiar/Colar)

```bash
# Criar log com timestamp
LOG_FILE="~/archimedes/docs/cerebrum/logs/runbook-$(date +%Y-%m-%d_%H%M%S).log"

# Escrever no log
echo "===== 🎯 Início da execução — $(date) =====" > "$LOG_FILE"

# Logar resultados
echo "✅ [1/3] Tarefa X concluída" >> "$LOG_FILE"
echo "✅ [2/3] Tarefa Y concluída" >> "$LOG_FILE"
echo "❌ [3/3] Tarefa Z falhou: mensagem de erro" >> "$LOG_FILE"

# Finalizar log
echo "===== 🎯 Execução concluída — $(date) =====" >> "$LOG_FILE"
```

---

## 🔄 Fluxo Completo de uma Tarefa

```
┌─────────────────────────────────────────────────────────────┐
│                   FLUXO DE UMA TAREFA                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Ler runbook em cerebrum/rotinas/                        │
│     ↓                                                        │
│  2. Executar comandos EXATOS da seção ⚙️ Comandos          │
│     ↓                                                        │
│  3. Se sucesso: gravar log em cerebrum/logs/                │
│     ↓                                                        │
│  4. Se falha: marcar runbook com #falha + PARE              │
│     ↓                                                        │
│  5. Reportar no próximo prompt (se houver)                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Regra de Ouro (Lembrar Sempre!)

> **"Se não tem certeza, PARE. Se tem certeza, EXECUTE exatamente o que está escrito."**

---

## 🔗 Fontes

- 📖 `cerebrum/prompts/prompt-executor-diario.md` — Seu prompt diário
- 📖 `cerebrum/rotinas/*.md` — Todos os seus runbooks
- 📖 `AGENTS.md` — Quem é o J.A.R.V.I.S.
- 📖 `docs/guia-ia-local/README.md` — Como usar o cofre
- 📖 `.agents/skills/` — O que cada skill faz

---

*Doc gerado por 🦾 J.A.R.V.I.S. em 2026-09-08*  
*Versão: 1.0.0 — Fluxo de Trabalho do Executor*  
*Objetivo: Tornar a vida do Executor o mais fácil e clara possível*

# 🕸️ MOC — Teia de Conexões do Cofre

> **Objetivo:** Centralizar todos os links e conexões do cofre em um mapa vivo  
> **Última atualização:** 2026-09-08  
> **Status:** ✅ Sincronizado com `MY-SETUP.md`

---

## 🌐 Mapa de Conexões

### 🎯 Nó Central: `MY-SETUP.md`
Este é o **coração da teia** — todas as máquinas, perfis e configurações partem deste arquivo.

```
┌─────────────────────────────────────────────────────────────┐
│              📂 docs/guia-ia-local/MY-SETUP.md                    │
│           (Coração da Teia de Conexões)                     │
│  • Especificações de hardware de todas as máquinas          │
│  • Referências para todos os perfis                         │
│  • Ponte entre setup e sistema                              │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│ PERFIS/      │     │ PERFIS/      │     │ PERFIS/      │
│ geekom.md    │     │ alienware.md │     │ acer-paula.md│
│ • Ryzen 9    │     │ • Core 7     │     │ • i3-1115G4  │
│ • 64GB RAM   │     │ • RTX 5060   │     │ • 12GB RAM   │
│ • Radeon 780M│     │ • 32GB RAM   │     │ • 22GB Swap  │
└──────────────┘     └──────────────┘     └──────────────┘
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              ▼
                    ┌──────────────────┐
                    │ opencode.json    │
                    │ • profiles: 3    │
                    │ • memory_limit   │
                    │ • cpu_threads    │
                    └──────────────────┘
```

---

## 🔗 Links Diretos (Todos os Arquivos Conectados)

### 1. **Setup/Hardware (Raiz da Teia)**

| Arquivo | Conecta a | Tipo |
|---------|-----------|------|
| `docs/guia-ia-local/MY-SETUP.md` | `PERFIS/geekom.md` | ➡️ Referência |
| `docs/guia-ia-local/MY-SETUP.md` | `PERFIS/alienware.md` | ➡️ Referência |
| `docs/guia-ia-local/MY-SETUP.md` | `PERFIS/acer-paula.md` | ➡️ Referência |
| `PERFIS/geekom.md` | `docs/guia-ia-local/MY-SETUP.md` | 🔙 Referência |
| `PERFIS/alienware.md` | `docs/guia-ia-local/MY-SETUP.md` | 🔙 Referência |
| `PERFIS/acer-paula.md` | `docs/guia-ia-local/MY-SETUP.md` | 🔙 Referência |

### 2. **Configuração da IA**

| Arquivo | Conecta a | Tipo |
|---------|-----------|------|
| `opencode.json` | `docs/guia-ia-local/MY-SETUP.md` | ➡️ Especificações |
| `opencode.json` | `PERFIS/geekom.md` | ➡️ Perfil |
| `opencode.json` | `PERFIS/alienware.md` | ➡️ Perfil |
| `opencode.json` | `PERFIS/acer-paula.md` | ➡️ Perfil |
| `PERFIS/geekom.md` | `opencode.json` | 🔙 Configuração |
| `PERFIS/alienware.md` | `opencode.json` | 🔙 Configuração |
| `PERFIS/acer-paula.md` | `opencode.json` | 🔙 Configuração |

### 3. **Documentação do Sistema**

| Arquivo | Conecta a | Tipo |
|---------|-----------|------|
| `docs/guia-ia-local/README.md` | `docs/guia-ia-local/MY-SETUP.md` | ➡️ Hardware |
| `docs/guia-ia-local/README.md` | `docs/guia-ia-local/DEPENDENCIAS.md` | ➡️ Pacotes |
| `docs/guia-ia-local/DEPENDENCIAS.md` | `docs/guia-ia-local/MY-SETUP.md` | ➡️ Hardware |
| `IA-RESTORE.md` | `docs/guia-ia-local/MY-SETUP.md` | ➡️ Hardware |
| `README-manual.md` | `docs/guia-ia-local/MY-SETUP.md` | ➡️ Hardware |
| `fluxo-trabalho-executor.md` | `cerebrum/prompts/*.md` | ➡️ Guia do Executor |
| `fluxo-trabalho-executor.md` | `cerebrum/rotinas/*.md` | ➡️ Runbooks |

### 4. **Sistema Cérebro & Executor**

| Arquivo | Conecta a | Tipo |
|---------|-----------|------|
| `00-sistema-cerebro.md` | `cerebrum/master-plan.md` | ➡️ Roadmap |
| `00-sistema-cerebro.md` | `cerebrum/estrutura-cofre.md` | ➡️ Estrutura |
| `cerebrum/README.md` | `00-sistema-cerebro.md` | 🔙 Interface |
| `cerebrum/README.md` | `fluxo-trabalho-executor.md` | 🔙 Guia do Executor |
| `fluxo-trabalho-executor.md` | `00-sistema-cerebro.md` | ➡️ Definição de papéis |

### 5. **Validação (Automação)**

| Arquivo | Conecta a | Tipo |
|---------|-----------|------|
| `valida-teia.sh` | `docs/guia-ia-local/MY-SETUP.md` | ➡️ Nó central |
| `valida-teia.sh` | `PERFIS/*.md` | ➡️ Perfis |
| `valida-teia.sh` | `opencode.json` | ➡️ Configuração |
| `valida-cofre.sh` | `valida-teia.sh` | ➡️ Validação integrada |
| `verificar-seguranca.sh` | `scripts/` | ➡️ Scripts |
| `validar-prompt-executor.sh` | `cerebrum/prompts/` | ➡️ Prompts |

---

## 🧠 Mapas de Conteúdo (MOCs)

### MOC #1: Setup e Hardware
```
docs/guia-ia-local/MY-SETUP.md (Coração da Teia)
├── PERFIS/geekom.md (IA Local)
├── PERFIS/alienware.md (Dev)
└── PERFIS/acer-paula.md (Portátil)
```

### MOC #2: Configuração da IA
```
opencode.json
├── profiles.geekom
├── profiles.alienware
└── profiles.acer-paula
```

### MOC #3: Sistema Cérebro & Executor
```
00-sistema-cerebro.md (Interface)
├── cerebrum/master-plan.md
├── cerebrum/estrutura-cofre.md
├── cerebrum/template-runbook.md
├── cerebrum/README.md
├── cerebrum/prompts/
│   ├── prompt-executor-diario.md
│   └── prompt-executor-auditoria.md
└── cerebrum/rotinas/
    ├── runbook-backup-limpeza.md
    ├── runbook-saude-sistema.md
    └── ...
```

### MOC #4: Validação (Automação)
```
valida-teia.sh
├── valida-cofre.sh
├── verificar-seguranca.sh
├── validar-prompt-executor.sh
└── validar-runbooks.sh
```

### MOC #5: Fluxo de Trabalho do Executor
```
fluxo-trabalho-executor.md
├── cerebrum/prompts/*.md
├── cerebrum/rotinas/*.md
├── scripts/linux/*.sh
└── AGENTS.md
```

---

## 🌐 Como a Teia Funciona

### Exemplo 1: Atualizar o `opencode.json`

1. → Mudança em `MY-SETUP.md` (ex: nova RAM no GEEKOM)
2. → Atualizar `PERFIS/geekom.md` com nova RAM
3. → Atualizar `opencode.json` com nova RAM
4. → Executar `validar-opencode-json.sh` para confirmar
5. → Executar `valida-teia.sh` para validar a teia
6. → Executar `valida-cofre.sh` para validar toda a estrutura

### Exemplo 2: Nova Máquina

1. → Adicionar specs em `MY-SETUP.md`
2. → Criar novo arquivo em `PERFIS/`
3. → Adicionar perfil em `opencode.json`
4. → Atualizar `cerebrum/README.md` (se necessário)
5. → Executar `valida-teia.sh`

### Exemplo 3: Executor Inicia uma Sessão

1. → Ler `cerebrum/prompts/prompt-executor-diario.md`
2. → Executar `runbook-backup-limpeza.md`
3. → Gravar log em `cerebrum/logs/`
4. → Se falha: marcar com `#falha` + PARE
5. → Se sucesso: executar `runbook-saude-sistema.md`

---

## 📋 Checklist de Integridade da Teia

| Item | Status | Verificação |
|------|--------|-------------|
| Todos os perfis conectam a `MY-SETUP.md` | ✅ | Todos têm links |
| `opencode.json` conecta a todos os perfis | ✅ | 3 perfis listados |
| `00-sistema-cerebro.md` conecta a estrutura | ✅ | Links existentes |
| `fluxo-trabalho-executor.md` conecta a prompts | ✅ | Prompts presentes |
| `fluxo-trabalho-executor.md` conecta a runbooks | ✅ | Runbooks presentes |
| Docs essenciais conectam a hardware | ✅ | Links em todos |

---

## 🔗 Fontes

- 📄 `docs/guia-ia-local/MY-SETUP.md` — Coração da teia
- 📄 `opencode.json` — Configuração da IA
- 📄 `PERFIS/geekom.md` — Perfil GEEKOM
- 📄 `PERFIS/alienware.md` — Perfil Alienware
- 📄 `PERFIS/acer-paula.md` — Perfil ACER
- 📄 `00-sistema-cerebro.md` — Interface IA-para-IA
- 📄 `fluxo-trabalho-executor.md` — Guia do Executor
- 📄 `valida-teia.sh` — Validação da teia

---

*Doc gerado por 🦾 J.A.R.V.I.S. em 2026-09-08*  
*Versão: 1.0.1 — Teia de Conexões do Cofre (com Fluxo do Executor)*  
*Status: ✅ Todos os nós conectados*

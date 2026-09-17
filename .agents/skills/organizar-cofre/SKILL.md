---
name: organizar-cofre
description: Organização da estrutura de pastas e arquivos do Archimedes. Use quando o usuário pedir "organizar cofre", "arrumar pastas", "limpar estrutura", "mover notas", "reorganizar" ou quando as notas estiverem em pastas erradas. Mantém a estrutura padrão do cofre.
compatibility: opencode
metadata:
  audience: ia-local
  workflow: gestao
---

# 🗂️ Organizar o Archimedes

Mantenha a estrutura do cofre organizada e padronizada.

## 📁 Estrutura padrão do cofre

```
archimedes/                 # repo: brcesarms/archimedes (repo único desde 17/09)
├── AGENTS.md                  # Regras e governança da IA (NÃO mover)
├── opencode.json              # Config da CLI (NÃO mover)
├── README.md                  # Documentação principal (NÃO mover)
├── .agents/                   # Skills e agentes da CLI
├── .opencode/                 # Commands da CLI
├── config/                    # Configuração de compatibilidade
├── docker/                    # Stack containerizada (opencode + ollama + webui)
├── docs/                      # 🧠 CONHECIMENTO — ver docs/ abaixo
└── scripts/                   # Scripts de infraestrutura (linux/windows)

docs/
├── runbooks/                  # Runbooks operacionais (única leitura do Executor)
├── notas/                     # Notas atômicas de manutenção
├── instintos/                 # Padrões aprendidos (YAML)
├── cerebrum/                  # Cérebro & Executor (prompts, systemd, logs)
├── convencoes/                # Convenções modulares
├── perfis/                    # Perfis de hardware
├── benchmarks/                # Benchmarks de modelos
└── guia-ia-local/             # Manual do sistema

dotfiles/                      # Configurações de shell e aliases (chezmoi)

# Fora do repositório (privado)
~/wikisidian/
├── concurseiro/               # 📂 ESTUDOS pessoais (concursos)
└── t.i/                       # 📂 ESTUDOS pessoais (T.I., redes)
```

## 🔍 Como organizar

### 1. Auditar a estrutura

- Listar todas as pastas e arquivos do cofre
- Comparar com a estrutura padrão acima
- Identificar arquivos fora do lugar

### 2. Classificar cada arquivo

| 📂 Tipo de conteúdo | 🎯 Pasta correta |
|---------------------|------------------|
| Nota de manutenção do sistema | `docs/notas/` |
| Script de manutenção do sistema | `scripts/linux/` ou `scripts/windows/` |
| Conteúdo de concurso | `~/wikisidian/concurseiro/` |
| Conteúdo de TI / estudos | `~/wikisidian/t.i/` |
| Utilitário/config do sistema | `scripts/` ou `dotfiles/` |
| Guia, setup, perfil | `docs/guia-ia-local/` ou `docs/perfis/` |
| Runbook operacional | `docs/runbooks/` |

### 3. Mover com segurança

- **Sempre confirmar o plano completo** antes de mover (regra de ouro)
- Mover um arquivo por vez
- Usar `mv` e verificar se o destino existe

### 4. Regras

- 🚫 **NUNCA** mover `AGENTS.md`, `opencode.json` ou a pasta `.agents/skills/` para fora
- ✏️ Corrigir nomes de arquivos para kebab-case quando estiverem fora do padrão
- 🔗 Após mover, atualizar os links markdown que apontavam para o antigo caminho
- 📝 Nunca deixar a raiz com arquivos soltos (exceto `AGENTS.md` e `opencode.json`)

## ✅ Checklist ao finalizar

1. [ ] Estrutura segue o padrão
2. [ ] Raiz só tem `AGENTS.md`, `opencode.json` e pastas
3. [ ] Links atualizados após mover
4. [ ] Nenhum arquivo crítico movido

---

## 🔗 Fontes

- 📁 Estrutura padrão: [`AGENTS.md`](../../../AGENTS.md) (Estrutura do Vault)

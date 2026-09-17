---
title: "Estrutura do Cofre — Sistema Cérebro & Executor"
date_created: 2026-09-08
date_updated: 2026-09-08
tags:
  - cerebro
  - estrutura
  - organizacao
status: ativo
---

# 🗂️ Estrutura do Archimedes (Sistema Cérebro & Executor)

> Árvore lógica do repositório único. O conhecimento reside em `docs/`, os scripts em `scripts/`, os dotfiles em `dotfiles/` e as skills/agentes em `.agents/`. Os estudos pessoais (`t.i/`, `concurseiro/`) ficam **fora do repositório**, em `~/wikisidian/`.

## 🌳 Árvore de Diretórios

```
archimedes/
├── AGENTS.md                    # 🏛️ Manual de governança, regras e identidade
├── opencode.json                # ⚙️ Configurações da CLI
├── README.md                    # 📖 Documentação principal
├── .agents/                     # 🤖 Skills e agentes da CLI
├── .opencode/                   # ⚙️ Commands da CLI
├── config/                      # 🔧 Configuração de compatibilidade
├── docker/                      # 🐳 Stack containerizada (opencode + ollama + webui)
├── docs/                        # 🧠 CONHECIMENTO E SISTEMA
│   ├── cerebrum/                #   🧠 Sistema Cérebro ↔ Executor
│   │   ├── master-plan.md       #     📋 Plano diretor em fases (Cérebro lê)
│   │   ├── estrutura-cofre.md   #     🗂️ Este documento (Cérebro lê)
│   │   ├── template-runbook.md  #     📝 Template padrão de Runbook (Cérebro usa)
│   │   ├── prompts/             #     💬 Prompts atômicos para o Executor
│   │   ├── systemd/             #     ⏱️ Units de automação systemd
│   │   └── logs/                #     🪵 Logs de execução (Executor escreve aqui)
│   ├── runbooks/                #   📋 RUNBOOKS prontos — 📖 única leitura do Executor
│   ├── notas/                   #   🗒️ Notas atômicas de manutenção do sistema
│   ├── instintos/               #   🧬 Padrões aprendidos (YAML)
│   ├── convencoes/              #   📏 Convenções modulares
│   ├── perfis/                  #   🖥️ Perfis por máquina
│   ├── benchmarks/              #   📊 Benchmarks de modelos
│   ├── finetune/                #   🎛️ Fine-tuning local
│   ├── arquitetura/             #   🏗️ Decisões de arquitetura
│   └── guia-ia-local/           #   📘 Manual do sistema
├── dotfiles/                    # 🐚 Configurações de terminal (chezmoi)
├── scripts/                     # 🐚 Scripts (linux/ windows/ python/)
└── .planning/                   # 📋 Planos e progresso persistente

# Fora do repositório (privado)
~/wikisidian/
├── t.i/                         # 📂 ESTUDOS: T.I., redes e certificações
└── concurseiro/                 # 📂 ESTUDOS: Concursos públicos
```

> 📌 **Nota de consolidação (17/09/2026):** o repositório `archimedes-vault` foi absorvido neste repo único. Os 8 runbooks que antes ficavam em `cerebrum/rotinas/` agora vivem em `docs/runbooks/`.

## 🎭 Quem Lê o Quê

| Ator | Lê | Escreve/Executa |
|------|----|-----------------|
| 🧠 **Cérebro** (modelo grande) | `AGENTS.md`, `master-plan.md`, `template-runbook.md`, `cerebrum/logs/estado-falhas.md` (ao iniciar sessão) | Gera/atualiza Runbooks e scripts; decide ações a partir dos alertas |
| ⚡ **Executor** (modelo local rápido) | **SOMENTE** `docs/runbooks/*.md` | Roda os comandos exatos do Runbook; escreve em `cerebrum/logs/`; marca `#falha` |

## 📏 Regras de Ouro

- 🚫 Executor **nunca** lê `AGENTS.md`, `template-runbook.md` nem `master-plan.md`
- ⚙️ Executor **nunca** edita scripts — apenas copia/cola o comando do Runbook
- 🪵 Toda execução gera log em `cerebrum/logs/`
- 🏷️ Falha → tag `#falha` no Runbook + PARE (nunca improvisar)

---

## 🔗 Fontes

- 🧠 Nota raiz: [`AGENTS.md`](../../AGENTS.md)
- 🗺️ Plano: [`master-plan.md`](./master-plan.md)
- 📄 Estrutura padrão do cofre: [`AGENTS.md`](../../AGENTS.md)
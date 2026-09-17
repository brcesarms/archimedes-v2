# 🗺️ Mapa Modular do Ecossistema Archimedes — Pilares Autônomos

> Criação: 2026-09-12 · Atualização: 2026-09-16 (Archimedes) · Status: 🟢 Ativo · Tipo: Arquitetura

## 🎯 Objetivo

Registrar o **mapa de conectividade e responsabilidades** entre os pilares do ecossistema técnico do Bruno César Medeiros Siqueira em Ariquemes-RO.
Cada projeto possui **um papel bem delimitado e autônomo**, trabalhando em sinergia para maximizar a automação, a confiabilidade técnica e a produtividade com IA.

---

## 🏛️ Os Pilares do Ecossistema

| Pilar / Repositório | Papel | Motor Principal | Dono de |
| :--- | :--- | :--- | :--- |
| 🏛️ [`archimedes`](https://github.com/brcesarms/archimedes) | **Estratégia & Governança V2** | Padrões de Indústria (`restic`, `lychee`, `pyinfra`, `gitleaks`) | Governança, runbooks de infraestrutura, perfis de hardware, dotfiles (Chezmoi) |
| 🔍 [`archimedes-rag`](https://github.com/brcesarms/archimedes-rag) | **Memória Semântica de Código** | Python + LanceDB + AST | Fatiamento cirúrgico de código, CLI `rag`, hooks git pós-commit, busca vetorial |
| 🩺 [`archimedes-doctor`](https://github.com/brcesarms/archimedes-doctor) | **Qualidade & Auto-Cura (Self-Healing)** | Python + Pytest + RAG | CLI `doctor`, suíte de testes unitários automatizados, loop de auto-cura |
| ⚙️ [`archimedes-operator`](https://github.com/brcesarms/archimedes-operator) | **Braços Mecânicos (Execução Unificada)** | Python + PowerShell + Bash | CLI `operator`, bancada técnica de T.I. (inventário, manifesto, backup robocopy) |
| 🧰 [`linux-toolbox-tui`](https://github.com/brcesarms/linux-toolbox-tui) | **Pós-Instalação Linux** | Bash / Dialog (Layout BIOS 120x30) | Pós-instalação e utilitários rápidos para Linux |
| 🪟 [`win-toolbox-tui`](https://github.com/brcesarms/win-toolbox-tui) | **Pós-Instalação Windows** | PowerShell nativo (Layout BIOS 120x30) | Pós-instalação e utilitários rápidos para Windows |

---

## 🔗 Fluxo de Integração e Execução

```text
┌────────────────────────────────────────────────────────┐
│ 🏛️ archimedes (Estratégia, Governança & Ferramentas)│
│    AGENTS.md · planning-with-files · runbooks · perfis  │
└──────────────────────────┬─────────────────────────────┘
                           │ orquestra e consulta
         ┌─────────────────┼─────────────────┐
         ▼                                   ▼
┌─────────────────────────┐         ┌─────────────────────────┐
│ 🔍 archimedes-rag       │         │ 🩺 archimedes-doctor    │
│    LanceDB + AST        │◄────────┤    Pytest + Self-Healing│
│    Busca semântica      │ alimenta│    Testes de qualidade  │
└─────────────────────────┘         └─────────────────────────┘
                           ▲
                           │ indexa código
┌──────────────────────────┴─────────────────────────────┐
│ ⚙️ archimedes-operator (Braços Mecânicos da Bancada)   │
│    ├── orquestrador.py + menu.py                       │
│    ├── scripts/powershell/ (inventário, robocopy, win11)│
│    └── scripts/bash/ (rsync, setup-ssh)                │
└────────────────────────────────────────────────────────┘
```

---

## 📌 Regras de Arquitetura

1. ❌ **Nunca copiar scripts entre pilares** — o cofre governa, o operator executa, o doctor testa e o rag memoriza.
2. ❌ **Zero improviso em execução mecânica** — usar sempre o CLI `operator` ou automações declarativas do `pyinfra`.
3. 🔄 Se faltar recurso de automação remota → evoluir o `archimedes-operator`, validar com `archimedes-doctor` e reindexar via `archimedes-rag`.
4. 🗺️ Manter o mapa e a documentação sincronizados a cada evolução estrutural.

---

## 🔗 Fontes

- [Decisão de Arquitetura ADR 001](./adr-001-python-powershell.md)
- [Runbook do Servidor de Arquivos Proxmox](../runbooks/servidor-arquivos-proxmox.md)
- [Instruções de Bancada](../runbooks/bancada-instrucoes.md)
- [AGENTS.md](../../AGENTS.md)

# 📂 Convenção: Estrutura de Projetos (`~/projetos/`)

> Carregue este arquivo quando for criar, mover ou organizar projetos/repositórios no sistema.

## 🎯 Regra Central

**Projetos de código, automação e infraestrutura ficam em `~/projetos/`** — NUNCA soltos na home.

```text
/home/brn/
├── archimedes/       <-- 🏛️ Cofre Obsidian (Governança, Regras, 19 Skills) — NÃO MEXER
├── projetos/               <-- 📂 PASTA CENTRAL DE PROJETOS
│   ├── archimedes-operator/    <-- 👷‍♂️ Braço Mecânico (Bancada, Backup Robocopy e Setup Win11)
│   ├── archimedes-rag/         <-- 🔍 Memória Semântica Local (LanceDB + AST)
│   ├── archimedes-doctor/      <-- 🩺 Hospital de Código (Pytest e Loop de Auto-Cura)
│   └── usb-bootavel-tui/       <-- 🔌 Criador de pendrive bootável TUI
└── ...pastas padrão...     <-- Documentos, Downloads, etc.
```

## 📋 Regras

| Regra | Detalhe |
| :--- | :--- |
| **Localização** | Todo novo projeto/repo clonado ou criado → `~/projetos/<nome>/` |
| **Nome da pasta** | `kebab-case`, minúsculo, sem acento (ex: `archimedes-operator`) |
| **Vault é sagrado** | `~/archimedes` NÃO move — caminhos absolutos fixos (AGENTS.md, opencode, submódulos) |
| **Novo repo GitHub** | Criar pasta em `~/projetos/`, clonar/nascer lá, push direto |
| **Migrações** | Sempre solicitar aprovação antes de mover pastas existentes |
| **🔗 Interligação entre repos** | Repositórios **NUNCA são silos**: documentação que afete outro projeto DEVE ser referenciada cruzadamente (guia de preparação no `archimedes-backup` ↔ vault/skills ↔ archimedes-operator). Ao criar/editar doc, procure onde ela deveria ser linkada nos demais repos. |

## 🗺️ Mapa de Projetos Atuais (4 Pilares Consolidados)

| Projeto | Caminho Local | Repo GitHub | Papel no Ecossistema |
| :--- | :--- | :--- | :--- |
| **archimedes-operator** | `~/projetos/archimedes-operator/` | `brcesarms/archimedes-operator` | 👷‍♂️ Braços Mecânicos (Consolidou Backup, Bancada e Setup) |
| **archimedes-rag** | `~/projetos/archimedes-rag/` | `brcesarms/archimedes-rag` | 🔍 Memória Semântica Local (LanceDB + AST) |
| **archimedes-doctor** | `~/projetos/archimedes-doctor/` | `brcesarms/archimedes-doctor` | 🩺 Centro Médico de Código & Auto-Cura (Pytest) |
| **usb-bootavel-tui** | `~/projetos/usb-bootavel-tui/` | `brcesarms/usb-bootavel-tui` | 🔌 Utilitário TUI de criação de pendrive bootável |
| **win-toolbox-tui** | `~/projetos/win-toolbox-tui/` | `brcesarms/win-toolbox-tui` | 🪟 Caixa de Ferramentas TUI & Pós-Instalação Exclusiva Windows 11 |
| **linux-toolbox-tui** | `~/projetos/linux-toolbox-tui/` | `brcesarms/linux-toolbox-tui` | 🐧 Caixa de Ferramentas TUI & Pós-Instalação para Linux (apt/dnf/pacman) |

## ⚙️ Fluxo para Novo Projeto

```bash
# 1. Criar/clonar na pasta central
mkdir -p ~/projetos && cd ~/projetos
git clone git@github.com:brcesarms/<novo-projeto>.git

# 2. Trabalhar dentro de ~/projetos/<novo-projeto>/
# 3. Commits seguem as convenções git (convencoes-git.md)
```

## ⚠️ Exceções

- `~/archimedes` → **NUNCA** mover (muitas referências absolutas).
- `~/obsidian-cofre-v1` → cofre legado; movido para `~/projetos/` apenas se o usuário solicitar explicitamente.
- Ferramentas pessoais (`.opencode`, `.config`, `.local`) → NUNCA em projetos.

---

## 🔗 Fontes

- [Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
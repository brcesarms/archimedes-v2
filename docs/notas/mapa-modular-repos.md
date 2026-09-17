# 🗺️ Mapa Modular do Ecossistema Archimedes — 4 Pilares Autônomos

> Criação: 2026-09-12 · Atualização: 2026-09-13 · Status: 🟢 ativo · Assunto: 4 pilares do ecossistema Archimedes

## 🎯 Objetivo

Registrar o **mapa de conectividade e responsabilidades** entre os pilares do ecossistema Archimedes.
Cada projeto possui **um papel bem delimitado e autónomo**, trabalhando em sinergia para maximizar a automação, a confiabilidade técnica e a economia de tokens de IA.

## 🏛️ Os 4 Pilares do Ecossistema

| Pilar / Repositório | Papel | Motor Principal | Dono de |
| :--- | :--- | :--- | :--- |
| 🏛️ [`archimedes`](https://github.com/brcesarms/archimedes) | **Estratégia & Governança** | Markdown + Git + OpenCode | 19 Skills operacionais · 13 Convenções modulares · Notas atômicas · Perfis de hardware |
| 🔍 [`archimedes-rag`](https://github.com/brcesarms/archimedes-rag) | **Memória Semântica de Longo Prazo** | Python + LanceDB + AST | Chunking cirúrgico de código · CLI `rag` · Hooks git pós-commit · Busca vetorial semântica |
| 🩺 [`archimedes-doctor`](https://github.com/brcesarms/archimedes-doctor) | **Controle de Qualidade & Auto-Cura** | Python + Pytest + RAG | CLI `doctor` · Suite de testes automatizados · Loop de auto-cura (self-healing) de código |
| ⚙️ [`archimedes-operator`](https://github.com/brcesarms/archimedes-operator) | **Braços Mecânicos (Execução Unificada)** | Python + PowerShell + Bash | CLI `operator` · Menu TUI interativo · Bancada (inventário + manifesto) · Backups · Win11 Setup |

*(Utilitário complementar: 🔌 [`usb-bootavel-tui`](https://github.com/brcesarms/usb-bootavel-tui) para criação de mídias bootáveis via terminal).*

## 🔗 Conexões e Fluxo de Execução

```text
┌────────────────────────────────────────────────────────┐
│ 🏛️ archimedes (Estratégia & Governança)          │
│    AGENTS.md · 19 Skills · 13 Convenções               │
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
│ ⚙️ archimedes-operator (Braços Mecânicos Unificados)   │
│    ├── orquestrador.py + menu.py                       │
│    ├── scripts/powershell/ (inventário, backup, win11) │
│    └── scripts/bash/ (rsync, setup-ssh)                │
└────────────────────────────────────────────────────────┘
```

## 🔄 Consolidação de Repositórios (2026-09-13)

- 📦 `archimedes-backup` e 🪟 `archimedes-win11-setup` foram **absorvidos integralmente no `archimedes-operator`**.
- **Motivação:** Eliminar dependências frágeis de caminhos absolutos externos (`~/projetos/archimedes-backup/...`) e permitir execução nativa e autocontida a partir do `operator`.
- Os repositórios satélites remotos foram arquivados/removidos, unificando o versionamento e a manutenção.

## 📌 Regras de Arquitetura

1. ❌ **Nunca copiar scripts entre pilares** — o cofre governa, o operator executa, o doctor testa e o rag memoriza.
2. ❌ **Zero improviso em execução mecânica** — usar sempre o CLI `operator` ou o orquestrador com suas flags validadas.
3. 🔄 Se faltar recurso no motor → evoluir o `archimedes-operator`, validar com `archimedes-doctor` e reindexar via `archimedes-rag`.
4. 🗺️ Manter o mapa e a documentação sincronizados a cada evolução estrutural.

## ✅ Verificação 2026-09-13

- ✔ 4 Pilares ativos e sincronizados com seus remotos no GitHub.
- ✔ Repositórios satélites removidos e histórico registrado.
- ✔ 100% dos testes unitários passando (`operator`: 23 testes, `doctor`: 49 testes).
- ✔ Indexação RAG em dia para todos os projetos com hooks git instalados.

## 🔗 Fontes

- [Nota: Archimedes Backup](./archimedes-backup.md)
- [Nota: Archimedes Win11-Setup](./archimedes-win11-setup.md)
- [Nota: Decisão de Arquitetura Python/PowerShell](./decisao-arquitetura-python-powershell-2026-09-11.md)
- [Nota: Arquitetura do Vault](./arquitetura-vault.md)
- [Nota: Servidor de Arquivos Proxmox](./servidor-arquivos-proxmox.md)
- [Nota: Proxmox GEEKOM — VM Windows](./proxmox-geekom-vm-windows.md)
- [Convenção de Projetos](../convencoes/convencoes-projetos.md)
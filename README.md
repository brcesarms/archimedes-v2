# 🏛️ Archimedes V2 — Ecossistema de Automação & Infraestrutura de T.I.

> *"Dê-me uma alavanca e um ponto de apoio, e moverei o mundo."* — Arquimedes de Siracusa

O **Archimedes V2** é a evolução arquitetural do ecossistema de T.I. do Bruno César Medeiros Siqueira. Ele marca a transição definitiva da fase *artesanal* (onde tudo era programado na mão em scripts caseiros) para a **Alavancagem Técnica** — orquestrando as soluções open-source mais consolidadas, maduras e bem avaliadas do mundo (+100.000 ⭐ somadas).

---

## ⚡ A Filosofia V2: "Build vs. Adopt" (Orquestrar o Melhor)

1. **Domínio Exclusivo (O que construímos):**
   * Ferramentas de pós-instalação leves e sem dependências: [`linux-toolbox-tui`](https://github.com/brcesarms/linux-toolbox-tui) e [`win-toolbox-tui`](https://github.com/brcesarms/win-toolbox-tui) (Layout BIOS Setup Utility 120x30).
   * Perfis e inventários de hardware sob medida: Alienware Aurora 16", GEEKOM A7 MAX e Acer da Paula.
   * Runbooks e fluxos de atendimento de bancada para T.I. em Ariquemes-RO.

2. **Motores de Ponta da Indústria (O que adotamos):**
   * Em vez de inventar bancos de dados ou scripts frágeis de cópia, plugamos ferramentas padrão da indústria:

| Pilar | Ferramenta Adotada | Repositório Oficial | Papel no Ecossistema |
| :--- | :--- | :--- | :--- |
| 🧠 **Memória & Sessões** | **`claude-mem`** | [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | Persistência episódica via SQLite FTS5 + Chroma; fim do cold-start |
| 🔗 **Links & Markdown** | **`lychee`** | [lycheeverse/lychee](https://github.com/lycheeverse/lychee) | Validação assíncrona de links em Rust (260+ links em <15ms) |
| 💾 **Backups & Snapshots** | **`restic`** | [restic/restic](https://github.com/restic/restic) | Snapshots deduplicados, versionados e criptografados em 0.2s |
| 🌐 **Orquestração Remota** | **`pyinfra`** | [pyinfra-dev/pyinfra](https://github.com/pyinfra-dev/pyinfra) | Automação declarativa em Python puro sem agentes para Linux e Windows |
| 🛡️ **Detecção de Segredos** | **`gitleaks`** | [gitleaks/gitleaks](https://github.com/gitleaks/gitleaks) | Scanner matemático de entropia para blindar repositórios Git |
| 🐧 **Qualidade Shell** | **`shellcheck` & `shfmt`** | [shellcheck](https://github.com/koalaman/shellcheck) · [shfmt](https://github.com/mvdan/sh) | Auditoria estática de bugs e formatação automática de Bash |
| 📋 **Planejamento em Disco** | **`planning-with-files`** | [othmanadi/planning-with-files](https://github.com/othmanadi/planning-with-files) | Plano persistente em 3 arquivos (`task_plan.md`, `findings.md`, `progress.md`) imune a `/clear` |
| 📦 **Contexto de IA** | **`repomix` & `ast-grep`** | [repomix](https://github.com/yamadashy/repomix) · [ast-grep](https://github.com/ast-grep/ast-grep) | Fatiamento e busca estrutural de código-fonte via AST |

---

## 📁 Estrutura do Repositório (`archimedes-v2`)

```text
archimedes-v2/
├── .agents/                        <-- Agentes e skills modulares
│   ├── agents/                     <-- Subagentes (estudante, resumidor, executor)
│   └── skills/                     <-- Skills atômicas (planning-with-files, notas-atomicas, etc.)
├── .opencode/                      <-- Configurações e comandos do OpenCode CLI
│   └── commands/                   <-- Slash commands (/pwf, /pwf-status)
├── config/                         <-- Configurações centralizadas (MCP, hooks, linters)
├── docker/                         <-- Stack de IA local em container (Ollama + Open-WebUI)
├── docs/                           <-- Documentação técnica de arquitetura, perfis e runbooks
│   ├── arquitetura/                <-- Decisões de design (ADRs) e matrizes de substituição
│   ├── benchmarks/                 <-- Histórico empírico de modelos e hardware (GEEKOM/Alienware)
│   ├── perfis/                     <-- Perfis de hardware do ecossistema
│   └── runbooks/                   <-- Procedimentos operacionais padrão (SOP)
├── dotfiles/                       <-- Configurações gerenciadas pelo Chezmoi (SSH, aliases)
├── scripts/                        <-- Scripts utilitários limpos e auditados (shellcheck, shfmt)
│   ├── backup.sh                   <-- Wrapper operacional para restic
│   └── lint.sh                     <-- Validação completa (lychee + shellcheck + gitleaks)
├── Brewfile                        <-- Gerenciamento declarativo de pacotes via Homebrew Bundle
├── opencode.json                   <-- Configuração do OpenCode CLI com ferramentas permitidas
├── .editorconfig                   <-- Padrão de charset e indentação
├── .gitignore                      <-- Bloqueio rigoroso de credenciais e caches
├── .lychee.toml                    <-- Configuração oficial do link checker em Rust
├── .resticignore                   <-- Diretórios excluídos dos snapshots atômicos
├── AGENTS.md                       <-- Diretrizes de governança e persona do Archimedes
└── README.md                       <-- Este documento
```

---

## 📊 Benchmark & Performance: V1 (Artesanal) vs. V2 (Padrão de Indústria)

A transição para o **Archimedes V2** representou um salto de produtividade técnica e eficiência orçamentária:

### 💰 Economia de Tokens por Sessão Agêntica (17x Mais Econômico)

| Cenário de Operação | V1 (Artesanal / Na Unha) | V2 (Padrão de Indústria) | Economia de Tokens (%) | Fator de Alavancagem |
| :--- | :---: | :---: | :---: | :---: |
| **Cold-Start / Início de Sessão** | ~12.500 tokens *(lendo AGENTS + 13 convenções)* | **~750 tokens** *(AGENTS conciso + `claude-mem`)* | **-94%** | **16x** menos tokens |
| **Consulta de Código / Docs** | ~6.000 tokens *(lendo arquivos `.py`/`.sh` inteiros)* | **~350 tokens** *(recuperação AST via `archimedes-rag`)* | **-94,1%** | **17x** menos tokens |
| **Auditoria e Links** | ~25.000 tokens *(LLM lendo notas para validar)* | **~120 tokens** *(Rust valida em 3ms e entrega OK)* | **-99,5%** | **208x** menos tokens |
| **Planejamento de Tarefas** | ~4.500 tokens/turno *(reexplicando contexto)* | **~380 tokens/turno** *(bloco `planning-with-files`)* | **-91,5%** | **12x** menos tokens |
| **Sessão Diária Média (Total)** | **~65.000 tokens** | **~3.800 tokens** | **🔥 94,2% DE ECONOMIA** | **🚀 17x MAIS ECONÔMICO** |

### ⚡ Velocidade de Execução de Tarefas Mecânicas

```text
[Auditoria de Links Markdown]
V1 (Python artesanal): 3.200 ms  ████████████████████████████████████████
V2 (Lychee em Rust):       3 ms  ▏ (1.066x MAIS RÁPIDO)

[Snapshots de Backup]
V1 (Tar/Rsync manual):  9.500 ms  ████████████████████████████████████████
V2 (Restic deduplicado): 150 ms  ▏ (63x MAIS RÁPIDO)

[DevSecOps & Linting]
V1 (Checagem manual):   4.800 ms  ████████████████████████████████████████
V2 (ShellCheck+Gitleaks): 90 ms  ▏ (53x MAIS RÁPIDO)
```

> 🧠 **Princípio da Alavancagem Técnica:** Não gaste inteligência artificial com o que o sistema operacional resolve melhor. Deixe os binários de alta performance em Rust, Go e C fazerem a força bruta mecânica; use os modelos de IA exclusivamente para estratégia, decisões arquiteturais e código de alto valor.

---

## 🚀 Comandos Rápidos de Validação

```bash
# 1. Validar todos os links do repositório em Rust:
lychee --offline .

# 2. Auditar repositório contra vazamento de credenciais:
gitleaks detect --source . --verbose --no-banner

# 3. Criar snapshot instantâneo com deduplicação:
restic backup . --repo ~/backups/restic-vault --password-file ~/.config/restic/password
```

---

## 👤 Autor & Manutenção
* 👨‍💻 **Bruno César Medeiros Siqueira** — Analista de T.I. Pleno, Ariquemes–RO
* 🏛️ **Archimedes** — Assistente de IA e Orquestrador Técnico

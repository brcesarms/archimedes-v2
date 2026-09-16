# 🗺️ Matriz de Substituição — Archimedes V1 ➔ Archimedes V2

> Documento de Arquitetura que define a transição do trabalho "na unha" (V1) para a orquestração de padrões consolidados da indústria (V2).

---

## 📊 Tabela Comparativa de Migração

| Componente | Abordagem V1 (Feito na Unha) | Abordagem V2 (Padrão de Mercado) | Status da Migração |
| :--- | :--- | :--- | :---: |
| **Memória de Sessões** | Notas manuais de histórico e instintos estáticos | **`claude-mem`** (SQLite FTS5 + Chroma) | ✅ Concluído |
| **Checagem de Links** | Script Python `validar_links.py` com regex | **`lychee`** em Rust com `.lychee.toml` | ✅ Concluído |
| **Snapshots de Backup** | Script `backup-cofre.sh` via `tar.gz` | **`restic`** com deduplicação e criptografia | ✅ Concluído |
| **Orquestração Remota** | `paramiko` e sockets SSH puros | **`pyinfra`** declarativo em Python puro | ✅ Concluído |
| **Detecção de Segredos** | Grep manual em bash (`verificar-seguranca.sh`) | **`gitleaks`** com análise de entropia | ✅ Concluído |
| **Linters de Shell** | Script manual checando headers | **`shellcheck`** (-S warning) | ✅ Concluído |
| **Pós-Formatação / Pacotes** | Script artesanal de 260 linhas (`bootstrap.sh`) | **`Brewfile` (Homebrew Bundle)** declarativo | ✅ Concluído |
| **Dotfiles & SSH Config** | Cópia manual de arquivos soltos com `cp`/`sed` | **`chezmoi`** com templates e diff | ✅ Concluído |
| **Contexto de IA** | Fatiamento manual de arquivos | **`repomix`** & **`ast-grep`** | 🔄 Em planejamento |
| **Sincronização P2P** | Scripts de `rsync` disparados na mão | **`syncthing`** contínuo pela LAN | 🔄 Em planejamento |

---

## 💎 Domínio Exclusivo Mantido (Identidade Archimedes)

Os projetos abaixo continuam sob desenvolvimento próprio, pois constituem a propriedade intelectual e as ferramentas de suporte sob medida do Bruno:
1. 🐧 [`linux-toolbox-tui`](https://github.com/brcesarms/linux-toolbox-tui) (BIOS Setup Utility 120x30 em Bash puro).
2. 🪟 [`win-toolbox-tui`](https://github.com/brcesarms/win-toolbox-tui) (BIOS Setup Utility 120x30 em PowerShell puro).
3. 📋 Perfis de hardware e runbooks locais de suporte da bancada de Ariquemes-RO.

# 🔌 Convenções SSH

> Carregue este arquivo quando for usar SSH, SCP ou RSync.

## 🔑 Regras

- Usar chaves SSH quando possível (evitar senhas em texto plano)
- Manter `~/.ssh/config` organizado com hosts conhecidos
- Documentar máquinas acessadas neste vault

## 🖥️ Máquinas conhecidas

| Máquina | Como acessar | Papel |
|---------|-------------|-------|
| 🧠 GEEKOM A7 MAX | `ssh geekom` — brn@10.0.0.3, chave ed25519 (migrado 2026-09-04) | 🏰 **Cofre principal** + IA local (Ollama/OpenCode) |
| 🚀 Alienware | `ssh laptop-brn` — bruno@10.0.0.5, chave ed25519 **também no GEEKOM** (configurado 2026-09-09) | 🎮 NVIDIA RTX 5060 (CUDA) — IA local |
| 💻 ACER Paula | Local (esta máquina) | 🛠️ **Backup/manutenção** do GEEKOM (não roda IA local) |
| 🪟 Notebook Pri | `ssh pri@10.0.0.216` — Windows 11 (OpenSSH), chave ed25519 do Bruno | 🛠️ Manutenção e suporte remoto |
| 🗂️ Servidor de Arquivos (CT 103) | `ssh root@10.0.0.103` ou `ssh backup@10.0.0.103` — LXC Debian 13 (privileged) no Proxmox, senha em `~/.config/servidor-arquivos/` | 📁 Samba + NFS + SFTP — destino dos backups (Hermes e robocopy) |
| ☤ Hermes Agent (CT 200) | `ssh root@10.0.0.4` ou `ssh hermes@10.0.0.4` — LXC Ubuntu 24.04 no Proxmox | 🧠 IA local-first, Ollama Vulkan, automação autônoma |

> 🔑 **GEEKOM → Alienware**: o GEEKOM tem chave própria (`~/.ssh/id_ed25519`) + config `Host laptop-brn` para `10.0.0.5`. A ACER usa o mesmo alias (`laptop-brn`). Ambas as máquinas conseguem `ssh laptop-brn` direto.

## 🔄 Sincronização do cofre (ACER ↔ GEEKOM)

> O GEEKOM é o **cofre principal com git**; a ACER é a **cópia de trabalho**.
> Script: `scripts/linux/sync-cofre.sh` · Alias: `jarv-sync` (ACER e GEEKOM).

| Comando | Direção | Uso |
|---------|---------|-----|
| `jarv-sync` | GEEKOM → ACER | Atualizar a máquina local com os commits do GEEKOM (default, seguro) |
| `jarv-sync --push` | ACER → GEEKOM | Enviar edições locais para o GEEKOM (⚠️ sobrescreve) |
| `jarv-sync --dry-run` | — | Mostrar o que seria transferido, sem agir |
| `jarv-sync --help` | — | Ajuda |

### 🧱 Fluxo de trabalho diário

1. **Editar na ACER** → `jarv-sync --push` (leva alterações ao GEEKOM)
2. **Commitar no GEEKOM**: `ssh geekom && cd ~/archimedes && git add -A && git commit -m "feat: ..."`
3. **Atualizar a ACER** com os commits → `jarv-sync` (pull)

### 🛡️ O que o script exclui automaticamente

- Artefatos de runtime: `.opencode/node_modules/`, `__pycache__/`, `*.pyc`
- Segredos: `.env*`, chaves (`*.key`, `*.pem`), tokens (nunca sincronizados)
- Estado local: `.obsidian/workspace*`, `.obsidian/cache`, `utils/backups/`, `.git/` (preserva o git do GEEKOM)

## ⚠️ Cuidados

- **SEMPRE** confirmar antes de conectar ou enviar comandos
- **NUNCA** executar comandos SSH em máquinas não documentadas
- **NUNCA** usar senhas em scripts (use chaves SSH)
- **NUNCA** commitar `.env`, `*.key`, `*.pem`, `id_rsa` (ver `.gitignore`)

---

## 🔗 Fontes
- [OpenSSH Docs](https://www.openssh.com/manual.html)

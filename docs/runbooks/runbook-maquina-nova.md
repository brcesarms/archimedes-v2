# 🖥️ Runbook: Máquina Nova — Bootstrap do Archimedes (< 2 min)

> **Objetivo:** após formatar qualquer máquina (ACER com Omarchy, GEEKOM, etc.), subir o cofre e voltar ao trabalho em **menos de 2 minutos**.
> **Pré-requisito:** token GitHub (PAT) salvo no **Bitwarden** e ISO baixada.

---

## 📋 Visão geral do fluxo

```text
[Backup antes] → [Instalar SO] → [gh auth login] → [clone cofre] → [bootstrap.sh] → 🏛️ online!
```

---

## 0️⃣ ANTES de formatar (NÃO PULE!)

| Item | O que fazer | Onde |
| :--- | :--- | :--- |
| 📦 Cofre | `git add -A && git commit && git push` | GitHub (raiz) |
| 🔑 Chave SSH `~/.ssh/id_ed25519` | Exporte a chave **privada** para o Bitwarden (ou pen drive criptografado) | Bitwarden |
| 🎫 Token GitHub (PAT) | Salve/confirme no Bitwarden (`gh auth login` usa ele) | Bitwarden |
| 📁 Dados pessoais | Copie documentos/imagens/etc. para backup externo | Pen drive / servidor |
| 🗂️ Outros configs | VPN, certificados, `~/.ssh/known_hosts` se quiser preservar | Backups |

> ⚠️ **Regra de ouro:** chave privada e token NUNCA vão para o repositório (mesmo privado). Moram no Bitwarden.

---

## 1️⃣ Instalar o SO (ex: Omarchy na ACER)

1. Baixe a ISO em `iso.omarchy.org` (v4.0.1+)
2. Grave num USB (balenaEtcher / caligula)
3. **BIOS:** desligue **Secure Boot** e **TPM** (exigência do instalador)
4. Boot pelo USB → escolha **Full disk** → aguarde (instala em poucos minutos)
5. No primeiro boot, **crie sua senha LUKS + usuário**

---

## 2️⃣ Bootstrap em < 2 min

### 2.1. Dependências mínimas (15s)

```bash
# Omarchy/Arch
sudo pacman -S --needed --noconfirm git curl
# Ubuntu/Debian
sudo apt update && sudo apt install -y git curl
```

### 2.2. Autenticação GitHub (30s)

```bash
# Token do Bitwarden — cola o PAT quando pedir
gh auth login          # escolha: GitHub.com → HTTPS → Login with token
```

### 2.3. Clone + bootstrap (40s)

```bash
gh repo clone brcesarms/archimedes-vault ~/archimedes-vault -- --recurse-submodules
cd ~/archimedes-vault && ./bootstrap.sh
```

> ⏱️ **Meta total:** ~2 min com internet boa. O `bootstrap.sh` instala deps, ssh config, OpenCode, dotfiles e valida o cofre.

---

## 3️⃣ Verificação final

| Check | Comando | Esperado |
| :--- | :--- | :--- |
| Cofre íntegro | `ls ~/archimedes-vault && git -C ~/archimedes-vault status` | Árvore + clean |
| Estudos pessoais (opcional) | `ls ~/wikisidian && git -C ~/wikisidian/t.i status` | `t.i` e `concurseiro` OK |
| OpenCode | `opencode --version` ou `agy` | Versão listada |
| SSH remoto | `ssh laptop-brn 'echo ok'` | `ok` |
| Chat | `cd ~/archimedes-vault && agy` | 🏛️ Archimedes online |

---

## 4️⃣ Pós-bootstrap (opcional, quando quiser)

- **IA local / Docker:** `cd ~/archimedes-vault/guia-ia-local && ./install.sh --full`
- **Restaurar chave SSH:** cole a chave privada do Bitwarden em `~/.ssh/id_ed25519` (chmod 600) ou gere nova

---

## ⚠️ Armadilhas conhecidas

| Armadilha | Solução |
| :--- | :--- |
| `gh` não autenticado → clone falha | Rodar `gh auth login` antes do clone com PAT do Bitwarden |
| Submódulos não clonados | `git submodule update --init --recursive` |
| `bootstrap.sh` acusa submódulo ausente indevidamente | `.git` de submódulo é arquivo pointer — a validação usa `-e` (bug já corrigido) |
| Teclado Bluetooth não funciona no LUKS | Usar teclado do laptop (embutido) ou USB/dongle 2.4GHz |
| Distro não reconhecida no install.sh | Adicionar ID ao case em `guia-ia-local/install.sh` / `bootstrap.sh` |

---

## 🔗 Fontes

- 🏛️ Script: [`bootstrap.sh`](./README.md)
- 🐚 Dotfiles: [`dotfiles/`](./README.md)
- 🔌 Convenção SSH: [`.opencode/convencoes/convencoes-ssh.md`](./bancada-instrucoes.md)
- 🌿 Convenção Git: [`.opencode/convencoes/convencoes-git.md`](./runbook-git-sync.md)
- 🖥️ Omarchy: https://omarchy.org

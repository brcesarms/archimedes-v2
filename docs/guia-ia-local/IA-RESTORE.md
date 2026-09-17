# 🏛️ IA-RESTORE.md — Guia para a IA Restaurar Tudo

> **Objetivo:** Copie e cole este guia no novo cofre e execute cada passo.  
> **Audiência:** Archimedes (Executor) + Humano (supervisor)  
> **Tempo estimado:** <10 minutos  
> **Última atualização:** 2026-09-10

---

## 🔹 Passo 1: Base do Sistema

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependências obrigatórias
sudo apt install curl tar git ssh rsync -y
```

**Verificação:**
```bash
curl --version && tar --version && git --version && ssh -V && rsync --version
```

---

## 🔹 Passo 2: Ollama (IA Local)

```bash
# Instalar Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Iniciar e habilitar serviço (user space)
systemctl --user start ollama
systemctl --user enable ollama
```

**Verificação:**
```bash
ollama --version
ollama ps  # deve mostrar "no models downloaded"
```

---

## 🔹 Passo 3: OpenCode CLI

```bash
# Instalar OpenCode
curl -fsSL https://opencode.sh/install | sh

# Autenticar com token GitHub
opencode login
# → Cole seu token de acesso pessoal do GitHub
```

**Verificação:**
```bash
opencode version
opencode run --help  # mostra comandos disponíveis
```

---

## 🔹 Passo 4: Restaurar Cofre

```bash
# Clonar cofre (com submódulos)
git clone --recurse-submodules https://github.com/brcesarms/archimedes.git ~/archimedes

# Acessar e rodar setup
cd ~/archimedes
./setup.sh

# Recarregar terminal
source ~/.bashrc  # ou source ~/.zshrc, etc.
```

**Verificação:**
```bash
cd ~/archimedes
ls -la  # deve ver AGENTS.md, guia-ia-local/, README.md
ls ~/wikisidian  # estudos pessoais (t.i/ e concurseiro/) fora do repositório público
```

---

## 🔹 Passo 5: Modelos (Qwen3 Coder + GPT-OSS)

```bash
# Usar script de troca de modelo (alias configurado no passo 4)
usar-qwen3coder  # modelo principal (coding, infra)
usar-gptoss      # modelo leve (sumarização, revisão)
```

**Verificação:**
```bash
ollama ps  # deve mostrar:
# NAME            ID              SIZE    MODIFIED
# qwen3-coder:30b sha256:xxxx      18 GB   x minutos atrás
# gpt-oss:20b     sha256:yyyy      12 GB   x minutos atrás
```

---

## 🔹 Passo 6: Validar Archimedes

```bash
# Executar runbook de saúde do sistema
opencode run --auto

# Verificar logs
cat ~/archimedes/docs/cerebrum/logs/saude-sistema-*.log | tail -20
```

**Sucesso:** Sem erros, com logs gerados.

---

## 🔹 Passo 7: Configuração Final (Opcional)

| Tarefa | Comando | Obs |
|--------|---------|-----|
| **Docker** | `./install.sh --docker` | Para containerização |
| **Modelos extras** | `usar-gptoss`, `usar-qwen2.5coder` | Para comparação |
| **Backup manual** | `./backup-cofre.sh` | Cria snapshot local |

---

## 🐧 Distros Suportadas

| Distribuição | Comando de Instalação |
|--------------|-----------------------|
| Ubuntu / Linux Mint | `sudo apt install` |
| Debian | `sudo apt install` |
| Fedora | `sudo dnf install` |
| CentOS / RHEL | `sudo yum install` |
| OpenSUSE | `sudo zypper install` |
| Arch / Manjaro | `sudo pacman -S` |

> ⚠️ Para Arch, use `yay -S curl tar git openssh rsync ollama` (ou `sudo pacman -S` se não tiver AUR).

---

## 📋 Checklist de Restore (Rápida)

| Etapa | Status | Comando |
|-------|--------|---------|
| [ ] Base do sistema | ✅ | `sudo apt update && sudo apt upgrade -y` |
| [ ] Dependências | ✅ | `sudo apt install curl tar git ssh rsync -y` |
| [ ] Ollama | ✅ | `curl -fsSL https://ollama.com/install.sh \| sh` |
| [ ] OpenCode | ✅ | `curl -fsSL https://opencode.sh/install \| sh` |
| [ ] Clone do cofre | ✅ | `git clone --recurse-submodules ...` |
| [ ] Setup | ✅ | `./install.sh --dotfiles` |
| [ ] Modelos | ✅ | `usar-qwen3coder` e `usar-gptoss` |
| [ ] Validação | ✅ | `opencode run --auto` |

---

## 🆘 Troubleshooting

| Problema | Solução |
|----------|---------|
| `curl: command not found` | `sudo apt install curl` |
| `git: command not found` | `sudo apt install git` |
| `ollama: command not found` | `source ~/.bashrc` ou `export PATH=$PATH:/usr/local/bin` |
| `opencode: command not found` | `source ~/.bashrc` ou `export PATH=$PATH:~/.opencode/bin` |
| `Cloning failed (permission)` | Verifique seu token GitHub no `opencode login` |

---

## 🔗 Fontes

- 📦 [DEPENDENCIAS.md](./DEPENDENCIAS.md) — Lista completa de pacotes
- 🐧 [Ollama Install](https://ollama.com/install.sh)
- 🎛️ [OpenCode Install](https://opencode.sh/install)
- 📚 [AGENTS.md](../../AGENTS.md) — Identidade do J.A.R.V.I.S.
- 🔄 [backup-cofre.sh](../../scripts/linux/backup-cofre.sh) — Script de backup

---

*Doc gerado por 🦾 J.A.R.V.I.S. em 2026-09-08*  
*Versão: 1.0.0 — Guia para IA Restaurar Tudo*  
*Próximo: `README-manual.md` para humanos*

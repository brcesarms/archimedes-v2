# 📦 Dependências do Sistema

> **Última atualização:** 2026-09-08  
> **Audiência:** Pós-formatação, restore em nova máquina  
> **Responsável:** J.A.R.V.I.S.

---

## 🔧 Obligatórias (Restore Básico)

| Pacote | Função | Comando de Instalação |
|--------|--------|-----------------------|
| `curl` | Baixar scripts e binaries | `sudo apt install curl` |
| `tar` | Descompactar backups | `sudo apt install tar` |
| `git` | Clonar repositórios | `sudo apt install git` |
| `ssh` | Acesso remoto | `sudo apt install openssh-client` |
| `rsync` | Sincronização segura | `sudo apt install rsync` |

---

## 🧠 IA Local (Ollama)

| Pacote | Função | Comando de Instalação |
|--------|--------|-----------------------|
| `ollama` | Servidor de modelos LLM | `curl -fsSL https://ollama.com/install.sh \| sh` |

**Verificação:**
```bash
ollama --version        # exibe versão
ollama ps               # lista modelos baixados
```

---

## 🎛️ OpenCode CLI

| Pacote | Função | Comando de Instalação |
|--------|--------|-----------------------|
| `opencode` | CLI para IA local (J.A.R.V.I.S.) | `curl -fsSL https://opencode.sh/install \| sh` |

**Verificação:**
```bash
opencode version        # exibe versão
opencode login          # autentica com token GitHub
opencode run --auto     # executa todos os runbooks
```

---

## 🐳 Docker (Opcional)

| Pacote | Função | Comando de Instalação |
|--------|--------|-----------------------|
| `docker` | Containerização | `curl -fsSL https://get.docker.com \| sh` |
| `docker-compose` | Orquestração | `sudo apt install docker-compose` |

**Verificação:**
```bash
docker --version
docker-compose --version
```

---

## 🐚 Shell e Utilitários

| Pacote | Função | Comando de Instalação |
|--------|--------|-----------------------|
| `bash` | Shell principal | `sudo apt install bash` |
| `zsh` | Shell alternativo | `sudo apt install zsh` |
| `fish` | Shell amigável | `sudo apt install fish` |
| `vim` | Editor leve | `sudo apt install vim` |
| `htop` | Monitor de processos | `sudo apt install htop` |
| `neofetch` | Info do sistema | `sudo apt install neofetch` |

---

## 📋 Checklist de Instalação (Restore)

```bash
# 1. Atualizar sistema
sudo apt update && sudo apt upgrade -y

# 2. Instalar dependências obrigatórias
sudo apt install curl tar git ssh rsync -y

# 3. Instalar Ollama
curl -fsSL https://ollama.com/install.sh | sh
systemctl --user start ollama
systemctl --user enable ollama

# 4. Instalar OpenCode
curl -fsSL https://opencode.sh/install | sh

# 5. Instalar Docker (opcional)
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# 6. Reiniciar e validar
reboot
```

---

## 🔍 Verificação Pós-Instalação

| Ferramenta | Comando | Saída Esperada |
|------------|---------|----------------|
| `curl` | `curl --version` | Version x.x.x |
| `git` | `git --version` | git version x.x.x |
| `tar` | `tar --version` | tar (GNU tar) x.x |
| `ssh` | `ssh -V` | OpenSSH_x.x |
| `rsync` | `rsync --version` | version x.x.x |
| `ollama` | `ollama --version` | x.x.x |
| `opencode` | `opencode version` | x.x.x |

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

---

## 🔗 Fontes

- 📦 [Ollama Install](https://ollama.com/install.sh)
- 🎛️ [OpenCode Install](https://opencode.sh/install)
- 🐳 [Docker Install](https://get.docker.com)
- 📋 [APT Package Manager](https://ubuntu.com/server/docs/package-management)
- 🐧 [Package Management by Distro](https://distrowatch.com/dwres.php?resource=package-management)

---

*Doc gerado por 🦾 J.A.R.V.I.S. em 2026-09-08*  
*Versão: 1.0.0 — Dependências do Sistema*

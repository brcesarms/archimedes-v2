# 🏛️ Archimedes - Guia de Restore

Este cofre contém **tudo que você precisa** para ter sua IA local funcionando após formatar o computador. Basta copiar a pasta e rodar um único script.

---

## 🚀 Restore completo (pós-formatação)

### Passo 1: Copiar o cofre

Após formatar e instalar o sistema básico (qualquer distribuição Linux), copie a pasta do cofre para o seu home:

```bash
# Copiar de um backup (pendrive, HD externo, etc.)
cp -r /caminho/do/backup/archimedes ~/
```

### Passo 2: Rodar o setup

```bash
cd ~/archimedes
./setup.sh
```

### Passo 3: Recarregar o terminal

O setup detecta seu shell automaticamente. Recarregue o arquivo de configuração correspondente:

```bash
# bash
source ~/.bashrc

# ou zsh
# source ~/.zshrc

# ou fish
# source ~/.config/fish/config.fish
```

### Passo 4: Começar a usar

```bash
cd ~/archimedes
agy # ou opencode
```

---

## 📋 O que o setup.sh faz automaticamente

| Passo | O que faz |
|-------|-----------|
| 1 | Cria a estrutura de pastas do cofre |
| 2 | Verifica dependências base (curl, tar, sed) |
| 3 | Instala OpenCode CLI (se necessário) |
| 4 | Instala Ollama (se necessário) |
| 5 | Configura o serviço do Ollama (user space + boot) |
| 6 | Baixa os 2 modelos e compila as versões 16k |
| 7 | Cria os aliases no terminal (multi-shell) |

---

## 🔄 Troca de modelos

Depois do setup, use os atalhos de qualquer pasta:

```bash
usar-qwen3coder  # Qwen3 Coder 30B MoE (principal)
usar-gptoss      # GPT-OSS 20B MoE
```

Cada atalho:
- ✅ Verifica se o Ollama está rodando
- ✅ Verifica se o modelo existe
- 💾 Faz backup do config anterior
- ⚡ Troca o modelo no `opencode.json`
- 🎯 Confirma que tudo foi gravado

---

## 📁 Arquivos importantes

| Arquivo | Função |
|---------|--------|
| `AGENTS.md` (na raiz) | Regras e personalidade da IA local |
| `opencode.json` (na raiz) | Config do OpenCode (modelo + permissões + skills) |
| `.agents/skills/` (na raiz) | Skills do projeto (nunca se perdem no backup) |
| `.editorconfig` (na raiz) | Config padrão de formatação para editores |
| `setup.sh` | Script de restore pós-formatação |
| `install.sh` | Script de instalação completo (novo!) |
| [DEPENDENCIAS.md](./DEPENDENCIAS.md) | Lista de pacotes do sistema |
| `ME.md` | Quem sou eu (perfil, qualificações, experiências) |
| `MY-SETUP.md` | Meu setup e hardware (máquinas) |
| `usar-*.sh` | Scripts de troca de modelo |
| `usar-*.md` | Guias de cada modelo |
| [IA-RESTORE.md](./IA-RESTORE.md) | Guia para a IA restaurar tudo sozinha |
| [README-manual.md](./README-manual.md) | Manual de uso do cofre |
| `.env.template` | Template de variáveis de ambiente (novo!) |
| `DOTFILES/` | Configs de shell (bashrc, aliases, prompt) (novo!) |
| `DOCKER/` | Docker Compose para serviços containerizados (novo!) |
| `PERFIS/` | Perfis por máquina (alienware, geekom, acer) (novo!) |
| `scripts/` | Scripts de manutenção do sistema (linux/windows/templates) |
| `notas/` | Notas de manutenção do sistema |
| `utils/` | Utilitários |

> 🔒 **`t.i/` e `concurseiro/`** NÃO ficam aqui — estão em **`~/wikisidian/`** (fora do repositório público), cada um com repo próprio no GitHub. Ver [AGENTS.md](../../AGENTS.md).

---

## 🛠️ Skills do Projeto

As skills ficam **dentro do cofre** em `.agents/skills/`, registradas no `opencode.json` via `skills.paths`. Como viajam junto no backup, **nunca se perdem** na formatação.

### 📚 Catálogo de skills

| 🗂️ Skill | 💡 O que faz |
|----------|--------------|
| 🗒️ `notas-atomicas` | Cria/edita notas no estilo do cofre (emojis, links markdown, fontes) |
| 🔗 `gerenciar-links` | Conecta notas correlatas, corrige links e evita notas órfãs |
| 🗺️ `criar-moc` | Cria Mapas de Conteúdo (índices que agrupam notas de um assunto) |
| 🗂️ `organizar-cofre` | Mantém a estrutura de pastas padronizada |
| 🏥 `auditar-cofre` | Auditoria de saúde do vault (links quebrados, órfãs, MOCs) |
| 🔄 `backup-cofre` | Backup e restauração segura do cofre |
| 🐧 `script-linux` | Cria scripts bash seguindo as convenções do cofre |
| 🔌 `atualizar-ssh` | Atualiza arquivos em máquinas remotas via SSH/SCP com verificação de integridade |
| ⚡ `motor-remoto` | Reusa o motor Python do archimedes-operator p/ operações remotas (sem duplicar) |

### ➕ Criar uma nova skill

```bash
# Estrutura esperada
.agents/skills/<nome-da-skill>/SKILL.md
```

Cada `SKILL.md` precisa:
- Frontmatter YAML com `name` e `description`
- O `name` deve bater com o nome da pasta
- Nome em minúsculas com hífens (ex: `notas-atomicas`)

> 💡 Após criar/editar uma skill, **reinicie o opencode** para ela ser carregada.

---

## 🚀 Portabilidade entre Máquinas

O cofre foi projetado para funcionar em qualquer Linux. Cada arquivo tem um propósito específico:

### 📦 Instalação em nova máquina

```bash
# 1. Copiar o cofre
cp -r /caminho/do/backup/archimedes ~/

# 2. Rodar install (completo)
cd ~/archimedes/docs/guia-ia-local
./install.sh

# Ou instalação mínima (só dependências)
./install.sh --minimal
```

### 🎯 Modos de instalação

| Modo | Comando | O que instala |
|------|---------|---------------|
| 📦 Completo | `./install.sh` | Tudo (deps + ollama + modelos + dotfiles + docker) |
| 🐧 Mínimo | `./install.sh --minimal` | Só dependências obrigatórias |
| 🐚 Shell | `./install.sh --dotfiles` | Só configura aliases e prompt |
| 🐳 Docker | `./install.sh --docker` | Só Docker + containers |

### 🖥️ Perfis por máquina

Cada máquina do Bruno tem um perfil com configurações otimizadas:

| Máquina | Perfil | Recomendação |
|---------|--------|-------------|
| 🚀 Alienware | `PERFIS/alienware.md` | GPU + Docker pesado |
| 🧠 GEEKOM A7 | `PERFIS/geekom.md` | IA local principal (64GB RAM) |
| 💻 ACER Paula | `PERFIS/acer-paula.md` | Só modelos leves (12GB RAM) |

### 🐚 Dotfiles

| Arquivo | Função |
|---------|--------|
| `DOTFILES/.bashrc` | Configuração de shell |
| `DOTFILES/.aliases` | Atalhos do terminal |
| `DOTFILES/.prompt` | Prompt visual estilo Jarvis |

---

## ⚠️ Observações

- O setup usa `set -euo pipefail` — se algo falhar, para na hora e mostra o erro
- Se você já tiver o Ollama instalado, ele **não reinstala** — só configura o serviço
- O script é idempotente: pode rodar quantas vezes quiser, não quebra nada
- **Compatível com**: Ubuntu, Linux Mint, Fedora, Omarchy, Bluefin, Aurora Linux e derivadas
- **Multi-shell**: detecta automaticamente bash, zsh ou fish e configura os aliases no arquivo certo

---

*J.A.R.V.I.S. - Setup v1.2 - Atualizado em 2026-09-04*

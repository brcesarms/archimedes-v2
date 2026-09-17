# 📖 README-Manual — Manual de Uso do Archimedes Vault

> **Audiência:** Humanos (Bruno + colaboradores)  
> **Objetivo:** Guia prático para uso diário do cofre  
> **Última atualização:** 2026-09-10

---

## 🚀 Primeiros Passos (Para Humanos)

### 1. Acessar o Cofre
```bash
cd ~/archimedes
```

### 2. Abrir no Obsidian (Editor de Notas)
```bash
# Abrir diretamente no Obsidian
obsidian .  # ou:
# ou clique com botão direito → "Open with Obsidian"
```

### 3. Atualizar Estudos Pessoais (se t.i/concurseiro mudarem)
```bash
cd ~/wikisidian/t.i && git pull
cd ~/wikisidian/concurseiro && git pull
```

---

## 📂 Estrutura do Cofre

| Pasta | Conteúdo | Para Quem? |
|-------|----------|------------|
| `~/wikisidian/t.i/` | Scripts de TI (Windows, Linux, Proxmox, Obsidian) | TI, infra, sysadmin |
| `~/wikisidian/concurseiro/` | Notas de estudo para concursos | Estudos, legislação, informática |
| `guia-ia-local/` | Sistema do Archimedes (scripts, runbooks, logs) | IA, automação |
| `.agents/skills/` | Skills do Archimedes (ações automatizadas) | IA, automação |
| `.opencode/convencoes/` | Convenções auxiliares (git, scripts, segurança) | IA, automação |

---

## 🎛️ Comandos Úteis (Aliases)

| Comando | O que faz |
|---------|-----------|
| `usar-qwen3coder` | Troca o modelo principal (Qwen3 Coder 30B) |
| `usar-gptoss` | Troca para modelo leve (GPT-OSS 20B) |
| `usar-qwen2.5coder` | Troca para modelo intermediário (Qwen2.5 Coder 7B) |

---

## 🛠️ Manutenção do Sistema

### Atualizar o Cofre
```bash
cd ~/archimedes
git pull origin main
```

### Criar Backup Manual
```bash
cd ~/archimedes/scripts/linux
./backup-cofre.sh
```

### Verificar Saúde do Sistema
```bash
cd ~/archimedes
agy # ou opencode run --auto
```

### Ver Logs de Última Execução
```bash
cat ~/archimedes/docs/cerebrum/logs/saude-sistema-*.log | tail -20
```

---

## 📊 Métricas do Sistema

| Métrica | Onde Ver |
|---------|----------|
| Último backup | `~/backups/archimedes/` |
| Última execução | `~/archimedes/docs/cerebrum/logs/` |
| Modelos instalados | `ollama ps` |
| Uso de CPU/RAM | `htop` |

---

## 🆘 Troubleshooting Rápido

| Problema | Solução |
|----------|---------|
| `opencode: command not found` | `source ~/.bashrc` |
| `Modelo não encontrado` | `usar-qwen3coder` (reinstala o modelo) |
| `Backup falhou` | Verificar espaço em disco (`df -h`) |
| `~/wikisidian/` não encontrado | `mkdir -p ~/wikisidian && git clone git@github.com:brcesarms/t.i.git ~/wikisidian/t.i && git clone git@github.com:brcesarms/concurseiro.git ~/wikisidian/concurseiro` |

---

## 📝 Como Contribuir

### Adicionar Nova Nota (Estilo Obsidian)
1. Criar arquivo em `~/wikisidian/t.i/` ou `~/wikisidian/concurseiro/`
2. Usar formato: `kebab-case.md` (ex: `ssh-remoto-configuracao.md`)
3. Adicionar H1 com emoji: `# 🐧 Configuração SSH Remota`
4. Finalizar com `## 🔗 Fontes`

### Adicionar Novo Script
1. Criar em `guia-ia-local/scripts/linux/` ou `windows/`
2. Adicionar shebang: `#!/usr/bin/env bash`
3. Seguir `set -euo pipefail` no topo
4. Adicionar `chmod +x` após criar

---

## 📅 Checklist Mensal

| Tarefa | Comando |
|--------|---------|
| Atualizar submódulos | `git submodule update --remote --merge` |
| Limpar logs antigos | `find ~/archimedes/docs/cerebrum/logs/ -name "*.log" -mtime +14 -delete` |
| Verificar espaço em disco | `df -h /` |
| Validar scripts | `cd ~/archimedes/scripts/linux && ./verificar-scripts.sh` |

---

## 🔗 Links Úteis

| Documento | Descrição |
|-----------|-----------|
| [AGENTS.md](../../AGENTS.md) | Identidade e regras do Archimedes |
| [guia-ia-local/README.md](./README.md) | Guia de restore pós-formatação |
| [guia-ia-local/DEPENDENCIAS.md](./DEPENDENCIAS.md) | Lista de pacotes do sistema |
| [guia-ia-local/IA-RESTORE.md](./IA-RESTORE.md) | Guia para IA restaurar tudo |
| [convencoes-git.md](../convencoes/convencoes-git.md) | Convenções de commit e push |

---

## 🧠 Como o Archimedes Funciona

| Componente | Função |
|------------|--------|
| **Cérebro** (ex: `big-pickle`, modelos pro) | Projeta Runbooks e scripts para o Executor |
| **Executor** (ex: `qwen2.5-coder:7b`, modelos locais) | Executa Runbooks com 100% de consistência |
| **Skills** | Tarefas automatizadas (criar nota, auditar, etc.) |
| **Runbooks** | Receitas passo a passo (ex: backup-semanal, auditoria) |

---

## 📞 Suporte

| Tipo | Como |
|------|------|
| **Dúvida de uso** | Ver `~/wikisidian/t.i/` (notas de TI) ou `~/wikisidian/concurseiro/` (estudos) |
| **Erro no sistema** | Ver `guia-ia-local/cerebrum/logs/` |
| **Sugestão de melhoria** | Criar issue no GitHub (`brcesarms/archimedes`) |

---

*Manual mantido por 🏛️ Archimedes*  
*Versão: 2.0.0 — Manual de Uso do Archimedes Vault*  
*Próximo: `guia-ia-local/perfis/` para configurações por máquina*

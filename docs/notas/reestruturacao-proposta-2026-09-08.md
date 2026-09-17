# 🗺️ Plano de Reestruturação Profissional — Obsidian Cofre

**Data:** 2026-09-08  
**Proponente:** 🦾 J.A.R.V.I.S.  
**Objetivo:** Transformar o cofre em um sistema **enterprise-ready**, com documentação completa, automação robusta e manutenção proativa.

---

## 🎯 Visão de Futuro

> *"Um cofre que se mantém sózinho: backup automático, saúde monitorada, falhas documentadas, e restore em 2 minutos."*

### ✅ Estado Atual
- Estrutura sólida, mas incompleta
- Automação em fase piloto (Cérebro ↔ Executor)
- Documentação essencial faltante
- Logs sem rotação explícita

### 🎯 Estado Desejado (30 dias)
- 📚 Todos os docs necessários prontos
- 🔄 Automação 100% operacional (7 runbooks validados)
- 🧹 Logs com rotação automática
- 📦 Deploy de nova máquina em <10 minutos
- 🧠 Sistema Cérebro validado (0 falhas em 30 dias)

---

## 📋 Plano de Ação (30 Dias)

| Semana | Foco | Objetivos | Entregáveis |
|--------|------|-----------|-------------|
| **S1** | 📚 Documentação | Criar docs críticos | `DEPENDENCIAS.md`, `IA-RESTORE.md`, `README-manual.md`, `cerebrum/README.md` |
| **S2** | 🛠️ Scripts | Padronizar headers e validações | 6 scripts com metadata + validações |
| **S3** | 🔁 Automação | Validar runbooks + rotação de logs | 3 execuções por runbook + `logs-rotator.sh` |
| **S4** | 🚀 Deploy | Criar perfil por máquina | `PERFIS/` com alienware, geekom, acer |

---

## 📚 Semana 1 — Documentação Enterprise

### 🚨 Prioridade Máxima (Hoje)

#### 1.1 `docs/guia-ia-local/DEPENDENCIAS.md`

**Objetivo:** Lista completa de pacotes do sistema para pós-formatação.

**Estrutura:**

```markdown
# 📦 Dependências do Sistema

> Última atualização: 2026-09-08

## 🔧 Obligatórias (Restore)

| Pacote | Comando |
|--------|---------|
| `curl` | `sudo apt install curl` |
| `tar` | `sudo apt install tar` |
| `git` | `sudo apt install git` |
| `ssh` | `sudo apt install openssh-client` |
| `rsync` | `sudo apt install rsync` |

## 🧠 IA Local

| Pacote | Comando |
|--------|---------|
| `ollama` | `curl -fsSL https://ollama.com/install.sh \| sh` |

## 🎛️ OpenCode CLI

| Pacote | Comando |
|--------|---------|
| `opencode` | `curl -fsSL https://opencode.sh/install \| sh` |
```

#### 1.2 `docs/guia-ia-local/IA-RESTORE.md`

**Objetivo:** Guia para a IA restaurar tudo do zero (pós-formatação).

**Estrutura:**

```markdown
# 🦾 IA-RESTORE.md — Guia para a IA Restaurar Tudo

> 📋 **Modo de uso:** Copie e cole este guia no novo cofre e execute cada passo.

## 🔹 Passo 1: Base do Sistema

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependências
sudo apt install curl tar git ssh rsync -y
```

## 🔹 Passo 2: Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
systemctl --user start ollama
systemctl --user enable ollama
```

## 🔹 Passo 3: OpenCode CLI

```bash
curl -fsSL https://opencode.sh/install | sh
opencode login  # use seu token
```

## 🔹 Passo 4: Restaurar Cofre

```bash
# Clonar cofre (com submódulos)
git clone --recurse-submodules https://github.com/brcesarms/archimedes-vault.git ~/archimedes-v2

# Rodar setup
cd ~/archimedes-v2/docs/guia-ia-local
./install.sh --dotfiles

# Recarregar terminal
source ~/.bashrc

# Verificar
opencode
```

## 🔹 Passo 5: Modelos

```bash
usar-qwen3coder  # modelo principal
usar-gptoss      # modelo leve
```

---

## 🛠️ Semana 2 — Scripts Profissionais

### 🎯 Prioridade: Todos os scripts com metadados

#### Exemplo de Header Padrão

```bash
#!/usr/bin/env bash
# ============================================================
# 🔄 backup-cofre.sh — Backup automático do Obsidian Cofre
# ============================================================
# @author: Bruno César Medeiros Siqueira
# @version: v1.2.3 (2026-09-08)
# @description: Cria snapshot datado, verifica integridade e aplica rotação
# @changelog:
#   - v1.2.3 (2026-09-08): Adiciona exclusão de cache do Obsidian
#   - v1.1.0 (2026-08-20): Adiciona verificação de integridade
# @usage:
#   ./backup-cofre.sh          # roda uma vez
#   systemctl --user start backup-cofre.service
# @security:
#   - Usa variáveis de ambiente (GITHUB_TOKEN)
#   - Valida caminhos antes de operações
#   - NÃO expõe senhas em logs
# ============================================================
set -euo pipefail
```

### 📋 Scripts para Atualizar

| Script | Meta | Prioridade |
|--------|------|------------|
| `sync-cofre.sh` | Adicionar metadados + validação de `git status` | 🔴 Alta |
| `delegar-executor.sh` | Adicionar metadados + validação de conexão | 🔴 Alta |
| `monitorar-executor.sh` | Adicionar metadados + healthcheck | 🟠 Média |
| `backup-semanal-executor.sh` | Adicionar metadados + checksum | 🟠 Média |
| `manutencao-diaria-executor.sh` | Adicionar metadados + limpeza seletiva | 🟡 Baixa |
| `verificar-scripts.sh` | Adicionar metadados + `shellcheck` | 🟡 Baixa |

---

## 🔁 Semana 3 — Automação Robusta

### 🎯 Prioridade: Validar Runbooks

#### 3.1 Executar cada runbook **3 vezes**

| Runbook | Status | Logs |
|---------|--------|------|
| `runbook-backup-limpeza.md` | ⚠️ 1 execução | `manutencao-2026-09-08_124746.log` |
| `runbook-git-sync.md` | ❌ 0 execução | — |
| `runbook-auditoria-cofre.md` | ❌ 0 execução | — |
| `runbook-backup-semanal.md` | ⚠️ 1 execução | `backup-semanal-2026-09-08_125603.log` |
| `runbook-saude-sistema.md` | ⚠️ 1 execução | `saude-sistema-2026-09-08_124752.log` |
| `runbook-delegacao.md` | ❌ 0 execução | — |
| `runbook-monitoramento.md` | ❌ 0 execução | — |

**Ação:** Rodar cada runbook 3x no GEEKOM (máquina principal), documentar resultados.

#### 3.2 Criar `logs-rotator.sh`

**Objetivo:** Limpar logs antigos automaticamente (manter apenas 14 dias).

```bash
#!/usr/bin/env bash
# ============================================================
# 🗑️ logs-rotator.sh — Limpeza automática de logs
# ============================================================
# @author: J.A.R.V.I.S.
# @version: v1.0.0 (2026-09-08)
# @description: Remove logs com mais de 14 dias
# @usage: ./logs-rotator.sh
# ============================================================
set -euo pipefail

COFRE_DIR="${COFRE_DIR:-$HOME/archimedes-v2}"
LOG_DIR="$COFRE_DIR/docs/cerebrum/logs"
DAYS_TO_KEEP=14

echo "⏳ [logs-rotator] Removendo logs com mais de $DAYS_TO_KEEP dias..."
find "$LOG_DIR" -name "*.log" -mtime +$DAYS_TO_KEEP -delete

echo "✅ [logs-rotator] Limpeza concluída."
```

**Agendar via cron (user):**

```bash
# Adicionar ao crontab
0 3 * * * "$HOME/archimedes-v2/scripts/linux/logs-rotator.sh"
```

---

## 🚀 Semana 4 — Deploy de Nova Máquina

### 🎯 Prioridade: Criar Perfis por Máquina

#### Estrutura

```
docs/perfis/
├── alienware.md      # GPU + Docker pesado (16" Intel i9 + RTX 4080)
├── geekom.md         # IA local principal (AMD Ryzen 9 7940HS, 64GB RAM)
└── acer-paula.md     # Só modelos leves (Intel i5, 12GB RAM)
```

#### Exemplo: `geekom.md`

```markdown
# 🧠 GEEKOM A7 MAX — Perfil IA Principal

> ⚡ Configurações otimizadas para IA local (64GB RAM, AMD Ryzen 9 7940HS)

## 🔧 Modelos Recomendados

| Modelo | Tamanho | Uso |
|--------|---------|-----|
| `qwen3-coder:30b` | 18GB | Principal (coding, infra) |
| `gpt-oss:20b` | 12GB | Leve (sumarização, revisão) |

## 🐳 Docker

- Ativar swap: `sudo sysctl -w vm.swappiness=80`
- Limitar RAM: `docker-compose -f docker-compose.yml up -d --limit-ram 16g`

## 📊 Monitoramento

- CPU: Alerta acima de 90% por 5 min
- RAM: Alerta acima de 85%
- Disco: Alerta acima de 90%

## 🔄 Backup

- Frequência: Diário (22:00)
- Retenção: 7 dias
- Destino: `$HOME/backups/archimedes-vault/`
```

---

## 📊 Métricas de Sucesso (30 Dias)

| Métrica | Hoje | Meta (30 dias) |
|---------|------|----------------|
| Docs críticos faltantes | 4 | 0 |
| Scripts com metadata | 0/8 | 8/8 |
| Runbooks validados (≥3 execuções) | 1/7 | 7/7 |
| Logs com rotação | ❌ | ✅ (script + cron) |
| Perfis por máquina | ❌ | 3/3 |
| Tempo de restore (nova máquina) | ~30 min | <10 min |

---

## 🎁 Bônus: Checklist de Auto-Avaliação (Mensal)

A cada 1º do mês, rodar:

```bash
# Validação completa do cofre
./scripts/linux/verificar-scripts.sh
./scripts/linux/verificar-links-parado.sh

# Auditoria de saúde
opencode run --auto  # executa todos os runbooks

# Verificar docs faltantes
grep -r "^[^#]" docs/guia-ia-local/README.md | grep "\[.*\](\./.*\.md)" | while read line; do
    file=$(echo "$line" | grep -oP '\(.*\.md\)' | tr -d '()')
    if [ ! -f "$file" ]; then
        echo "❌ Doc faltante: $file"
    fi
done
```

---

## 🔗 Fontes

- 📖 [`docs/guia-ia-local/README.md`](../guia-ia-local/README.md)
- 📖 [`master-plan.md`](../cerebrum/master-plan.md)
- 📖 [`convencoes-git.md`](../convencoes/convencoes-git.md)
- 📖 [`convencoes-scripts.md`](../convencoes/convencoes-scripts.md)

---

*Plano gerado por 🦾 J.A.R.V.I.S. em 2026-09-08*  
*Versão: 1.0.0 — Reestruturação Profissional*  
**Próximo passo:** Bruno, aprova o plano? Posso começar a executar as ações de prioridade máxima (hoje) se quiser. 🚀

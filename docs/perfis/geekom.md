# 🧠 GEEKOM A7 MAX — Perfil de Máquina

> **Máquina:** GEEKOM A7 MAX (Ryzen 9 7940HS / 64GB RAM)  
> **Uso principal:** **IA Local Principal** (J.A.R.V.I.S. Executor)  
> **Responsável:** Bruno César Medeiros Siqueira  
> **Data:** 2026-09-08  
> **Referência:** `guia-ia-local/MY-SETUP.md`

---

## 🔧 Especificações

| Componente | Detalhe |
|------------|---------|
| **CPU** | AMD Ryzen 9 7940HS |
| **GPU** | AMD Radeon 780M (integrated) |
| **RAM** | 64GB DDR5 (perfeito para modelos de IA complexos) |
| **Armazenamento** | 1TB SSD (Samsung 9100 PRO) |
| **Sistema** | Linux (Fedora Atomic Silverblue) |

> 💡 **Destaque para a IA:** É nesta máquina que a IA local (Ollama + OpenCode) roda de forma nativa.

---

## 🧠 Modelos Recomendados

| Modelo | Tamanho | Uso | Prioridade |
|--------|---------|-----|------------|
| `qwen3-coder:30b` | 18GB | Principal (coding, infra) | 🔴 Alta |
| `gpt-oss:20b` | 12GB | Leve (sumarização, revisão) | 🟠 Média |
| `qwen3:14b` | 8GB | Análise complexa | 🟡 Média |
| `qwen3.6:27b` | 16GB | Backup | 🟢 Baixa |

---

## 📊 Monitoramento

| Métrica | Alerta | Comando |
|---------|--------|---------|
| **CPU** | >85% por 5 min | `htop` |
| **RAM** | >80% | `free -h` |
| **Disco** | >85% | `df -h` |
| **Ollama** | Down | `systemctl --user status ollama` |
| **OpenCode** | Down | `pgrep -f opencode` |

---

## 🔄 Backup

| Configuração | Valor |
|--------------|-------|
| **Frequência** | Diário (22:00) |
| **Retenção** | 7 dias |
| **Destino** | `$HOME/backups/archimedes-vault/` |
| **Push para GitHub** | Automático |

---

## 🎯 Usos Específicos (Archimedes)

| Uso | Comando |
|-----|---------|
| **Executar todos os runbooks** | `opencode run --auto` |
| **Validar saúde do sistema** | `./saude-sistema-executor.sh` |
| **Sincronizar com GitHub** | `./sync-cofre.sh` |
| **Verificar scripts** | `./verificar-scripts.sh` |

---

## 🛡️ Segurança

| Item | Configuração |
|------|--------------|
| **Firewall** | `sudo ufw enable` |
| **SSH** | Acesso limitado por IP |
| **Backup automático** | `systemctl --user enable backup-cofre.service` |
| **Logs rotativos** | `systemctl --user enable logs-rotator.service` |

---

## 📋 Checklist Mensal

| Tarefa | Comando |
|--------|---------|
| Atualizar sistema | `sudo rpm-ostree update` |
| Validar Ollama | `ollama ps` |
| Validar OpenCode | `opencode version` + `opencode run --auto` |
| Limpar logs antigos | `./logs-rotator.sh` |
| Validar backup | `tar -tzf $HOME/backups/archimedes-vault/archimedes-vault_*.tar.gz > /dev/null && echo "✅ Integro"` |

---

## 🆘 Troubleshooting (Archimedes)

| Problema | Solução |
|----------|---------|
| **Ollama não responde** | `systemctl --user restart ollama` |
| **Modelo não carrega** | `ollama pull qwen3-coder:30b` |
| **OpenCode falha** | `opencode login` (reautenticar) |
| **Runbook falha** | Verificar `cerebrum/logs/estado-falhas.md` |

---

## 🔗 Fontes

- 📖 [Modelos Ollama](https://ollama.com/library)
- 📖 [Fedora Atomic Docs](https://docs.fedoraproject.org/en-US/fedora-silverblue/)

---

*Perfil mantido por 🏛️ Archimedes*  
*Versão: 2.0.0 — GEEKOM A7 MAX (IA Principal)*

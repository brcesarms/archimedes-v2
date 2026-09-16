# 🧠 GEEKOM A7 MAX — Perfil de Máquina

> **Máquina:** GEEKOM A7 MAX (Ryzen 9 7940HS / 64GB RAM)  
> **Uso principal:** **IA Local Principal** (Archimedes V2 — Ollama + OpenCode)  
> **Responsável:** Bruno César Medeiros Siqueira  
> **Data:** 2026-09-08  
> **Referência:** [`my-setup.md`](./my-setup.md)

---

## 🔧 Especificações

| Componente | Detalhe |
|------------|---------|
| **CPU** | AMD Ryzen 9 7940HS |
| **GPU** | AMD Radeon 780M (integrated) |
| **RAM** | 64GB DDR5 (perfeito para modelos de IA complexos) |
| **Armazenamento** | 1TB SSD (Samsung 9100 PRO) |
| **Sistema** | **Proxmox VE 9.2** (hypervisor) — VMs/CTs de serviço |

> 💡 **Destaque para a IA:** É nesta máquina que a IA local (Ollama + OpenCode) roda de forma nativa.

---

## 🧠 Modelos Recomendados

| Modelo | Tamanho | Uso | Prioridade |
|--------|---------|-----|------------|
| `qwen3-coder:30b` | ~18GB | Principal (coding, infra) — roda em CPU/iGPU com offload | 🔴 Alta |
| `gpt-oss:20b` | ~12GB | Leve (sumarização, revisão) | 🟠 Média |
| `qwen2.5-coder:7b` | ~4.5GB | Testes rápidos e fallback | 🟢 Baixa |

> 💡 **Nota:** Sem GPU dedicada, modelos >14B dependem de **offload CPU/RAM** (64GB tornam isso viável).

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
| **Retenção** | 7 dias (política restic) |
| **Destino** | `$HOME/backups/restic-vault` (repo restic deduplicado) |
| **Push para GitHub** | Automático (git sync) |

---

## 🎯 Usos Específicos (Archimedes)

| Uso | Comando |
|-----|---------|
| **Backup restic** | `./scripts/backup.sh` |
| **Esteira de qualidade** | `./scripts/lint.sh` |
| **Setup do ambiente** | `./scripts/setup.sh` |
| **Validar links** | `lychee --offline .` |

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
| Atualizar sistema | `apt update && apt upgrade` (Proxmox) |
| Validar Ollama | `ollama ps` |
| Validar OpenCode | `opencode version` |
| Limpar logs antigos | `journalctl --vacuum-time=7d` |
| Validar backup | `restic snapshots --repo "$HOME/backups/restic-vault" --latest 1` |

---

## 🆘 Troubleshooting (Archimedes)

| Problema | Solução |
|----------|---------|
| **Ollama não responde** | `systemctl --user restart ollama` |
| **Modelo não carrega** | `ollama pull qwen3-coder:30b` |
| **OpenCode falha** | `opencode login` (reautenticar) |
| **Runbook falha** | Verificar `.planning/` e `findings.md` do plano ativo |

---

## 🔗 Fontes

- 📖 [Modelos Ollama](https://ollama.com/library)
- 🖥️ [Proxmox VE Docs](https://pve.proxmox.com/wiki/Main_Page)

---

*Perfil mantido por 🏛️ Archimedes*  
*Versão: 2.0.0 — GEEKOM A7 MAX (IA Principal)*

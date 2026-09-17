# 🧠 GEEKOM A7 MAX — Perfil de Máquina

> **Máquina:** GEEKOM A7 MAX (Ryzen 9 7940HS / 64GB RAM)  
> **Uso principal:** **IA Local Principal** (Archimedes V2 — Ollama em LXC + OpenCode)  
> **Responsável:** Bruno César Medeiros Siqueira  
> **Data:** 2026-09-16  
> **Referência:** [`my-setup.md`](./my-setup.md)

---

## 🔧 Especificações

| Componente | Detalhe |
|------------|---------|
| **CPU** | AMD Ryzen 9 7940HS |
| **GPU** | AMD Radeon 780M (integrated) |
| **RAM** | 64GB DDR5 (perfeito para modelos de IA complexos) |
| **Armazenamento** | 1TB SSD (Samsung 9100 PRO) |
| **Sistema** | **Proxmox VE 9.2.2** (hypervisor) — VMs/CTs de serviço |

> 💡 **Destaque para a IA:** A IA local roda no **LXC 104 (Ollama)** — VM/CT isolada com GPU passada (ROCm).

---

## 🧠 Servidor Ollama — LXC 104

| Configuração | Valor |
|--------------|-------|
| **IP** | `10.0.0.4/24` (estático, gateway `10.0.0.1`, DNS `10.0.0.1`) |
| **Endpoint** | `http://10.0.0.4:11434` (API) · `http://10.0.0.4:11434/v1` (OpenAI-compatível) |
| **Recursos** | 8 vCPU · 12 GB RAM · 132 GB disco (LVM-thin) |
| **Tipo** | Privilegiado · GPU AMD iGPU 780M ativa (ROCm, benchmark 2026-09-16) · SSH por chave ed25519 |
| **SO** | Ubuntu 24.04 LTS · Ollama **v0.34.1** |
| **Acesso host** | `pct exec 104 -- bash` (no Proxmox) · SSH: `ssh pve-ollama` |

> ⚙️ **GPU ROCm — fix obrigatório no systemd** (senão cai 100% CPU ~19 tok/s):
> `Environment=OLLAMA_IGPU_ENABLE=1` + `Environment=HSA_OVERRIDE_GFX_VERSION=11.0.0`
> (mapeia a iGPU `gfx1103` → `gfx1100` suportado pelo ROCm 7.2). Validado: 26.8 tok/s + 3x prompt eval.

> 💡 **Conexão com o claude-mem:** o observer local usa um proxy TCP `127.0.0.1:37777 → 10.0.0.4:11434` (mini-proxy Python; substituir por socat quando houver sudo disponível).

---

## 🧠 Modelos Recomendados

| Modelo | Tamanho | Uso | Prioridade |
|--------|---------|-----|------------|
| `qwen3-coder:30b` | ~18GB | Principal (coding, infra) — roda em CPU/iGPU com offload | 🔴 Alta |
| `qwen3:4b` | ~2.6GB | **LXC 104 — 100% GPU validado** (26.8 tok/s); observer do claude-mem | 🟢 Baixa |
| `qwen2.5-coder:7b` | ~4.5GB | Testes rápidos e fallback | 🟢 Baixa |

> 💡 **Nota:** Sem GPU dedicada, modelos >14B dependem de **offload CPU/RAM** (64GB tornam isso viável).

---

## 📊 Monitoramento

| Métrica | Alerta | Comando |
|---------|--------|---------|
| **CPU** | >85% por 5 min | `htop` |
| **RAM** | >80% | `free -h` |
| **Disco** | >85% | `df -h` |
| **Ollama** | Down | `curl -s http://10.0.0.4:11434/api/ps` (ou `pct exec 104 -- systemctl status ollama`) |
| **GPU ativa** | `size_vram=0` | `curl -s http://10.0.0.4:11434/api/ps \| jq '.models[0].size_vram'` — se 0, conferir systemd do LXC |
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
| **Ollama não responde** | `pct exec 104 -- systemctl restart ollama` (host Proxmox) |
| **Modelo não carrega** | `curl -X POST http://10.0.0.4:11434/api/pull -d '{"name":"qwen3-coder:30b"}'` |
| **GPU não ativa (size_vram=0)** | No LXC: `systemctl cat ollama` → conferir `OLLAMA_IGPU_ENABLE=1` e `HSA_OVERRIDE_GFX_VERSION=11.0.0`; log: `journalctl -u ollama \| grep -i "rocblas\|dropping"`. Editou? `systemctl daemon-reload && systemctl restart ollama` |
| **LXC 104 parado** | `pct start 104` (host Proxmox) |
| **SSH ao LXC negado** | Chave pública instalada (2026-09-16 via `pct exec`); se trocar a máquina do Bruno, re-autorizar: `ssh root@10.0.0.3 "pct exec 104 -- sh -c 'mkdir -p /root/.ssh; cat >> /root/.ssh/authorized_keys'"` |
| **OpenCode falha** | `opencode login` (reautenticar) |
| **Runbook falha** | Verificar `.planning/` e `findings.md` do plano ativo |

---

## 🔗 Fontes

- 📖 [Modelos Ollama](https://ollama.com/library)
- 🖥️ [Proxmox VE Docs](https://pve.proxmox.com/wiki/Main_Page)

---

*Perfil mantido por 🏛️ Archimedes*  
*Versão: 2.0.0 — GEEKOM A7 MAX (IA Principal)*

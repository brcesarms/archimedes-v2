# 🚀 Alienware Aurora 16" — Perfil de Máquina

> **Máquina:** Alienware Aurora 16" (Core 7 Series 2 240H / RTX 5060 / 32GB RAM)  
> **Uso principal:** Desenvolvimento local, emulação de redes, alto desempenho  
> **Responsável:** Bruno César Medeiros Siqueira  
> **Data:** 2026-09-08  
> **Referência:** [`my-setup.md`](./my-setup.md)

---

## 🔧 Especificações

| Componente | Detalhe |
|------------|---------|
| **CPU** | Intel Core 7 Series 2 240H (2025, 24 núcleos, 5.8 GHz Turbo) |
| **GPU** | NVIDIA GeForce RTX 5060 8GB |
| **RAM** | 32GB DDR5 |
| **Armazenamento** | 1TB NVMe SSD |
| **Sistema** | Linux (Ubuntu/Fedora) |

---

## 🧠 Modelos Recomendados

| Modelo | Tamanho | Uso | Prioridade |
|--------|---------|-----|------------|
| `qwen3-coder:30b` | ~18GB | Principal (coding, infra) | 🔴 Alta |
| `gpt-oss:20b` | ~12GB | Leve (sumarização, revisão) | 🟠 Média |
| `qwen2.5-coder:7b` | ~4.5GB | Testes rápidos (GPU pura) | 🟢 Baixa |
| `mistral-large:24b` | ~14GB | Análise complexa | 🟡 Média |

> 💡 **Nota VRAM:** A RTX 5060 tem **8GB VRAM**. O `qwen3-coder:30b` (~18GB) **não cabe na VRAM**: o Ollama faz **offload automático** — camadas na VRAM e o restante na RAM de 32GB. Para máxima velocidade use modelos ≤7B (GPU pura, sem offload).

---

## 🐳 Docker

| Configuração | Valor |
|--------------|-------|
| **Swap** | `vm.swappiness=80` (para modelos grandes) |
| **Limites de RAM** | `docker-compose.yml` com `mem_limit: 32g` |
| **Swap ativo** | `docker-compose up -d --limit-swap 8g` |

### Serviços Recomendados

| Serviço | Porta | Comando |
|---------|-------|---------|
| **Ollama** | 11434 | `systemctl --user start ollama` |
| **Vaultwarden** | 8080 | `docker-compose -f docker-compose.yml up -d` |
| **Traefik** | 8081 | `docker-compose -f docker-compose.yml up -d` |

---

## 📊 Monitoramento

| Métrica | Alerta | Comando |
|---------|--------|---------|
| **CPU** | >90% por 5 min | `htop` |
| **RAM** | >85% | `free -h` |
| **GPU** | >95% | `nvidia-smi` |
| **Disco** | >90% | `df -h` |
| **Temperatura** | >85°C | `sensors` |

---

## 🔄 Backup

| Configuração | Valor |
|--------------|-------|
| **Frequência** | Diário (23:00) |
| **Retenção** | 7 dias (política restic) |
| **Destino** | `$HOME/backups/restic-vault` (repo restic deduplicado) |
| **Push para GitHub** | Automático (git sync) |

---

## 🎯 Usos Específicos

| Uso | Comando |
|-----|---------|
| **Testar modelo novo** | `ollama run qwen3-coder:30b` (usa offload VRAM→RAM) |
| **Executar Docker pesado** | `docker-compose -f docker-compose.yml up -d` |
| **Monitorar GPU** | `watch -n 1 nvidia-smi` |
| **Validar sistema** | `opencode run --auto` |

---

## 🛡️ Segurança

| Item | Configuração |
|------|--------------|
| **Firewall** | `sudo ufw enable` |
| **SSH** | Acesso limitado por IP |
| **Backup automático** | `systemctl --user enable logs-rotator` |

---

## 🔗 Configurações Especiais

### GPU Pass-through (KVM/QEMU)

```bash
# Verificar dispositivos GPU
lspci | grep -i vga

# Adicionar ao /etc/modprobe.d/blacklist.conf
blacklist nvidia
blacklist nvidia-uvm
```

### Ollama com GPU

```bash
# VerificarCUDA
curl -s http://localhost:11434/api/tags | jq '.models[] | select(.name == "qwen3-coder:30b") | .details'

# Configurar GPU no Ollama
export OLLAMA_NUM_GPUS=1
```

---

## 📋 Checklist Mensal

| Tarefa | Comando |
|--------|---------|
| Atualizar drivers NVIDIA | `sudo dnf update nvidia-driver*` |
| Validar Docker | `docker compose -f docker/docker-compose.yml config` |
| Backup restic | `./scripts/backup.sh` |
| Validar backup | `restic snapshots --repo "$HOME/backups/restic-vault" --latest 1` |

---

## 🆘 Troubleshooting

| Problema | Solução |
|----------|---------|
| **CUDA out of memory** | Reduzir `OLLAMA_NUM_PARALLEL` ou usar modelo ≤7B (GPU pura) |
| **Docker falha ao iniciar** | `sudo systemctl restart docker` |
| **Ollama não responde** | `systemctl --user restart ollama` |
| **Temperatura alta** | Limpar ventiladores, aumentar velocidade do ventilador |

---

## 🔗 Fontes

- 📖 [Modelos Ollama](https://ollama.com/library)
- 🐳 [Docker Compose](https://docs.docker.com/compose/)
- 🖥️ [Fedora Atomic Docs](https://docs.fedoraproject.org/en-US/fedora-silverblue/)
- 📊 [NVIDIA SM](https://developer.nvidia.com/nvidia-system-management-interface)

---

*Perfil mantido por 🏛️ Archimedes*  
*Versão: 2.0.0 — Alienware Aurora 16" (archimedes)*

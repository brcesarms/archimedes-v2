# 💻 ACER Aspire — Perfil de Máquina

> **Máquina:** ACER Aspire A514-54 (i3-1115G4 / 12GB RAM + 22GB Swap)  
> **Uso principal:** Leve (modelos leves, backup, revisão)  
> **Responsável:** Bruno César Medeiros Siqueira  
> **Data:** 2026-09-08  
> **Referência:** [`my-setup.md`](./my-setup.md)

---

## 🔧 Especificações

| Componente | Detalhe |
|------------|---------|
| **CPU** | Intel Core i3-1115G4 (11ª Geração, 2 núcleos / 4 threads, 3.00 GHz base / 4.10 GHz turbo) |
| **GPU** | Intel UHD Graphics G4 (integrated) |
| **RAM** | 12GB DDR4 (Swap de 22GB para garantir estabilidade máxima) |
| **Armazenamento** | 238,5GB SSD NVMe + 931,5GB HDD SATA |
| **Sistema** | Linux (x86_64) |

> 💡 **Destaque para portabilidade:** Laptop da Paula rodando Linux, perfeito para estudos e automações leves.

---

## 🧠 Modelos Recomendados

| Modelo | Tamanho | Uso | Prioridade |
|--------|---------|-----|------------|
| `qwen2.5-coder:7b` | ~4.5GB | Principal (sumarização, revisão) | 🟠 Média |
| `qwen3:4b` | ~2.6GB | Testes rápidos e chat leve | 🟢 Baixa |

> ⚠️ **Importante:** Esta máquina **não roda IA pesada** (sem GPU e com 12GB RAM total). Modelos >7B causam **OOM garantido** — o `gpt-oss:20b` foi **descartado** por isso.

---

## 📊 Monitoramento (Leve)

| Métrica | Alerta | Comando |
|---------|--------|---------|
| **CPU** | >70% por 5 min | `htop` |
| **RAM** | >75% | `free -h` |
| **Disco** | >85% | `df -h` |

---

## 🔄 Backup (Prioridade Alta)

| Configuração | Valor |
|--------------|-------|
| **Frequência** | Semanal (Domingo 03:00) |
| **Retenção** | 4 semanas (política restic) |
| **Destino** | `$HOME/backups/restic-vault` (repo restic deduplicado) |
| **Sincronização** | Manual (via `./scripts/backup.sh`) |

> 💡 O backup do ACER é **manual e semanal** (não é máquina principal).

---

## 🎯 Usos Específicos (ACER Paula)

| Uso | Comando |
|-----|---------|
| **Revisar nota longa** | `ollama run qwen2.5-coder:7b` |
| **Sumarizar artigo** | `ollama run qwen2.5-coder:7b` |
| **Validar backup** | `restic snapshots --repo "$HOME/backups/restic-vault" --latest 1` |
| **Backup manual** | `./scripts/backup.sh` |

---

## 📋 Checklist Semanal

| Tarefa | Comando |
|--------|---------|
| Backup restic | `./scripts/backup.sh` |
| Validar backup | `restic snapshots --repo "$HOME/backups/restic-vault" --latest 1` |
| Limpar logs antigos | `journalctl --vacuum-time=7d` |

---

## 🆘 Troubleshooting (Leve)

| Problema | Solução |
|----------|---------|
| **Out of memory (OOM)** | Usar modelo `qwen3:4b` (~2.6GB) |
| **Modelo não carrega** | `ollama pull qwen2.5-coder:7b` (~4.5GB) |
| **Lentidão** | Fechar outros aplicativos |

---

## 🔗 Fontes

- 📖 [Modelos Ollama](https://ollama.com/library)

---

*Perfil mantido por 🏛️ Archimedes*  
*Versão: 2.0.0 — ACER Aspire (Leve)*

# 💻 ACER Aspire — Perfil de Máquina

> **Máquina:** ACER Aspire A514-54 (i3-1115G4 / 12GB RAM + 22GB Swap)  
> **Uso principal:** Leve (modelos leves, backup, revisão)  
> **Responsável:** Bruno César Medeiros Siqueira  
> **Data:** 2026-09-08  
> **Referência:** `guia-ia-local/MY-SETUP.md`

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
| `gpt-oss:20b` | 12GB | Leve (sumarização, revisão) | 🔴 Alta |
| `qwen2.5-coder:7b` | 4.5GB | Testes rápidos | 🟠 Média |

> ⚠️ **Importante:** Esta máquina **não roda IA pesada** (sem GPU). Modelos >7B causam OOM.

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
| **Retenção** | 4 semanas |
| **Destino** | `$HOME/backups/archimedes-vault/` |
| **Push para GitHub** | Manual (via `sync-cofre.sh`) |

> 💡 O backup do ACER é **manual e semanal** (não é máquina principal).

---

## 🎯 Usos Específicos (ACER Paula)

| Uso | Comando |
|-----|---------|
| **Revisar nota longa** | `ollama run gpt-oss:20b` |
| **Sumarizar artigo** | `ollama run gpt-oss:20b` |
| **Validar backup** | `tar -tzf $HOME/backups/archimedes-vault/archimedes-vault_*.tar.gz` |
| **Sincronizar com GEEKOM** | `./sync-cofre.sh` |

---

## 📋 Checklist Semanal

| Tarefa | Comando |
|--------|---------|
| Sincronizar com GEEKOM | `./sync-cofre.sh` |
| Validar backup | `tar -tzf $HOME/backups/archimedes-vault/archimedes-vault_*.tar.gz > /dev/null && echo "✅ Integro"` |
| Limpar logs antigos | `./logs-rotator.sh` |

---

## 🆘 Troubleshooting (Leve)

| Problema | Solução |
|----------|---------|
| **Out of memory (OOM)** | Usar modelo `qwen2.5-coder:7b` (4.5GB) |
| **Modelo não carrega** | `ollama pull gpt-oss:20b` (12GB) |
| **Lentidão** | Fechar outros aplicativos |

---

## 🔗 Fontes

- 📖 [Modelos Ollama](https://ollama.com/library)

---

*Perfil mantido por 🏛️ Archimedes*  
*Versão: 2.0.0 — ACER Aspire (Leve)*

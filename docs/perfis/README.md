# 🖥️ PERFIS/ — Perfis por Máquina

> **Objetivo:** Configurações otimizadas para cada máquina do Bruno  
> **Última atualização:** 2026-09-08

---

## 📋 Lista de Perfis

| Máquina | Perfil | Uso Principal | Modelo Principal |
|---------|--------|---------------|------------------|
| 🚀 **Alienware Aurora 16"** | [`alienware.md`](./alienware.md) | Desenvolvimento pesado, Docker, testes | `qwen3-coder:30b` |
| 🧠 **GEEKOM A7 MAX** | [`geekom.md`](./geekom.md) | **IA Local Principal** (J.A.R.V.I.S. Executor) | `qwen3-coder:30b` |
| 💻 **ACER Aspire** | [`acer-paula.md`](./acer-paula.md) | Leve (modelos leves, backup, revisão) | `gpt-oss:20b` |

---

## 🎯 Como Usar

### 1. Identificar sua máquina
```bash
# Ver modelo do hardware
sudo dmidecode -s system-product-name

# Ou usar neofetch
neofetch
```

### 2. Ler o perfil correspondente
```bash
# Exemplo para GEEKOM
cat ~/archimedes-vault/guia-ia-local/perfis/geekom.md
```

### 3. Aplicar configurações
- Siga as instruções do perfil (ex: Ollama, Docker, modelos)
- Não copie configurações de outra máquina (cada perfil é único)

---

## 🔍 Comparação Rápida

| Critério | Alienware | GEEKOM | ACER |
|----------|-----------|--------|------|
| **CPU** | Core 7 240H | Ryzen 9 7940HS | i3-1115G4 |
| **GPU** | RTX 5060 (8GB) | Radeon 780M | UHD Graphics |
| **RAM** | 32GB | 64GB | 12GB |
| **Armazenamento** | 1TB NVMe | 1TB NVMe | 512GB NVMe |
| **Ollama pesado** | ✅ (18GB+ modelos) | ✅ (18GB+ modelos) | ❌ (máx 12GB) |
| **Docker pesado** | ✅ (32GB RAM) | ✅ (16GB RAM) | ⚠️ (limitado) |
| **IA Principal** | ❌ (testes) | ✅ (Executor) | ❌ (leve) |

---

## 🔧 Scripts Recomendados por Máquina

| Script | Alienware | GEEKOM | ACER |
|--------|-----------|--------|------|
| `backup-cofre.sh` | ✅ | ✅ | ✅ |
| `saude-sistema-executor.sh` | ✅ | ✅ | ✅ |
| `sync-cofre.sh` | ✅ | ✅ | ✅ |
| `manutencao-diaria-executor.sh` | ⚠️ (raro) | ✅ | ❌ |
| `backup-semanal-executor.sh` | ✅ | ✅ | ✅ |

---

## 🆘 Troubleshooting por Máquina

### Alienware
| Problema | Solução |
|----------|---------|
| **CUDA OOM** | Reduzir batch size ou usar modelo menor |
| **Temperatura alta** | Limpar ventiladores, aumentar velocidade do ventilador |

### GEEKOM
| Problema | Solução |
|----------|---------|
| **Ollama não responde** | `systemctl --user restart ollama` |
| **Runbook falha** | Verificar `cerebrum/logs/estado-falhas.md` |

### ACER
| Problema | Solução |
|----------|---------|
| **Out of memory (OOM)** | Usar modelo `qwen2.5-coder:7b` (4.5GB) |
| **Lentidão** | Fechar outros aplicativos |

---

## 🔗 Fontes

- 🚀 [`alienware.md`](./alienware.md)
- 🧠 [`geekom.md`](./geekom.md)
- 💻 [`acer-paula.md`](./acer-paula.md)
- 📖 [`guia-ia-local/README.md`](../../README.md)
- 🧠 [`cerebrum/README.md`](../runbooks/README.md)

---

*Doc mantido por 🏛️ Archimedes*  
*Versão: 2.0.0 — Perfis por Máquina (archimedes-vault)*

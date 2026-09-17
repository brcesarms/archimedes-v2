# 🔗 opencode.json — Fontes e Sincronização

> **Data:** 2026-09-08  
> **Status:** ✅ Sincronizado com `MY-SETUP.md`  
> **Responsável:** J.A.R.V.I.S. + Bruno César

---

## 📋 Resumo

O arquivo `opencode.json` agora está **100% sincronizado com os dados reais do cofre**. Todas as especificações de hardware foram copiadas **diretamente de `docs/guia-ia-local/MY-SETUP.md`** — nenhuma suposição genérica.

---

## 🔗 Fontes de Dados (Tudo no Cofre)

| Dado | Arquivo do Cofre | Linha |
|------|------------------|-------|
| Especificações completas | `docs/guia-ia-local/MY-SETUP.md` | 1-85 |
| Perfil GEEKOM | `docs/perfis/geekom.md` | 1-180 |
| Perfil ACER | `docs/perfis/acer-paula.md` | 1-100 |
| Perfil Alienware | `docs/perfis/alienware.md` | 1-155 |

---

## 🖥️ Especificações Reais (Do `MY-SETUP.md`)

### 🖥️ GEEKOM A7 MAX (IA Local)

| Componente | Valor |
|------------|-------|
| CPU | AMD Ryzen 9 7940HS |
| RAM | 64GB DDR5 (perfeito para IA complexos) |
| GPU | AMD Radeon 780M (integrada) |
| Armazenamento | 1TB SSD (Samsung 9100 PRO) |
| Sistema | Linux (Fedora Atomic Silverblue) |

> 📌 **Origem:** `MY-SETUP.md` linhas 39-51

---

### 💻 ACER Aspire A514-54 (Portátil)

| Componente | Valor |
|------------|-------|
| CPU | Intel Core i3-1115G4 (11ª Geração) |
| RAM | 12GB DDR4 + 22GB Swap (swap para estabilidade) |
| GPU | Intel UHD Graphics G4 (integrada) |
| Armazenamento | 238,5GB SSD NVMe + 931,5GB HDD SATA |
| Sistema | Linux (x86_64) |

> 📌 **Origem:** `MY-SETUP.md` linhas 55-65

---

### 🚀 Alienware Aurora 16" (Notebook Dev)

| Componente | Valor |
|------------|-------|
| CPU | Intel Core 7 Series 2 240H (2025) |
| RAM | 32GB DDR5 |
| GPU | NVIDIA GeForce RTX 5060 (8GB VRAM) |
| Armazenamento | 1TB SSD NVMe M.2 |
| Tela | 16" 2.5K |
| Sistema | Linux |

> 📌 **Origem:** `MY-SETUP.md` linhas 25-36

---

## 📊 Sincronização do `opencode.json`

| Seção | Status | Fonte |
|-------|--------|-------|
| `profiles.geekom` | ✅ | `MY-SETUP.md` linha 44-47 |
| `profiles.acer-paula` | ✅ | `MY-SETUP.md` linha 60-64 |
| `profiles.alienware` | ✅ | `MY-SETUP.md` linha 31-34 |

### Configurações do `opencode.json`

| Máquina | `description` | `memory_limit` | `cpu_threads` |
|---------|---------------|----------------|---------------|
| geekom | Ryzen 9 7940HS / 64GB RAM | 50g | 8 |
| acer-paula | i3-1115G4 / 12GB RAM + 22GB Swap | 10g | 4 |
| alienware | Core 7 240H / RTX 5060 / 32GB RAM | 28g | 16 |

---

## 🔒 Regra de Ouro do Cofre

> **Todo dado no `opencode.json` deve vir de um arquivo do cofre. Nenhuma suposição genérica.**

### ✅ Dados Permitidos
- Especificações de hardware → `docs/guia-ia-local/MY-SETUP.md`
- Modelos Ollama instalados → `docs/perfis/*.md`
- Configurações de rede → `t.i/proxmox/` ou `t.i/obsidian/`
- Caminhos e aliases → `docs/guia-ia-local/README.md`

### ❌ O que Evitar
- Especificações genéricas (ex: "Intel Core i9")
- Valores aproximados (ex: "64GB RAM" sem saber o modelo exato)
- Suposições sem fonte no cofre

---

## 📋 Checklist de Validação

| Item | Status | Arquivo |
|------|--------|---------|
| JSON válido | ✅ | Validado com `python3 -m json.tool` |
| Perfis sincronizados | ✅ | 3/3 (GEEKOM, ACER, Alienware) |
| Descrições exatas | ✅ | Copiadas de `MY-SETUP.md` |
| Memória RAM correta | ✅ | 64GB, 12GB+22GB Swap, 32GB |
| CPUs corretas | ✅ | Ryzen 9 7940HS, i3-1115G4, Core 7 240H |
| GPUs corretas | ✅ | Radeon 780M, UHD G4, RTX 5060 |

---

## 🔗 Fontes

- 📄 **`docs/guia-ia-local/MY-SETUP.md`** — Documento principal de setup/hardware
- 📄 **`docs/perfis/geekom.md`** — Perfil GEEKOM
- 📄 **`docs/perfis/acer-paula.md`** — Perfil ACER
- 📄 **`docs/perfis/alienware.md`** — Perfil Alienware
- 📄 **`opencode.json`** — Configuração principal (sincronizada)

---

*Doc gerado por 🦾 J.A.R.V.I.S. em 2026-09-08*  
*Versão: 1.0.0 — Fontes do opencode.json*  
*Revisão: ✅ Tudo validado contra `MY-SETUP.md`*

# 🎛️ Fine-Tuning Archimedes — Qwen3-4B no estilo do cofre

> **Objetivo:** criar um modelo local que fala no **estilo Archimedes** (pt-BR, emojis, tabelas, tom técnico do cofre), servido pelo Ollama no LXC 104.
> **Data:** 2026-09-16 · **Base:** `Qwen/Qwen3-4B-Instruct-2507` · **Método:** LoRA (fp16) + merge + GGUF Q4_K_M

---

## 🎯 Resultado

| Item | Valor |
|------|-------|
| 🏁 Treino | 60 steps · ~16 min · **loss 14.26 → 3.65** |
| 🧩 Adaptador LoRA | `adapter_model.safetensors` (~132 MB, r=16) |
| 📦 GGUF | `archimedes-q4km.gguf` (**2.4 GB**, 4.95 BPW) |
| 🦙 Ollama | `archimedes:latest` (2.5 GB) em `10.0.0.4:11434` |
| ⚡ Velocidade | **26.2 tok/s** (base: 26.8) — sem regressão |
| 🎨 Estilo | ✅ emojis + pt-BR + tabelas markdown |

**Exemplo real** (prompt "Qual a diferença entre Mikrotik e Ubiquiti?"):

```
📋 Mikrotik = sistema operacional próprio (Linux), foco em rede complexa;
   Ubiquiti = plataforma OpenWrt, foco em facilidade de configuração.

| Aspecto | MikroTik | Ubiquiti |
|---------|----------|---------|
| SO | RouterOS | OpenWrt |
| Complexidade | Alta | Média |
| Interface | WebGUI + CLI | WebGUI |
| Uso típico | Redes corporativas | Pontos de acesso |

✅ No caso do Bruno: **Mikrotik** (alta complexidade, controle total). 🏛️
```

---

## 🔧 Ambiente

| Componente | Detalhe |
|------------|---------|
| 🖥️ Máquina | GEEKOM A7 MAX (Ryzen 9 7940HS · 64GB RAM · Radeon 780M iGPU) |
| 🐧 Onde treina | LXC 104 `ollama` (10.0.0.4 · 8 vCPU · 12GB RAM · GPU passthrough) |
| 🧪 Venv | `/opt/finetune` (Python 3.12.3) |
| 🔥 Stack | `torch 2.9.1+rocm6.3` · `transformers 5.x` · `peft` · `datasets` · `accelerate` |
| 🧬 Triton | `pytorch-triton-rocm==3.5.1` (**nunca** deixar o `triton` do PyPI — quebra o HIP) |

---

## 🚧 Lições aprendidas — o GPU Hang na 780M

> ⚠️ **O maior obstáculo:** qualquer treino travava no step 1 com `HW Exception by GPU node-1 ... reason : GPU Hang` (dmesg: `MES failed to respond to msg=REMOVE_QUEUE` → `MODE2 reset`).

| Tentativa | Resultado |
|-----------|-----------|
| Unsloth + bnb 4-bit | ❌ GPU Hang |
| PEFT + bitsandbytes 4-bit | ❌ GPU Hang (bnb ROCm 6.4 vs runtime 6.3) |
| LoRA bf16 puro (torch padrão) | ❌ GPU Hang |
| bf16 + batch=1 + seq curto | ❌ GPU Hang |
| **fp16 + `AMD_SERIALIZE_KERNEL=3` + `AMD_SERIALIZE_COPY=3`** | ✅ **Sucesso!** |

**Diagnóstico:** não era falta de memória (aumentar VRAM/UMA no BIOS **não** resolve) — é **timeout do MES** do kernel amdgpu com a `gfx1103` mapeada para `gfx1100`. A serialização de kernels evita o estouro de fila.

> 🧠 **Regra de ouro:** `AMD_SERIALIZE_KERNEL=3` é obrigatório. Sem ele, `bf16` **ou** `fp16` travam.

---

## 🚀 Pipeline de reprodução

Todos os comandos rodam no **LXC 104** (`ssh pve-ollama`).

### 0️⃣ Dependências

```bash
# torch ROCm + libs
/opt/finetune/bin/pip install --index-url https://download.pytorch.org/whl/rocm6.3 torch torchvision
/opt/finetune/bin/pip install transformers peft datasets accelerate gguf sentencepiece protobuf
# ⚠️ corrigir triton (se instalado pelo PyPI, remover e reinstalar o do ROCm)
/opt/finetune/bin/pip uninstall -y triton
/opt/finetune/bin/pip install --force-reinstall --no-deps --no-cache-dir \
  --index-url https://download.pytorch.org/whl/rocm6.3 "pytorch-triton-rocm==3.5.1"
```

### 1️⃣ Treinar (LoRA fp16)

```bash
cd /root/finetune
export LD_LIBRARY_PATH=/opt/rocm/lib HSA_OVERRIDE_GFX_VERSION=11.0.0
export AMD_SERIALIZE_KERNEL=3 AMD_SERIALIZE_COPY=3
/opt/finetune/bin/python train.py    # → archimedes-lora-fp16/
```

### 2️⃣ Merge do adaptador (CPU)

```bash
/opt/finetune/bin/python merge_lora.py   # → archimedes-merged/ (bf16, ~8GB)
```

### 3️⃣ Exportar GGUF e quantizar

```bash
cd /opt/llama.cpp
python convert_hf_to_gguf.py /root/finetune/archimedes-merged \
  --outfile /root/finetune/archimedes-f16.gguf --outtype f16
./build/bin/llama-quantize /root/finetune/archimedes-f16.gguf \
  /root/finetune/archimedes-q4km.gguf Q4_K_M
```

### 4️⃣ Carregar no Ollama

```bash
ollama create archimedes -f /root/finetune/Modelfile
ollama run archimedes "Quem é você?"
```

### 5️⃣ Benchmark

```bash
/opt/finetune/bin/python bench.py
```

---

## 📁 Arquivos

| Arquivo | Descrição |
|---------|-----------|
| `dataset.jsonl` | 54 exemplos de estilo (formato ShareGPT) gerados a partir do cofre |
| `train.py` | Treino LoRA fp16 (kernels torch, sem bitsandbytes) |
| `merge_lora.py` | Merge do adaptador no base bf16 (em CPU) |
| `Modelfile` | Persona/system prompt + template ChatML para o Ollama |
| `bench.py` | Benchmark comparativo de velocidade via API do Ollama |

---

## 🔗 Relacionados

- [BENCHMARKS.md](../benchmarks/BENCHMARKS.md) — métricas comparativas
- [HISTORICO.md](../benchmarks/HISTORICO.md) — registro das execuções
- [geekom.md](../perfis/geekom.md) — perfil da GEEKOM / LXC 104
- [AGENTS.md](../../AGENTS.md) — fonte do estilo usado no dataset

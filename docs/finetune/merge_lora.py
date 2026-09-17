#!/usr/bin/env python3
"""Merge do LoRA Archimedes no base bf16 (em CPU, sem GPU)."""
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import PeftModel

BASE = "/root/finetune/base-bf16"
ADAPTER = "/root/finetune/archimedes-lora-fp16"
OUT = "/root/finetune/archimedes-merged"

print("🔧 Carregando base (CPU)...")
model = AutoModelForCausalLM.from_pretrained(BASE, torch_dtype=torch.bfloat16, device_map="cpu")
print("🔧 Aplicando adaptador LoRA:", ADAPTER)
model = PeftModel.from_pretrained(model, ADAPTER)
print("🔧 Merge and unload...")
model = model.merge_and_unload()
model.save_pretrained(OUT, safe_serialization=True)
AutoTokenizer.from_pretrained(BASE).save_pretrained(OUT)
print("✅ Merge salvo em", OUT)
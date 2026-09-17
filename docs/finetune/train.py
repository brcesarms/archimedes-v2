#!/usr/bin/env python3
"""PoC Fine-Tuning Archimedes — LoRA fp16 (sem bitsandbytes).

Lições da Radeon 780M (gfx1103, ROCm 6.3):
- bitsandbytes 4-bit causa GPU Hang (binário ROCm 6.4 vs runtime 6.3) → NÃO usar.
- bf16 puro também travava ("GPU Hang / MES failed to respond").
- Combinação vencedora: fp16=True + AMD_SERIALIZE_KERNEL=3 + AMD_SERIALIZE_COPY=3.
  A serialização de kernels evita o timeout do MES. Validado: 60 steps, loss 14.26→3.65."""
import os
os.environ.setdefault("LD_LIBRARY_PATH", "/opt/rocm/lib")
os.environ.setdefault("HSA_OVERRIDE_GFX_VERSION", "11.0.0")
os.environ.setdefault("PYTORCH_ALLOC_CONF", "garbage_collection_threshold:0.6,max_split_size_mb:128")
# ⚠️ OBRIGATÓRIO na 780M: sem serialização de kernels o step 1 trava (GPU Hang/MES)
os.environ.setdefault("AMD_SERIALIZE_KERNEL", "3")
os.environ.setdefault("AMD_SERIALIZE_COPY", "3")

import torch
from transformers import (
    AutoModelForCausalLM, AutoTokenizer,
    TrainingArguments, Trainer, DataCollatorForLanguageModeling,
)
from peft import LoraConfig, get_peft_model
from datasets import load_dataset

BASE = "/root/finetune/base-bf16"
MAX_SEQ = 768
OUTDIR = "/root/finetune/output_fp16"

print("🧠 Carregando base bf16 (kernels torch padrão)...")
model = AutoModelForCausalLM.from_pretrained(
    BASE, torch_dtype=torch.bfloat16, device_map="auto",
    trust_remote_code=True, use_cache=False, attn_implementation="eager",
)
tokenizer = AutoTokenizer.from_pretrained(BASE, trust_remote_code=True)
if tokenizer.pad_token is None:
    tokenizer.pad_token = tokenizer.eos_token

model.gradient_checkpointing_enable()
model.enable_input_require_grads()

# LoRA
lora = LoraConfig(
    r=16, lora_alpha=16, lora_dropout=0,
    bias="none", task_type="CAUSAL_LM",
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj",
                    "gate_proj", "up_proj", "down_proj"],
)
model = get_peft_model(model, lora)
model.print_trainable_parameters()

# Dataset
def fmt(ex):
    msgs = []
    for c in ex["conversations"]:
        role = "user" if c["from"] == "human" else "assistant"
        msgs.append({"role": role, "content": c["value"]})
    return {"text": tokenizer.apply_chat_template(msgs, tokenize=False, add_generation_prompt=False)}

ds = load_dataset("json", data_files="/root/finetune/dataset.jsonl", split="train")
ds = ds.map(fmt, remove_columns=["conversations"])
print("✅ Dataset:", len(ds), "exemplos")

def tokenize_fn(examples):
    return tokenizer(examples["text"], truncation=True, max_length=MAX_SEQ, padding=False)

tok_ds = ds.map(tokenize_fn, batched=True, remove_columns=["text"])
collator = DataCollatorForLanguageModeling(tokenizer=tokenizer, mlm=False)


class LossTrainer(Trainer):
    """Override compatível com transformers 5.x (labels + cross-entropy padrão)."""

    def compute_loss(self, model, inputs, return_outputs=False, num_items_in_batch=None):
        labels = inputs.pop("labels")
        outputs = model(**inputs)
        logits = outputs.logits
        shift_logits = logits[..., :-1, :].contiguous()
        shift_labels = labels[..., 1:].contiguous()
        loss = torch.nn.functional.cross_entropy(
            shift_logits.view(-1, shift_logits.size(-1)),
            shift_labels.view(-1),
            ignore_index=-100,
        )
        return (loss, outputs) if return_outputs else loss


args = TrainingArguments(
    output_dir=OUTDIR,
    per_device_train_batch_size=1,
    gradient_accumulation_steps=4,
    warmup_steps=5,
    max_steps=60,
    learning_rate=2e-4,
    logging_steps=1,
    optim="adamw_torch",
    weight_decay=0.01,
    lr_scheduler_type="linear",
    seed=3407,
    fp16=True,
    report_to=[],
    save_strategy="no",
    gradient_checkpointing=True,
    gradient_checkpointing_kwargs={"use_reentrant": False},
)

trainer = LossTrainer(model=model, args=args, train_dataset=tok_ds, data_collator=collator)
print("🚀 Iniciando treino LoRA fp16 (60 steps)...")
trainer.train()
print("🏁 Treino concluído")

model.save_pretrained("/root/finetune/archimedes-lora-fp16")
tokenizer.save_pretrained("/root/finetune/archimedes-lora-fp16")
print("✅ LoRA salvo em /root/finetune/archimedes-lora-fp16")
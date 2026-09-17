#!/usr/bin/env python3
"""Benchmark comparativo base vs fine-tuned (Ollama local)."""
import json, urllib.request

API = "http://localhost:11434"
PROMPT = "Explique o que é virtualização LXC de forma técnica."


def post(path, payload):
    req = urllib.request.Request(
        API + path, data=json.dumps(payload).encode(),
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=300) as r:
        return json.loads(r.read())


def bench(model):
    d = post("/api/generate", {
        "model": model, "prompt": PROMPT, "stream": False,
        "options": {"num_predict": 256, "temperature": 0.2},
    })
    ev = d.get("eval_count", 0)
    ed = d.get("eval_duration", 1) or 1
    pv = d.get("prompt_eval_count", 0)
    pd = d.get("prompt_eval_duration", 1) or 1
    return {
        "model": model,
        "tok_s": ev / (ed / 1e9),
        "prompt_eval": pv / (pd / 1e9),
        "ttft_ms": pd / 1e6,
        "total_s": d.get("total_duration", 0) / 1e9,
        "tokens": ev,
    }


print(f"{'modelo':<14} {'tok/s':>7} {'prompt_eval':>12} {'TTFT(ms)':>10} {'total(s)':>9}")
for m in ["qwen3:4b", "archimedes"]:
    r = bench(m)
    print(f"{r['model']:<14} {r['tok_s']:>7.1f} {r['prompt_eval']:>12.1f} {r['ttft_ms']:>10.0f} {r['total_s']:>9.1f}")

ps = post("/api/ps", {})
for m in ps.get("models", []):
    print(f"VRAM {m['name']}: {m.get('size_vram', 0)/1e9:.2f} GB | 100% GPU={m.get('size_vram', 0) > 0}")
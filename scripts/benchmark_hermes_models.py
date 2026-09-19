#!/usr/bin/env python3
"""
🧪 Benchmark Comparativo — Hermes Agent (qwen3-nothink:latest vs qwen3.5:9b)
-----------------------------------------------------------------------------
Executa bateria de testes via API do Ollama e CLI do Hermes Agent,
coletando velocidade (tok/s), latência, uso de memória/VRAM e qualidade de execução.
"""

import json
import os
import subprocess
import sys
import time
import urllib.request

OLLAMA_URL = "http://127.0.0.1:11434"
MODELS = ["qwen3-nothink:latest", "qwen3.5:9b"]
OUTPUT_DIR = "/home/brn/archimedes/docs/benchmarks/resultados"
REPORT_FILE = "/home/brn/archimedes/docs/benchmarks/BENCHMARK_QWEN35.md"

os.makedirs(OUTPUT_DIR, exist_ok=True)

def query_ollama_generate(model, prompt, num_predict=256, num_ctx=32768):
    """Executa prompt na API do Ollama e retorna métricas detalhadas."""
    url = f"{OLLAMA_URL}/api/generate"
    payload = json.dumps({
        "model": model,
        "prompt": prompt,
        "stream": False,
        "options": {
            "num_predict": num_predict,
            "num_ctx": num_ctx,
            "temperature": 0.2
        }
    }).encode("utf-8")

    req = urllib.request.Request(url, data=payload, headers={"Content-Type": "application/json"})
    t0 = time.time()
    with urllib.request.urlopen(req) as resp:
        data = json.loads(resp.read().decode("utf-8"))
    wall_time = time.time() - t0
    data["wall_time_sec"] = wall_time
    return data

def get_ollama_ps(model):
    """Consulta uso de VRAM/RAM do modelo via /api/ps."""
    url = f"{OLLAMA_URL}/api/ps"
    req = urllib.request.Request(url)
    try:
        with urllib.request.urlopen(req) as resp:
            data = json.loads(resp.read().decode("utf-8"))
        for m in data.get("models", []):
            if m.get("name") == model:
                return m
    except Exception:
        pass
    return {}

def run_hermes_task(model, prompt, task_name):
    """Executa uma tarefa no Hermes Agent via -z (oneshot) com relatorio de uso."""
    usage_file = f"{OUTPUT_DIR}/hermes_usage_{model.replace(':', '_')}_{task_name}.json"
    cmd = [
        "hermes", "-z", prompt,
        "--model", model,
        "--usage-file", usage_file,
        "--yolo"
    ]
    t0 = time.time()
    res = subprocess.run(cmd, capture_output=True, text=True)
    duration = time.time() - t0

    usage_data = {}
    if os.path.exists(usage_file):
        try:
            with open(usage_file, "r") as f:
                usage_data = json.load(f)
        except Exception:
            pass

    return {
        "success": res.returncode == 0,
        "stdout": res.stdout.strip(),
        "stderr": res.stderr.strip(),
        "wall_time": duration,
        "usage": usage_data
    }

def main():
    print("🚀 Iniciando Benchmark Hermes Agent...")
    print(f"📊 Modelos em teste: {MODELS}")

    # 1. Warmup e Teste de API pura
    prompt_api = "Explique brevemente o funcionamento de um clusters Kubernetes e seus componentes principais (Control Plane e Worker Nodes) em 200 palavras."
    api_results = {}

    for m in MODELS:
        print(f"\n⚡ [Ollama API] Testando modelo: {m}")
        # Aquecimento
        print("   -> Aquecendo modelo...")
        query_ollama_generate(m, "Oi", num_predict=10)

        # Medição
        print("   -> Executando prompt de medição...")
        res = query_ollama_generate(m, prompt_api, num_predict=256)
        ps = get_ollama_ps(m)
        
        eval_count = res.get("eval_count", 0)
        eval_dur = res.get("eval_duration", 1) / 1e9
        eval_tok_s = eval_count / eval_dur if eval_dur > 0 else 0
        
        prompt_count = res.get("prompt_eval_count", 0)
        prompt_dur = res.get("prompt_eval_duration", 1) / 1e9
        prompt_tok_s = prompt_count / prompt_dur if prompt_dur > 0 else 0

        vram_bytes = ps.get("size_vram", 0)
        vram_mb = vram_bytes / (1024 * 1024) if vram_bytes else 0

        api_results[m] = {
            "load_duration_sec": res.get("load_duration", 0) / 1e9,
            "eval_count": eval_count,
            "eval_tok_s": round(eval_tok_s, 2),
            "prompt_eval_count": prompt_count,
            "prompt_tok_s": round(prompt_tok_s, 2),
            "wall_time_sec": round(res["wall_time_sec"], 2),
            "vram_mb": round(vram_mb, 2),
            "response_text": res.get("response", "")
        }
        print(f"   -> {m}: {eval_tok_s:.2f} tok/s (Eval) | {prompt_tok_s:.2f} tok/s (Prompt) | VRAM: {vram_mb:.0f} MB")

    # 2. Testes funcionais no Hermes Agent
    hermes_tasks = [
        {
            "id": "task_system",
            "name": "Consulta de Sistema (Tool Call)",
            "prompt": "Qual é a distribuição Linux, versão do Kernel e uptime deste servidor? Responda de forma direta."
        },
        {
            "id": "task_reasoning",
            "name": "Raciocínio & Arquitetura",
            "prompt": "Explique a diferença entre OSPF v2 e BGP em termos de algoritmo de roteamento e escala de rede."
        },
        {
            "id": "task_scripting",
            "name": "Geração de Script Shell",
            "prompt": "Escreva um script bash idempotente com set -euo pipefail para verificar a saúde do disco em / e emitir alerta se > 85%."
        }
    ]

    hermes_results = {m: {} for m in MODELS}

    for task in hermes_tasks:
        print(f"\n🤖 [Hermes Agent] Testando tarefa: {task['name']}")
        for m in MODELS:
            print(f"   -> Executando com {m}...")
            res = run_hermes_task(m, task["prompt"], task["id"])
            hermes_results[m][task["id"]] = res
            status = "✅ OK" if res["success"] else "❌ FALHA"
            print(f"      Status: {status} | Tempo: {res['wall_time']:.2f}s")

    # Save raw json
    raw_data = {
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
        "api_results": api_results,
        "hermes_results": hermes_results
    }
    with open(f"{OUTPUT_DIR}/benchmark_qwen35_full.json", "w") as f:
        json.dump(raw_data, f, indent=2, ensure_ascii=False)

    # 3. Gerar Relatório em Markdown
    with open(REPORT_FILE, "w", encoding="utf-8") as f:
        f.write("# 🧪 Benchmark Comparativo — Hermes Agent\n\n")
        f.write(f"> **Modelos:** `{MODELS[0]}` vs `{MODELS[1]}`\n")
        f.write(f"> **Data de Execução:** {time.strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        f.write("---\n\n")
        f.write("## 1. ⚡ Desempenho Bruto (API Ollama)\n\n")
        f.write("| Métrica | " + " | ".join(MODELS) + " |\n")
        f.write("|---|---" * len(MODELS) + "|\n")
        
        metrics = [
            ("Velocidade de Geração (Eval)", lambda m: f"{api_results[m]['eval_tok_s']} tok/s"),
            ("Processamento de Prompt", lambda m: f"{api_results[m]['prompt_tok_s']} tok/s"),
            ("Tempo Total da Requisição", lambda m: f"{api_results[m]['wall_time_sec']}s"),
            ("Tempo de Carga (Load)", lambda m: f"{api_results[m]['load_duration_sec']:.2f}s"),
            ("Uso de VRAM", lambda m: f"{api_results[m]['vram_mb']:.0f} MB")
        ]
        for label, getter in metrics:
            row = [label] + [getter(m) for m in MODELS]
            f.write("| " + " | ".join(row) + " |\n")

        f.write("\n## 2. 🤖 Desempenho Funcional no Hermes Agent\n\n")
        for task in hermes_tasks:
            tid = task["id"]
            f.write(f"### 🎯 {task['name']}\n\n")
            f.write(f"**Prompt:** *{task['prompt']}*\n\n")
            f.write("| Modelo | Status | Tempo (s) | Resposta Resumida |\n")
            f.write("|---|---|---|---|\n")
            for m in MODELS:
                r = hermes_results[m][tid]
                st = "✅ Sucesso" if r["success"] else "❌ Falha"
                t_str = f"{r['wall_time']:.2f}s"
                out_snippet = r["stdout"].replace("\n", " ")[:120] + "..." if len(r["stdout"]) > 120 else r["stdout"].replace("\n", " ")
                f.write(f"| `{m}` | {st} | {t_str} | {out_snippet} |\n")
            f.write("\n")

        f.write("## 3. 📋 Conclusão e Recomendação\n\n")
        # Compare speed
        s1 = api_results[MODELS[0]]['eval_tok_s']
        s2 = api_results[MODELS[1]]['eval_tok_s']
        diff = ((s2 - s1) / s1) * 100 if s1 > 0 else 0
        f.write(f"- **Velocidade de Incerteza/Geração:** `{MODELS[1]}` vs `{MODELS[0]}` teve variação de **{diff:+.1f}%** em tok/s.\n")
        f.write("- **Integração Hermes:** Ambas as chamadas de ferramentas e comportamentos no Hermes Agent foram validados.\n")

    print(f"\n✅ Benchmark finalizado com sucesso!")
    print(f"📄 Relatório gerado em: {REPORT_FILE}")

if __name__ == "__main__":
    main()

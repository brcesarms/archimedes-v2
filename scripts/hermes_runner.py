#!/usr/bin/env python3
"""
hermes_runner.py - Dispatcher de passos atômicos do AGY para o Hermes Agent
Executa chamadas reais de ferramentas usando o modelo local (Ollama qwen3.5:9b)
com captura robusta de saída, encoding tolerante e retroalimentação do tool result.
"""
import sys
import json
import subprocess
from openai import OpenAI

client = OpenAI(base_url="http://127.0.0.1:11434/v1", api_key="ollama")

TOOLS = [{
    "type": "function",
    "function": {
        "name": "terminal",
        "description": "Execute a shell command in the local environment and return stdout/stderr",
        "parameters": {
            "type": "object",
            "properties": {
                "command": {"type": "string", "description": "Shell command to execute"}
            },
            "required": ["command"]
        }
    }
}]

SYSTEM_PROMPT = """Você é o Hermes Agent 🤖⚡, assistente técnico de infraestrutura do Bruno e braço executor local rodando na estação Alienware com GPU RTX 5060.
Sua missão é executar tarefas mecânicas no sistema com precisão cirúrgica.
Quando receber uma instrução para executar um comando, você DEVE SEMPRE chamar a ferramenta terminal.
Após a ferramenta ser executada, analise o retorno real e reporte o resultado de forma vibrante com emojis contextuais em pt-BR."""

def run_step(instruction: str) -> tuple[bool, str]:
    print(f"🤖 [Hermes] Nova instrução recebida:\n   >> {instruction}\n")
    messages = [
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": instruction}
    ]
    
    # 1. Turno de decisão da ferramenta
    resp = client.chat.completions.create(
        model="qwen3.5:9b",
        messages=messages,
        tools=TOOLS,
        temperature=0.1
    )
    msg = resp.choices[0].message
    
    if not msg.tool_calls:
        print(f"⚠️ [Hermes] Respondeu diretamente sem emitir tool call:\n{msg.content}")
        return False, msg.content or ""
        
    for tc in msg.tool_calls:
        fn_name = tc.function.name
        try:
            args = json.loads(tc.function.arguments)
        except Exception:
            args = {"command": tc.function.arguments}
            
        cmd = args.get("command", "")
        print(f"🛠️ [Hermes Tool Call] {fn_name}: {cmd}\n")
        
        # Executa no terminal com tratamento tolerante de encoding
        proc = subprocess.run(
            cmd,
            shell=True,
            capture_output=True,
            text=True,
            errors="replace"
        )
        stdout = proc.stdout.strip()
        stderr = proc.stderr.strip()
        output = stdout
        if stderr:
            output += ("\nSTDERR:\n" + stderr if output else stderr)
        if not output:
            output = "(comando executado com sucesso e sem saída)"
            
        print(f"💻 [Saída Real do Sistema]:\n{output[:1000]}\n")
        
        messages.append(msg)
        messages.append({
            "role": "tool",
            "tool_call_id": tc.id,
            "content": output[:8000] # Limite seguro para não sobrecarregar
        })
        
    # 2. Turno final: o modelo processa a saída real da ferramenta
    final_resp = client.chat.completions.create(
        model="qwen3.5:9b",
        messages=messages,
        tools=TOOLS,
        temperature=0.1
    )
    final_text = final_resp.choices[0].message.content or ""
    print(f"✅ [Hermes Conclusão do Passo]:\n{final_text}\n")
    return True, final_text

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python3 hermes_runner.py '<instrucao>'")
        sys.exit(1)
        
    instr = " ".join(sys.argv[1:])
    success, result = run_step(instr)
    sys.exit(0 if success else 1)

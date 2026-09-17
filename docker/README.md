# 🐳 Stack Docker de IA Local — Archimedes

Stack padronizada para execução de Large Language Models (LLMs) locais e interface de chat de ponta.

## 📦 Serviços Inclusos

| Serviço | Imagem Oficial | Porta | Descrição |
|---|---|---|---|
| **Ollama** | `ollama/ollama:latest` | `11434` | Runtime de inferência e gerenciador de modelos locais |
| **Open-WebUI** | `ghcr.io/open-webui/open-webui:main` | `3000` | Interface web moderna, suporte a RAG, personas e chat |

## 🚀 Como Usar

Subir os serviços em segundo plano:
```bash
docker compose up -d
```

Verificar saúde dos containers:
```bash
docker compose ps
```

Acessar a interface:
- Abra o navegador em `http://localhost:3000`

Parar os serviços:
```bash
docker compose down
```

---

## 🔗 Fontes e Referências
- [Ollama Oficial](https://ollama.com)
- [Open-WebUI Docs](https://docs.openwebui.com)
- [AGENTS.md](../AGENTS.md)

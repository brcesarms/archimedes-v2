# 🧪 Benchmarks de Modelos de IA Local — Archimedes

Esta pasta armazena o histórico empírico e os relatórios de benchmarks dos modelos de Inteligência Artificial testados no hardware local (notadamente a máquina de inferência GEEKOM A7 MAX e Alienware).

## 📁 Estrutura

- **[BENCHMARKS.md](./BENCHMARKS.md)**: Quadro consolidado das métricas de velocidade (tok/s), alocação de VRAM e estabilidade de tool calling para uso agêntico.
- **[HISTORICO.md](./HISTORICO.md)**: Histórico detalhado de testes comparativos, lições aprendidas e análise comportamental de cada modelo.
- **[resultados/](./resultados/)**: Arquivos de log e payloads JSON brutos coletados durante as sessões de benchmark da API do Ollama.

## 🛠️ Padrões de Indústria para Novos Benchmarks

Para execuções futuras e mensurações padronizadas, utilize ferramentas de mercado consagradas:
- **`llama-bench`**: Utilitário nativo de alta precisão do ecossistema llama.cpp para avaliar tokens/segundo de prompt processing e token generation.
- **Ollama API (`/api/generate`)**: Chamadas REST automatizadas com medição de `eval_count` e `eval_duration`.

---

## 🔗 Fontes
- [Documentação Oficial do Ollama](https://github.com/ollama/ollama)
- [Perfis de Hardware](../perfis/my-setup.md)

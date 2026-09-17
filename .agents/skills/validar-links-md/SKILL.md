---
name: validar-links-md
description: Validação de links markdown em notas e arquivos do Archimedes Vault. Verifica se destinos de links relativos existem e detecta links quebrados.
---

# 🔗 Skill: validar-links-md

## Validação de Links em Markdown

Esta skill valida links markdown em arquivos do cofre usando o motor de alta performance **`lychee` (Rust)**, com fallback para o script Python legado.

## 📋 O que fazer

### Método 1: `lychee` (Recomendado — Ultra-rápido em Rust)

O `lychee` lê automaticamente o arquivo `.lychee.toml` na raiz do cofre e valida centenas de links em milissegundos:

```bash
# Validar links locais (offline) em todo o cofre:
lychee --offline .

# Validar links incluindo URLs externas na web:
lychee .

# Validar apenas uma pasta específica:
lychee --offline docs/notas/
```

### Método 2: Script Python (Legado / Fallback)
1. **Ativar venv**:
   ```bash
   cd ~/archimedes-v2/scripts/python
   source .venv/bin/activate
   ```

2. **Rodar o validador**:
   ```bash
   python3 validar_links.py ~/archimedes-v2 --raiz ~/archimedes-v2
   ```

3. **Interpretar o relatório**:
   - ✅ links que resolvem para destinos existentes
   - ❌ links quebrados (destino não existe) → listados com arquivo, linha e link
   - Ignorados: URLs externas (`http/https/ftp/mailto/www`), âncoras (`#...`), blocos de código e código inline

4. **Rodar os testes** (após alterar o script):
   ```bash
   python3 -m pytest tests/ -v
   ```

## 📝 Resultado esperado

- Log de cada link com ✅ ou ❌
- Resumo final com quantidade de links quebrados
- Exit code: `0` sem quebrados, `1` com quebrados, `2` caminho inválido

> 🧪 **Testes obrigatórios:** todo script Python novo em `scripts/python/` deve ter testes em `tests/` (ver skill `revisar-scripts` e nota `arquitetura-vault.md`).

## 🧠 Lições Aprendidas (auditoria 2026-09-11)

1. **Subagentes erram a profundidade de links relativos** — notas geradas por IA usavam padrões errados: `../AGENTS.md` (deveria ser `../../AGENTS.md` por estar em `notas/`), `./docs/guia-ia-local/README.md` (deveria ser `../README.md`), `reestruturação` com cedilha (arquivo real é sem acento). **Sempre revalidar após gerar notas em lote.**
2. **Acentos/cedilhas quebram links silenciosamente** — o cofre usa `kebab-case` SEM acento; link com `ç` não resolve. Se o arquivo existe mas o validador aponta quebrado, confira acentuação do nome.
3. **Falso-positivos automáticos** — `node_modules`, curingas `*`/`?`, URLs externas, âncoras e code blocks são ignorados pelo script. **Não** corrigir esses links.
4. **Erros sistemáticos → correção em lote**: quando o MESMO padrão repete em vários arquivos (ex: `docs/guia-ia-local/guia-ia-local`, `../.opencode/`), usar `git grep` para mapear e edições com `replaceAll` por arquivo — depois revalidar até 0.

## 🔗 Fontes

- 📄 Processo definido em: [`AGENTS.md`](../../../AGENTS.md)
- 🐍 Script: `scripts/python/validar_links.py` (módulo em `snake_case` por ser importável — PEP 8)
- 🧪 Testes: `scripts/python/tests/test_validar_links.py`
- 🗺️ Arquitetura: `docs/notas/arquitetura-vault.md`

# 🗺️ Arquitetura do Archimedes Vault

> **Data:** 2026-09-11 · **Tipo:** Nota de arquitetura · **Status:** Aprovada ✅

## 🎯 Princípio

Adotar a arquitetura do archimedes-operator **de forma seletiva**: camadas bem definidas e testes para lógica complexa — **sem** reescrever scripts que já resolvem bem em bash.

## 🧭 As 3 ferramentas e quando usar

| Ferramenta | Onde usar | Por quê |
| :--- | :--- | :--- |
| 🐚 **Bash** (`scripts/linux/`) | Tarefas locais simples: backup, cron, sync, validações de shell | Resolve em poucas linhas; zero dependência |
| 🪟 **PowerShell** (`scripts/windows/`) | Ações dentro do Windows (SSH, ajustes, debloat) | Só ele fala nativo com Windows/winget/registro |
| 🐍 **Python** (`scripts/python/`) | Parsing pesado (links markdown), relatórios ricos, **orquestração remota** | Lógica complexa + bibliotecas + testes pytest |

## 🗺️ Diagrama de camadas

```text
┌─────────────────────────────────────────────────────────────┐
│  🗒️ SKILLS (.opencode/skills/)                              │
│  Instruções markdown que o Archimedes segue                 │
└─────────────────────────────────────────────────────────────┘
                        │ "executa"
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  🐚/🐍/🪟 SCRIPTS (scripts/)                  │
│  bash (local) · python (parsing/orquestração) · ps1 (Win)   │
└─────────────────────────────────────────────────────────────┘
                        │ "produz"
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  📋 MARKDOWN/RELATÓRIOS (manifests/, notas/, logs)          │
│  Resultado legível no Obsidian/GitHub                       │
└─────────────────────────────────────────────────────────────┘
```

## 🧪 Testes (pytest)

- Scripts Python com parsing/relatório **devem** ter testes em `scripts/python/tests/`.
- Rodar: `cd scripts/python && source .venv/bin/activate && python3 -m pytest tests/ -v`

## 🔌 Reuso do motor remoto

- Operações remotas (SSH/SFTP/inventário/backup/manifesto) **referenciam** o motor do `archimedes-operator` — ver skill 🔌 `motor-remoto`.
- ❌ Nunca duplicar `orquestrador.py` ou `.ps1` no vault.

## ⚠️ Exceção de nomenclatura

- A convenção do cofre é `kebab-case`, mas **scripts Python usam `snake_case`** (`validar_links.py`) porque módulo com hífen não pode ser importado (PEP 8).
- Arquivos Markdown/notas continuam em `kebab-case`.

## 🔗 Fontes

- [ADR-001: Arquitetura Python/PowerShell](../arquitetura/adr-001-python-powershell.md)
- [Skill motor-remoto](../../.agents/skills/motor-remoto/SKILL.md)
- [Skill validar-links-md](../../.agents/skills/validar-links-md/SKILL.md)
- [Projeto bancada no GitHub](https://github.com/brcesarms/archimedes-operator)
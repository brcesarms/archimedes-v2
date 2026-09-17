---
name: auditar-cofre
description: Auditoria de saúde do Archimedes Vault (Vault Health Report). Use quando o usuário pedir "auditar cofre", "vault health", "saúde do cofre", "links quebrados", "notas órfãs" ou "propor MOC". Executa a checagem de 4 passos e gera um relatório em notas/vault-health-report.md.
compatibility: opencode
metadata:
  audience: ia-local
  workflow: auditoria
---

# 🏥 Auditoria do Cofre (Vault Health Report)

Realize esta auditoria quando solicitado. Ela verifica a saúde do vault e gera um relatório.

## 🔍 1. Links Quebrados

Usar o **validador Python** (skill [`validar-links-md`](../validar-links-md/SKILL.md)) — mais preciso que grep:

```bash
cd ~/archimedes/scripts/python
source .venv/bin/activate
python3 validar_links.py ~/archimedes --raiz ~/archimedes
```

- ❌ links quebrados reais → corrigir (ver lições na skill `validar-links-md`)
- ⚪ já ignorados automaticamente: `node_modules`, curingas `*`/`?`, URLs externas, âncoras, code blocks

## 🕸️ 2. Notas Órfãs

- Mapear notas que **não recebem nenhum link** de outras notas (zero backlinks)
- Sugerir de onde faria sentido criar links para elas

## 🗺️ 3. Proposta de Novos MOCs

- Contar a frequência de tags no frontmatter YAML das notas
- Se uma tag tiver **mais de 7 notas** e não existir **MOC** para ela, propor a criação
- O MOC deve listar e categorizar os links das notas daquele assunto

## 📊 4. Relatório

Criar a nota `docs/notas/vault-health-report.md` resumindo:
- Inconsistências encontradas
- Notas órfãs
- Sugestões de MOCs

## 📝 Formato do relatório

Use emojis, tabelas e a seção `## 🔗 Fontes` no final, conforme as convenções do cofre:
- ✅ Links OK
- ❌ Links quebrados (com caminho)
- 🕸️ Notas órfãs
- 🗺️ MOCs propostos

---

## 🔗 Fontes

- 📄 Processo definido em: [`AGENTS.md`](../../../AGENTS.md)

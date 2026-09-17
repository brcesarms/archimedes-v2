---
name: gerenciar-links
description: Gerenciamento de links entre notas do Archimedes. Use quando o usuário pedir "gerenciar links", "conectar notas", "corrigir links", "evitar notas órfãs", "revisar backlinks" ou quando notas estiverem isoladas. Cria conexões entre notas correlatas e corrige links quebrados.
compatibility: opencode
metadata:
  audience: ia-local
  workflow: notas
---

# 🔗 Gerenciar Links do Archimedes

Notas atômicas nunca ficam isoladas — conecte-as com notas correlatas e índices.

## 🔍 Como gerenciar links

### 1. Identificar notas isoladas (órfãs)

- Buscar notas que não recebem nenhum link de outras notas
- Verificar backlinks: quais notas apontam para cada nota?

Comando útil:
```bash
# Listar todos os links markdown
grep -rEn '\[[^]]*\]\([^)]*\)' ~/archimedes-v2 --include="*.md"
```

### 2. Conectar notas correlatas

- Para cada nota órfã, encontrar notas sobre o mesmo assunto
- Adicionar links bidirecionais (nota A → nota B e nota B → nota A)
- Conectar com o MOC do assunto, se existir (ver skill `criar-moc`)

### 3. Corrigir links quebrados

- Localizar links que apontam para arquivos inexistentes
- Corrigir o caminho ou remover o link

> ⚠️ **PEGADINHA DA VALIDAÇÃO:** links markdown são **relativos ao diretório do arquivo** que os contém. Ao verificar/validar links de uma nota, rode a checagem **a partir do diretório da nota** (`cd "$(dirname nota.md)"`), nunca da raiz do cofre — senão todo `../` parece quebrado por engano (já nos mordeu em 2026-09-04!).

### 4. Regras de links

- ✅ **Sempre** links markdown com caminhos relativos
- ❌ **Nunca** wikilinks `[[...]]`
- ✅ Links relativos à pasta atual: `./nota-correlata.md`
- ✅ Links entre pastas do sistema: `../convencoes/nota.md`
- ✅ Links para estudos pessoais: `~/wikisidian/concurseiro/nota.md` (fora do repo público)

## 📌 Exemplo

Nota órfã `~/wikisidian/t.i/docker-redes.md` → conectar com:
- `./docker-basico.md` (mesma pasta)
- `~/wikisidian/t.i/docker-moc.md` (MOC do assunto)

## ✅ Checklist ao finalizar

1. [ ] Todas as notas conexas entre si
2. [ ] Nenhuma nota órfã sem destino
3. [ ] Links relativos (sem wikilinks)
4. [ ] Links quebrados corrigidos

---

## 🔗 Fontes

- 🔗 Regras de links: [`AGENTS.md`](../../../AGENTS.md) (Notas Atômicas / Formato de Links)

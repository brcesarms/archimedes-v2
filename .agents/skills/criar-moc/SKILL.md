---
name: criar-moc
description: Criação de Maps of Content (MOC), índices que agrupam e conectam notas de um mesmo assunto. Use quando o usuário pedir "criar MOC", "mapa de conteúdo", "índice do assunto" ou quando houver mais de 7 notas sobre o mesmo tema sem um índice para conectá-las.
compatibility: opencode
metadata:
  audience: ia-local
  workflow: organização
---

# 🗺️ Criar MOC (Map of Content)

Um **MOC (Map of Content)** é uma nota-índice que reúne, organiza e conecta **todas as notas de um mesmo assunto** em um único lugar. É o "sumário vivo" de um tema.

## ⚖️ O que é MOC vs. outro elemento

| 🧩 | 📂 Pasta | 🗺️ MOC | 📝 Nota Atômica |
|----|----------|---------|-----------------|
| O que é | Contêiner no disco | Índice/central de links | Conteúdo único |
| Contém | Arquivos | Links para notas | Um assunto |

## 🔎 Quando criar um MOC

- Quando uma tag/assunto tiver **mais de 7 notas** (conforme regra do AGENTS.md)
- Quando o usuário pedir explicitamente (dizer "criar MOC" ou "índice do assunto")
- Quando houver várias notas sobre o mesmo tema ainda desconectadas entre si

## 🛠️ Como criar

### 1. Identificar o assunto
- Verificar quais notas pertencem ao tema (por pasta, tag no frontmatter ou conteúdo)
- Confirmar se já não existe um MOC para esse assunto

### 2. Definir nome e local
- Nome do arquivo: kebab-case, minúsculas, **sem emojis**
- Local: na mesma pasta do assunto (ex: `~/wikisidian/t.i/docker.md`, `~/wikisidian/concurseiro/direito-administrativo.md`)

### 3. Estrutura padrão do MOC

```markdown
# 📚 Direito Administrativo — Mapa de Conteúdo

## 🔧 Teoria Básica
- [Ato administrativo](../../../../wikisidian/concurseiro/07_administracao_publica/administracao_publica.md)
- [Princípios administrativos](../../../../wikisidian/concurseiro/07_administracao_publica/README.md)

## 🌐 Jurisprudência
- [STJ - Súmulas](https://ww2.stj.jus.br)

---

## 🔗 Fontes
- [Legislação brasileira](https://www.planalto.gov.br)
```

### 4. Regras dos links
- ✅ Links markdown com caminhos relativos
- ❌ **Proibido** wikilinks `[[...]]`
- Agrupar notas por categoria, não listar soltas

### 5. Conectar o MOC
- Todas as notas do assunto devem linkar de volta para o MOC
- O MOC nunca deve ficar isolado — conectá-lo a outros MOCs ou à nota de índice

## 📝 Checklist antes de salvar

1. [ ] Nome em kebab-case, minúsculas, sem emojis
2. [ ] H1 com emoji do assunto
3. [ ] Categorias que agrupam as notas
4. [ ] Links markdown relativos (sem wikilinks)
5. [ ] Seção `## 🔗 Fontes` no final
6. [ ] Notas apontam de volta para o MOC

---

## 🔗 Fontes

- 📄 Regra de MOCs definida em: [`AGENTS.md`](../../../AGENTS.md)

# 🏥 Auditoria do Vault

> Carregue este arquivo quando o Bruno pedir auditoria do cofre (saúde do vault).
> 📝 Lições aprendidas sobre manutenção do cofre: [`notas/licoes-manutencao-cofre-2026-09-04.md`](../../docs/notas/licoes-manutencao-cofre-2026-09-04.md)

## 🔍 Procedimento de 4 passos

### 1. Links Quebrados 🔍🚫

- Analisar todos os `.md` buscando links `[Texto](caminho)`
- Verificar se o destino realmente existe no cofre
- Listar links quebrados ou caminhos incorretos

> ⚠️ **PEGADINHA DA VALIDAÇÃO (já nos mordeu!):** links markdown são **relativos ao diretório do arquivo** que os contém (ex: uma nota em `notas/` usa `../.opencode/...`). Se você validar a partir da raiz ou de outro diretório, todo link "quebra" por engano. **Sempre validar a partir do diretório do arquivo analisado.**

```bash
# ✅ Correto: valida a partir do diretório da nota
cd "$(dirname caminho/da/nota.md)"
grep -oP '\]\(\K[^)]+' nota.md | while read -r dest; do
    [ -e "$dest" ] && echo "✅ $dest" || echo "❌ $dest QUEBRADO"
done
```

```bash
# ❌ ERRADO: valida da raiz do cofre (links de notas em subpastas quebram por engano)
cd ~/archimedes
grep -oP '\]\(\K[^)]+' notas/nota.md | while read -r dest; do
    [ -e "$dest" ] && echo "✅" || echo "❌"   # todos quebram se $dest começa com ../ 
done
```

### 2. Notas Órfãs 🕸️🏚️

- Mapear notas que não recebem nenhum link de outras notas (zero backlinks)
- Sugerir de onde faria sentido criar links

### 3. Proposta de Novos MOCs 🗺️🗂️

- Contar frequência de tags no frontmatter YAML
- Se uma tag tiver **+7 notas** e não existir MOC, proponha criação
- O MOC deve listar e categorizar os links das notas do assunto

### 4. Relatório

- Criar nota `vault-health-report.md`
- Resumir inconsistências, notas órfãs e sugestões de MOCs

---

## 🔗 Fontes
- [Obsidian - Tags](https://help.obsidian.md/editing-and-formatting/tags)

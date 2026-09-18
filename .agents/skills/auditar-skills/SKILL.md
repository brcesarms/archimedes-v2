---
name: auditar-skills
description: Auditoria das skills do Archimedes para identificar quais não estão sendo usadas e são candidatas a exclusão. Use ao ouvir "auditar skills", "quais skills não são usadas", "dieta de skills", "limpar skills", "skills inativas", "revisar skills", "skills mortas". Analisa referências cruzadas, links internos e gera relatório com recomendação de manter/excluir/mergear — nunca exclui sem confirmação explícita.
compatibility: agy, hermes
metadata:
  audience: ia-local
  workflow: skills
---

# 🧼 Auditoria de Skills do Archimedes

O cofre é um segundo cérebro — e skills demais viram peso morto. Esta auditoria mantém as skills **enxutas e usadas**, evitando o over-engineering de regras que ninguém consulta.

> ⚠️ **Regra de ouro:** nunca excluir uma skill sem confirmação explícita do usuário. A auditoria **recomenda**; o usuário **decide**.

## 🔍 Ordem da auditoria

### 1. 📋 Listar skills existentes

```bash
ls -d .opencode/skills/*/
```

### 2. 🔗 Contar referências cruzadas (critério principal)

Para cada skill, contar quantas vezes o **nome da skill** aparece em: `AGENTS.md`, outras skills, convenções e notas.

> ⚠️ **PEGADINHA DO `rg` (já nos mordeu!):** a pasta `.opencode/` começa com ponto = oculta, e o `rg` **ignora arquivos/pastas ocultas por padrão**. Sem `--hidden` você conta metade das referências e pode concluir errado que uma skill não é usada! **SEMPRE usar `--hidden`** na busca.

```bash
# Exemplo para a skill "auditar-skills" (--hidden é OBRIGATÓRIO)
rg -l --hidden "auditar-skills" . --glob '!*.tar.gz' | wc -l
# ou listar onde aparece:
rg -l --hidden "auditar-skills" . --glob '!*.tar.gz'
```

> 💡 O nome da skill costuma ser distinto o suficiente para não gerar falsos positivos (ex: `backup-cofre` vs a palavra "backup" genérica).
> 💡 Distinguir **links reais** de **exemplos didáticos** (code blocks / backticks) — exemplos em crases como `[Nota A](./nota-a.md)` NÃO são links quebrados de verdade.

### 3. 🔗 Verificar links internos da skill

Skill com links quebrados internos = sinal de abandono:

```bash
# Extrai links markdown do SKILL.md e confere se o destino existe
grep -oP '\]\(\K[^)]+' .opencode/skills/<skill>/SKILL.md | while read -r dest; do
    [ -e "$(dirname .opencode/skills/<skill>/SKILL.md)/$dest" ] && echo "✅ $dest" || echo "❌ $dest QUEBRADO"
done
```

### 4. 🏷️ Classificar cada skill

| Referências | Links internos | Classificação | Ação |
|-------------|----------------|---------------|------|
| 0-1 | ok/quebrados | 🟠 **Candidata a exclusão** | Recomendar excluir ou mergear |
| 2+ | ok | 🟢 **Saudável** | Manter |
| 2+ | quebrados | 🟡 **Manutenção** | Corrigir links, manter |

### 5. 📊 Gerar relatório

Apresentar tabela com: skill | referências | links | classificação | recomendação.

---

## 🗑️ Fluxo de exclusão (após confirmação do usuário)

1. Mover skill para lixeira: `mv .opencode/skills/<skill> /tmp/opencode/skills-<skill>-$(date +%Y%m%d%H%M%S)`
   > 🗑️ Mover para `/tmp` em vez de `rm -rf` = seguro por padrão (recuperável até reiniciar)
2. **Limpar referências** no `AGENTS.md` (remover da lista de skills) e em links de outras skills/notas
3. Verificar com grep que nenhuma referência órfã restou
4. Rodar `./scripts/linux/verificar-scripts.sh` (se houver scripts afetados)

## 📌 Regras

- 🔓 **Nunca** excluir sem confirmação explícita do usuário
- 🗑️ Preferir `mv` para lixeira (recuperável) em vez de `rm -rf`
- 🔗 Após excluir, **sempre limpar as referências** (AGENTS.md, links de outras skills) — senão troca skill morta por link quebrado
- 🧠 Só criar skill nova depois do padrão se repetir 2-3x (dieta de meta)

---

## 🔗 Fontes

- 🧠 Regra de sobrecarga de metas: [`AGENTS.md`](../../../AGENTS.md) (Gerenciamento de Contexto)
- 🏥 Auditoria do conteúdo do cofre (notas/MOCs): [`auditar-cofre`](../auditar-cofre/SKILL.md)
- 🔗 Correção de links: [`gerenciar-links`](../gerenciar-links/SKILL.md)
- 💾 Backup antes de mexer: [`backup-cofre`](../backup-cofre/SKILL.md)
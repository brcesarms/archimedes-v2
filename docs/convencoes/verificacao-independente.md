# 🕵️ Verificação Independente — Boa Prática Universal

> **Regra de ouro:** *"Relatório não é evidência."*
> SEMPRE re-checar por conta própria antes de reportar sucesso. Adotado como boa prática em 2026-09-09 (pedido explícito do Bruno).

## 🎯 Por quê

- Modelos locais (Executor) podem **reportar sucesso sem ter confirmado de fato**
- Um `echo "Tarefa concluída!"` do agente NÃO prova que a estrutura está correta
- O J.A.R.V.I.S. (supervisor) é responsável pela **verificação independente** — separada do agente executor

## ✅ Como verificar (não confiar em relatório)

| Situação | Comando de verificação |
|----------|------------------------|
| Criou arquivo | `ls -la <arquivo>` |
| Editou arquivo | `grep "conteúdo" <arquivo>` ou `diff` com origem |
| Criou diretório | `ls <dir>/` |
| Rodou script | exit code + saída real |
| Clonou repo | `ls <dir>/` + `.git` presente + `git log --oneline -3` |
| Inicializou submódulos | `git submodule status` (mostra hash + branch real) |
| Transferiu arquivos (scp/rsync) | `sha256sum`/`md5sum` **nos dois lados** (idênticos) |
| Configurou SSH remoto | `ssh <host> 'comando'` e conferir saída real |
| Criou link | destino existe (`ls -la` / `readlink`) |

## 🚦 Fluxo quando se recebe "concluído com sucesso"

1. **NÃO** aceitar o relatório como verdade
2. Re-executar os comandos de verificação **por conta própria** (outra sessão/comando)
3. Comparar com o esperado
4. Só então reportar sucesso ao Bruno — com a EVIDÊNCIA (saída real)

## 🏷️ Se a verificação divergir do relatório

- Reportar divergência em PT-BR, com a saída real
- Marcar tarefa com `#falha`
- **NUNCA** alucinar sucesso (`AGENTS.md § Tratamento de Erros`)

## ⚠️ Atenção — não confundir

- **Relatório do agente** = texto que o LLM gerou (pode alucinar) → NÃO é evidência
- **Evidência** = saída real de comandos (`ls`, `git log`, `sha256sum`) → É a verdade

---

## 🔗 Fontes

- [AGENTS.md — Auto-Verificação](../../AGENTS.md)
- [Skill atualizar-ssh — Regras](../../.agents/skills/atualizar-ssh/SKILL.md)
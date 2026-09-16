---
description: Iniciar planejamento persistente com planning-with-files (task_plan.md, findings.md, progress.md); flags --gated, --autonomous, --template analytics, e nome opcional do plano
---
Iniciar o fluxo de trabalho do planning-with-files para este projeto.

Argumentos informados: "$ARGUMENTS"

1. Chame a ferramenta `pwf_init` ou inicialize a tríade de arquivos. Mapeie os argumentos: `--gated` define o modo "gated", `--autonomous` define o modo "autonomous", `--template analytics` usa o template "analytics"; qualquer palavra restante forma o nome do plano. Um nome cria um diretório `.planning/YYYY-MM-DD-<slug>/` e o torna ativo; sem nome, usa a raiz do projeto.
2. Leia os arquivos gerados `task_plan.md`, `findings.md` e `progress.md` do diretório definido, preenchendo o objetivo, os critérios de aceitação e as fases da tarefa antes de qualquer outra ação.
3. Siga o fluxo do planning-with-files: atualize `progress.md` após cada ação relevante, registre lições em `findings.md` e marque as fases como concluídas à medida que forem finalizadas.

---
title: "Master Plan — Autonomia Total do Cofre"
date_created: 2026-09-08
date_updated: 2026-09-08
tags:
  - cerebro
  - plano
  - autonomia
  - roadmap
status: ativo
---

# 🗺️ Master Plan — Sistema Cérebro & Executor

> Plano de implementação em fases para tornar o projeto **100% autônomo**. Cada fase é quebrada em incrementos diários pequenos e executáveis.

## 🏛️ Visão Geral

O **Cérebro** (modelo grande, ex: `big-pickle`) projeta Runbooks e scripts mecânicos. O **Executor** (modelo local, ultra-rápido) roda os Runbooks com consistência, sem alucinar — guiado por scripts que fazem o trabalho pesado.

## 🚀 Fases

### 🔹 Fase 0 — Fundação *(HOJE ✅ CONCLUÍDA)*
- [x] Criar `AGENTS.md` (interface IA-para-IA + proteção ao Executor)
- [x] Definir estrutura de pastas (`estrutura-cofre.md`)
- [x] Criar template de Runbook (`template-runbook.md`)
- [x] Tarefa piloto: backup + limpeza de temporários (script + runbook)
- [x] Revisar se os Runbooks são verdadeiramente mecânicos (sem ambiguidade)
- [x] Criar 4 docs críticos: `DEPENDENCIAS.md`, `IA-RESTORE.md`, `README-manual.md`, `cerebrum/README.md`
- [x] Criar 3 perfis por máquina: `alienware.md`, `geekom.md`, `acer-paula.md`
- [x] Criar 4 scripts de validação: `valida-cofre.sh`, `verificar-seguranca.sh`, `validar-runbooks.sh`, `backup-logs.sh`
- [x] Padronizar 10 scripts com headers e `set -euo pipefail`
- [x] Agendar systemd timers: `logs-rotator.timer`, `backup-logs.timer`
- [x] Documentar `t.i/tests/` e `t.i/benchmarks/` com READMEs
- [x] Criar script `agendar-cron.sh` para gestão de agendamentos

### 🔹 Fase 1 — Rotinas Diárias *(semana 1)*
- [x] **Dia 1:** Runbook `git-sync` (pull/push + submódulo) — script existente `sync-cofre.sh`
- [x] **Dia 2:** Runbook `auditoria-cofre` (links quebrados + notas órfãs) — skill `auditar-cofre`
- [x] **Dia 0 (execução):** Rotina piloto **rodada na prática** — backup + limpeza OK, idempotente, 1º log em `cerebrum/logs/`
- [ ] **Incremento:** script dedicado de validação de links (resolve caminhos relativos por nota)
- [x] **Dia 3:** Agendar Fase 0 + Fase 1 em `cron`/`systemd timer` (user) no GEEKOM
- [x] **Dia 4:** Runbook `backup-semanal` (snapshot + push GitHub)
- [x] **Dia 5:** Runbook `saude-sistema` (OpenCode/Ollama: processos, disk, RAM)
- [ ] **Dia 6/7:** Ranhura de folga para ajustes

### 🔹 Fase 2 — Monitoramento *(semana 2)*
- [x] Logs centralizados em `docs/cerebrum/logs/`
- [x] Estatística de falhas (`#falha`) vs sucessos por runbook
- [x] Alerta ao Cérebro quando 2+ falhas seguidas na mesma rotina

### 🔹 Fase 3 — Delegação Total *(semana 3)*
- [x] Rodar todos os Runbooks via `opencode run --auto` (headless) no GEEKOM
- [x] Zero intervenção manual em tarefas de manutenção
- [x] Executor reporta resultado no próprio cofre (log + tag)

### 🔹 Fase 4 — Auto-Melhoria *(mês 2)*
- [ ] Cérebro revisa logs 1x/semana e evolui Runbooks
- [ ] Rotina vira self-serve: Executor sugere rotina nova, Cérebro valida
- [ ] Métrica: % de execuções sem alucinação (meta: 100%)

## 🎯 Definition of Done (projeto autônomo)

- [ ] Executor roda todos os Runbooks sem intervenção humana
- [ ] 100% das falhas gravadas com tag `#falha` (nunca silenciosas)
- [ ] Nenhum modelo local processa `AGENTS.md`
- [ ] Cérebro pode reconstruir qualquer rotina a partir dos Runbooks

---

## 🔗 Fontes

- 🧠 Nota raiz: [`AGENTS.md`](../../AGENTS.md)
- 🗂️ Estrutura: [`estrutura-cofre.md`](./estrutura-cofre.md)
- 📋 Template: [`template-runbook.md`](./template-runbook.md)
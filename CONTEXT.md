# 📋 Estado Vivo do Projeto — Archimedes V2

> **Atualizado dinamicamente pelo AGY CLI & Hermes Agent ao final de cada entrega ou sessão.**

---

## 🎯 Objetivo Atual
- Orquestração de automação local, infraestrutura e gestão de rotinas com delegação local-first ao Hermes Agent.
- Manutenção da regra de escopo: repositório `linux-toolbox-tui` restrito exclusivamente à aplicação TUI e scripts de pós-instalação Linux.

---

## 🕒 Últimas Alterações Realizadas
- **2026-09-18:**
  - Implementado o novo protocolo de orquestração e consulta prévia obrigatória ao Hermes Agent no `AGENTS.md`.
  - Revertido e limpo o repositório `linux-toolbox-tui` (removido runbook do MikroTik).
  - Memorizadas as restrições e comportamentos do MikroTik hAP ac^3 (RouterOS v7 `device-mode: home`) na memória permanente do Hermes Agent.
  - Adicionado protocolo de **Session Bootstrap** (inicialização de sessão) e **Estado Vivo (`CONTEXT.md`)**.

---

## 🚀 Próximos Passos
- Em cada nova sessão do AGY CLI, efetuar o **Session Bootstrap**: consultar a memória permanente do Hermes Agent e carregar o estado de `CONTEXT.md`.
- Manter registros de aprendizado de infraestrutura armazenados na memória permanente do Hermes Agent.

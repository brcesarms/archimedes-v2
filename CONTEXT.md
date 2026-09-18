# 📋 Estado Vivo do Projeto — Archimedes V2

> **Atualizado dinamicamente pelo AGY CLI & Hermes Agent ao final de cada entrega ou sessão.**

---

## 🎯 Objetivo Atual
- Orquestração de automação local, infraestrutura e gestão de rotinas com delegação local-first ao Hermes Agent.
- Manutenção da regra de escopo: repositório `linux-toolbox-tui` restrito exclusivamente à aplicação TUI e scripts de pós-instalação Linux.

---

## 🕒 Últimas Alterações Realizadas
- **2026-09-18 (sessão AGY tarde):**
  - Corrigido caractere invisível Unicode U+200D (ZWJ no emoji 👨‍💻) que bloqueava a leitura do `AGENTS.md` pelo Hermes Agent via Telegram.
  - Patch de resiliência aplicado em `~/.hermes/hermes-agent/tools/delegation_output_schema.py`: `coerce_output_schema` agora ignora esquemas malformados do LLM local em vez de abortar o `delegate_task`.
  - **Refatoração completa do `AGENTS.md` v3.0:** -34% bytes, zero redundâncias, todas as 19 skills listadas, fallback para Hermes offline, regra anti-ZWJ, versionamento.
  - Sincronizado `AGENTS.md` para `~/.gemini/config/plugins/archimedes-agent/rules/AGENTS.md`.
- **2026-09-18 (sessão anterior):**
  - Implementado o novo protocolo de orquestração e consulta prévia obrigatória ao Hermes Agent no `AGENTS.md`.
  - Revertido e limpo o repositório `linux-toolbox-tui` (removido runbook do MikroTik).
  - Memorizadas as restrições e comportamentos do MikroTik hAP ac^3 (RouterOS v7 `device-mode: home`) na memória permanente do Hermes Agent.
  - Adicionado protocolo de **Session Bootstrap** (inicialização de sessão) e **Estado Vivo (`CONTEXT.md`)**.
  - Removidas 3 skills descontinuadas absorvidas pelo Hermes Agent, mantendo 19 skills ativas.
  - Removida a VM antiga e recriada a VM 101 (`win11`) no Proxmox VE (`10.0.0.3`) totalmente otimizada.
  - Configurado e ativado o serviço systemd persistente `cpu-performance.service` no host Proxmox GEEKOM.

---

## 🚀 Próximos Passos
- Concluir a instalação interativa do Windows 11 via console do Proxmox (`https://10.0.0.3:8006`).
- Em cada nova sessão do AGY CLI, efetuar o **Session Bootstrap**: consultar a memória permanente do Hermes Agent e carregar o estado de `CONTEXT.md`.
- Manter registros de aprendizado de infraestrutura armazenados na memória permanente do Hermes Agent.


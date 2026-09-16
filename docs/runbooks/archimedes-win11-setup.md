# 🪟 Archimedes After-Install Win11 — Pós-Instalação & Debloat

> Criação: 2026-09-12 · Atualização: 2026-09-13 · Status: 🪟 Consolidado / Arquivado · Repo integrado: [`archimedes-operator`](https://github.com/brcesarms/archimedes-operator)

> ⚠️ **Consolidação:** Este repositório satélite foi unificado diretamente no repositório principal [`archimedes-operator`](https://github.com/brcesarms/archimedes-operator). Seus scripts de pós-instalação, Win11Debloat e runtimes residem em `~/projetos/archimedes-operator/scripts/powershell/`.

---

## 🎯 Objetivo

Reunir **pós-instalação e desbloat do Windows 11** em um módulo padronizado, sem duplicar código:

| Etapa | Script | Técnica |
| :--- | :--- | :--- |
| 🧩 Pós-instalação | `pos-instalacao.ps1` | Ajustes de sistema (energia, tema escuro, privacidade) + **10 apps** e **19 runtimes** via winget |
| 🧹 Desbloat | `Win11Debloat.ps1` | Remove bloatware, telemetria e ajusta privacidade/visual (cópia offline MIT) |

Arquitetura **controller + agent**: Python só no orquestrador (`archimedes-operator` / `pyinfra`); motores **PowerShell nativos** no alvo (referenciados por caminho absoluto — zero duplicação).

---

## 📁 Estrutura do Pacote

```text
~/projetos/archimedes-win11-setup/
├── windows/
│   ├── pos-instalacao.ps1    <-- 🧩 Migrado: ajustes + apps + runtimes
│   ├── Win11Debloat.ps1      <-- 🧹 Migrado: script principal do debloat (628 linhas)
│   ├── Win11Debloat.zip      <-- Migrado: pacote p/ envio remoto via SFTP
│   ├── Win11Debloat/         <-- Migrado: pacote completo (Regfiles, Scripts, Tests...)
│   └── README.md             <-- Instruções do módulo
├── docs/instrucoes.md        <-- Manual completo (requisitos, flags, tabelas de apps/runtimes)
├── README.md
└── LICENSE                   <-- MIT
```

---

## 🔀 Relação com o archimedes-operator

- O `pos-instalacao.ps1`, `Win11Debloat.ps1`, `Win11Debloat.zip` e `Win11Debloat/` foram integrados ao ecossistema da bancada.
- O `orquestrador.py` da bancada referencia caminho absoluto — sem duplicar código.
- Disparo remoto via flags `--pos` (completa/ajustes/sem-runtimes/sem-apps) e `--debloat` (completo/lite).

---

## 🧠 Ordem Ideal na Bancada

1. 💾 **Backup Forense** (`archimedes-operator` — robocopy/rsync)
2. 🧹 **Desbloat** (`Win11Debloat.ps1 -RunDefaults`)
3. 🧩 **Pós-instalação** (`pos-instalacao.ps1`)
4. ✅ **Validação e Entrega**

---

## 🛡️ Segurança

- `-ForceRemoveEdge` é agressivo — **somente com autorização explícita do cliente**.
- Rodar debloat **sempre com ponto de restauração** (`-CreateRestorePoint`).
- Nenhum dado sensível de cliente vive nos repositórios.

---

## 🔗 Fontes

- [Repositório archimedes-win11-setup](https://github.com/brcesarms/archimedes-win11-setup)
- [Win11Debloat — Raphire (GitHub)](https://github.com/Raphire/Win11Debloat)
- [winget — Microsoft Learn](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
- [Instruções de Bancada](./bancada-instrucoes.md)
- [AGENTS.md](../../AGENTS.md)

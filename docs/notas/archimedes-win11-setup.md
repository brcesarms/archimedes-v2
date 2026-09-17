# 🪟 Archimedes After-Install Win11 — (Consolidado no archimedes-operator)

> Criação: 2026-09-12 · Atualização: 2026-09-13 · Status: 🪟 consolidado / arquivado · Repo integrado: [`archimedes-operator`](https://github.com/brcesarms/archimedes-operator)

> ⚠️ **Consolidação em 2026-09-13:** Este repositório satélite foi unificado diretamente no repositório principal [`archimedes-operator`](https://github.com/brcesarms/archimedes-operator). Seus scripts de pós-instalação, Win11Debloat e runtimes agora residem nativamente em `~/projetos/archimedes-operator/scripts/powershell/`.

## 🎯 Objetivo

Reunir **pós-instalação e desbloat do Windows 11** em um repositório único, sem duplicar código:

| Etapa | Script | Técnica |
| :--- | :--- | :--- |
| 🧩 Pós-instalação | `pos-instalacao.ps1` | Ajustes de sistema (energia, tema escuro, privacidade) + **10 apps** e **19 runtimes** via winget |
| 🧹 Desbloat | `Win11Debloat.ps1` | Remove bloatware, telemetria e ajusta privacidade/visual (cópia offline MIT) |

Arquitetura **controller + agent**: Python só no orquestrador (`archimedes-operator`); motores **PowerShell nativos** no alvo (referenciados por caminho absoluto — zero duplicação).

## 📁 Estrutura

```text
~/projetos/archimedes-win11-setup/
├── windows/
│   ├── pos-instalacao.ps1    <-- 🧩 Migrado: ajustes + apps + runtimes
│   ├── Win11Debloat.ps1      <-- 🧹 Migrado: script principal do debloat (628 linhas)
│   ├── Win11Debloat.zip      <-- Migrado: pacote p/ envio remoto via SFTP
│   ├── Win11Debloat/         <-- Migrado: pacote completo (Regfiles, Scripts, Tests...) — AGORA VERSIONADO
│   └── README.md             <-- Instruções do módulo
├── docs/instrucoes.md        <-- Manual completo (requisitos, flags, tabelas de apps/runtimes)
├── README.md
└── LICENSE                   <-- MIT
```

## 🔀 Relação com o archimedes-operator

- O `pos-instalacao.ps1`, `Win11Debloat.ps1`, `Win11Debloat.zip` e `Win11Debloat/` **saíram** de `archimedes-operator/scripts/powershell/` (2026-09-12).
- O `orquestrador.py` da bancada referencia **caminho absoluto** `~/projetos/archimedes-win11-setup/windows/` — sem duplicar código (mesmo padrão do `archimedes-backup`).
- Disparo remoto via flags `--pos` (completa/ajustes/sem-runtimes/sem-apps) e `--debloat` (completo/lite).

## 🧠 Ordem ideal na bancada

1. 💾 **Backup** (`archimedes-backup` — robocopy/rsync) → 2. 🧹 **Desbloat** (`Win11Debloat.ps1 -RunDefaults`) → 3. 🧩 **Pós-instalação** (`pos-instalacao.ps1`) → 4. ✅ **Entrega**

## 🛡️ Segurança

- `-ForceRemoveEdge` é agressivo — **somente com autorização explícita do cliente**.
- Rodar desbloat **sempre com ponto de restauração** (`-CreateRestorePoint`).
- Nenhum dado sensível de cliente vive aqui (scripts são genéricos).

## ✅ Status 2026-09-12

- ✔ Repo criado e público: [brcesarms/archimedes-win11-setup](https://github.com/brcesarms/archimedes-win11-setup) (commit `cadc547`).
- ✔ 404 arquivos versionados (pacote Win11Debloat completo, antes fora do git).
- ✔ `archimedes-operator` atualizado (`e9e6d56`) — fluxo `--pos`/`--debloat` funcionando via caminho absoluto.
- ✔ 23 testes do archimedes-operator passando após a migração.

## 🔗 Fontes

- [Repositório archimedes-win11-setup](https://github.com/brcesarms/archimedes-win11-setup)
- [Win11Debloat — Raphire (GitHub)](https://github.com/Raphire/Win11Debloat)
- [winget — Microsoft Learn](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
- [Nota: Archimedes Backup](../notas/archimedes-backup.md)
# 📦 Archimedes Backup — (Consolidado no archimedes-operator)

> Criação: 2026-09-12 · Atualização: 2026-09-13 · Status: 📦 consolidado / arquivado · Repo integrado: [`archimedes-operator`](https://github.com/brcesarms/archimedes-operator)

> ⚠️ **Consolidação em 2026-09-13:** Este repositório satélite foi unificado diretamente no repositório principal [`archimedes-operator`](https://github.com/brcesarms/archimedes-operator). Seus scripts de robocopy, rsync e perfis agora residem nativamente em `~/projetos/archimedes-operator/scripts/powershell/` e `scripts/bash/`.

## 🎯 Objetivo

Unir **todo backup do ecossistema** em um único repositório, sem duplicar código:

| Plataforma | Motor | Técnica |
| :--- | :--- | :--- |
| 🪟 Windows | `robocopy` | Cópia por usuário (Desktop/Documents/Downloads/Pictures) → share SMB |
| 🐧 Linux | `rsync` | Cópia block-level (`-aHX --partial --delete`) → via SSH |

Arquitetura **controller + agent**: Python só no orquestrador; motores **nativos** no alvo
(PowerShell no Windows, rsync no Linux).

## 📁 Estrutura

```text
~/projetos/archimedes-backup/
├── orquestrador.py           <-- CLI: --perfil / --novo-perfil / --lista-perfis / --dry-run
├── comum/                    <-- perfis.py · conexao.py (paramiko) · relatorio.py · tests/
├── config/perfis/            <-- Perfis de máquina (.conf) — exemplo-linux, exemplo-windows...
├── linux/                    <-- motor-rsync.sh · setup-ssh.sh · README
├── windows/                  <-- backup-robocopy.ps1 (migrado) · README
├── docs/instrucoes.md        <-- Manual completo
├── manifests/                <-- Manifestos gerados (gitignored 🛡️)
└── logs/                     <-- Logs de execução (gitignored 🛡️)
```

## 🔀 Relação com o archimedes-operator

- O `backup-robocopy.ps1` **saiu** de `archimedes-operator/scripts/powershell/` (2026-09-12).
- O `orquestrador.py` da bancada referencia **caminho absoluto** `~/projetos/archimedes-backup/windows/backup-robocopy.ps1` — sem duplicar código.

## 🔗 Relação com o ecossistema Archimedes

| Repo | Papel |
| :--- | :--- |
| [`archimedes-win11-setup`](../runbooks/archimedes-win11-setup.md) | 🪟 Pós-instalação (apps + runtimes) e desbloat do Windows 11 — mesma arquitetura controller + agent, referenciado por caminho absoluto |

> 🧠 **Ordem ideal na bancada:** Backup (este repo) → Formatação → Desbloat → Pós-instalação → Entrega.

## 🔑 Perfis (config/perfis/*.conf)

```ini
[geral]
nome = omarchy-paula
plataforma = linux

[origem]
ssh_origem = paula@10.0.0.218       # vazio = origem local
caminho = /run/media/paula/BRUNO/
excluir = *.tmp,*.part

[destino]
ssh_destino = backup@10.0.0.4
caminho = /srv/arquivos/backup/omarchy-paula/
```

> `--novo-perfil` gera o esqueleto; edite e rode `--perfil <nome>`.

## 🌐 Backup do navegador (favoritos + senhas criptografadas)

Desde 2026-09-12 (`b09711e`) o orquestrador suporta **backup de navegador Chrome/Edge** quando o
perfil tem `[navegador] ativo = true`:

| Plataforma | Script | O que copia (destino: `navegador/<browser>/...`) |
| :--- | :--- | :--- |
| 🐧 Linux | `linux/motor-navegador.sh` (enviado à origem via scp) | `Local State` + por perfil: `Bookmarks`, `Bookmarks.bak`, `Login Data` |
| 🪟 Windows | `windows/backup-navegador.ps1` (via SSH/robocopy) | idem, sob `$Destino\navegador\<browser>\` |

- **Detecção:** navegador padrão (`xdg-settings` no Linux / associação `http` → `ChromeHTML`/`MSEdgeHTM` no Windows), com fallback por instalação.
- ⚠️ **Senhas:** somente como arquivo criptografado (`Login Data`, DPAPI no Windows) — **nunca** texto plano; restauram no mesmo usuário/máquina; destino sugerido: storage interno.
- Se o navegador nunca foi aberto (sem perfis), o motor avisa e pula.

## 🛡️ Política de segurança (bancada)

- Ambiente confiável: host keys automáticas + senha via prompt (nunca salva).
- **Nunca** commitar senha/token/chave privada (`manifests/` e `logs/` gitignored).
- Fora da bancada → adotar chave obrigatória + `known_hosts`.

## ✅ Status 2026-09-12

- ✔ SSH ativo no Omarchy (`10.0.0.218`) + chave do operador autorizada.
- ✔ 1º backup real `omarchy-paula` concluído: **314 arquivos · 89 GB** em `backup@10.0.0.4:/srv/arquivos/backup/omarchy-paula/`.
- ✔ Perfil atualizado: `caminho = /run/media/paula/BRUNO/pma` (partição exfat montada — não usar `/dev/sda3/pma`).
- ✔ Backup diário futuro: `python3 orquestrador.py --perfil omarchy-paula` (1 comando, sem senha).
- ℹ Chrome instalado no Omarchy porém **nunca aberto** — motor-navegador roda e avisa que não há perfis (comportamento esperado).

## 🔗 Fontes

- [Repositório archimedes-backup](https://github.com/brcesarms/archimedes-backup)
- [Nota: Archimedes After-Install Win11](../runbooks/archimedes-win11-setup.md)
- [Robocopy — Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy)
- [rsync man page](https://linux.die.net/man/1/rsync)
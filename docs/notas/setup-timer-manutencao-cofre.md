---
title: "Setup do Timer diário de manutenção do cofre (systemd)"
date_created: 2026-09-08
date_updated: 2026-09-08
tags:
  - sistema
  - systemd
  - timer
  - automacao
  - manutencao
status: ativo
---

# ⏰ Setup do Timer Diário de Manutenção (Cérebro → Executor)

> Instala o `manutencao-cofre.timer` no GEEKOM: roda o script do **Executor** todo dia às 03:00 — backup + limpeza de temporários, 100% automático. Também documenta a **correção do timer antigo quebrado**.

## 🎯 Contexto

O GEEKOM é o cofre principal com IA local. A rotina diária de **backup + limpeza** é delegada ao **Executor** (modelo local) via `manutencao-diaria-executor.sh`. O `systemd --user` timer dispara o script todo dia, sem intervenção humana.

## ⚠️ Antecedente (bug corrigido)

- Existia `backup-cofre.service` apontando para o **caminho antigo** `_scripts/linux/backup-cofre.sh`
- O cofre foi reorganizado — os scripts **migraram** para `scripts/linux/`
- Resultado: o timer falhava todo dia com `status=203/EXEC` ("Unable to locate executable") desde **06/09**
- **Correção:** removido o serviço/timer antigo e substituído pelo novo `manutencao-cofre`

## 📁 Unit Files (em `~/.config/systemd/user/`)

### `manutencao-cofre.service`
```ini
[Unit]
Description=Manutencao diaria do Obsidian Cofre (backup + limpeza temporarios)
After=network.target

[Service]
Type=oneshot
ExecStart=/var/home/brn/archimedes/scripts/linux/manutencao-diaria-executor.sh
```

### `manutencao-cofre.timer`
```ini
[Unit]
Description=Dispara manutencao-cofre.service diariamente as 03:00

[Timer]
OnCalendar=*-*-* 03:00:00
Persistent=true
RandomizedDelaySec=300

[Install]
WantedBy=timers.target
```

> `Persistent=true`: se a máquina estiver desligada na hora, roda no próximo boot. `RandomizedDelaySec=300`: espalha até 5 min para não bater com outros agendamentos.

## 🛠️ Instalação Manual

```bash
# copiar units para o GEEKOM
scp manutencao-cofre.service manutencao-cofre.timer geekom:~

# dentro do GEEKOM
mkdir -p ~/.config/systemd/user
mv ~/manutencao-cofre.service ~/manutencao-cofre.timer ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now manutencao-cofre.timer
```

## ✅ Verificação

```bash
systemctl --user list-timers manutencao*        # ver próximo disparo
systemctl --user status manutencao-cofre.service # status=0/SUCCESS
cat ~/archimedes/docs/cerebrum/logs/manutencao-*.log
```

## 🪵 Logs

- Toda execução grava `docs/cerebrum/logs/manutencao-<STAMP>.log`
- Backup em `~/backups/archimedes/` (rotação mantém as 7 últimas)

---

## 🔗 Fontes

- 🐚 Script do Executor: [`manutencao-diaria-executor.sh`](../../scripts/linux/manutencao-diaria-executor.sh)
- 📋 Runbook: [`runbook-backup-limpeza.md`](../runbooks/runbook-backup-limpeza.md)
- 🧠 Sistema: [`AGENTS.md`](../../AGENTS.md)
- 🔌 Conveções SSH: [`.opencode/convencoes/convencoes-ssh.md`](../convencoes/convencoes-ssh.md)
- 💾 Script de backup: [`backup-cofre.sh`](../../scripts/linux/backup-cofre.sh)
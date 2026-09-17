---
name: motor-remoto
description: Reuso do motor Python do archimedes-operator para operações remotas (SSH/SFTP/inventário/backup/manifesto) sem duplicar código. Use quando o usuário pedir "operar máquina remota", "inventário remoto", "backup remoto", "rodar banco no vault" ou quando uma tarefa do vault exigir executar scripts PowerShell em outra máquina via SSH/SFTP. Apenas REFERENCIA o orquestrador do archimedes-operator por caminho absoluto — nunca copie o código.
---

# 🔌 Skill: motor-remoto

## Reutilizar o motor Python do archimedes-operator (sem duplicar)

O Archimedes usa **um único motor** para operações remotas: o orquestrador do `archimedes-operator`. O vault **não** possui cópia — apenas referencia o caminho absoluto.

## 📂 Localização do motor

| Item | Caminho |
| :--- | :--- |
| CLI Global | `~/.local/bin/operator` e `pyinfra` (global via pipx) |
| Automações Declarativas Pyinfra | `~/projetos/archimedes-operator/scripts/pyinfra/` |
| Orquestrador Headless | `~/projetos/archimedes-operator/scripts/python/orquestrador.py` |
| Menu TUI Interativo | `~/projetos/archimedes-operator/scripts/python/menu.py` |
| Scripts PowerShell (Inventário, Backup, Setup) | `~/projetos/archimedes-operator/scripts/powershell/` |
| Scripts Bash (Rsync, Navegadores) | `~/projetos/archimedes-operator/scripts/bash/` |
| Venv | `~/projetos/archimedes-operator/.venv` |

## 📋 Como usar

### 1. Automação Declarativa com Pyinfra (Recomendado)
Executa tarefas declarativas com verificação prévia (dry-run) e idempotência:

```bash
# Executar inventário em host remoto ou máquina de bancada:
pyinfra -y <IP_OU_HOST_SSH> ~/projetos/archimedes-operator/scripts/pyinfra/inventario_remoto.py

# Testar localmente:
pyinfra -y @local ~/projetos/archimedes-operator/scripts/pyinfra/inventario_remoto.py
```

### 2. Orquestrador Python Legado (Paramiko)

1. **Ativar venv** (dependência `paramiko`):
   ```bash
   source ~/projetos/archimedes-operator/.venv/bin/activate
   ```

2. **Executar o orquestrador** com os parâmetros da máquina alvo:
   ```bash
   python3 ~/projetos/archimedes-operator/scripts/python/orquestrador.py \
       --host <IP> --usuario <usuario> --chave ~/.ssh/id_ed25519 \
       --cliente "<NOME_CLIENTE>" \
       --destino '<CAMINHO_UNC_OU_LOCAL>'
   ```

3. **Exemplo real** (VM Windows — confirmar dados na nota `proxmox-geekom-vm-windows.md`):
   ```bash
   python3 ~/projetos/archimedes-operator/scripts/python/orquestrador.py \
       --host 10.0.0.217 --usuario brces \
       --cliente "pricila braga" \
       --destino 'C:\Backups\Bancada\pricila braga'
   ```

## 🚫 Regras

- ❌ **NUNCA copiar** `orquestrador.py` ou `.ps1` para dentro do vault.
- ❌ **NUNCA** inventar novas flags — usar exatamente a interface do orquestrador (`--host`, `--usuario`, `--chave`, `--cliente`, `--destino`, `--saida`).
- ✅ Se faltar recurso no motor, **melhorar o archimedes-operator** (README, testes e docs lá) — depois atualizar esta skill.
- ✅ Configurações de máquinas conhecidas ficam nas notas do vault (ex: `docs/notas/proxmox-geekom-vm-windows.md`).

## 🔗 Fontes

- [Projeto bancada no GitHub](https://github.com/brcesarms/archimedes-operator)
- [Nota: Decisão de Arquitetura Python/PowerShell](../../../docs/notas/decisao-arquitetura-python-powershell-2026-09-11.md)
- [Nota: Arquitetura do Vault](../../../docs/notas/arquitetura-vault.md)
- [Nota: Proxmox GEEKOM — VM Windows](../../../docs/notas/proxmox-geekom-vm-windows.md)
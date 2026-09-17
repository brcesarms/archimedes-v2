# 🏛️ Proxmox GEEKOM — Setup e Acesso SSH à VM Windows

> **Data:** 2026-09-11 · **Status:** Ativo · **Tipo:** Nota técnica de infraestrutura

## 🎯 Resumo

O GEEKOM A7 MAX ("AI") foi transformado em servidor **Proxmox VE 9.2**. O Archimedes roda como VM/CT dentro dele (`10.0.0.10`) e agora tem acesso ao host e às VMs via **API token (PVEVMUser)** e **SSH (chave autorizada)**.

---

## 🖥️ Topologia

| Recurso | Valor |
| :--- | :--- |
| **Host Proxmox** | `10.0.0.3` (`root@10.0.0.3`) — pve-manager 9.2.2 |
| **API Proxmox** | `https://10.0.0.3:8006/api2/json/` |
| **VM Archimedes** (onde rodo) | `10.0.0.10` |
| **VM 100 — ubuntu24.04** | Ligada · 8 vCPU · 20 GB RAM |
| **VM 101 — win11** | Ligada · 4 vCPU · 8 GB RAM · **IP `10.0.0.217`** |
| **CT 102 — netboot-xyz** | Parada · 4 vCPU · 4 GB RAM |
| **CT 103 — arquivos** | Ligado · 2 vCPU · 2 GB RAM · 200 GB · **IP `10.0.0.4`** — Samba + NFS + SFTP |

> 🔐 **Token API:** salvo em `~/.config/proxmox/archimedes-token` (permissão 600, **fora do git**). Usuário `archimedes@pve` com role **PVEVMUser** (gerencia VMs, não mexe no host).

---

## 🔌 Acesso à VM Windows (brces@10.0.0.217)

```bash
ssh brces@10.0.0.217
```

### ✅ Fluxo de configuração que funcionou (2026-09-11)

1. **Script `setup-ssh-pri.ps1`** na VM (UTF-8 BOM + CRLF obrigatório!) — instala OpenSSH, inicia `sshd`, autoriza chave do Bruno.
2. Serviço e porta ficaram OK, mas **porta 22 não respondia de fora**.
3. **Diagnóstico em cascata:**
   - Firewall do **Proxmox** → *desabilitado* (não era o problema)
   - `sc query sshd` → **RUNNING** (não era o problema)
   - `netstat -an | findstr :22` → **LISTENING** (não era o problema)
   - `Get-NetConnectionProfile` → **NetworkCategory: Public** ⚠️
   - `netsh advfirewall firewall show rule name="OpenSSH-Server-In-TCP"` → **NÃO EXISTIA** 🔥 **O VILÃO!**
4. **Correção (via guest agent do Proxmox):**
   ```bash
   qm guest exec 101 -- netsh advfirewall firewall add rule name="OpenSSH-Server-In-TCP" dir=in action=allow protocol=TCP localport=22
   ```
5. **Sucesso:** `ssh brces@10.0.0.217` conectou imediatamente. ✅

---

## 🛠️ Comandos úteis no host Proxmox

```bash
ssh root@10.0.0.3

# Listar VMs
qm list

# Status e porta da VM
qm config 101 | grep net0
timeout 4 bash -c 'cat < /dev/null > /dev/tcp/10.0.0.217/22'

# Executar comando DENTRO da VM (guest agent ativo)
qm guest exec 101 -- cmd /c "sc query sshd"
qm guest exec 101 -- powershell -Command "Get-NetConnectionProfile | Select NetworkCategory"

# Firewall do Proxmox (status)
pve-firewall status
cat /etc/pve/firewall/cluster.fw   # ausente = desabilitado
```

> 💡 **QEMU Guest Agent:** instalado na VM 101 (`virtio-win-guest-tools.exe` do ISO virtio-win montado em `ide2`) — habilita `qm guest exec` para diagnóstico e automação sem console.

---

## 💡 Lições e Boas Práticas

- ⚠️ **Perfil de rede Windows `Public` bloqueia tudo** — sempre verificar `Get-NetConnectionProfile` e a regra de firewall específica quando "SSH não conecta".
- 🛡️ **Regra de firewall mínima** (`allow` só na porta 22) é melhor que desligar o firewall.
- 🔑 **API token** com role mínima (`PVEVMUser`) + **chave SSH** é o padrão seguro; nunca senha root no cofre.
- 📄 **Scripts PowerShell p/ Windows devem ser UTF-8 com BOM + CRLF** (senão Windows PowerShell 5.1 interpreta ANSI e quebra com `ParserError`).
- ⚠️ **BOM DUPLICADO também quebra:** um `.ps1` com 2× `EF BB BF` gera `ParserError` no PS 5.1 (ex: `Atributo 'CmdletBinding' inesperado`). Conferir com `od -c` — os primeiros bytes devem ser uma única sequência `357 273 277 #`. 🐛 Caso real: `pos-instalacao.ps1` do archimedes-operator (2026-09-11).
- 🎁 **Guest agent nas VMs Windows** = superpoder para automação (`qm guest exec`).

---

## 🔗 Fontes

- [Proxmox VE API](https://pve.proxmox.com/wiki/Proxmox_VE_API)
- [QEMU Guest Agent](https://pve.proxmox.com/wiki/Qemu-guest-agent)
- [OpenSSH Server no Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse)
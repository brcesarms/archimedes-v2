# 🗂️ Servidor de Arquivos — CT 103 no Proxmox (10.0.0.4)

> **Data:** 2026-09-12 · **Status:** Ativo · **Tipo:** Nota técnica de infraestrutura

## 🎯 Resumo

Servidor de arquivos dedicado criado como **container LXC (privileged) no Proxmox GEEKOM** (`10.0.0.3`) para servir **Samba (SMB) + NFS + SFTP** na rede local. É o **destino central dos backups robocopy do archimedes-operator**.

---

## 🖥️ Identificação

| Recurso | Valor |
| :--- | :--- |
| **Container** | CT 103 (`arquivos`) — Debian 13 (Trixie) LXC privileged |
| **IP** | `10.0.0.4/24` (gateway/DNS `10.0.0.1`) |
| **Recursos** | 2 vCPU · 2 GB RAM · 512 MB swap · **200 GB** disco (`local-lvm`) |
| **Host Proxmox** | `10.0.0.3` (GEEKOM A7 MAX) — pve-manager 9.2.2 |
| **Kernel do host** | 7.0.2-6-pve |

> 🟢 **Por que privileged:** servidor NFS dentro de LXC *unprivileged* é frágil (módulo `nfsd` do kernel); o container privileged resolve NFS com robustez. Aceitável pois a rede `10.0.0.0/24` é privada e não exposta à internet.

---

## 📁 Serviços e Compartilhamentos

| Serviço | Detalhe | Porta |
| :--- | :--- | :--- |
| **Samba/SMB** | Shares `backup` + `arquivos` | 445/139 |
| **NFS** | Export `/srv/arquivos` para `10.0.0.0/24` (rw, no_root_squash) | 2049 |
| **SSH/SFTP** | OpenSSH 10.0 (`ssh` + `sftp-server`) | 22 |

| Share SMB | Caminho | Uso |
| :--- | :--- | :--- |
| `\\10.0.0.4\backup` | `/srv/arquivos/backup` | 🎯 **Destino robocopy** (archimedes-operator) |
| `\\10.0.0.4\arquivos` | `/srv/arquivos/documentos` | Documentos e uso geral |

**Prefixos de acesso:**
- SMB: `\\10.0.0.4\backup` · NFS: `mount -t nfs 10.0.0.4:/srv/arquivos /mnt/...` · SFTP: `sftp backup@10.0.0.4`

---

## 👤 Acesso e Credenciais

| Usuário | Uso | Senha |
| :--- | :--- | :--- |
| `root` | Administração do container | 🔒 Guardada em `~/.config/servidor-arquivos/senha-root-ct103.txt` (600) |
| `backup` | SMB + NFS + SFTP (robocopy/backups) | 🔒 Guardada em `~/.config/servidor-arquivos/senha-backup.txt` (600) |

> ⚠️ **Segredos fora do cofre git** — nunca commitar senhas. Backups das credenciais: gerenciador de senhas do Bruno.
>
> 🔑 **Acesso SSH por chave:** chave ed25519 do Bruno (`brcesarms@gmail.com`) autorizada para `root@10.0.0.4` e `backup@10.0.0.4` — login sem senha.

**Fingerprint host SSH (ed25519):** `SHA256:I5NOPIeBoewcKKLSTmyG3YeQh68NP+s/xLyudb90o8c`

---

## 🔄 Integração com o archimedes-operator

O `backup-robocopy.ps1` usa o parâmetro `--destino` (storage central UNC). Apontar para:

```
--destino \\10.0.0.4\backup
```

Credenciais SMB para o robocopy: usuário `backup`.

---

## 🛠️ Comandos úteis (no host Proxmox)

```bash
ssh root@10.0.0.3

pct list                                # ver CT 103
pct exec 103 -- bash                    # shell no container
pct exec 103 -- systemctl status smbd nmbd nfs-server ssh
exportfs -v                             # ver exports NFS
testparm -s                             # validar smb.conf
```

---

## 💡 Lições e Boas Práticas

- 🟢 **LXC para serviços únicos** (Samba/SFTP) = leveza e automação via `pct`.
- 🟡 **NFS pede container privileged** (ou VM) — planeje o trade-off se precisar de LXC unprivileged.
- 🔴 **FTP puro é anti-padrão** — SFTP cobre o caso com criptografia.
- 🔒 **Senhas nunca no cofre** — usar `~/.config/` com permissão 600 ou gerenciador.
- 📋 Sempre testar escrita real no share (não só listar shares) antes de declarar sucesso.
- 🐛 **`backup` já existe no Debian** (uid 34, home `/var/backups`, shell `nologin`) — `useradd` falha silenciosamente; usar `usermod -s /bin/bash -d /home/backup backup` e criar o `.ssh` manualmente.

---

## 🔗 Fontes

- [Proxmox Container Management (pct)](https://pve.proxmox.com/wiki/Linux_Container)
- [Debian 13 (Trixie)](https://www.debian.org/releases/trixie/)
- [Samba Documentation](https://www.samba.org/samba/docs/)
- [NFS HOWTO](https://tldp.org/HOWTO/NFS-HOWTO/)

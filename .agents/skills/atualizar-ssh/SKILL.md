---
name: atualizar-ssh
description: Atualização autônoma de arquivos em máquinas remotas via SSH/SCP. Use quando o usuário pedir "atualizar arquivos", "sincronizar arquivos", "enviar arquivo", "copiar para", "atualizar config remota", "atualizar o cofre no alienware" ou quando precisar transferir arquivos de configuração (AGENTS.md, opencode.json, scripts) para outro host. Aplica comandos atômicos com permissões allow e verificação de integridade.
compatibility: opencode
metadata:
  audience: ia-local
  workflow: automacao
---

# 🔌 Atualização Autônoma de Arquivos via SSH

> **Objetivo:** atualizar arquivos em máquinas remotas (Alienware, GEEKOM, etc.) sem travar em permissões, sem pedir confirmação a cada comando e com verificação de integridade ao final.
> **Testado em:** 2026-09-09 — qwen3-coder:30b no GEEKOM → Alienware (scp + sha256sum) ✅

## 🚦 Pré-requisitos (verificar antes de começar)

1. **Host documentado** na [convenção SSH](../../convencoes/convencoes-ssh.md) (`laptop-brn`, `geekom`, etc.)
2. **Chave SSH** já configurada no host de origem (`~/.ssh/config` + `id_ed25519`)
3. **Permissões no `opencode.json`** — conferir se os padrões abaixo existem (senão, o agente trava no modo `run`):

```json
"bash": {
  "*": "ask",
  "ssh *": "ask",
  "scp *": "ask",
  "rsync *": "ask",
  "ssh laptop-brn *": "allow",
  "scp * laptop-brn:*": "allow",
  "scp * bruno@10.0.0.5:*": "allow",
  "rsync * laptop-brn:*": "allow",
  "ssh geekom *": "allow",
  "cat *": "allow",
  "ls *": "allow",
  "diff *": "allow",
  "wc *": "allow",
  "stat *": "allow",
  "sha256sum *": "allow",
  "md5sum *": "allow"
}
```

> ⚠️ **REGRAS DE PERMISSÃO (não pule):**
> - O OpenCode usa **"a última regra que casa vence"** → o `allow` específico DEVE vir DEPOIS do `ask` genérico
> - Padrão do scp real: `scp CAMINHO_LOCAL HOST:destino` — o **host vem depois do caminho local** (NÃO usar `scp HOST *`)
> - No modo `run` não-interativo, tudo que for `ask` é **auto-rejeitado** → só comandos `allow` executam

## 📋 Fluxo de Execução (passos mecânicos)

### Passo 1 — Inspecionar o remoto

```bash
ssh laptop-brn 'ls -la ~/archimedes'
ssh laptop-brn 'ls -lh ~/archimedes/AGENTS.md ~/archimedes/opencode.json'
```

### Passo 2 — Comparar com o local

```bash
ls -lh ~/archimedes/AGENTS.md ~/archimedes/opencode.json
```

> Se os tamanhos forem iguais e o objetivo for "atualizar sempre", prosseguir mesmo assim (scp sobrescreve).

### Passo 3 — Transferir (UM comando por vez!)

```bash
scp ~/archimedes/AGENTS.md laptop-brn:~/archimedes/AGENTS.md
```

```bash
scp ~/archimedes/opencode.json laptop-brn:~/archimedes/opencode.json
```

> ⚠️ **NUNCA** usar comandos compostos (`scp a && scp b` ou `ssh ... > /tmp/x; diff ...`) — não casam com os padrões de permissão e travam.

### Passo 4 — Verificar integridade (obrigatório!)

```bash
sha256sum ~/archimedes/AGENTS.md ~/archimedes/opencode.json
```

```bash
ssh laptop-brn 'sha256sum ~/archimedes/AGENTS.md ~/archimedes/opencode.json'
```

> ✅ **Sucesso = checksums IDÊNTICOS** nas duas máquinas. Se divergirem → reportar `#falha` e parar.

### Passo 5 — Reportar

Resumo com: origem → destino, tamanhos antes/depois, checksums e conclusão. Sempre em pt-BR com emojis.

## 🔄 Atualização Completa via Git (clone do cofre)

> Quando o objetivo é atualizar o cofre INTEIRO (não só arquivos soltos) numa máquina com estrutura antiga/sem git.
> **Testado em:** 2026-09-09 — qwen3-coder:30b no GEEKOM → Alienware (clone + submódulos + backup) ✅

### Pré-requisitos

- Machine já tem **chave SSH cadastrada no GitHub** (testar: `ssh -T git@github.com` → "Hi <user>!")
- Repo é privado? → precisa da chave cadastrada (SSH) OU credencial HTTPS no destino

### Fluxo (seguro, com backup)

```bash
# 1. Backup dos arquivos únicos/locais do cofre antigo
ssh laptop-brn 'mkdir -p ~/archimedes-antigo && cp ~/archimedes/perfis/alienware.md ~/archimedes-antigo/ 2>/dev/null; cp -r ~/archimedes/.obsidian ~/archimedes-antigo/ 2>/dev/null; cp -r ~/archimedes/.hermes ~/archimedes-antigo/ 2>/dev/null; cp ~/archimedes/config.yaml ~/archimedes-antigo/ 2>/dev/null'

# 2. Clone para pasta NOVA (nunca sobre a antiga)
ssh laptop-brn 'git clone git@github.com:brcesarms/archimedes.git ~/archimedes-novo'

# 3. Submódulos — se o --recurse-submodules falhar, usar fallback:
ssh laptop-brn 'cd ~/archimedes-novo && git submodule update --init --recursive'

# 4. Verificar o clone novo ANTES de trocar
ssh laptop-brn 'ls ~/archimedes-novo && git -C ~/archimedes-novo log --oneline -3'

# 5. Troca segura (apenas se passo 4 confirmou)
ssh laptop-brn 'mv ~/archimedes ~/archimedes-antigo && mv ~/archimedes-novo ~/archimedes'

# 6. Verificação final
ssh laptop-brn 'ls ~/archimedes && git -C ~/archimedes submodule status'
```

> ⚠️ **Regras do clone:**
> - **NUNCA** `git clone` direto na pasta que já tem conteúdo (falha/sobrescreve) — clonar em pasta nova, verificar, depois mover
> - **SEMPRE** preservar arquivos locais (`.obsidian/`, `.hermes/`, `config.yaml`, perfis) em pasta de backup antes
> - **NUNCA** `rm -rf` da estrutura antiga — mover para backup (a troca é `mv`, não `rm`)
> - Se o repo tem submódulos e `--recurse-submodules` não funcionar (permissão HTTPS vs SSH), usar `git submodule update --init --recursive` como fallback
> - URL SSH: `git@github.com:usuario/repo.git` (após chave cadastrada); URL HTTPS só com credenciais no destino

## ⚠️ Armadilhas conhecidas (não repetir!)

| ⚠️ Armadilha | ❌ Errado | ✅ Certo |
|--------------|----------|----------|
| Permissão `ssh *` antes do específico | `ssh laptop-brn *: allow` seguido de `ssh *: ask` | `ask` genérico primeiro, `allow` específico DEPOIS |
| Padrão scp com host primeiro | `scp laptop-brn *` | `scp * laptop-brn:*` (host após caminho local) |
| Comando composto | `scp a laptop-brn:x && scp b laptop-brn:y` | Um `scp` por call |
| Redirecionamento para comparar | `ssh laptop-brn 'cat f' > /tmp/f && diff` | `sha256sum` local e remoto em chamadas separadas |
| Pedir confirmação no modo run | "Prossigo?" | Executar direto (autorização já concedida) |
| `find` sem `-maxdepth` (não casa com permissão) | `find ~/x -type f \( -name "*.env" ... \)` | `find ~/x -maxdepth 3 -name "*.env"` (ou `ls *` + `grep *`) — permissão exige `-maxdepth` |
| Travar após permissão negada | Ficar repetindo "vou continuar" sem executar | Trocar por comando SIMPLES que casa com permissão e seguir |
| Comando composto com pipe/loop | `grep ... \| while read ...; do ...; done` | Quebrar em passos: `grep *` → analisar → `ls *` para confirmar cada destino |
| Executar scripts (`bash -n`, `chmod`, `du`, rodar .sh) sem allow | Tentar e travar | Garantir permissões no `opencode.json`: `bash -n *`, `chmod *`, `du *`, `*backup-cofre.sh*` (adicionado 2026-09-09, commit `171073e`) |

## 📌 Regras

- 🤖 **Autonomia:** no modo `run`, executar tudo sem perguntar (permissões já `allow`)
- 🔒 **Segurança:** nunca apagar arquivos remotos sem confirmação explícita; nunca tocar hosts não documentados
- 📏 **Atomicidade:** um comando por tool call
- ✅ **Verificação:** sempre `sha256sum`/`md5sum` dos dois lados antes de reportar sucesso
- 🕵️ **Verificação independente:** **NUNCA confiar no relatório do agente** (`echo`/resposta) — o supervisor/observador DEVE re-checar por conta própria com `ls`, `git log`, `sha256sum`, `submodule status` etc. **Relatório não é evidência.**
- 🏷️ **Falha:** divergência de checksum, permissão negada ou estrutura não confirmada → tag `#falha` + parar

---

## 🔗 Fontes

- [Convenção SSH](../../convencoes/convencoes-ssh.md)
- [OpenCode Permissions — última regra vence](https://opencode.ai/docs/permissions)
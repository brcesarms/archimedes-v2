---
name: backup-cofre
description: Backup e restauração do Archimedes Vault. Use quando o usuário pedir "fazer backup", "backup do cofre", "snapshot", "salvar cópia", "restaurar cofre" ou "recuperar backup". Cria snapshots datados com verificação de integridade e restaura o cofre a partir deles.
compatibility: opencode
metadata:
  audience: ia-local
  workflow: gestao
---

# 🔄 Backup e Restauração do Archimedes Vault

O cofre é o segundo cérebro — proteja-o com backups regulares e restauração segura.

## 💾 Backup

### 1. Fluxo Git (primário)

O GitHub + submódulos **já é o backup lógico** do cofre. Antes de criar snapshots, garantir que o conteúdo esteja versionado:

```bash
git status --short          # mudanças não commitadas?
git -C ~/wikisidian/t.i status --short   # estudos pessoais também
```

> Se houver mudanças, commitar e publicar seguindo [`convencoes-git.md`](../../convencoes/convencoes-git.md). O snapshot abaixo é o backup offline **complementar**.

### 2. Snapshots Restic (Recomendado — Deduplicado & Criptografado)

Utiliza o **`restic`**, o padrão da indústria para backups atômicos, deduplicados e criptografados. Snapshots são criados em milissegundos sem duplicar dados inalterados:

```bash
# Criar snapshot manual:
~/archimedes/scripts/linux/restic-vault.sh backup manual

# Listar todos os snapshots existentes com datas e tamanhos:
~/archimedes/scripts/linux/restic-vault.sh list

# Verificar integridade criptográfica dos dados:
~/archimedes/scripts/linux/restic-vault.sh check

# Aplicar política de retenção (mantém 7 diários, 4 semanais, 6 mensais):
~/archimedes/scripts/linux/restic-vault.sh prune
```

### 3. Snapshot Legado via tar.gz (Fallback)

Criar um arquivo tar.gz compactado com a data no nome. **O destino é FORA do cofre** (`$HOME/backups/`) para evitar backup aninhado:

```bash
BACKUP_BASE="$HOME/backups/archimedes"
mkdir -p "$BACKUP_BASE"
STAMP="$(date +%Y-%m-%d_%H%M%S)"
tar -czf "$BACKUP_BASE/archimedes_$STAMP.tar.gz" \
    --exclude='archimedes/docs/guia-ia-local/utils/backups/*.tar.gz' \
    --exclude='archimedes/.opencode/node_modules' \
    --exclude='archimedes/.git' \
    -C "$HOME" archimedes
```

> 💡 Também exclui `node_modules` (62M de dependência npm recuperável) — nunca deve pesar no backup do conteúdo.

### 4. Verificar integridade (tar.gz legado)

Sempre conferir se o backup está íntegro antes de dar como concluído:

```bash
tar -tzf "$BACKUP_BASE/archimedes_$STAMP.tar.gz" > /dev/null && echo "✅ Backup íntegro"
ls -lh "$BACKUP_BASE/archimedes_$STAMP.tar.gz"
```

> ✅ Confirmação extra de que nada foi aninhado:
> ```bash
> [ "$(tar -tzf "$BACKUP_BASE/archimedes_$STAMP.tar.gz" | grep -c 'backups/.*tar.gz')" -eq 0 ] && echo "✅ Sem backups aninhados"
> ```

### 5. Rotação (opcional)

- Manter backups recentes e remover os antigos, se o usuário quiser
- Perguntar antes de apagar backups antigos (nunca apagar sem confirmação)

## ♻️ Restauração

### 1. Localizar o backup

```bash
ls -lh "$HOME/backups/archimedes/"*.tar.gz
```

### 2. Restaurar

⚠️ **Sempre confirmar com o usuário** antes de sobrescrever o cofre atual.

```bash
# Restaurar a partir de um backup específico
tar -xzf "$HOME/backups/archimedes/archimedes_<DATA>.tar.gz" -C "$HOME"
```

### 3. Verificar

- Confirmar que `AGENTS.md`, `opencode.json`, `setup.sh`, `ME.md` e `MY-SETUP.md` existem
- Confirmar que `.agents/skills/` está presente (skills nunca se perdem)

## 📌 Regras

- 🔬 **Nunca** apagar backups sem perguntar
- 📁 Backups ficam em `$HOME/backups/archimedes/` (FORA do cofre)
- 🏷️ Nome sempre com data/hora (`archimedes_YYYY-MM-DD_HHMMSS.tar.gz`)
- ✅ Verificar integridade do backup após criar e após restaurar

---

## 🔗 Fontes

- 🖥️ Estrutura do cofre: [`AGENTS.md`](../../../AGENTS.md) (Estrutura do Vault)

#!/usr/bin/env bash
# ==============================================================================
# Script: backup-hermes.sh
# Finalidade: Backup atômico, cirúrgico e consistente do novo Hermes Agent
# Destino: Servidor de Arquivos Proxmox (LXC 103 - arquivos: 10.0.0.103)
# ==============================================================================

set -euo pipefail

DEST_HOST="10.0.0.103"
DEST_USER="backup"
DEST_DIR="/srv/arquivos/backup/hermes-backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="hermes-core-backup-${TIMESTAMP}.tar.zst"
STAGE_DIR="/tmp/hermes_backup_${TIMESTAMP}_$$"
ARCHIVE_FILE="/tmp/${BACKUP_NAME}"
CHECKSUM_FILE="/tmp/${BACKUP_NAME}.sha256"

cleanup() {
    rm -rf "${STAGE_DIR}" "${ARCHIVE_FILE}" "${CHECKSUM_FILE}"
}
trap cleanup EXIT

echo "🚀 [1/6] Preparando diretório de staging..."
mkdir -p "${STAGE_DIR}/hermes_home" "${STAGE_DIR}/system"

echo "🧠 [2/6] Exportando estado SQLite consistente (VACUUM INTO)..."
HERMES_DIR="${HERMES_HOME:-$HOME/.hermes}"
mkdir -p "${STAGE_DIR}/hermes_home/.hermes"
if [ -f "${HERMES_DIR}/state.db" ]; then
    python3 -c "import sqlite3; con = sqlite3.connect('${HERMES_DIR}/state.db'); con.execute(\"VACUUM INTO '${STAGE_DIR}/hermes_home/.hermes/state.db'\"); con.close()"
fi

echo "📁 [3/6] Coletando arquivos vitais do Hermes..."
# Arquivos de identidade e configuração
for f in .env SOUL.md config.yaml context_length_cache.yaml; do
    if [ -f "${HERMES_DIR}/$f" ]; then
        cp -a "${HERMES_DIR}/$f" "${STAGE_DIR}/hermes_home/.hermes/"
    fi
done

# Pastas de dados e inteligência
for d in skills memories sessions cron hooks backups; do
    if [ -d "${HERMES_DIR}/$d" ]; then
        cp -a "${HERMES_DIR}/$d" "${STAGE_DIR}/hermes_home/.hermes/"
    fi
done

# Scripts operacionais e credenciais do usuário
if [ -d "$HOME/scripts" ]; then
    cp -a "$HOME/scripts" "${STAGE_DIR}/hermes_home/"
fi
if [ -d "$HOME/.ssh" ]; then
    cp -a "$HOME/.ssh" "${STAGE_DIR}/hermes_home/"
fi
for f in .bashrc .profile; do
    if [ -f "$HOME/$f" ]; then
        cp -a "$HOME/$f" "${STAGE_DIR}/hermes_home/"
    fi
done

# Configurações do sistema
if [ -d "/etc/systemd/system/ollama.service.d" ]; then
    mkdir -p "${STAGE_DIR}/system/ollama.service.d"
    cp -a /etc/systemd/system/ollama.service.d/* "${STAGE_DIR}/system/ollama.service.d/" 2>/dev/null || true
fi
if [ -d "/etc/udev/rules.d" ]; then
    mkdir -p "${STAGE_DIR}/system/udev_rules.d"
    cp -a /etc/udev/rules.d/* "${STAGE_DIR}/system/udev_rules.d/" 2>/dev/null || true
fi

echo "📋 [4/6] Gerando manifesto com metadados do ambiente..."
python3 -c "
import json, subprocess, platform, datetime

def run(cmd):
    try:
        return subprocess.check_output(cmd, shell=True, text=True).strip()
    except Exception as e:
        return str(e)

def get_os():
    try:
        with open('/etc/os-release') as f:
            for line in f:
                if line.startswith('PRETTY_NAME='):
                    return line.split('=', 1)[1].strip().strip('\"')
    except Exception:
        pass
    return platform.platform()

manifest = {
    'backup_timestamp_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'backup_timestamp_local': datetime.datetime.now().isoformat(),
    'hostname': platform.node(),
    'kernel': platform.release(),
    'os': get_os(),
    'python_version': platform.python_version(),
    'hermes_agent_commit': run('git -C \"${HERMES_DIR}/hermes-agent\" rev-parse HEAD 2>/dev/null || echo unknown'),
    'ollama_version': run('ollama --version 2>/dev/null || echo unknown'),
    'ollama_models': run('ollama list 2>/dev/null || echo unknown')
}
with open('${STAGE_DIR}/manifest.json', 'w', encoding='utf-8') as f:
    json.dump(manifest, f, indent=2, ensure_ascii=False)
"

echo "🗜️ [5/6] Compactando via tar + zstd (compressão máxima multi-thread)..."
tar -I 'zstd -19 -T0' -cf "${ARCHIVE_FILE}" -C "${STAGE_DIR}" .
sha256sum "${ARCHIVE_FILE}" | awk '{print $1}' > "${CHECKSUM_FILE}"

ARCHIVE_SIZE=$(du -h "${ARCHIVE_FILE}" | cut -f1)
CHECKSUM_VAL=$(cat "${CHECKSUM_FILE}")
echo "📦 Pacote gerado com sucesso: ${BACKUP_NAME} (${ARCHIVE_SIZE}) | SHA256: ${CHECKSUM_VAL}"

echo "📡 [6/6] Enviando backup para ${DEST_USER}@${DEST_HOST}:${DEST_DIR}..."
scp -o BatchMode=yes -o StrictHostKeyChecking=accept-new "${ARCHIVE_FILE}" "${CHECKSUM_FILE}" "${DEST_USER}@${DEST_HOST}:${DEST_DIR}/"

# Validação remota do checksum e atualização do link 'latest'
ssh -o BatchMode=yes "${DEST_USER}@${DEST_HOST}" "
    cd '${DEST_DIR}' &&
    echo '${CHECKSUM_VAL}  ${BACKUP_NAME}' | sha256sum -c - &&
    ln -sf '${BACKUP_NAME}' latest.tar.zst &&
    ln -sf '${BACKUP_NAME}.sha256' latest.tar.zst.sha256
"

echo "✅ Backup concluído e validado com integridade 100% no servidor de arquivos!"

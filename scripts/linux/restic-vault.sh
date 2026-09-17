#!/usr/bin/env bash
# ==============================================================================
# 🔄 restic-vault.sh — Gerenciador de Snapshots Restic do Archimedes Vault
# ==============================================================================
# @author: Bruno César Medeiros Siqueira / Archimedes
# @version: v1.0.0 (2026-09-16)
# @description: Snapshots deduplicados, criptografados e atômicos via Restic
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COFRE_DIR="${COFRE_DIR:-$(cd "${SCRIPT_DIR}/../../.." && pwd)}"
REPO_DIR="${RESTIC_REPOSITORY:-$HOME/backups/restic-vault}"
PASS_FILE="${RESTIC_PASSWORD_FILE:-$HOME/.config/restic/password}"
IGNORE_FILE="${COFRE_DIR}/.resticignore"

# Cores e ícones
C_RESET=$'\e[0m'
C_CYAN=$'\e[96m'
C_GREEN=$'\e[32m'
C_YELLOW=$'\e[33m'
C_RED=$'\e[31m'

verificar_requisitos() {
    if ! command -v restic &>/dev/null; then
        printf "%s\n" "${C_RED}❌ Erro: restic não está instalado. Execute: brew install restic${C_RESET}"
        exit 1
    fi
    if [ ! -f "$PASS_FILE" ]; then
        printf "%s\n" "${C_RED}❌ Erro: Arquivo de senha não encontrado em $PASS_FILE${C_RESET}"
        exit 1
    fi
    if [ ! -d "$REPO_DIR" ]; then
        printf "%s\n" "${C_YELLOW}⚡ Repositório restic não encontrado. Inicializando em $REPO_DIR ...${C_RESET}"
        restic init --repo "$REPO_DIR" --password-file "$PASS_FILE"
    fi
}

cmd_backup() {
    verificar_requisitos
    local tag="${1:-auto}"
    printf "\n%s\n" "${C_CYAN}🔄 [Restic] Criando snapshot do cofre ($COFRE_DIR)...${C_RESET}"
    
    local args=(
        backup "$COFRE_DIR"
        --repo "$REPO_DIR"
        --password-file "$PASS_FILE"
        --tag "vault-$tag"
    )
    if [ -f "$IGNORE_FILE" ]; then
        args+=(--exclude-file "$IGNORE_FILE")
    fi

    restic "${args[@]}"
    printf "%s\n\n" "${C_GREEN}✅ Snapshot concluído e deduplicado com sucesso!${C_RESET}"
}

cmd_list() {
    verificar_requisitos
    printf "\n%s\n" "${C_CYAN}📋 [Restic] Snapshots do Archimedes Vault:${C_RESET}"
    restic snapshots --repo "$REPO_DIR" --password-file "$PASS_FILE"
    printf "\n"
}

cmd_check() {
    verificar_requisitos
    printf "\n%s\n" "${C_CYAN}🔍 [Restic] Verificando integridade estrutural dos dados...${C_RESET}"
    restic check --repo "$REPO_DIR" --password-file "$PASS_FILE"
    printf "%s\n\n" "${C_GREEN}✅ Repositório íntegro e verificado.${C_RESET}"
}

cmd_prune() {
    verificar_requisitos
    printf "\n%s\n" "${C_YELLOW}✂️ [Restic] Aplicando política de retenção (7 dias, 4 semanas, 6 meses)...${C_RESET}"
    restic forget \
        --repo "$REPO_DIR" \
        --password-file "$PASS_FILE" \
        --keep-daily 7 \
        --keep-weekly 4 \
        --keep-monthly 6 \
        --prune
    printf "%s\n\n" "${C_GREEN}✅ Limpeza e retenção concluídas!${C_RESET}"
}

cmd_restore() {
    verificar_requisitos
    local snapshot_id="${1:-latest}"
    local target_dir="${2:-$HOME/restic-restore-preview}"

    printf "\n%s\n" "${C_YELLOW}⚠️ [Restic] Restaurando snapshot '%s' para: %s${C_RESET}" "$snapshot_id" "$target_dir"
    mkdir -p "$target_dir"
    restic restore "$snapshot_id" \
        --repo "$REPO_DIR" \
        --password-file "$PASS_FILE" \
        --target "$target_dir"
    printf "%s\n\n" "${C_GREEN}✅ Dados restaurados em $target_dir${C_RESET}"
}

case "${1:-backup}" in
    backup)  cmd_backup "${2:-manual}" ;;
    list|ls) cmd_list ;;
    check)   cmd_check ;;
    prune)   cmd_prune ;;
    restore) cmd_restore "${2:-latest}" "${3:-$HOME/restic-restore-preview}" ;;
    *)
        echo "Uso: $0 {backup [tag]|list|check|prune|restore <snapshot_id> [destino]}"
        exit 1
        ;;
esac

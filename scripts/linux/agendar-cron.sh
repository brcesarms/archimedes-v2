#!/usr/bin/env bash
# ============================================================
# ⏰ agendar-cron.sh — Instala agendamentos systemd para o cofre
# ============================================================
# @author: Archimedes
# @version: v1.0.0 (2026-09-08)
# @description: Instala e ativa systemd timers para automação
# @usage: ./agendar-cron.sh [--install|--uninstall|--status]
# @security:
#   - Usa variáveis de ambiente (COFRE_DIR)
#   - Valida existência de scripts
#   - NÃO modifica scripts, apenas instala services
# ============================================================
set -euo pipefail

COFRE_DIR="${COFRE_DIR:-$HOME/archimedes-v2}"
SYSTEMD_DIR="$COFRE_DIR/docs/cerebrum/systemd"
USER_SYSTEMD="$HOME/.config/systemd/user"

log() { echo "$*"; }

# ── Funções auxiliares ─────────────────────────────────────────
enable_services() {
    log "⏳ Habilitando services systemd..."
    systemctl --user daemon-reload
    
    # Logs rotator
    systemctl --user enable logs-rotator.timer
    systemctl --user start logs-rotator.timer
    log "✅ logs-rotator.timer habilitado"
    
    # Backup logs
    systemctl --user enable backup-logs.timer
    systemctl --user start backup-logs.timer
    log "✅ backup-logs.timer habilitado"
    
    log ""
    log "📋 Timers habilitados:"
    systemctl --user list-timers *.timer
}

disable_services() {
    log "⏳ Desabilitando services systemd..."
    systemctl --user stop logs-rotator.timer 2>/dev/null || true
    systemctl --user stop backup-logs.timer 2>/dev/null || true
    systemctl --user disable logs-rotator.timer 2>/dev/null || true
    systemctl --user disable backup-logs.timer 2>/dev/null || true
    systemctl --user daemon-reload
    log "✅ Services desabilitados"
}

show_status() {
    log "📋 Status dos systemd timers:"
    systemctl --user list-timers *.timer 2>/dev/null || log "⚠️  Nenhum timer ativo"
}

# ── Help ───────────────────────────────────────────────────────
show_help() {
    sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'
    echo ""
    echo "Opções:"
    echo "  --install   Instala e ativa todos os timers"
    echo "  --uninstall Desinstala e desativa todos os timers"
    echo "  --status    Mostra status dos timers"
    echo "  --help      Mostra esta ajuda"
    echo ""
    echo "Exemplo:"
    echo "  ./agendar-cron.sh --install"
}

# ── Main ───────────────────────────────────────────────────────
MODE="${1:-status}"
case "$MODE" in
    --install|-i)
        # Verificar se os arquivos existem
        [ -f "$SYSTEMD_DIR/logs-rotator.service" ] || { log "❌ logs-rotator.service não encontrado"; exit 1; }
        [ -f "$SYSTEMD_DIR/logs-rotator.timer" ] || { log "❌ logs-rotator.timer não encontrado"; exit 1; }
        [ -f "$SYSTEMD_DIR/backup-logs.service" ] || { log "❌ backup-logs.service não encontrado"; exit 1; }
        [ -f "$SYSTEMD_DIR/backup-logs.timer" ] || { log "❌ backup-logs.timer não encontrado"; exit 1; }
        
        # Criar diretório se não existir
        mkdir -p "$USER_SYSTEMD"
        
        # Copiar services para user systemd
        cp "$SYSTEMD_DIR"/*.service "$USER_SYSTEMD/"
        cp "$SYSTEMD_DIR"/*.timer "$USER_SYSTEMD/"
        
        enable_services
        ;;
    --uninstall|-u)
        disable_services
        ;;
    --status|-s)
        show_status
        ;;
    --help|-h)
        show_help
        ;;
    *)
        echo "❌ Opção inválida: $MODE (use --help)"
        exit 1
        ;;
esac

log ""
log "🎯 Agendamento concluído com sucesso!"

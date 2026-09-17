#!/usr/bin/env bash
# ============================================================
# 📊 monitorar-executor.sh — Estatística das rotinas do Executor
# ============================================================
# @author: Bruno César Medeiros Siqueira
# @version: v1.1.0 (2026-09-08)
# @description: Estatística por rotina + detecção de 2+ falhas consecutivas
# @changelog:
#   - v1.1.0 (2026-09-08): Adiciona shebang completo e headers
#   - v1.0.0 (2026-08-25): Versão inicial (Fase 2)
# @usage:
#   ./monitorar-executor.sh
# @security:
#   - Usa variáveis de ambiente (COFRE_DIR, LOG_DIR)
#   - Valida existência de LOG_DIR
#   - Escreve apenas em pasta própria (logs/)
# ============================================================
set -euo pipefail

COFRE_DIR="${COFRE_DIR:-$HOME/archimedes}"
LOG_DIR="$COFRE_DIR/docs/cerebrum/logs"
OUT_FILE="$LOG_DIR/estado-falhas.md"
STAMP="$(date +%Y-%m-%d_%H%M%S)"
HUMAN_DATE="$(date '+%d/%m/%Y %H:%M')"

# ── Pré-checagens ─────────────────────────────────────────────
if [ ! -d "$LOG_DIR" ]; then
  echo "❌ ERRO: pasta de logs não encontrada: $LOG_DIR" >&2
  exit 1
fi

# ── Coleta de dados ───────────────────────────────────────────
FAILBACKUP=0
TOTBACKUP=0
FAILMANU=0
TOTMANU=0
FAILSAUDE=0
TOTSAUDE=0

# Lista os 2 logs mais recentes por rotina (para detecção de consecutivas)
recent2_backup=""
recent2_manu=""
recent2_saude=""

for logfile in "$LOG_DIR"/{manutencao,saude-sistema,backup-semanal}-*.log; do
  [ -e "$logfile" ] || continue
  base="$(basename "$logfile")"
  case "$base" in
    manutencao-*)
      rotina="manutencao"
      TOTMANU=$((TOTMANU + 1))
      ;;
    saude-sistema-*)
      rotina="saude"
      TOTSAUDE=$((TOTSAUDE + 1))
      ;;
    backup-semanal-*)
      rotina="backup"
      TOTBACKUP=$((TOTBACKUP + 1))
      ;;
    *) continue ;;
  esac

  if grep -qE '❌|#falha|✖' "$logfile"; then
    case "$rotina" in
      manutencao)
        FAILMANU=$((FAILMANU + 1))
        recent2_manu="FAIL $recent2_manu"
        ;;
      saude)
        FAILSAUDE=$((FAILSAUDE + 1))
        recent2_saude="FAIL $recent2_saude"
        ;;
      backup)
        FAILBACKUP=$((FAILBACKUP + 1))
        recent2_backup="FAIL $recent2_backup"
        ;;
    esac
  else
    case "$rotina" in
      manutencao) recent2_manu="OK $recent2_manu" ;;
      saude) recent2_saude="OK $recent2_saude" ;;
      backup) recent2_backup="OK $recent2_backup" ;;
    esac
  fi
done

# ── Detecção de alertas (2+ falhas consecutivas, <10 últimos) ──
alert() { # $1 = string "OK FAIL OK ..." (mais recente primeiro)
  local seq="$1" count=0
  for w in $seq; do
    [ "$count" -ge 2 ] && break
    if [ "$w" = "FAIL" ]; then
      count=$((count + 1))
    else
      break
    fi
  done
  [ "$count" -ge 2 ] && echo "SIM" || echo "NAO"
}

A_BACKUP="$(alert "$recent2_backup")"
A_MANU="$(alert "$recent2_manu")"
A_SAUDE="$(alert "$recent2_saude")"

# ── Escreve snapshot ──────────────────────────────────────────
{
  echo "# 📊 Estado das Rotinas — ${HUMAN_DATE}"
  echo ""
  echo "> Gerado automaticamente pelo **Executor** em \`${STAMP}\`. Não editar manualmente — o Cérebro lê este arquivo."
  echo ""
  echo "## 📋 Resumo por rotina"
  echo ""
  echo "| Rotina | Execuções | Falhas | Status |"
  echo "|--------|:---------:|:------:|:------:|"
  echo "| 🧹 manutencao | $TOTMANU | $FAILMANU | $([ "$A_MANU" = "SIM" ] && echo "🚨 ALERTA" || echo "✅ OK") |"
  echo "| 🩺 saude-sistema | $TOTSAUDE | $FAILSAUDE | $([ "$A_SAUDE" = "SIM" ] && echo "🚨 ALERTA" || echo "✅ OK") |"
  echo "| 💾 backup-semanal | $TOTBACKUP | $FAILBACKUP | $([ "$A_BACKUP" = "SIM" ] && echo "🚨 ALERTA" || echo "✅ OK") |"
  echo ""
  echo "## 🚨 Alertas (2+ falhas consecutivas)"
  echo ""
  if [ "$A_MANU" = "SIM" ] || [ "$A_SAUDE" = "SIM" ] || [ "$A_BACKUP" = "SIM" ]; then
    [ "$A_MANU" = "SIM" ] && echo "- 🧹 **manutencao**: 2+ execuções consecutivas falharam — revisar script/runbook"
    [ "$A_SAUDE" = "SIM" ] && echo "- 🩺 **saude-sistema**: 2+ execuções consecutivas falharam — revisar script/runbook"
    [ "$A_BACKUP" = "SIM" ] && echo "- 💾 **backup-semanal**: 2+ execuções consecutivas falharam — revisar script/runbook"
    echo ""
    echo "> 🧠 **Cérebro:** avaliar e decidir ação (corrigir script, marcar runbook, etc.)."
  else
    echo "- Nenhum alerta ativo ✅"
  fi
  echo ""
  echo "---"
  echo "Últimas execuções (mais recente primeiro): manutencao [$recent2_manu] · saude [$recent2_saude] · backup [$recent2_backup]"
} >"$OUT_FILE"

echo "✅ Monitoramento concluído — snapshot em: $OUT_FILE"
echo "📋 Alertas: manutencao=$A_MANU · saude=$A_SAUDE · backup=$A_BACKUP"

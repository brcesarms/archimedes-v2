#!/bin/bash
set -euo pipefail

# ============================================================
# 🏛️ Bootstrap do Archimedes — Recupera o ambiente em ~2 min
# ============================================================
# Rode APÓS clonar o cofre em máquina nova (pós-formatação):
#   gh repo clone brcesarms/archimedes ~/archimedes -- --recurse-submodules
#   cd ~/archimedes && ./bootstrap.sh
#
# Compatível com: Ubuntu/Mint/Pop (apt) e Arch/Manjaro/Omarchy (pacman)
#
# O que faz:
#   1. Dependências base (git, curl, gh)
#   2. ~/.ssh/config a partir do template versionado (sem segredos)
#   3. OpenCode CLI (agy/opencode)
#   4. Dotfiles do cofre no shell (bash/fish)
#   5. Valida o cofre (submódulos + arquivos-chave)
# ============================================================

COFRE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 🎨 Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${CYAN}[$1]${NC} $2"; }
success() { echo -e "${GREEN}  ✔ $1${NC}"; }
warn() { echo -e "${YELLOW}  ⚠️ $1${NC}"; }
error() { echo -e "${RED}  ✖ $1${NC}"; }
have_cmd() { command -v "$1" >/dev/null 2>&1; }

detect_distro() {
  if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    echo "$ID"
  else
    echo "unknown"
  fi
}

detect_shell() {
  if have_cmd fish; then echo "fish"; else echo "bash"; fi
}

show_help() {
  echo "Uso: ./bootstrap.sh [--help]"
  echo ""
  echo "Configura o ambiente do Archimedes em máquina nova."
  echo "  --help    Mostra esta ajuda"
}

if [ "${1:-}" = "--help" ]; then
  show_help
  exit 0
fi

# ============================================================
# 🎯 Banner
# ============================================================
DISTRO=$(detect_distro)
SHELL_ACTIVE=$(detect_shell)

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════╗"
echo "║  🏛️ Archimedes Bootstrap — Setup Rápido          ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "🏠 Cofre: ${CYAN}${COFRE_DIR}${NC}"
echo -e "🐧 Distro: ${CYAN}${DISTRO}${NC} | Shell: ${CYAN}${SHELL_ACTIVE}${NC}"
echo ""

# ============================================================
# 1/5 📦 Dependências base
# ============================================================
log "1/5" "Verificando dependências base (git, curl)..."
MISSING=()
have_cmd git || MISSING+=(git)
have_cmd curl || MISSING+=(curl)

if [ ${#MISSING[@]} -gt 0 ]; then
  warn "Instalando: ${MISSING[*]}"
  case "$DISTRO" in
    ubuntu | linuxmint | pop | debian)
      sudo apt update && sudo apt install -y "${MISSING[@]}"
      ;;
    arch | manjaro | omarchy | endeavouros)
      sudo pacman -S --needed --noconfirm "${MISSING[@]}"
      ;;
    *)
      error "Instale manualmente: ${MISSING[*]}"
      exit 1
      ;;
  esac
fi
success "Dependências base OK"

# gh (GitHub CLI) — opcional mas recomendado para auth rápida
if ! have_cmd gh; then
  warn "GitHub CLI (gh) não encontrado. Instalando..."
  case "$DISTRO" in
    ubuntu | linuxmint | pop | debian)
      (type -p wget >/dev/null || sudo apt install -y wget) \
        && sudo mkdir -p -m 755 /etc/apt/keyrings \
        && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null \
        && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null \
        && sudo apt update && sudo apt install -y gh
      ;;
    arch | manjaro | omarchy | endeavouros)
      sudo pacman -S --needed --noconfirm github-cli
      ;;
    *)
      warn "Instale o gh manualmente: https://cli.github.com"
      ;;
  esac
fi
success "GitHub CLI disponível: $(gh --version 2>/dev/null | head -1 || echo 'instale manualmente')"

# ============================================================
# 2/5 🔑 SSH config a partir do template
# ============================================================
log "2/5" "Configurando ~/.ssh/config (template versionado)..."
TEMPLATE_SSH="${COFRE_DIR}/dotfiles/ssh-config"

if [ -f "$TEMPLATE_SSH" ]; then
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  if [ -f "$HOME/.ssh/config" ]; then
    if ! grep -q "laptop-brn" "$HOME/.ssh/config" 2>/dev/null; then
      cp "$HOME/.ssh/config" "$HOME/.ssh/config.backup.$(date +%Y%m%d%H%M%S)"
      warn "Backup do ssh config antigo criado"
    fi
  fi

  cp "$TEMPLATE_SSH" "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
  success "SSH config aplicado (hosts: laptop-brn, geekom)"
else
  warn "Template não encontrado em $TEMPLATE_SSH — pule (não crítico)"
fi

# Verifica chave SSH (nunca versionada — deve vir do Bitwarden)
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  warn "Chave SSH privada ausente. Restaure do Bitwarden ou gere nova:"
  echo "    ssh-keygen -t ed25519 -C 'bruno@$(hostname)' -f ~/.ssh/id_ed25519 -N ''"
  echo "    cat ~/.ssh/id_ed25519.pub   # e adicione no GitHub: https://github.com/settings/ssh/new"
fi

# ============================================================
# 3/5 🛠️ OpenCode CLI (agy/opencode)
# ============================================================
log "3/5" "Verificando OpenCode CLI..."
if ! have_cmd opencode && ! have_cmd agy; then
  warn "OpenCode não encontrado. Instalando..."
  curl -fsSL https://opencode.ai/install | bash
  export PATH="$HOME/.opencode/bin:$PATH"
fi
success "OpenCode disponível: $(opencode --version 2>/dev/null || agy --version 2>/dev/null || echo 'adicione ao PATH')"

# ============================================================
# 4/5 🐚 Dotfiles no shell ativo
# ============================================================
log "4/5" "Linkando dotfiles do cofre no shell ($SHELL_ACTIVE)..."

DOTFILES_DIR="${COFRE_DIR}/dotfiles"
if [ "$SHELL_ACTIVE" = "fish" ]; then
  # Omarchy/Arch com Fish shell
  FISH_DIR="$HOME/.config/fish"
  mkdir -p "$FISH_DIR"
  if [ -f "$DOTFILES_DIR/config.fish" ]; then
    if ! grep -q "dotfiles" "$FISH_DIR/config.fish" 2>/dev/null; then
      cat >>"$FISH_DIR/config.fish" <<EOF

# 🏛️ Dotfiles do Archimedes
if test -f "$DOTFILES_DIR/config.fish"
    source "$DOTFILES_DIR/config.fish"
end
EOF
      success "Fish config linkado"
    else
      success "Fish já configurado"
    fi
  else
    warn "config.fish não existe em dotfiles/ — crie ou use bash"
  fi
else
  # Bash
  if [ -f "$DOTFILES_DIR/.bashrc" ]; then
    if ! grep -q "dotfiles" "$HOME/.bashrc" 2>/dev/null; then
      cat >>"$HOME/.bashrc" <<EOF

# 🏛️ Dotfiles do Archimedes
if [ -f "$DOTFILES_DIR/.bashrc" ]; then
    source "$DOTFILES_DIR/.bashrc"
fi
EOF
      success "Bashrc linkado"
    else
      success "Bash já configurado"
    fi
  else
    warn ".bashrc não existe em dotfiles/ — crie aliases quando quiser"
  fi
fi

# PATH do OpenCode no shell (se ainda não existir)
if ! grep -q '.opencode/bin' "$HOME/.bashrc" 2>/dev/null && [ "$SHELL_ACTIVE" = "bash" ]; then
  echo 'export PATH="$HOME/.opencode/bin:$PATH"' >>"$HOME/.bashrc"
  success "PATH do OpenCode adicionado ao .bashrc"
fi

# ============================================================
# 5/5 ✅ Validação do cofre
# ============================================================
log "5/5" "Validando o cofre..."
FAIL=0

# Estudos pessoais (fora do repositório público — opcionais para o restore)
for mod in t.i concurseiro; do
  if [ -d "${HOME}/wikisidian/${mod}/.git" ]; then
    success "Estudos pessoais: wikisidian/$mod OK"
  else
    warn "Estudos pessoais: wikisidian/$mod ausente (opcional) — clone em ~/wikisidian: git clone git@github.com:brcesarms/$mod.git"
  fi
done

# Arquivos-chave
for f in AGENTS.md opencode.json README.md docs/guia-ia-local/install.sh; do
  if [ -f "${COFRE_DIR}/${f}" ]; then
    success "Arquivo $f OK"
  else
    error "Faltando: $f"
    FAIL=1
  fi
done

# ============================================================
# ✅ Finalização
# ============================================================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✅ Bootstrap concluído!                   ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
if [ "$FAIL" -eq 1 ]; then
  echo -e "⚠️  Corrija as pendências acima antes de começar."
fi
echo -e "🚀 Para começar:"
echo -e "  ${CYAN}cd ~/archimedes${NC}"
echo -e "  ${CYAN}source ~/.bashrc  # ou abra novo terminal${NC}"
echo -e "  ${CYAN}agy${NC}  (ou opencode)"
echo ""
echo -e "🛠️  Instalação completa (modelos/Ollama/Docker) quando quiser:"
echo -e "  ${CYAN}cd ~/archimedes/docs/guia-ia-local && ./install.sh --full${NC}"
echo ""
echo -e "🔑 Se a chave SSH foi restaurada, teste: ${CYAN}ssh laptop-brn 'echo ok'${NC}"

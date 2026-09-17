#!/bin/bash
set -euo pipefail

# ============================================================
# 🏛️ Install Script do Archimedes - Setup Completo
# ============================================================
# Este script instala TUDO que o cofre precisa em uma nova máquina.
# Compatível com: Ubuntu, Linux Mint, Pop!_OS, Fedora, Omarchy, Arch, Manjaro
#
# Uso:
#   cd ~/archimedes-v2/docs/guia-ia-local
#   ./install.sh
#
# Opções:
#   --full       Instalação completa (padrão)
#   --minimal    Só dependências obrigatórias (sem Ollama/Docker)
#   --dotfiles   Só configura shell
#   --docker     Só Docker + containers
#   --help       Mostra esta ajuda
# ============================================================

COFRE_DIR="${COFRE_DIR:-$HOME/archimedes-v2}"

# 🎨 Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 📋 Parse de argumentos
INSTALL_MODE="${1:---full}"

# ============================================================
# 🧰 Funções auxiliares
# ============================================================

log() {
    echo -e "${CYAN}[$1]${NC} $2"
}

success() {
    echo -e "${GREEN}  ✔ $1${NC}"
}

warn() {
    echo -e "${YELLOW}  ⚠️ $1${NC}"
}

error() {
    echo -e "${RED}  ✖ $1${NC}"
}

have_cmd() {
    command -v "$1" > /dev/null 2>&1
}

detect_distro() {
    if [ -f /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

wait_ollama() {
    log "🦙" "Aguardando Ollama responder (até 30s)..."
    for _ in $(seq 1 15); do
        if curl -s --max-time 2 http://127.0.0.1:11434/api/tags > /dev/null 2>&1; then
            return 0
        fi
        sleep 2
    done
    return 1
}

show_help() {
    echo "Uso: ./install.sh [OPÇÃO]"
    echo ""
    echo "Opções:"
    echo "  --full       Instalação completa (padrão)"
    echo "  --minimal    Só dependências obrigatórias (sem Ollama/Docker)"
    echo "  --dotfiles   Só configura shell"
    echo "  --docker     Só Docker + containers"
    echo "  --help       Mostra esta ajuda"
}

# ============================================================
# ✅ Validação do argumento
# ============================================================
if [ "$INSTALL_MODE" = "--help" ]; then
    show_help
    exit 0
fi

case "$INSTALL_MODE" in
    --full|--minimal|--dotfiles|--docker)
        ;;
    *)
        error "Modo inválido: $INSTALL_MODE"
        echo ""
        show_help
        exit 1
        ;;
esac

# ============================================================
# 🎨 Banner
# ============================================================
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════╗"
echo "║  🦾 J.A.R.V.I.S. - Install Script       ║"
echo "║  \"Just A Rather Very Intelligent System\" ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo -e "📦 Modo: ${CYAN}${INSTALL_MODE}${NC}"
echo -e "🏠 Cofre: ${CYAN}${COFRE_DIR}${NC}"
echo -e "🐧 Distro: ${CYAN}$(detect_distro)${NC}"
echo ""

# ============================================================
# 📦 PASSO 1: Dependências do sistema
# ============================================================
if [ "$INSTALL_MODE" = "--full" ] || [ "$INSTALL_MODE" = "--minimal" ]; then
    log "1/6" "Instalando dependências do sistema..."

    DISTRO=$(detect_distro)

    case "$DISTRO" in
        ubuntu|linuxmint|pop)
            sudo apt update
            if [ "$INSTALL_MODE" = "--full" ]; then
                sudo apt install -y curl tar sed git tmux tree jq vim neovim
            else
                sudo apt install -y curl tar sed git tmux tree jq vim
            fi
            ;;
        fedora|rhel|centos)
            sudo dnf install -y curl tar sed git tmux tree jq vim neovim
            ;;
        arch|manjaro|omarchy)
            sudo pacman -S --needed --noconfirm curl tar sed git tmux tree jq vim neovim
            ;;
        *)
            warn "Distro não reconhecida. Instale manualmente: curl tar sed git tmux tree jq vim (neovim no --full)"
            ;;
    esac

    success "Dependências base instaladas"
fi

# ============================================================
# 🐧 PASSO 2: OpenCode CLI
# ============================================================
if [ "$INSTALL_MODE" = "--full" ] || [ "$INSTALL_MODE" = "--minimal" ]; then
    log "2/6" "Verificando OpenCode CLI..."

    if ! have_cmd opencode; then
        warn "OpenCode não encontrado. Instalando..."
        curl -fsSL https://opencode.ai/install | bash
        export PATH="$HOME/.opencode/bin:$PATH"
        if ! grep -qF '.opencode/bin' "$HOME/.bashrc" 2>/dev/null; then
            # shellcheck disable=SC2016 # intencional: $HOME expande quando .bashrc rodar
            echo 'export PATH="$HOME/.opencode/bin:$PATH"' >> "$HOME/.bashrc"
            success "PATH do OpenCode adicionado ao .bashrc"
        else
            success "PATH do OpenCode já configurado"
        fi
    fi

    success "OpenCode disponível"
fi

# ============================================================
# 🦙 PASSO 3: Ollama
# ============================================================
if [ "$INSTALL_MODE" = "--full" ]; then
    log "3/6" "Verificando Ollama..."

    if ! have_cmd ollama; then
        warn "Ollama não encontrado. Instalando..."
        curl -fsSL https://ollama.com/install.sh | sh
    fi

    success "Ollama disponível"
else
    log "3/6" "Pulando Ollama (use --full para instalar)"
fi

# ============================================================
# 📦 PASSO 4: Modelos
# ============================================================
if [ "$INSTALL_MODE" = "--full" ]; then
    log "4/6" "Baixando modelos..."

    if ! wait_ollama; then
        error "Ollama não respondeu após 30s. Verifique o serviço: systemctl status ollama"
        exit 1
    fi

    for model in "qwen3-coder:30b" "gpt-oss:20b"; do
        if ollama list 2>/dev/null | awk '{print $1}' | grep -qxF "$model"; then
            success "$model já existe"
        else
            warn "Baixando $model..."
            ollama pull "$model" || warn "Falha ao baixar $model"
        fi
    done

    warn "Modelos custom (-16k) dependem de perfis de hardware — veja docs/perfis/"

    success "Modelos verificados"
else
    log "4/6" "Pulando modelos (use --full para baixar)"
fi

# ============================================================
# 🐚 PASSO 5: Dotfiles
# ============================================================
if [ "$INSTALL_MODE" = "--full" ] || [ "$INSTALL_MODE" = "--dotfiles" ]; then
    log "5/6" "Configurando dotfiles..."

    DOTFILES_DIR="${COFRE_DIR}/dotfiles"

    if [ -d "$DOTFILES_DIR" ]; then
        # Backup do .bashrc atual
        if [ -f "$HOME/.bashrc" ]; then
            cp "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%Y%m%d%H%M%S)"
            success "Backup do .bashrc criado"
        fi

        # Adicionar source do cofre no .bashrc (usa o COFRE_DIR real, sem hardcode)
        if ! grep -qF "dotfiles/.bashrc" "$HOME/.bashrc" 2>/dev/null; then
            cat >> "$HOME/.bashrc" << EOF

# 🏛️ Dotfiles do Archimedes
if [ -f "$COFRE_DIR/dotfiles/.bashrc" ]; then
    source "$COFRE_DIR/dotfiles/.bashrc"
fi
EOF
            success "Dotfiles adicionados ao .bashrc"
        else
            success "Dotfiles já configurados"
        fi
    else
        warn "Pasta DOTFILES não encontrada em $DOTFILES_DIR"
    fi
fi

# ============================================================
# 🐳 PASSO 6: Docker
# ============================================================
if [ "$INSTALL_MODE" = "--full" ] || [ "$INSTALL_MODE" = "--docker" ]; then
    log "6/6" "Verificando Docker..."

    if ! have_cmd docker; then
        warn "Docker não encontrado. Instalando..."
        DISTRO=$(detect_distro)
        case "$DISTRO" in
            ubuntu|linuxmint|pop)
                sudo apt install -y docker.io docker-compose-v2
                sudo usermod -aG docker "$USER"
                warn "Faça logout/login para usar Docker sem sudo"
                ;;
            fedora|rhel|centos)
                sudo dnf install -y docker docker-compose
                sudo usermod -aG docker "$USER"
                ;;
            arch|manjaro|omarchy)
                sudo pacman -S --needed --noconfirm docker docker-compose
                sudo usermod -aG docker "$USER"
                ;;
            *)
                warn "Instale Docker manualmente"
                ;;
        esac
    fi

    success "Docker disponível"
else
    log "6/6" "Pulando Docker (use --docker para instalar)"
fi

# ============================================================
# ✅ FINALIZAÇÃO
# ============================================================
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✅ Instalação concluída com sucesso!   ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "🔄 ${YELLOW}Recarregue o terminal:${NC}"
echo -e "  ${CYAN}source ~/.bashrc${NC}"
echo ""
echo -e "🚀 ${YELLOW}Para começar:${NC}"
echo -e "  ${CYAN}cd ~/archimedes-v2${NC}"
echo -e "  ${CYAN}agy${NC}  # ou opencode"
echo ""
echo -e "🚀  ${YELLOW}Em máquina recém-formatada, rode primero o bootstrap:${NC}"
echo -e "  ${CYAN}cd ~/archimedes-v2 && ./bootstrap.sh${NC}"
echo ""
echo -e "🔄 ${YELLOW}Trocar de modelo (aliases prontos):${NC}"
echo -e "  ${CYAN}usar-coder${NC}   → Qwen 2.5 Coder 7B (16k)   [usar-coder-v1.1.sh]"
echo -e "  ${CYAN}usar-qwen3${NC}   → Qwen 3 8B (16k)           [usar-qwen3-v1.1.sh]"
echo -e "  ${CYAN}usar-qwen35${NC}  → Qwen 3.5 9B (16k)         [usar-qwen35-v1.1.sh]"
echo ""
echo -e "ℹ️  Se algum comando falhar, verifique o ${CYAN}DEPENDENCIAS.md${NC} ou a mensagem de erro acima."
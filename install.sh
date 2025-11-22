#!/bin/bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DEV_FOLDER="${HOME}/dev"
DOTSDIR="${DEV_FOLDER}/dots"
BASE_URL="https://github.com/bigmstone/dots"
RAW_BASE_URL="https://raw.githubusercontent.com/bigmstone/dots/master"
BREW_FILE_URL="${RAW_BASE_URL}/brew.txt"
BREW_CASK_FILE_URL="${RAW_BASE_URL}/brew-cask.txt"

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        log_error "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

# Detect Linux distribution
detect_linux_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        log_error "Cannot detect Linux distribution"
        exit 1
    fi
}

install_rust() {
    if command_exists rustc; then
        log_info "Rust already installed, skipping..."
        return
    fi
    
    log_info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
}

install_homebrew() {
    if command_exists brew; then
        log_info "Homebrew already installed, skipping..."
        return
    fi
    
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

install_osx() {
    log_info "Setting up macOS..."
    
    install_homebrew
    
    # Download brew file
    log_info "Downloading package list..."
    curl -o /tmp/brew.txt "${BREW_FILE_URL}" || {
        log_error "Failed to download brew.txt"
        exit 1
    }
    
    # Install fonts
    log_info "Installing fonts..."
    # brew install --cask font-myna
    
    # Install packages
    log_info "Installing packages from brew.txt..."
    while IFS= read -r package; do
        [[ -z "$package" || "$package" =~ ^# ]] && continue
        if brew list "$package" &>/dev/null; then
            log_info "Already installed: $package"
        else
            brew install "$package" || log_warn "Failed to install: $package"
        fi
    done < /tmp/brew.txt
    
    # Install fzf key bindings
    if [[ -f "$(brew --prefix)/opt/fzf/install" ]]; then
        log_info "Installing fzf key bindings..."
        "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish
    fi
    
    setup_kitty
}

install_linux() {
    log_info "Setting up Linux..."
    local distro=$(detect_linux_distro)
    
    log_info "Detected distribution: $distro"
    
    case "$distro" in
        ubuntu|debian|linuxmint)
            install_apt
            ;;
        fedora|rhel|centos)
            install_dnf
            ;;
        arch|manjaro)
            install_pacman
            ;;
        *)
            log_error "Unsupported distribution: $distro"
            exit 1
            ;;
    esac
}

install_apt() {
    log_info "Installing packages with APT..."
    local packages=(
        vim neovim universal-ctags golang git tmux cmake
        build-essential curl wget zsh python3-pip
    )
    
    sudo apt-get update
    sudo apt-get install -y "${packages[@]}"
}

install_dnf() {
    log_info "Installing packages with DNF..."
    sudo dnf copr enable thindil/universal-ctags -y
    local packages=(
        vim neovim universal-ctags golang git tmux cmake
        sqlite-devel bzip2-devel readline-devel openssl-devel
        zlib-devel make gcc links zsh python3-pip
    )
    
    sudo dnf install -y "${packages[@]}"
}

install_pacman() {
    log_info "Installing packages with Pacman..."
    local packages=(
        vim neovim ctags go git tmux cmake sqlite
        make gcc links zsh python-pip base-devel
    )
    
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm "${packages[@]}"
}

install_zsh() {
    # Check if zim is already installed (we're using zim now, not prezto)
    if [[ -f "${HOME}/.zim/zimfw.zsh" ]]; then
        log_info "Zim already installed, skipping..."
    else
        log_info "Zim will be installed on first zsh launch via .zshrc"
    fi

    # Change shell if not already zsh
    if [[ "$SHELL" != */zsh ]]; then
        log_info "Changing default shell to zsh..."
        if command_exists zsh; then
            chsh -s "$(which zsh)" || log_warn "Failed to change shell, please run: chsh -s $(which zsh)"
        fi
    else
        log_info "Default shell is already zsh"
    fi
}

link_dots() {
    log_info "Linking dotfiles..."
    
    # Create necessary directories
    mkdir -p ~/.config/{zellij,nvim,kitty,fish/conf.d,jj} ~/.bin
    
    # Link files with proper error handling
    local links=(
        "$DOTSDIR/zellij/config.kbl:~/.config/zellij/config.kbl"
        "$DOTSDIR/zellij/dev.kbl:~/.config/zellij/dev.kbl"
        "$DOTSDIR/nvim:~/.config/nvim"
        "$DOTSDIR/kitty:~/.config/kitty"
        "$DOTSDIR/jj/config.toml:~/.config/jj/config.toml"
        "$DOTSDIR/.aliases:~/.aliases"
        "$DOTSDIR/.aliases.fish:~/.aliases.fish"
        "$DOTSDIR/exports.fish:~/.config/fish/conf.d/exports.fish"
        "$DOTSDIR/.tmux.conf:~/.tmux.conf"
        "$DOTSDIR/.vimrc:~/.vimrc"
        "$DOTSDIR/.zshrc:~/.zshrc"
        "$DOTSDIR/.zpreztorc:~/.zpreztorc"
        "$DOTSDIR/zsh:~/.zsh"
    )
    
    for link in "${links[@]}"; do
        src="${link%:*}"
        dst="${link#*:}"
        dst="${dst/#\~/$HOME}"  # Expand tilde

        # Check if already correctly linked
        if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$src" ]]; then
            log_info "Already linked: $dst"
            continue
        fi

        # Handle existing file/directory that's not our symlink
        if [[ -e "$dst" || -L "$dst" ]]; then
            log_warn "Backing up existing: $dst -> ${dst}.backup"
            mv "$dst" "${dst}.backup"
        fi

        ln -s "$src" "$dst" && log_info "Linked: $dst"
    done
    
    # Create prienv if it doesn't exist
    [[ ! -f ~/.prienv ]] && touch ~/.prienv && log_info "Created ~/.prienv"
}

setup_vim() {
    if command_exists nvim; then
        log_info "Setting up Neovim plugins..."
        nvim --headless "+Lazy! sync" +qa || log_warn "Failed to install Neovim plugins"
    else
        log_warn "Neovim not found, skipping plugin installation"
    fi
}

setup_kitty() {
    local os=$(detect_os)

    if [[ "$os" == "macos" ]]; then
        if command_exists kitty; then
            log_info "Kitty already installed"
        else
            log_info "Installing Kitty..."
            brew install --cask kitty || log_warn "Failed to install Kitty"
        fi
    fi

    if [[ -d ~/.config/kitty/kitty-themes ]]; then
        log_info "Kitty themes already installed"
    else
        log_info "Installing Kitty themes..."
        git clone --depth 1 https://github.com/dexpota/kitty-themes.git ~/.config/kitty/kitty-themes
    fi
}

setup_git() {
    log_info "Configuring Git..."
    
    # Check if already configured
    if git config --global user.email &>/dev/null && git config --global user.name &>/dev/null; then
        log_info "Git already configured"
        read -p "Reconfigure Git? (y/N): " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && return
    fi
    
    read -p "Git email: " gitemail
    read -p "Git name: " gitname
    
    git config --global diff.tool vimdiff
    git config --global merge.tool vimdiff
    git config --global user.email "${gitemail}"
    git config --global user.name "${gitname}"
    git config --global init.defaultBranch main
    
    log_info "Git configured successfully"
}

setup_python() {
    if command_exists uv; then
        log_info "Python setup via uv..."
        log_info "Use 'uv python install' to install Python versions"
        log_info "Use 'uv python pin' to set project-specific versions"
    else
        log_warn "uv not found, skipping Python setup"
    fi
}

install_language_servers() {
    log_info "Installing language servers..."

    # Python
    if command_exists pyright && command_exists ruff; then
        log_info "Python language servers already installed"
    elif command_exists pip3; then
        pip3 install --user pyright ruff || log_warn "Failed to install Python language servers"
    elif command_exists pip; then
        pip install --user pyright ruff || log_warn "Failed to install Python language servers"
    fi

    # Rust (rust-analyzer comes with rustup)
    if command_exists rustup; then
        if rustup component list | grep -q "rust-analyzer.*installed"; then
            log_info "rust-analyzer already installed"
        else
            rustup component add rust-analyzer || log_warn "Failed to install rust-analyzer"
        fi
    fi

    # Go
    if command_exists gopls; then
        log_info "gopls already installed"
    elif command_exists go; then
        go install golang.org/x/tools/gopls@latest || log_warn "Failed to install gopls"
    fi

    # TypeScript/JavaScript
    if command_exists typescript-language-server; then
        log_info "TypeScript language server already installed"
    elif command_exists npm; then
        npm install -g typescript typescript-language-server || log_warn "Failed to install TypeScript language server"
    fi

    # Lua
    if command_exists lua-language-server; then
        log_info "Lua language server already installed"
    elif [[ "$(detect_os)" == "macos" ]]; then
        brew install lua-language-server || log_warn "Failed to install Lua language server"
    else
        log_warn "Please install lua-language-server manually for your distribution"
    fi
}

setup_zsh_plugins() {
    log_info "Setting up Zsh plugins with zap..."

    # Install zap if not already installed
    if [[ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}/zap" ]]; then
        log_info "Installing zap..."
        zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
    else
        log_info "Zap already installed"
    fi
}

# Main installation flow
main() {
    log_info "Starting dotfiles installation..."
    log_info "OS: $(detect_os)"
    
    # Confirm before proceeding
    read -p "This will install packages and link dotfiles. Continue? (y/N): " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 0
    
    # Detect OS and run appropriate installer
    local os=$(detect_os)
    case "$os" in
        macos)
            install_osx
            ;;
        linux)
            install_linux
            ;;
    esac
    
    # Common installations
    install_zsh
    setup_git
    install_rust
    setup_python
    install_language_servers
    link_dots
    setup_vim
    setup_zsh_plugins
    
    log_info "Installation complete!"
    log_info "Please restart your terminal or run: source ~/.zshrc"
}

# Run main function
main "$@"

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
    brew tap homebrew/cask-fonts
    brew install --cask font-caskaydia-cove-nerd-font || log_warn "Font installation failed"
    
    # Install packages
    log_info "Installing packages from brew.txt..."
    while IFS= read -r package; do
        [[ -z "$package" || "$package" =~ ^# ]] && continue
        brew install "$package" || log_warn "Failed to install: $package"
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
    if [[ -d "${HOME}/.zprezto" ]]; then
        log_info "Prezto already installed, skipping..."
        return
    fi
    
    log_info "Installing Zsh with Prezto..."
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    
    # Link prezto files
    /usr/bin/env zsh -c 'setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done'
    
    # Change shell if not already zsh
    if [[ "$SHELL" != */zsh ]]; then
        log_info "Changing default shell to zsh..."
        if command_exists zsh; then
            chsh -s "$(which zsh)" || log_warn "Failed to change shell, please run: chsh -s $(which zsh)"
        fi
    fi
}

link_dots() {
    log_info "Linking dotfiles..."
    
    # Create necessary directories
    mkdir -p ~/.config/{zellij,nvim,kitty,fish/conf.d} ~/.bin
    
    # Link files with proper error handling
    local links=(
        "$DOTSDIR/zellij/config.kbl:~/.config/zellij/config.kbl"
        "$DOTSDIR/zellij/dev.kbl:~/.config/zellij/dev.kbl"
        "$DOTSDIR/nvim:~/.config/nvim"
        "$DOTSDIR/kitty:~/.config/kitty"
        "$DOTSDIR/.aliases:~/.aliases"
        "$DOTSDIR/.aliases.fish:~/.aliases.fish"
        "$DOTSDIR/exports.fish:~/.config/fish/conf.d/exports.fish"
        "$DOTSDIR/.tmux.conf:~/.tmux.conf"
        "$DOTSDIR/.vimrc:~/.vimrc"
        "$DOTSDIR/.zshrc:~/.zshrc"
        "$DOTSDIR/.zpreztorc:~/.zpreztorc"
    )
    
    for link in "${links[@]}"; do
        src="${link%:*}"
        dst="${link#*:}"
        dst="${dst/#\~/$HOME}"  # Expand tilde
        
        # Remove existing link/file if it exists
        if [[ -e "$dst" || -L "$dst" ]]; then
            rm -rf "$dst"
        fi
        
        ln -sf "$src" "$dst" && log_info "Linked: $dst"
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
        log_info "Installing Kitty..."
        brew install --cask kitty || log_warn "Failed to install Kitty"
    fi
    
    if [[ ! -d ~/.config/kitty/kitty-themes ]]; then
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
    if command_exists pyenv; then
        log_info "Setting up Python with pyenv..."
        pyenv install 3 || log_warn "Failed to install Python 3"
        pyenv global 3
    else
        log_warn "pyenv not found, skipping Python setup"
    fi
}

setup_zsh_plugins() {
    log_info "Setting up Zsh plugins..."
    [[ ! -f ~/antigen.zsh ]] && curl -L git.io/antigen > ~/antigen.zsh
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
    link_dots
    setup_vim
    setup_zsh_plugins
    
    log_info "Installation complete!"
    log_info "Please restart your terminal or run: source ~/.zshrc"
}

# Run main function
main "$@"
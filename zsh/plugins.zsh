# Plugin configuration and initialization

# Rust environment
source $HOME/.cargo/env

# Zap plugin manager
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "Aloxaf/fzf-tab"

# Setup fzf
eval "$(fzf --zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Bun completions
[ -s "/Users/mstone/.bun/_bun" ] && source "/Users/mstone/.bun/_bun"

# Enable completion system
autoload -U compinit; compinit

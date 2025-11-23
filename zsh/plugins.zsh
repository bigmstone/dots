# Plugin configuration and initialization
# Note: zsh plugins are managed by zim (see .zimrc)

# Rust environment
source $HOME/.cargo/env

# Setup fzf
eval "$(fzf --zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Bun completions
[ -s "/Users/mstone/.bun/_bun" ] && source "/Users/mstone/.bun/_bun"

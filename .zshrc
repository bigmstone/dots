# Modular Zsh Configuration
# Each component is sourced from zsh/ directory for better organization

# XDG Base Directory specification
ZDOTDIR=${ZDOTDIR:-$HOME}
ZSH_CONFIG_DIR="${HOME}/.zsh"

# Source configuration modules
# Order matters: exports and PATH should come before plugins

# 1. Basic environment setup
source "${ZSH_CONFIG_DIR}/exports.zsh"
source "${ZSH_CONFIG_DIR}/path.zsh"

# 2. Framework initialization (zim)
source "${ZSH_CONFIG_DIR}/zim.zsh"

# 3. Plugins and external tools
source "${ZSH_CONFIG_DIR}/plugins.zsh"

# 4. Prompt configuration
source "${ZSH_CONFIG_DIR}/prompt.zsh"

# 5. Utility functions
source "${ZSH_CONFIG_DIR}/functions.zsh"

# 6. Optional: Conda (only if installed)
[[ -f "${ZSH_CONFIG_DIR}/conda.zsh" ]] && source "${ZSH_CONFIG_DIR}/conda.zsh"

# 7. Aliases (kept in root for tradition)
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# 8. Private environment variables (not tracked in git)
[[ -f "$HOME/.prienv" ]] && source "$HOME/.prienv"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

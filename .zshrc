#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
export PYTHON_CONFIGURE_OPTS="--enable-framework"
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export PATH="$PATH:$HOME/dev/arcanist/bin"
export PATH="$PATH:$HOME/dev/bin"
export PATH="$PATH:$HOME/dev/go/bin"
export PATH="$HOME/Library/Haskell/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/dev/bin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
# export PATH="$(brew --prefix)/bin:${PATH}"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/java/bin:$PATH"
export GOPATH=$HOME/dev/go
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export VISUAL=nvim
export EDITOR=nvim
export XML_CATALOG_FILES="/usr/local/etc/xml/catalog"
export ET_NO_TELEMETRY=1
export AWS_SDK_LOAD_CONFIG=1
export AWS_VAULT_KEYCHAIN_NAME=login

# Load aliases
source $HOME/.aliases
source $HOME/.prienv
autoload -Uz promptinit
promptinit
# prompt paradox
prompt steeef

export PATH=~/Library/Python/3.6/bin:$PATH

# RUST or BUST...or something.
source $HOME/.cargo/env

# Antigen
source $HOME/antigen.zsh
antigen bundle Aloxaf/fzf-tab
antigen apply


autoload -U compinit; compinit
function gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ ;}

# bun completions
[ -s "/Users/mstone/.bun/_bun" ] && source "/Users/mstone/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/mstone/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/mstone/dev/aiPlay/text-generation-webui/installer_files/conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/mstone/dev/aiPlay/text-generation-webui/installer_files/conda/etc/profile.d/conda.sh" ]; then
        . "/Users/mstone/dev/aiPlay/text-generation-webui/installer_files/conda/etc/profile.d/conda.sh"
    else
        export PATH="/Users/mstone/dev/aiPlay/text-generation-webui/installer_files/conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Setup fzf
# ---------
eval "$(fzf --zsh)"

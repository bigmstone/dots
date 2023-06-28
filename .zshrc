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
export PATH="$HOME/.pyenv/shims:$PATH"
export PATH="$HOME/.bin:$PATH"
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

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh


eval "$(pyenv init -)"

autoload -U compinit; compinit
function gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ ;}

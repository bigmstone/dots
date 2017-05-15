#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
export PATH=$PATH:/usr/local/go/bin
export PATH="$PATH:$HOME/dev/arcanist/bin"
export PATH="$PATH:$HOME/dev/bin"
export PATH="$PATH:$HOME/dev/go/bin"
export GOPATH=$HOME/dev/go
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export VISUAL=vimx
export EDITOR=vimx
export XML_CATALOG_FILES="/usr/local/etc/xml/catalog"

# Load aliases
source $HOME/.aliases
source $HOME/.prienv
autoload -Uz promptinit
promptinit
prompt steeef

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
export PATH="$PATH:$HOME/Dropbox/dev/arcanist/bin"
export PATH="$PATH:$HOME/Dropbox/dev/bin"
export PATH="$PATH:$HOME/Dropbox/dev/go/bin"
export GOPATH=~/Dropbox/dev/go
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export XML_CATALOG_FILES="/usr/local/etc/xml/catalog"

# Load aliases
source $HOME/.aliases
source $HOME/.prienv
autoload -Uz promptinit
promptinit
prompt sorin

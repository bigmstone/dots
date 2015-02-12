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
export PATH=$PATH:/Users/mstone/Dropbox/Dev/go/bin
export PATH="$PATH:/Users/mstone/Dropbox/Dev/arcanist/bin"
export GOPATH=/Users/mstone/Dropbox/Dev/go

# Load aliases
source $HOME/.aliases

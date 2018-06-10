export PATH="$PATH:$HOME/dev/go/bin"
export GOPATH=$HOME/dev/go
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export VISUAL=vim
export EDITOR=vim
export XML_CATALOG_FILES="/usr/local/etc/xml/catalog"

# Load aliases
source $HOME/.aliases.fish
source $HOME/.prienv

status --is-interactive; and source (pyenv init -|psub)

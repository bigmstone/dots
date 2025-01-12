#!/bin/bash
read -p "Make sure your shell is installed and all requirements are satisfied."
DEV_FOLDER=~/dev
#DOTSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTSDIR=${DEV_FOLDER}/dots
BASE_URL="https://github.com/bigmstone/dots"
RAW_BASE_URL="https://raw.githubusercontent.com/bigmstone/dots/master"
BREW_FILE_URL="${RAW_BASE_URL}/brew.txt"
BREW_CASK_FILE_URL="${RAW_BASE_URL}/brew-cask.txt"

function install_rust {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

function install_osx {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  curl -o /tmp/brew.txt ${BREW_FILE_URL}
  /opt/homebrew/bin/brew tap homebrew/cask-fonts
  /opt/homebrew/bin/brew install --cask font-caskaydia-cove-nerd-font
  /opt/homebrew/bin/brew install `cat /tmp/brew.txt | sed ':a;N;$!ba;s/\n/ /g'`
  $(brew --prefix)/opt/fzf/install
  setup_kitty
}

function install_linux {
  echo "Installing on linux."
  distro=`lsb_release -si`

  echo $distro

  case "$distro" in
    LinuxMint) install_apt ;;
    Ubuntu)    install_apt ;;
    Fedora)    install_dnf ;;
    Arch)      install_pacman;;
    *)          echo "Unsupported Distro" ;;
  esac
}

function install_apt {
  echo "Installing with APT"
  sudo apt-get -y install vim universal-ctags golang git tmux cmake
}

function install_dnf {
  echo "Installing with DNF"
  sudo dnf copr enable thindil/universal-ctags
  sudo dnf install util-linux-user vim gvim universal-ctags golang git tmux cmake sqlite-devel bzip2-devel readline-devel openssl-devel zlib-devel make gcc links
}

function install_pacman {
  echo "Installing with Pacman"
  sudo pacman -S ctags golang git tmux cmake sqlite make gcc links
}

function install_zsh {
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    /usr/bin/env zsh -c 'setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done'

    chsh -s $(which zsh)
}

function link_dots {
    mkdir ~/.config/zellij
    ln -sf $DOTSDIR/zellij/config.kbl ~/.config/zellij/config.kbl
    ln -sf $DOTSDIR/zellij/dev.kbl ~/.config/zellij/dev.kbl
    ln -sf $DOTSDIR/nvim ~/.config/nvim
    ln -sf $DOTSDIR/kitty ~/.config/kitty
    ln -sf $DOTSDIR/.aliases ~/
    ln -sf $DOTSDIR/.aliases.fish ~/
    ln -sf $DOTSDIR/exports.fish ~/.config/fish/conf.d/
    ln -sf $DOTSDIR/.tmux.conf ~/
    ln -sf $DOTSDIR/.vimrc ~/
    ln -sf $DOTSDIR/.zshrc ~/
    ln -sf $DOTSDIR/.zpreztorc ~/
    touch ~/.prienv
    mkdir ~/.bin
}

function setup_vim {
    nvim --headless "+Lazy! sync" +qa
}

function setup_kitty {
    brew install --cask kitty
    git clone --depth 1 https://github.com/dexpota/kitty-themes.git ~/.config/kitty/kitty-themes
}

function setup_git {
    read -p "Git e-mail: " gitemail
    read -p "Git name: " gitname
    git config --global diff.tool vimdiff
    git config --global merge.tool vimdiff
    git config --global user.email "${gitemail}"
    git config --global user.name "${gitname}"
    git config --global init.defaultBranch main
}

function setup_python {
    pyenv install 3
    pyenv global 3
}

function setup_zsh {
    curl -L git.io/antigen > ~/antigen.zsh
}

function main {
    install_osx
    install_zsh
    setup_git
    install_rust
    # setup_python
    link_dots
    setup_vim
    setup_zsh
}

main $@

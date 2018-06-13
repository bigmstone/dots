#!/bin/bash
read -p "Make sure your shell is installed and all requirements are satisfied."
DOTSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function install_osx {
  brew install `cat ${DOTSDIR}/brew.txt | sed ':a;N;$!ba;s/\n/ /g'`
  brew cask install `cat ${DOTSDIR}/brew-cask.txt | sed ':a;N;$!ba;s/\n/ /g'`
}

function install_linux {
  echo "Installing on linux."
  distro=`lsb_release -si`

  echo $distro

  case "$distro" in
    LinuxMint) install_apt ;;
    Ubuntu)    install_apt ;;
    Fedora)    install_dnf ;;
    *)          echo "Unsupported Distro" ;;
  esac
}

function install_apt {
  echo "Installing with APT"
  sudo apt-get -y install vim ctags golang git tmux cmake
}

function install_dnf {
  echo "Installing with DNF"
  sudo dnf install util-linux-user vim gvim ctags golang git tmux cmake
}

function install_ycm {
    python2 ~/.vim/bundle/YouCompleteMe/install.py --all --gocode-completer
}

function install_zsh {
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    /usr/bin/env zsh -c 'setopt EXTENDED_GLOB\
        for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do \
            ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}" \
        done'

    chsh -s $(which zsh)
}

function install_omf {
    curl -L https://get.oh-my.fish | fish
    fish -c "omf theme clearance"
}

function link_dots {
    ln -sf $DOTSDIR/.aliases ~/
    ln -sf $DOTSDIR/.tmux.conf ~/
    ln -sf $DOTSDIR/.vimrc ~/
    ln -sf $DOTSDIR/.zshrc ~/
    ln -sf $DOTSDIR/.zpreztorc ~/
    touch ~/.prienv
}

function setup_vim {
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
}

function setup_git {
    read -p "Git e-mail: " gitemail
    read -p "Git name: " gitname
    git config --global diff.tool vimdiff
    git config --global merge.tool vimdiff
    git config --global user.email "${gitemail}"
    git config --global user.name "${gitname}"
}

function main {
    case "$OSTYPE" in
    darwin*) install_osx ;; 
    linux*)  install_linux ;;
    *)       echo "Unsupported OS" ;;
    esac

    setup_vim
    install_omf
    setup_git
}

main $@

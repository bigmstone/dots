#!/bin/bash
read -p "Make sure your shell is installed and all requirements are satisfied."
DEV_FOLDER=~/dev
#DOTSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTSDIR=${DEV_FOLDER}/dots
BASE_URL="https://github.com/bigmstone/dots"
RAW_BASE_URL="https://raw.githubusercontent.com/bigmstone/dots/master"
BREW_FILE_URL="${RAW_BASE_URL}/brew.txt"
BREW_CASK_FILE_URL="${RAW_BASE_URL}/brew-cask.txt"

function install_osx {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  curl -o /tmp/brew.txt ${BREW_FILE_URL}
  curl -o /tmp/brew-cask.txt ${BREW_CASK_FILE_URL}
  brew install `cat /tmp/brew.txt | sed ':a;N;$!ba;s/\n/ /g'`
  brew cask install `cat /tmp/brew-cask.txt | sed ':a;N;$!ba;s/\n/ /g'`
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
    (curl -L https://get.oh-my.fish | fish)
    fish -c "omf install clearance"
    fish -c "omf theme clearance"
    sudo /bin/bash -c "echo $(which fish) >> /etc/shells"
    chsh -s $(which fish)
}

function link_dots {
    ln -sf $DOTSDIR/.aliases ~/
    ln -sf $DOTSDIR/.aliases.fish ~/
    ln -sf $DOTSDIR/exports.fish ~/.config/fish/conf.d/
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

function copy_aws_backup {
    read -p "AWS Secret Key: " aws_secret
    read -p "AWS Access Key: " aws_access

    aws configure set --profile personal aws_access_key_id ${aws_access}
    aws configure set --profile personal aws_secret_access_key ${aws_secret}

    mkdir -p ${DEV_FOLDER}
    aws --profile personal s3 sync s3://savenv ${DEV_FOLDER}
}

function setup_python {
    pyenv global 2.7.14 3.6.5
    pip install pipenv awscli ipython[all]
}

function main {
    case "$OSTYPE" in
    darwin*) install_osx ;; 
    linux*)  install_linux ;;
    *)       echo "Unsupported OS" ;;
    esac

    install_omf
    setup_git
    setup_python
    copy_aws_backup
    link_dots
    setup_vim
}

main $@

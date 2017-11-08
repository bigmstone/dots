#!/usr/bin/env zsh
read -q "ignore?Make sure ZSH is installed and all requirements are satisfied."
dotswd=`pwd`
echo $dotswd
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

function install_osx {
  brew install vim ctags golang git tmux reattach-to-user-namespace
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

case "$OSTYPE" in
  darwin*) install_osx ;; 
  linux*)  install_linux ;;
  *)       echo "Unsupported OS" ;;
esac

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

ln -sf $dotswd/.aliases ~/
ln -sf $dotswd/.muttrc ~/
ln -sf $dotswd/.tmux.conf ~/
ln -sf $dotswd/.vimrc ~/
ln -sf $dotswd/.zshrc ~/
ln -sf $dotswd/.zpreztorc ~/
touch ~/.prienv

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

ln -sf $dotswd/yang.vim ~/.vim/
python2 ~/.vim/bundle/YouCompleteMe/install.py --all --gocode-completer
vim +PluginInstall +qall

chsh -s $(which zsh)

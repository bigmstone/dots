#!/usr/bin/env zsh
read -q "ignore?Make sure GO is installed and all requirements are satisfied."
dotswd=`pwd`
echo $dotswd
sudo apt-get install vim ctags golang git tmux
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

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
#python2 ~/.vim/bundle/YouCompleteMe/install.py --gocode-completer
vim +PluginInstall +qall

chsh -s $(which zsh)

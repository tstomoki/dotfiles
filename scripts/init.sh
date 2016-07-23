#!/bin/bash

# save current dir
CurrentDIR=$PWD

# install python with pyenv
# install requisite packages
sudo yum -y groupinstall "Development Tools"
sudo yum -y install readline-devel zlib-devel bzip2-devel sqlite-devel openssl-devel

# install pyenv
git clone https://github.com/yyuu/pyenv.git ~/.pyenv

# install rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv

# config git
git config --global user.name "tstomoki"
git config --global user.email tstomoki4@gmail.com

# install tig
if [ -e $PWD/lib ]; then
    # 存在する場合
    echo "lib dir already exists"
else
    # 存在しない場合
    mkdir lib
fi
cd lib

if [ -e tig-2.1.tar.gz ]; then
    # 存在する場合
    echo "file already exists"
else
    # 存在しない場合
    wget http://jonas.nitro.dk/tig/releases/tig-2.1.tar.gz
fi
tar xvzf tig-2.1.tar.gz
cd tig-2.1
./configure
make 
sudo make install

# install tmux
sudo yum -y install tmux

# install zsh
sudo yum -y install zsh

# change bash to zsh
sudo usermod -s /bin/zsh `whoami`

# locate .zshrc from zsh/zshrc
ln -s $PWD/zsh/zshrc ~/.zshrc
source ~/.zshrc

# install emacs
sudo yum -y install emacs

# configure emacs
if [ -e ~/.emacs.d ]; then
    # 存在する場合
    echo "~/.emacs.d dir already exists"
else
    # 存在しない場合
    mkdir ~/.emacs.d
fi

# locate .emacs from emacs/emacs
ln -s $PWD/emacs/emacs ~/.emacs


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

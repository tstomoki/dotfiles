#!/bin/bash

# save current dir
CurrentDIR=$PWD

# config git
git config --global user.name "tstomoki"
git config --global user.email tstomoki4@gmail.com

# install zsh
sudo yum -y install zsh

# change bash to zsh
sudo usermod -s /bin/zsh `whoami`

# locate .zshrc from zsh/zshrc
ln -s $PWD/zsh/zshrc ~/.zshrc
source ~/.zshrc

# install emacs
sudo yum -y install emacs

#!/bin/bash

# save current dir
CurrentDIR=$PWD

# install zsh
sudo yum -y install zsh

# change bash to zsh
sudo usermod -s /bin/zsh `whoami`

# locate .zshrc from zsh/zshrc
ln -s $PWD/zsh/zshrc ~/.zshrc
source ~/.zshrc

# install emacs
sudo yum -y install emacs

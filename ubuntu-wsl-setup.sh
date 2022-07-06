#!/bin/sh

# update & upgrade
echo 'Performing system update'
sudo apt-get update -y
sudo apt-get upgrade -y
echo 'Done.'

# install apps from software-repos
echo 'Installing favourite applications'
for package in "vim" "curl" "git" "htop" "python-pip" "python-virtualenv" \
  "tmux" "zsh"; do
    echo "**** installing $package ****"
    sudo apt-get install -y $package
done
# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Configure git
echo 'Configuring git'
git config --global user.name "poojankhanpara"
git config --global user.email "poojankhanpara@gmail.com"
git config --global credential.helper cache
echo 'Done.'

# Install powerline fonts
sudo pip install git+git://github.com/Lokaltog/powerline
sudo wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf -O /usr/share/fonts/PowerlineSymbols.otf
sudo fc-cache -vf /usr/share/fonts/
sudo wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf -O /etc/fonts/conf.d/10-powerline-symbols.conf

# enable powerline 
echo ". `pip show powerline-status | grep Location | cut -d ':' -f2`/powerline/bindings/bash/powerline.sh" >> ~/.bashrc

# Install tmux-manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Setting up dotefiles
echo 'Setting up dotfiles'
for file in tmux.conf; do
    echo "... Creating symlink to $file"
    mv ~/.$file ~/.$file.bak.$RANDOM
    ln -bs $(pwd)/$file ~/.$file
done

echo 'Done.'

# Generate SSH keys
if [ ! -f ~/.ssh/id_rsa.pub -o ! -f ~/.ssh/id_dsa.pub ]; then 
# Checks if keys have already been generated
    echo 'Creating SSH keys'
    ssh-keygen -t rsa -C "poojankhanpara@gmail.com" -N '';
else
    echo "SSH keys already exists!"
fi

# Change default shell to zsh
chsh -s `which zsh` $USER

# to start cron on wsl
sudo usermod -a -G crontab $USER
sudo service cron start
sudo update-rc.d cron defaults

# add docker desktop option
echo 'export DOCKER_HOST=tcp://localhost:2375' >> ~/.zshrc


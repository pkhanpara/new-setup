#!/bin/sh

# This is a simple script to set up ubuntu the way I like it.

# add ppas
echo 'Adding PPAs'
#add-apt-repository ppa:webupd8team/sublime-text-3
echo 'Done.'

# adding keys
echo 'adding keys to repo for spotify'
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

#wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 

# update & upgrade
echo 'Performing system update'
apt-get update
apt-get upgrade -y
echo 'Done.'

# install apps from software-repos
echo 'Installing favourite applications'
apt-get install -y vim ubuntu-restricted-extras git-core gimp git openjdk-7-jdk inkscape nautilus-dropbox geany xclip htop python-pip python-virtualenv spotify-client ttf-mscorefonts-installer tmux vlc browser-plugin-vlc
echo 'Done.'

# Configure git
echo 'Configuring git'
git config --global user.name "poojankhanpara"
git config --global user.email "poojankhanpara@gmail.com"
git config --global credential.helper cache
echo 'Done.'

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

## Install chrome ##
####################
echo 'downloading chrome'
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i ./google-chrome-stable_current_amd64.deb
echo 'Done'

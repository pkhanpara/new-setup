#!/bin/sh

# This is a simple script to set up ubuntu the way I like it.

# add ppas
echo 'Adding PPAs'
#add-apt-repository ppa:webupd8team/sublime-text-3
echo 'Done.'

# adding keys
echo 'adding keys to repo for spotify'
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

echo 'adding keys for sublime text'
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

# update & upgrade
echo 'Performing system update'
sudo apt-get update -y
sudo apt-get upgrade -y
echo 'Done.'

# install apps from software-repos
echo 'Installing favourite applications'
for package in "vim" "curl" "ubuntu-restricted-extras" "git-core" "gimp" "git" "inkscape" \
 "geany" "xclip" "htop" "python-pip" "python-virtualenv" \
 "ttf-mscorefonts-installer" "tmux" "vlc" "browser-plugin-vlc"\
  "network-manager-openvpn-gnome" "sublime-text" "zsh"; do
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

## Install chrome ##
####################
echo 'downloading chrome'
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i ./google-chrome-stable_current_amd64.deb
echo 'Done'

# Change default shell to zsh
chsh -s `which zsh` $USER

# load old gsettings
dconf load / < gsettings.txt
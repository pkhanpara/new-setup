#!/bin/bash

echo 'Setting up dotfiles'

for file in tmux.conf; do
    echo "Creating symlink to $file"
    ln -bs $(pwd)/$file ~/.$file
done

echo 'Done.'

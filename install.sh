#!/bin/bash

set -euo pipefail

# The directory this script is in.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$DIR"

echo "Running $DIR/install-dotfiles.sh"

function relink() {
  source_file="$DIR/$1"
  if [ -z "${2:-}" ] ; then
    target_file="$HOME/.$1"
  else
    target_file="$HOME/$2"
  fi
  if [[ -h "$target_file" ]] ; then
    unlink "$target_file"
  else
    if [[ -f $target_file || -d $target_file ]] ; then
        mv "$target_file" "$target_file.bak"
    fi
  fi
  if [[ -e $source_file ]] ; then
    ln -sn "$source_file" "$target_file"
  fi
}

# Ensure we have a .ssh dir.
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Set up $HOME/.vimtmp
mkdir -p "$HOME/.vimtmp/backup"
mkdir -p "$HOME/.vimtmp/sessions"
mkdir -p "$HOME/.vimtmp/swap"
mkdir -p "$HOME/.vimtmp/undo"

relink bin
relink js
relink tmux-layouts
relink tmuxifier
relink vim

relink ackrc
relink alacritty.yml
relink allshellsrc
relink bash_profile
relink bashrc
relink eslintrc
relink gemrc
relink gitconfig
relink gitignore_global
relink gvimrc
relink irbrc
relink iterm2_shell_integration.bash
relink iterm2_shell_integration.zsh
relink rdebugrc
relink rvmrc
relink tmux.conf
relink vimrc
relink zshrc

mkdir -p "$HOME/.config/nvim"
relink nvim-init.vim .config/nvim/init.vim

mkdir -p "$HOME/config"
relink starship.toml .config/starship.toml

# Install all homebrew deps
if hash brew 2>/dev/null; then
  brew update && brew cleanup
  if [[ -z "${GITPOD_HOST:-}" ]]; then  
    brew bundle
  else
    brew bundle --file ./Brewfile-gitpod
  fi
else
  echo "No homebrew, skipping brew."
fi

# Install poetry
if ! hash poetry 2>/dev/null; then
  echo "Installing poetry..."
  curl -sSL https://install.python-poetry.org | python3 -
fi

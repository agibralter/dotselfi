#!/bin/bash

export PATH="/usr/local/sbin:$PATH"

# Add RVM to PATH
if [ -d "$HOME/.rvm/bin" ]; then
  export PATH="$HOME/.rvm/bin:$PATH"
fi

# Add `pip install --user` to PATH
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Heroku Toolbelt
if [ -d /usr/local/heroku/bin ]; then
  export PATH="/usr/local/heroku/bin:$PATH"
fi

# Add tmuxifier to path.
if [ -d "$HOME/.tmuxifier/bin" ]; then
  export PATH="$HOME/.tmuxifier/bin:$PATH"
  export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux-layouts"
fi

# Add yarn to path.
if [ -d "$HOME/.yarn/bin" ]; then
  export PATH="$HOME/.yarn/bin:$PATH"
fi

# Add custom bin directory to path.
export PATH="$HOME/.bin:$PATH"

export EDITOR="vim"
export SVN_EDITOR="vim"
export GIT_EDITOR='vim'
export GEMEDITOR="vim"

###############################################################################
# ssh stuff
###############################################################################
SOCK="/tmp/ssh-agent-$USER-screen"
if test "$SSH_AUTH_SOCK" && [ "$SSH_AUTH_SOCK" != "$SOCK" ]; then
  rm -f "/tmp/ssh-agent-$USER-screen"
  ln -sf "$SSH_AUTH_SOCK" "$SOCK"
  export SSH_AUTH_SOCK=$SOCK
fi

ssh-reagent () {
  for agent in /tmp/ssh-*/agent.*; do
    export SSH_AUTH_SOCK=$agent
    if ssh-add -l >/dev/null 2>&1; then
      echo Found working SSH Agent:
      ssh-add -l
      return
    fi
  done
  echo Cannot find ssh agent - maybe you should reconnect and forward it?
}

ssh-add -A &> /dev/null

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# vim: ft=sh

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

# Add custom bin directory to path.
export PATH="$HOME/.bin:$PATH"

# https://twitter.com/tpope/status/165631968996900865
# Add bin/ directories within "trusted" local repos to be in PATH. Make sure
# to "trust" a repo by running `mkdir .git/safe-binstubs`.
# export PATH=".git/safe-binstubs/../../bin:$PATH"

###############################################################################
# Use MacVim or Vim as $EDITOR?
###############################################################################
# From mvim script...
if [ -z "$VIM_APP_DIR" ]; then
  for i in ~/Applications ~/Applications/vim /Applications /Applications/vim /Applications/Utilities /Applications/Utilities/vim; do
    if [ -x "$i/MacVim.app" ]; then
      VIM_APP_DIR="$i"
      break
    fi
  done
fi
if [ -z "$VIM_APP_DIR" ]; then
  # NO MACVIM
  export EDITOR="vim"
  export SVN_EDITOR="vim"
  export GIT_EDITOR='vim'
  export GEMEDITOR="vim"
else
  # YES MACVIM
  export EDITOR="mvim -f"
  export SVN_EDITOR="mvim -f"
  export GIT_EDITOR='mvim -f'
  export GEMEDITOR="mvim"
fi

###############################################################################
# ssh stuff
###############################################################################
SOCK="/tmp/ssh-agent-$USER-screen"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
then
  rm -f /tmp/ssh-agent-$USER-screen
  ln -sf $SSH_AUTH_SOCK $SOCK
  export SSH_AUTH_SOCK=$SOCK
fi

ssh-reagent () {
  for agent in /tmp/ssh-*/agent.*; do
    export SSH_AUTH_SOCK=$agent
    if ssh-add -l 2>&1 > /dev/null; then
      echo Found working SSH Agent:
      ssh-add -l
      return
    fi
  done
  echo Cannot find ssh agent - maybe you should reconnect and forward it?
}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

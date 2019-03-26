###############################################################################
# bash setup
###############################################################################

export BASH_ENV=$HOME/.bashrc

DOTSELFI="$(dirname "$(readlink "${BASH_SOURCE[@]}")")"
export DOTSELFI

# Source .bashrc
# shellcheck disable=SC1090
if [ -f "$HOME/.bashrc" ]; then source "$HOME/.bashrc"; fi

# Source extras.
# shellcheck disable=SC1090
if [ -f "$HOME/.bash_extras" ]; then source "$HOME/.bash_extras"; fi

# Add custom bin directory to path.
export PATH="$HOME/.bin:$PATH"

export EDITOR="vim"
export SVN_EDITOR="vim"
export GIT_EDITOR='vim'
export GEMEDITOR="vim"

###############################################################################
# aliases
###############################################################################

alias cp="cp -i"
alias mv="mv -i"
# shellcheck disable=SC2032
alias rm="rm -i"
alias ls="ls -GF"
alias ll="ls -alGF"
alias g="git"
alias sizes="du -h -d1"
alias be="bundle exec"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias killpyc="find . -name '*.pyc' -delete"
alias bip="bundle install --binstubs=.bundler_bin --path=vendor/bundle"

function pstreeme() {
  pstree -aup "$(whoami)"
}

# pick!
if hash pick 2>/dev/null; then
  pickcd() { cd "$(find . -type d | pick)" || return 1; }
  pickkill() { kill "$(ps -e | awk '{if(NR!=1) { print $4, $1 }}' | pick -do | tail -n +2)" ; }
  pickhist() { history | cut -c8- | sort -u | pick ; }
fi

function dotselfi() {
  cd "$DOTSELFI" || return 1
}

# ctags!
if hash ctags 2>/dev/null; then
  alias ctagit="ctags -R --exclude=.git --exclude=log --exclude=public *"
fi

# Stop the annoying ctrl-s/ctrl-q control flow mappings.
stty stop ''
stty start ''
stty -ixon
stty -ixoff

# History control
export HISTFILESIZE=10000
export HISTSIZE=10000
export HISTIGNORE="[bf]g:[ ]*:exit:??"
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
shopt -s cmdhist

PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

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

###############################################################################
# lib setup
###############################################################################

# Heroku Toolbelt
if [ -d /usr/local/heroku/bin ]; then
  export PATH="/usr/local/heroku/bin:$PATH"
fi

# if hash rbenv 2>/dev/null; then
#   eval "$(rbenv init -)"
# fi

# Set up pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"

  # Create a wrapper to automatically set compiler flags:
  # https://github.com/pyenv/pyenv/issues/1219#issuecomment-428793012
  function pyenv_install() {
    (
      __pyenv_readline="$(brew --prefix readline)"
      __pyenv_openssl="$(brew --prefix openssl)"
      __pyenv_cflags="-I$__pyenv_readline/include -I$__pyenv_openssl/include -I$(xcrun --show-sdk-path)/usr/include"
      __pyenv_ldflags="-L$__pyenv_readline/lib -L$__pyenv_openssl/lib"
      CFLAGS=$__pyenv_cflags
      export CFLAGS
      LDFLAGS=$__pyenv_ldflags
      export LDFLAGS
      PYTHON_CONFIGURE_OPTS="--enable-unicode=ucs2 --enable-framework" 
      export PYTHON_CONFIGURE_OPTS
      pyenv install "$@"
    )
  }
fi

# And pyenv-virtualenv
if command -v pyenv-virtualenv 1>/dev/null 2>&1; then
  eval "$(pyenv virtualenv-init -)"
fi

# Set up alacritty
if [[ -d $ALACRITTY_PATH ]]; then
  export PATH="$ALACRITTY_PATH:$PATH"
fi

# Tab Completions
if hash brew 2>/dev/null; then
  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    # Source all custom bash completions
    # shellcheck disable=SC1090
    . "$(brew --prefix)/etc/bash_completion"

    # shellcheck disable=SC1090
    for f in ~/.bin/bash-completion/*; do source "$f"; done

    # Autocomplete for 'g' alias as well.
    complete -o default -o nospace -F _git g
  fi
fi

# Hub
if hash hub 2>/dev/null; then
  eval "$(hub alias -s)"
fi

###############################################################################
# bash prompt
###############################################################################

# Colors
RED="\\[\\033[0;31m\\]"
YELLOW="\\[\\033[0;33m\\]"
GREEN="\\[\\033[0;32m\\]"
LT_GREEN="\\[\\033[1;32m\\]"
BLUE="\\[\\033[0;34m\\]"
WHITE="\\[\\033[1;37m\\]"
COLOR_NONE="\\[\\033[0m\\]"
LIGHTNING_BOLT="⚡"
UP_ARROW="↑"
DOWN_ARROW="↓"
UD_ARROW="↕"
RECYCLE="♺"

function parse_git_branch {
  local branch_pattern
  local remote_pattern
  local diverge_pattern
  local initials

  branch_pattern="^(# )?On branch ([^${IFS}]*)"
  remote_pattern="(# )?Your branch is (.*) of"
  diverge_pattern="(# )?Your branch and (.*) have diverged"
  initials=$(git config user.initials)

  if [[ -n $initials ]]; then
    initials=" [${initials}] "
  else
    initials=""
  fi

  git_status="$(git status 2>/dev/null)"
  if [[ ! ${git_status} =~ ${branch_pattern} ]]; then
    return
  fi
  branch=${BASH_REMATCH[2]}

  # Dirty?
  if [[ ! ${git_status} =~ "working tree clean" ]]; then
    git_is_dirty="${RED}${LIGHTNING_BOLT}"
  else
    git_is_dirty=
  fi

  # Do we need to push to origin?
  git_log_linecount="$(git log --pretty=oneline "origin/${branch}..${branch}" 2>/dev/null | wc -l)"
  if [[ ! ${git_log_linecount} =~ "0" ]]; then
    needs_push="${WHITE}${RECYCLE}"
  fi

  # Are we ahead of, beind, or diverged from the remote?
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[2]} =~ "ahead" ]]; then
      remote="${YELLOW}${UP_ARROW}"
    else
      remote="${YELLOW}${DOWN_ARROW}"
    fi
  fi

  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="${YELLOW}${UD_ARROW}"
  fi

  echo "(${branch})${initials}${remote}${git_is_dirty}${needs_push}"
}

function set_prompt() {
  git_prompt="${GREEN}$(parse_git_branch)${COLOR_NONE}"
  export PS1="$RED\$(date +%H:%M) ${HOSTNAME} ${LT_GREEN}[\\w] ${git_prompt}\\n${BLUE}\$${COLOR_NONE} "
}

PROMPT_COMMAND="$PROMPT_COMMAND set_prompt"

###############################################################################
# random functions
###############################################################################

# Usage `$gifify name-of-input-file.mov name-of-output-file.gif`
# Run on a .mov or video file.
function gifify() {
  docker run -it --rm -v "$(pwd)":/data maxogden/gifify "$1" -o "$2"
}

function cheat() {
  curl "cht.sh/$1"
}

function bbb() {
  brew update; brew upgrade; brew cleanup
}

function imdone() {
  if [[ "$#" == 0 ]]; then
    terminal-notifier -sound default -message "Done!"
  else
    "$@"

    args=''
    for i in "$@"; do
      args="$args ${i//\"/\\\"}"
    done
    
    terminal-notifier -sound default -message "Done running: $args"
  fi
}

function docker-nuke() {
  docker ps -q | xargs docker stop
  # shellcheck disable=SC2033
  docker ps -qa | xargs docker rm
  # shellcheck disable=SC2033
  docker volume ls -q | xargs docker volume rm
}

function docker-super-nuke() {
  docker-nuke
  docker images list -q | xargs docker rmi
}

function osx-reset-video() {
  sudo killall VDCAssistant
  sudo killall AppleCameraAssistant
}

function git-root() {
  root=$(git rev-parse --git-dir 2>/dev/null)
  if [[ "$root" == "" ]]; then root="."; fi
  dirname $root
}

# Open a manpage in Preview, which can be saved to PDF
function pman() {
  man -t "${1}" | open -f -a /Applications/Preview.app
}

exclude="\\.svn|\\.git|\\.swp|\\.coverage|\\.pyc|_build"
function pgrep() {
  find . -maxdepth 1 -mindepth 1| grep -Ev "$exclude" | xargs grep -Elir "$1" | grep -Ev "$exclude" | xargs grep -EHin --color "$1"
}

if hash nodenv 2>/dev/null; then
  eval "$(nodenv init -)"
fi

# shellcheck disable=SC1090
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

export PATH="$HOME/.cargo/bin:$PATH"

GPG_TTY="$(tty)"
export GPG_TTY

# Set up direnv (must be last thing that modifies prompt).
if hash direnv 2>/dev/null; then
  eval "$(direnv hook bash)"
fi

# Must come last otherwise it breaks other things that rely on $PS1, such as
# direnv
# shellcheck disable=SC1090
source "$HOME/.iterm2_shell_integration.$(basename "$SHELL")"

# vim:set ft=bash:

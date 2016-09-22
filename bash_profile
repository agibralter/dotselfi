# vim: ft=sh

###############################################################################
# bash setup
###############################################################################

export BASH_ENV=$HOME/.bashrc

export DOTSELFI=$(dirname $(readlink ${BASH_SOURCE[@]}))

# Source .bashrc
if [ -f $HOME/.bashrc ]; then source $HOME/.bashrc; fi

# Source extras.
if [ -f $HOME/.bash_extras ]; then source $HOME/.bash_extras; fi

###############################################################################
# lib setup
###############################################################################

# Set up rvm...
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  source "$HOME/.rvm/scripts/rvm"
fi

# ... or rbenv.
hash rbenv 2>/dev/null
if [ $? -eq 0 ]; then
  eval "$(rbenv init -)"
fi

# Set up tmuxifier.
hash tmuxifier 2>/dev/null
if [ $? -eq 0 ]; then
  eval "$(tmuxifier init -)"
fi

# Tab Completions
hash brew 2>/dev/null
if [ $? -eq 0 ]; then
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion

    # Source all custom bash completions
    for f in ~/.bin/bash-completion/*; do source $f; done

    # Autocomplete for 'g' alias as well.
    complete -o default -o nospace -F _git g
  fi
fi

# bcat!
hash bcat 2>/dev/null
if [ $? -eq 0 ]; then
  export MANPAGER="col -b | bcat"
  export GIT_PAGER="bcat"
fi


# virtualenvwrapper!
hash virtualenvwrapper.sh 2>/dev/null
if [ $? -eq 0 ]; then
  source `command -v virtualenvwrapper.sh`
fi

###############################################################################
# aliases
###############################################################################

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias ls="ls -GF"
alias ll="ls -alGF"
alias g="git"
alias sizes="du -h -d1"
alias be="bundle exec"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias pstreeme="pstree -aup $(whoami)"
alias killpyc="find . -name '*.pyc' -delete"
alias bip="bundle install --binstubs=.bundler_bin --path=vendor/bundle"

alias cdd="cd $DOTSELFI"

# hub!
hash hub 2>/dev/null
if [ $? -eq 0 ]; then
  alias git=hub
fi

# ctags!
hash ctags 2>/dev/null
if [ $? -eq 0 ]; then
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
# bash prompt
###############################################################################

# Colors
RED="\[\033[0;31m\]"
PINK="\[\033[1;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
LT_GREEN="\[\033[1;32m\]"
BLUE="\[\033[0;34m\]"
WHITE="\[\033[1;37m\]"
PURPLE="\[\033[1;35m\]"
CYAN="\[\033[1;36m\]"
COLOR_NONE="\[\033[0m\]"
LIGHTNING_BOLT="⚡"
UP_ARROW="↑"
DOWN_ARROW="↓"
UD_ARROW="↕"
RECYCLE="♺"

function parse_git_branch {
  local branch_pattern="^(# )?On branch ([^${IFS}]*)"
  local remote_pattern="(# )?Your branch is (.*) of"
  local diverge_pattern="(# )?Your branch and (.*) have diverged"
  local initials=`git config user.initials`

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
  git_log_linecount="$(git log --pretty=oneline origin/${branch}..${branch} 2>/dev/null | wc -l)"
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
  export PS1="$RED\$(date +%H:%M) ${HOSTNAME} $LT_GREEN[\w] ${git_prompt}\n${BLUE}\$${COLOR_NONE} "
}

PROMPT_COMMAND="$PROMPT_COMMAND set_prompt"


###############################################################################
# random functions
###############################################################################

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

exclude="\.svn|\.git|\.swp|\.coverage|\.pyc|_build"
function pgrep() {
  find . -maxdepth 1 -mindepth 1| egrep -v "$exclude" | xargs egrep -lir "$1" | egrep -v "$exclude" | xargs egrep -Hin --color "$1"
}

source ~/.iterm2_shell_integration.`basename $SHELL`

# Set up direnv (must be last thing that modifies prompt).
hash direnv 2>/dev/null
if [ $? -eq 0 ]; then
  eval "$(direnv hook bash)"
fi

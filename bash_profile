###############################################################################
# bash setup
###############################################################################

export BASH_ENV=$HOME/.bashrc

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
which rbenv > /dev/null
if [ $? -eq 0 ]; then
  eval "$(rbenv init -)"
fi

# Set up tmuxifier.
which tmuxifier > /dev/null
if [ $? -eq 0 ]; then
  eval "$(tmuxifier init -)"
fi

# Tab Completions
which brew > /dev/null
if [ $? -eq 0 ]; then
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
    source $HOME/.bin/git-completion.bash
  fi
fi

# bcat!
which bcat > /dev/null
if [ $? -eq 0 ]; then
  export MANPAGER="col -b | bcat"
  export GIT_PAGER="bcat"
fi


# virtualenvwrapper!
which virtualenvwrapper.sh > /dev/null
if [ $? -eq 0 ]; then
  source `which virtualenvwrapper.sh`
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

# hub!
which hub > /dev/null
if [ $? -eq 0 ]; then
  alias git=hub
fi

# ctags!
which ctags > /dev/null
if [ $? -eq 0 ]; then
  alias ctagit="ctags -R --exclude=.git --exclude=log --exclude=public *"
fi

# Stop the annoying ctrl-s/ctrl-q control flow mappings.
stty stop ''
stty start ''
stty -ixon
stty -ixoff

# History control
export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth
shopt -s histappend

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
  branch_pattern="^(# )?On branch ([^${IFS}]*)"
  remote_pattern="(# )?Your branch is (.*) of"
  diverge_pattern="(# )?Your branch and (.*) have diverged"

  git_status="$(git status 2> /dev/null)"
  if [[ ! ${git_status} =~ ${branch_pattern} ]]; then
    return
  fi
  branch=${BASH_REMATCH[2]}

  # Dirty?
  if [[ ! ${git_status} =~ "working directory clean" ]]; then
    git_is_dirty="${RED}${LIGHTNING_BOLT}"
  else
    git_is_dirty=
  fi

  # Do we need to push to origin?
  git_log_linecount="$(git log --pretty=oneline origin/${branch}..${branch} 2> /dev/null | wc -l)"
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

  echo "(${branch})${remote}${git_is_dirty}${needs_push}"
}

function set_prompt() {
  git_prompt="${GREEN}$(parse_git_branch)${COLOR_NONE}"
  export PS1="$RED\$(date +%H:%M) ${HOSTNAME} $LT_GREEN[\w] ${git_prompt}\n${BLUE}\$${COLOR_NONE} "
}

export PROMPT_COMMAND=set_prompt


###############################################################################
# random functions
###############################################################################

function git-root() {
  root=$(git rev-parse --git-dir 2> /dev/null)
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

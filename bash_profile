# shellcheck disable=SC1090
source "$HOME/.allshellsrc"

# History control
export HISTFILESIZE=10000
export HISTSIZE=10000
export HISTIGNORE="[bf]g:[ ]*:exit:??"
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
shopt -s cmdhist

PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

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

# vim:ft=bash:tw=0:ts=2:sw=2:noet:nolist:foldmethod=marker

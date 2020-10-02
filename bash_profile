# shellcheck shell=bash
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

if hash starship 2>/dev/null; then
  eval "$(starship init bash)"
fi

# Must come last otherwise it breaks other things that rely on $PS1, such as
# direnv
# shellcheck disable=SC1090
test -e "$HOME/.iterm2_shell_integration.bash" && source "$HOME/.iterm2_shell_integration.bash"

# vim:ft=bash:tw=0:ts=2:sw=2:noet:nolist:foldmethod=marker
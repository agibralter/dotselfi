# shellcheck shell=bash

if [[ -n "${GITPOD_HOST:-}" ]]; then
  # shellcheck disable=SC1091
  source "$HOME/.bash_profile"

  for f in "$HOME"/.bashrc.d/*
  do
    [[ -e "$f" ]] || break  # handle the case of no files
    # shellcheck disable=SC1090
    source "$f"
  done
fi

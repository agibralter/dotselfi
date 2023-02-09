# shellcheck shell=bash

if [[ -n "${GITPOD_HOST:-}" ]]; then
    # shellcheck disable=SC1091
    source "$HOME/.bash_profile"
fi
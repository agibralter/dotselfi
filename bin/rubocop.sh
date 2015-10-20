#! /bin/bash

bundle exec rubocop --version &>/dev/null

if [ $? -eq 0 ]; then
  bundle exec rubocop --force-exclusion "$@"
else
  rubocop "$@"
fi

# dotselfi
Dotfiles. New and improved.

## dependencies (OS X)
* [Homebrew](https://brew.sh/)

## setup
* Run `./install-dotfiles.sh`.
* Install [Oh My Zsh](https://ohmyz.sh/).

## notes
To use direnv with rbenv, bundler, and binstubs, run (e.g.):

    bundle install --binstubs .bundler_bin

And add the following to the project's .envrc file:

    PATH_add .bundler_bin

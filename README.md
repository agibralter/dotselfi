# dotselfi
Dotfiles. New and improved.

## dependencies (OS X)
* Homebrew

## setup
1. Make sure to init submodules after clone.
   [YouCompleteMe](https://github.com/Valloric/YouCompleteMe) requires `git
   submodule update --init --recursive`.
2. Run `./install-dotfiles.sh`.
3. `cd vim/bundles/YouCompleteMe; ./install.py --clang-completer
   --gocode-completer`.

## important brew deps for dotselfi
* `bash-completion`
* `ctags`
* `pstree`
* `node`
* `golang` (YouCompleteMe)
* `vim` (use 7.4!)
* `macvim` (make sure to `brew linkapps macvim`)
* `editorconfig` [link](https://github.com/editorconfig/editorconfig-core-c)
* `the_silver_searcher` [link](https://github.com/ggreer/the_silver_searcher)
* `cmake` (for YouCompleteMe Vim bundle)
* `direnv` [link](https://github.com/direnv/direnv)

## other important brews
* `rbenv`
* `tmux`
* `postgres`
* `nginx`
* `redis`

## other things to install/setup
* `npm install -g jshint`
* [Powerline fonts](https://github.com/powerline/fonts) for vim-airline.

## notes
* To use direnv with rbenv, bundler, and binstubs, run (e.g.):

    bundle install --binstubs .bundler_bin

  And add the following to the project's .envrc file:

    PATH_add .bundler_bin

# dotselfi
Dotfiles. New and improved.

## dependencies (OS X)
* Homebrew

## setup
1. Make sure to init submodules after clone.
   [YouCompleteMe](https://github.com/Valloric/YouCompleteMe) requires `git
   submodule update --init --recursive`.
2. Run `./install-dotfiles.sh`.
3. `cd vim/bundles/YouCompleteMe; ./install.sh --clang-completer
   --gocode-completer`.

## important brew deps for dotselfi
* `bash-completion`
* `ctags`
* `pstree`
* `node`
* `vim` (use 7.4!)
* `macvim` (make sure to `brew linkapps macvim`)
* `editorconfig` [link](https://github.com/editorconfig/editorconfig-core-c)
* `the_silver_searcher` [link](https://github.com/ggreer/the_silver_searcher)
* `cmake` (for YouCompleteMe Vim bundle)

## other important brews
* `rbenv`
* `tmux`
* `postgres`
* `nginx`
* `redis`

## other things to install/setup
* `npm install -g jshint`
* [Powerline fonts](https://github.com/powerline/fonts) for vim-airline.

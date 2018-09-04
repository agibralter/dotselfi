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
4. Check out [alacritty](https://github.com/jwilm/alacritty) and set the
   ALACRITTY_PATH env var in ~/.bash_extras:
   ```
   export ALACRITTY_PATH="/path/to/alacritty"
   ```

## important brew deps for dotselfi
* `bash-completion`
* `bat` [link](https://github.com/sharkdp/bat)
* `cmake` (for YouCompleteMe Vim bundle)
* `ctags`
* `diff-so-fancy` [link](https://github.com/so-fancy/diff-so-fancy)
* `direnv` [link](https://github.com/direnv/direnv)
* `editorconfig` [link](https://github.com/editorconfig/editorconfig-core-c)
* `fzf` [link](https://github.com/junegunn/fzf)
* `golang` (YouCompleteMe)
* `htop` [link](https://github.com/hishamhm/htop)
* `macvim` (make sure to `brew linkapps macvim`)
* `nodenv`
* `noti` [link](https://github.com/variadico/noti)
* `pick` [link](https://github.com/calleerlandsson/pick)
* `pstree`
* `rg` [link](https://github.com/BurntSushi/ripgrep)
* `the_silver_searcher` [link](https://github.com/ggreer/the_silver_searcher)
* `vim` (use 7.4!)

## other important brews
* `rbenv`
* `tmux`
* `postgres`
* `nginx`
* `redis`
* `pyenv`

## other things to install/setup
* `npm install -g jshint`
* [Powerline fonts](https://github.com/powerline/fonts) for vim-airline.
* [rustup](https://rustup.rs/): `curl https://sh.rustup.rs -sSf | sh`

## notes

To use direnv with rbenv, bundler, and binstubs, run (e.g.):

    bundle install --binstubs .bundler_bin

And add the following to the project's .envrc file:

    PATH_add .bundler_bin

# dotselfi

Dotfiles. New and improved.

## new computer setup

* Install [1password](https://1password.com/downloads/)
* Install [Homebrew](https://brew.sh/) (May need `xcode-select --install`)
* Install [Oh My Zsh](https://ohmyz.sh/)
* Clone this repo (will need to set up github ssh key and may want to grab gpg key from 1pw)
* Run `./install.sh` (May need temporary PATH setting for access to `brew` command)

## Apps (Manual Downloads)

* aText
* Chrome / Brave / Firefox
* Docker for Mac
* iTerm 2 / [Hyper](https://hyper.is/)
* Little Snitch
* Micro Snitch
* Slack
* Spotify

## App Store

* Amphetamine
* Magnet
* Pastebot
* Xcode

## other stuff

* [Solarized](https://ethanschoonover.com/solarized/)

## vim

Vim will be messed up until running `:PlugInstall`

## iterm

Set profile to use the Fira Code font.

## gitpod

To forward gpg signing to gitpod, add the following to .ssh/config:

```plaintext
Host *.ssh.ws*.gitpod.io
  ForwardAgent yes
  ServerAliveInterval 15
  RemoteForward /home/gitpod/.gnupg/S.gpg-agent /Users/aarongibralter/.gnupg/S.gpg-agent.extra
  StreamLocalBindUnlink yes
```

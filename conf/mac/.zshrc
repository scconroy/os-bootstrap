#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
#source /usr/local/bin/aws_zsh_completer.sh

# Prezto update
alias pzupdate='cd ~/.zprezto && git pull && git submodule update --init --recursive && cd -'

PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

alias reload=". ~/.zshrc && echo 'ZSH config reloaded from ~/.zshrc'"
alias ls='ls --color=auto'

source /usr/local/share/zsh/site-functions/_aws

# Android
#export ANDROID_HOME=/usr/local/opt/android-sdk
#/usr/local/etc/bash_completion.d

#eval "$(thefuck --alias)"

# Go lang Path
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export GOPATH=$HOME/work/go
export PATH=$PATH:$GOPATH/bin

# Brew and Pip aliases
alias brewski='brew update && brew upgrade --all && brew cask list | xargs brew cleanup; brew cask cleanup; brew doctor'
alias pipu='pip freeze --local | grep -v \'\^\-\e' | cut -d = -f 1  | xargs -n1 pip install -U'

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters

# VMIE SSH Identities
source $HOME/.ssh/vmie.zsh

#fpath+=( $HOME/.linuxbrew/share/zsh-navigation-tools )
#fpath=($HOME/.linuxbrew/share/zsh-completions $fpath)

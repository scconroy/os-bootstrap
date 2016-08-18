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

# Prezto update
alias pzupdate='cd ~/.zprezto && git pull && git submodule update --init --recursive && cd -'

alias reload=". ~/.zshrc && echo 'ZSH config reloaded from ~/.zshrc'"
alias ls='ls --color=auto'

## Setup LinuxBrew
export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
export HOMEBREW_BUILD_FROM_SOURCE=1

# Brew and Pip aliases
alias brewski='brew update && brew upgrade --all && brew cask list | xargs brew cleanup; brew cask cleanup; brew doctor'
alias pipu='pip freeze --local | grep -v \'\^\-\e' | cut -d = -f 1  | xargs -n1 pip install -U'

# VMIE SSH Identities
source $HOME/.ssh/vmie.zsh

unalias run-help
autoload run-help
HELPDIR=$HOME/.linuxbrew/share/zsh/help

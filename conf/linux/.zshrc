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
alias pzupdate='cd $HOME/.zprezto && git pull && git submodule update --init --recursive && cd -'

alias reload="source $HOME/.zshrc && echo 'ZSH config reloaded from $HOME/.zshrc'"
alias ls='ls --color=auto'

## Setup LinuxBrew
export PATH="$HOME/.linuxbrew/bin:$PATH"
export PATH="$HOME/.linuxbrew/sbin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
export HOMEBREW_BUILD_FROM_SOURCE=1

# Brew and Pip aliases
alias brewski='brew update && brew upgrade --all && brew cask list | xargs brew cleanup; brew cask cleanup; brew doctor'
alias pipu='pip freeze --local | grep -v \'\^\-\e' | cut -d = -f 1  | xargs -n1 pip install -U'

# Fancy ZSH Tools
source $HOME/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.linuxbrew/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh
source $HOME/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  

# VMIE SSH Identities
source $HOME/.ssh/vmie.zsh

unalias run-help
autoload run-help
HELPDIR=$HOME/.linuxbrew/share/zsh/help

######################################################
#fpath+=( $HOME/.linuxbrew/share/zsh-navigation-tools )
#fpath=($HOME/.linuxbrew/share/zsh-completions $fpath)

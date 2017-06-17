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
alias ls='ls --color=auto'

## Setup LinuxBrew
export MANPATH="$(brew --prefix)/share/man:$MANPATH"
export INFOPATH="$(brew --prefix)/share/info:$INFOPATH"

# Brew and Pip aliases
#alias brewski='brew update && brew upgrade --all && brew cask list | xargs brew cleanup; brew cask cleanup; brew doctor'
alias pipu='pip freeze --local | grep -v \'\^\-\e' | cut -d = -f 1  | xargs -n1 pip install -U'

# Fancy ZSH Tools
source /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/linuxbrew/.linuxbrew/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh
source /home/linuxbrew/.linuxbrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# VMIE SSH Identities
# source $HOME/.ssh/vmie.zsh

#unalias run-help
#autoload run-help
#HELPDIR=$HOME/.linuxbrew/share/zsh/help

######################################################
fpath=(/home/linuxbrew/.linuxbrew/share/zsh-completions $fpath)

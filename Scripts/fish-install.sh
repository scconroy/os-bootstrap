##### Script to setup LinuxBrew and fish shell on linux ##### 

cd ~

sudo apt-get install build-essential ncurses-dev libncurses5-dev curl gettext bc autoconf git python ruby -y 
sudo yum groupinstall "Development Tools" -y
sudo yum install ncurses-devel curl -y

echo '### Custom exports for LinuxBrew ###' >> ~/.bashrc
echo 'export PATH="$HOME/.linuxbrew/bin:$PATH"' >> ~/.bashrc
echo 'export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"' >> ~/.bashrc
echo 'export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"' >> ~/.bashrc
echo 'export HOMEBREW_BUILD_FROM_SOURCE=1' >> ~/.bashrc
source ~/.bashrc

##### Installs LinuxBrew and installs required packages ##### 

echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/linuxbrew/go/install)"

brew doctor
brew update
brew install coreutils binutils fish zsh htop homebrew/dupes/nano
brew cleanup

##### Adding fish and ZSH shells to shells #####
echo $(which fish) | sudo tee -a /etc/shells
echo $(which zsh) | sudo tee -a /etc/shells

##### Adding nanorc to config #####
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

##### ZSH Completions #####
brew install zsh-autosuggestions zsh-history-substring-search zsh-navigation-tools zshdb zsh-completions zsh-lovers zsh-syntax-highlighting

##### Adding ZSH completions to path #####
source $HOME/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath+=( $HOME/.linuxbrew/share/zsh-navigation-tools )
source $HOME/.linuxbrew/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh
fpath=($HOME/.linuxbrew/share/zsh-completions $fpath)
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$HOME/.linuxbrew/share/zsh-syntax-highlighting/highlighters

# Rebuild the z cache
rm -f ~/.zcompdump; compinit
# source ~/.zshrc

##### Installing prezto #####
zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

##################
echo "
#
# Sets Prezto options.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# General
#

# Set case-sensitivity for completion, history lookup, etc.
# zstyle ':prezto:*:*' case-sensitive 'yes'

# Color output (auto set to 'no' on dumb terminals).
zstyle ':prezto:*:*' color 'yes'

# Set the Zsh modules to load (man zshmodules).
# zstyle ':prezto:load' zmodule 'attr' 'stat'

# Set the Zsh functions to load (man zshcontrib).
# zstyle ':prezto:load' zfunction 'zargs' 'zmv'

# Set the Prezto modules to load (browse modules).
# The order matters.
zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'directory' \
  'spectrum' \
  'utility' \
  'ssh' \
  'completion' \
  'homebrew' \
  'osx' \
  'ruby' \
  'rails' \
  'git' \
  'python' \
  'rsync' \
  'spectrum' \
  'screen' \
  'gpg' \
  'gnu-utility' \
  'utility' \
  'syntax-highlighting' \
  'history-substring-search' \
  'prompt' \

#
# Editor
#

# Set the key mapping style to 'emacs' or 'vi'.
zstyle ':prezto:module:editor' key-bindings 'emacs'

# Auto convert .... to ../..
# zstyle ':prezto:module:editor' dot-expansion 'yes'

#
# Git
#

# Ignore submodules when they are 'dirty', 'untracked', 'all', or 'none'.
# zstyle ':prezto:module:git:status:ignore' submodules 'all'

#
# GNU Utility
#

# Set the command prefix on non-GNU systems.
# zstyle ':prezto:module:gnu-utility' prefix 'g'

#
# History Substring Search
#

# Set the query found color.
# zstyle ':prezto:module:history-substring-search:color' found ''

# Set the query not found color.
# zstyle ':prezto:module:history-substring-search:color' not-found ''

# Set the search globbing flags.
# zstyle ':prezto:module:history-substring-search' globbing-flags ''

#
# Pacman
#

# Set the Pacman frontend.
# zstyle ':prezto:module:pacman' frontend 'yaourt'

#
# Prompt
#

# Set the prompt theme to load.
# Setting it to 'random' loads a random theme.
# Auto set to 'off' on dumb terminals.
zstyle ':prezto:module:prompt' theme 'sorin'

#
# Ruby
#

# Auto switch the Ruby version on directory change.
# zstyle ':prezto:module:ruby:chruby' auto-switch 'yes'

#
# Screen
#

# Auto start a session when Zsh is launched in a local terminal.
# zstyle ':prezto:module:screen:auto-start' local 'yes'

# Auto start a session when Zsh is launched in a SSH connection.
# zstyle ':prezto:module:screen:auto-start' remote 'yes'

#
# SSH
#

# Set the SSH identities to load into the agent.
# zstyle ':prezto:module:ssh:load' identities 'id_rsa' 'id_rsa2' 'id_github'

#
# Syntax Highlighting
#

# Set syntax highlighters.
# By default, only the main highlighter is enabled.
# zstyle ':prezto:module:syntax-highlighting' highlighters \
#   'main' \
#   'brackets' \
#   'pattern' \
#   'cursor' \
#   'root'
#
# Set syntax highlighting styles.
# zstyle ':prezto:module:syntax-highlighting' styles \
#   'builtin' 'bg=blue' \
#   'command' 'bg=blue' \
#   'function' 'bg=blue'

#
# Terminal
#

# Auto set the tab and window titles.
# zstyle ':prezto:module:terminal' auto-title 'yes'

# Set the window title format.
# zstyle ':prezto:module:terminal:window-title' format '%n@%m: %s'

# Set the tab title format.
# zstyle ':prezto:module:terminal:tab-title' format '%m: %s'

#
# Tmux
#

# Auto start a session when Zsh is launched in a local terminal.
# zstyle ':prezto:module:tmux:auto-start' local 'yes'

# Auto start a session when Zsh is launched in a SSH connection.
# zstyle ':prezto:module:tmux:auto-start' remote 'yes'

# Integrate with iTerm2.
# zstyle ':prezto:module:tmux:iterm' integrate 'yes'
" > ~/.zpreztorc

##### Incase glibc install fails #####
echo "
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
export ANDROID_HOME=/usr/local/opt/android-sdk
#/usr/local/etc/bash_completion.d

eval "$(thefuck --alias)"

export PATH=$PATH:/usr/local/opt/go/libexec/bin
export GOPATH=$HOME/work/go
export PATH=$PATH:$GOPATH/bin

alias brewski='brew update && brew upgrade --all && brew cask list | xargs brew cleanup; brew cask cleanup; brew doctor'
alias pipu='pip freeze --local | grep -v \'\^\-\e' | cut -d = -f 1  | xargs -n1 pip install -U'
" > ~/.zshrc

##### Incase glibc install fails #####
#/bin/rm -rf ~/.linuxbrew/Cellar/glibc

##### Compiling MTR from git HEAD and installing it #####
git clone https://github.com/traviscross/mtr.git
cd mtr
./bootstrap.sh
./configure --without-gtk
make
sudo make install
cd .. 
rm -rf mtr/

##### Changing to fish shell #####
sudo chsh -s $(which fish) $USER

##### Creating directories for fish shell #####
mkdir -p ~/.config/fish/functions/

##### Adding custom functions to fish shell #####
echo '
function dl --description "Parallel and resumable download with aria2c"
    aria2c -c -x 4 $argv[1]
end
' > ~/.config/fish/functions/dl.fish

##### Adding custom functions to fish shell for !! #####
echo '
function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end
' > ~/.config/fish/functions/sudo.fish

##### Adding variables and paths in fish shell #####

echo '
Now run these lazy boyyy......

set -U fish_user_paths ~/.linuxbrew/bin/ $fish_user_paths
set -U fish_user_paths ~/.linuxbrew/sbin/ $fish_user_paths
set -U fish_user_paths ~/.linuxbrew/opt/ $fish_user_paths
set -U fish_user_paths ~/.linuxbrew/share/man/ $fish_user_paths
set -U fish_user_paths ~/.linuxbrew/share/info/ $fish_user_paths
set -U HOMEBREW_BUILD_FROM_SOURCE 1

curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
fisher simple z fzf edc/bass omf/tab
fisher omf/plugin-brew
fisher omf/theme-l
'

echo "Now starting fish shell..."
fish

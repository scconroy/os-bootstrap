#!/bin/bash

##### Make sure only non-root user is running the script #####
if [ "$(id -u)" == "0" ]; then
   echo "This script must NOT be run as root. Please run as normal user" 1>&2
   exit 1
fi

##### Configuring Basepath and Repo #####
base_path="https://raw.githubusercontent.com/1ne/os-bootstrap/master"

##### Installing Brew #####
echo | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

##### Installing the Shells and Plugins #####
brew install git wget axel curl coreutils binutils
pkill -f firefox
brew cask install firefox --force
brew cask install iterm2 google-chrome keka flycut visual-studio-code atom
brew install bash fish zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-lovers zsh-navigation-tools zsh-syntax-highlighting brew-cask-completion

##### Adding Shells to list #####
echo '/usr/local/bin/bash' | sudo tee -a /etc/shells
echo '/usr/local/bin/zsh'  | sudo tee -a /etc/shells
echo '/usr/local/bin/fish' | sudo tee -a /etc/shells

##### Making ZSH the deafult Shell #####
sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
dscl . -read /Users/$USER UserShell

##### Adding nanorc to config #####
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

##### Installing prezto #####
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
touch ~/.zshrc
/usr/local/bin/zsh -i -c 'setopt EXTENDED_GLOB && for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"; done'
curl $base_path/conf/mac/zshrc -o ~/.zshrc
curl $base_path/conf/zpreztorc -o ~/.zpreztorc

##### Downloading Custom Utils #####
curl $base_path/assets/curl-format -o ~/curl-format
sudo curl $base_path/assets/ls-instances -o /usr/local/bin/ls-instances
sudo chmod 777 /usr/local/bin/ls-instances
sudo curl $base_path/assets/ls-instances-all -o /usr/local/bin/ls-instances-all
sudo chmod 777 /usr/local/bin/ls-instances-all
sudo curl $base_path/assets/ciphers-test -o /usr/local/bin/ciphers-test
sudo chmod 777 /usr/local/bin/ciphers-test

##### Installing Amazon Tools #####
brew cask install amazon-chime amazon-workspaces
#brew cask install amazon-workdocs

##### Uncomment if you need these #####
#brew cask install atext typora microsoft-remote-desktop-beta applepi-baker marshallofsound-google-play-music-player caskroom/drivers/logitech-options caskroom/versions/sublime-text-dev
brew cask install typora microsoft-remote-desktop-beta quip

##### Downloading the next Script #####
curl $base_path/scripts/mac/brew-install-mac.sh -o ~/brew-install.sh
chmod +x ~/brew-install.sh

##### Print Additonal ToDo Stuff #####
cat << EOF
####################################################
The shell will close and kick you out. Please open iTerm2 and run the following
time ./brew-install.sh
####################################################
EOF

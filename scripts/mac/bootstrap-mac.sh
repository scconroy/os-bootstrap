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

##### Installing the Browsers, Editors and Apps #####
killall 'firefox'
brew cask install firefox --force
killall 'Google Chrome'
brew cask install google-chrome --force
brew cask install iterm2
brew cask install keka
brew cask install flycut
brew cask install visual-studio-code
brew cask install atom
brew cask install cakebrew

##### Installing the Shells and Plugins #####
brew install coreutils binutils
brew install git 
brew install wget axel curl
brew install bash fish zsh 
brew install zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-navigation-tools zsh-syntax-highlighting

##### Adding Shells to list #####
echo '/usr/local/bin/bash' | sudo tee -a /etc/shells
echo '/usr/local/bin/zsh'  | sudo tee -a /etc/shells
echo '/usr/local/bin/fish' | sudo tee -a /etc/shells

##### Making ZSH the default Shell #####
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
brew cask install amazon-chime
brew cask install amazon-workspaces
#brew cask install amazon-workdocs

##### Uncomment if you need these #####
#brew cask install atext applepi-baker marshallofsound-google-play-music-player 
#brew cask install caskroom/drivers/logitech-options
#brew cask install caskroom/versions/sublime-text-dev
#brew cask install suspicious-package
#brew cask install appcleaner
brew cask install typora 
brew cask install quip
brew cask install microsoft-remote-desktop-beta

##### Downloading the next Script #####
curl $base_path/scripts/mac/brew-install-mac.sh -o ~/brew-install.sh
chmod +x ~/brew-install.sh

##### Print Additional ToDo Stuff #####
cat << EOF
####################################################
The shell will close and kick you out. Please open iTerm2 and run the following
time ./brew-install.sh
####################################################
EOF

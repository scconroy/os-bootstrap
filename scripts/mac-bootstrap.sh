#!/bin/bash

##### Make sure only non-root user is running the script #####
if [ "$(id -u)" == "0" ]; then
   echo "This script must NOT be run as root. Please run as normal user" 1>&2
   exit 1
fi

##### Configuring Basepath and Repo #####
base_path="https://raw.githubusercontent.com/1ne/os-bootstrap/master"

##### Installing Brew #####
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

##### Installing the Shells and Plugins #####
brew install git wget
brew install bash fish zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-lovers zsh-navigation-tools zsh-syntax-highlighting 

##### Adding Shells to list #####
echo '/usr/local/bin/bash' | sudo tee -a /etc/shells
echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells
echo '/usr/local/bin/fish' | sudo tee -a /etc/shells

##### Adding nanorc to config #####
#curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

##### Installing prezto #####
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
touch ~/.zshrc
/usr/local/bin/zsh -i -c 'setopt EXTENDED_GLOB && for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"; done'
wget $base_path/conf/mac/zshrc -q -O ~/.zshrc
wget $base_path/conf/zpreztorc -q -O ~/.zpreztorc

##### Downloading the next Script #####
#wget $base_path/scripts/brew-install.sh -q
#chmod +x brew-install.sh

##### Downloading Custom Utils #####
wget $base_path/assets/curl-format -q -O ~/curl-format
sudo wget $base_path/assets/ls-instances -q -O /usr/local/bin/ls-instances
sudo chmod 777 /usr/local/bin/ls-instances
sudo wget $base_path/assets/ls-instances-all -q -O /usr/local/bin/ls-instances-all
sudo chmod 777 /usr/local/bin/ls-instances-all
sudo wget $base_path/assets/ciphers-test -q -O /usr/local/bin/ciphers-test
sudo chmod 777 /usr/local/bin/ciphers-test

##### Print Additonal ToDo Stuff #####
#cat << EOF
####################################################
#The instance will reboot and kick you out. Please login back and run the following command
#time ./brew-install.sh
####################################################
#EOF

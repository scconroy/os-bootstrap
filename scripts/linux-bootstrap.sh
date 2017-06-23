#!/bin/bash

sudo yum update -y
sudo yum groupinstall -y 'Development Tools' && sudo yum install -y curl file git irb python-setuptools ruby mlocate golang awslogs

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"' >>~/.bash_profile
source ~/.bash_profile

brew tap linuxbrew/extra
brew install libpcap

brew install bash fish zsh zsh-autosuggestions zsh-completions zshdb zsh-history-substring-search zsh-lovers zsh-navigation-tools zsh-syntax-highlighting

sudo echo '/home/linuxbrew/.linuxbrew/bin/bash'>> /etc/shells
sudo echo '/home/linuxbrew/.linuxbrew/bin/zsh'>> /etc/shells
sudo echo '/home/linuxbrew/.linuxbrew/bin/fish'>> /etc/shells

#chsh -s /usr/local/bin/bash $USER
sudo chsh -s /home/linuxbrew/.linuxbrew/bin/zsh $USER
#chsh -s /usr/local/bin/fish $USER
chmod go-w '/home/linuxbrew/.linuxbrew/share'

##### Adding nanorc to config #####
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

##### Installing prezto #####
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
touch ~/.zshrc
/home/linuxbrew/.linuxbrew/bin/zsh -i -c 'setopt EXTENDED_GLOB && for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"; done'
wget https://raw.githubusercontent.com/1ne/bootstrap/master/conf/linux/.zshrc -q -O ~/.zshrc
wget https://raw.githubusercontent.com/1ne/bootstrap/master/conf/.zpreztorc -q -O ~/.zpreztorc

##### Downloading Custom Stuff #####
wget https://raw.githubusercontent.com/1ne/bootstrap/master/scripts/curl-format -q -O ~/curl-format

wget https://raw.githubusercontent.com/1ne/bootstrap/master/scripts/brew-install.sh -q
chmod +x brew-install.sh

cat << EOF
####################################################
Edit the sudoers file and replace the line.
sudo visudo
Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin
####################################################
Logout and log back in
vim ~/.config/znt/n-list.conf
local border=1
####################################################
Now run the following command
./brew-install.sh
####################################################
EOF

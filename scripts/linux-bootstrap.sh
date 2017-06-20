#!/bin/bash

sudo yum update -y
sudo yum groupinstall -y 'Development Tools' && sudo yum install -y curl file git irb python-setuptools ruby mlocate

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

cat << EOF
Run the following commands

zsh | q
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

Edit the sudoers file and replace the line.

sudo visudo
Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin

vim ~/.config/znt/n-list.conf
local border=1

EOF

wget https://raw.githubusercontent.com/1ne/bootstrap/master/conf/linux/.zshrc -O ~/.zshrc
wget https://raw.githubusercontent.com/1ne/bootstrap/master/conf/.zpreztorc -O ~/.zpreztorc

wget https://raw.githubusercontent.com/1ne/bootstrap/master/scripts/brew-install.sh
chmod +x brew-install.sh

cat << EOF
Now run the following command
./brew-install.sh

EOF

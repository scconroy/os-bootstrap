#!/bin/bash

##### Configuring Basepath and Repo #####
base_path="https://raw.githubusercontent.com/1ne/os-bootstrap/master/"

##### Updating the System #####
sudo yum update -y
sudo yum groupinstall -y 'Development Tools' && sudo yum install -y curl file git irb python-setuptools ruby mlocate golang awslogs

##### Enabling AWSLogs #####
sudo chkconfig awslogs on
sudo service awslogs start
sudo service awslogs status

##### Installing SSM Agent #####
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo start amazon-ssm-agent
sudo status amazon-ssm-agent

##### Installing LinuxBrew #####
echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"' >>~/.bash_profile
source ~/.bash_profile
chmod go-w '/home/linuxbrew/.linuxbrew/share'

##### Tapping Brew Extras #####
brew tap linuxbrew/extra
brew install libpcap

##### Installing the Shells and Plugins #####
brew install bash fish zsh zsh-autosuggestions zsh-completions zshdb zsh-history-substring-search zsh-lovers zsh-navigation-tools zsh-syntax-highlighting

##### Adding Shells to list #####
sudo echo '/home/linuxbrew/.linuxbrew/bin/bash'>> /etc/shells
sudo echo '/home/linuxbrew/.linuxbrew/bin/zsh'>> /etc/shells
sudo echo '/home/linuxbrew/.linuxbrew/bin/fish'>> /etc/shells

##### Chainging User Shells #####
#chsh -s /usr/local/bin/bash $USER
sudo chsh -s /home/linuxbrew/.linuxbrew/bin/zsh $USER
#chsh -s /usr/local/bin/fish $USER

##### Adding nanorc to config #####
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

##### Installing prezto #####
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
touch ~/.zshrc
/home/linuxbrew/.linuxbrew/bin/zsh -i -c 'setopt EXTENDED_GLOB && for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"; done'
wget $base_path/conf/linux/zshrc -q -O ~/.zshrc
wget $base_path/conf/zpreztorc -q -O ~/.zpreztorc

##### Downloading the next Script #####
wget $base_path/assets/curl-format -q -O ~/curl-format
wget $base_path/scripts/brew-install.sh -q
chmod +x brew-install.sh

##### Downloading Custom Utils #####
sudo wget $base_path/assets/ls-instances -q -O /usr/bin/ls-instances
sudo chmod 777 /usr/bin/ls-instances
sudo wget $base_path/assets/ls-instances-all -q -O /usr/bin/ls-instances-all
sudo chmod 777 /usr/bin/ls-instances-all
sudo wget $base_path/assets/ciphers-test -q -O /usr/bin/ciphers-test
sudo chmod 777 /usr/bin/ciphers-test
sudo wget $base_path/assets/clone-instance -q -O /usr/bin/clone-instance
sudo chmod 777 /usr/bin/clone-instance

##### Print Additonal ToDo Stuff #####
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

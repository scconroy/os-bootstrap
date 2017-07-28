#!/bin/bash

##### Make sure only non-root user is running the script #####
if [ "$(id -u)" == "0" ]; then
   echo "This script must NOT be run as root. Please run as normal user" 1>&2
   exit 1
fi

##### Configuring Basepath and Repo #####
base_path="https://raw.githubusercontent.com/1ne/os-bootstrap/master"

##### Defining the Confirm function #####
confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure you want set Hostname to $hostname? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

##### Setting Hostname to Amazon #####
read -p "Enter your Hostname (Press enter for ubuntu): " hostname
hostname=${hostname:-ubuntu}
sudo hostnamectl set-hostname $hostname

##### Updating the System #####
sudo apt update
sudo apt upgrade
sudo apt install build-essential jq curl ruby file mlocate golang git irb python-setuptools ruby -y

##### Enabling AWSLogs #####
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -c -r .region)
curl https://s3.amazonaws.com//aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
sudo python ./awslogs-agent-setup.py --region $region

##### Installing SSM Agent #####	
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
rm -f amazon-ssm-agent.deb

##### Installing LinuxBrew #####
echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"' >>~/.bash_profile
source ~/.bash_profile
chmod go-w '/home/linuxbrew/.linuxbrew/share'

##### Tapping Brew Extras #####
brew tap linuxbrew/extra

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

##### Setting Brew Path #####
sudo wget $base_path/assets/brew-path -q -O /etc/sudoers.d/brew-path
sudo chmod 440 /etc/sudoers.d/brew-path

##### Giving user SuperPowers #####
cat << EOF
####################################################
Setting the Open file limits on the Box
####################################################
EOF
echo 'fs.file-max = 256000' | sudo tee /etc/sysctl.d/60-file-max.conf
echo '* soft nofile 256000' | sudo tee /etc/security/limits.d/60-nofile-limit.conf
echo '* hard nofile 256000' | sudo tee -a /etc/security/limits.d/60-nofile-limit.conf
echo 'root soft nofile 256000' | sudo tee -a /etc/security/limits.d/60-nofile-limit.conf
echo 'root hard nofile 256000' | sudo tee -a /etc/security/limits.d/60-nofile-limit.conf

##### Print Additonal ToDo Stuff #####
cat << EOF
####################################################
The instance will reboot and kick you out. Please login back and run the following command
time ./brew-install.sh
####################################################
EOF

##### Rebooting Box #####
sudo reboot

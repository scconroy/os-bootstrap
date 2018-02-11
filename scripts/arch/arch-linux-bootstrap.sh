#!/bin/bash

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

##### Creating a non-privleged user #####
read -p "Enter your Username (Press enter for ec2-user): " user_name
user_name=${user_name:-ec2-user}
groupadd -g 1000 $user_name
useradd -u 1000 -g 1000 $user_name
usermod -a -G wheel $user_name
mkdir -p /home/$user_name
chown -R $user_name:$user_name /home/$user_name
chmod -R 700 /home/$user_name
echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/sudo

##### Creating a non-privleged user #####
cp -r /root/.ssh/ /home/$user_name/
chown -R $user_name:$user_name /home/$user_name/
rm -rf /root/.ssh/

sudo passwd -d $user_name

##### Setting Hostname to Amazon #####
read -p "Enter your Hostname (Press enter for arch): " hostname
hostname=${hostname:-arch}
sudo hostnamectl set-hostname --static $hostname

##### Updating the System #####
pacman -Syyu --noconfirm
pacman -S base-devel
pacman -S yaourt --noconfirm

yaourt -S curl wget file git irb python-setuptools ruby mlocate awslogs wireshark-cli --noconfirm 
sudo usermod -a -G wireshark $user_name

##### Enabling AWSLogs #####
sudo systemctl enable awslogsd
sudo systemctl start  awslogsd
sudo systemctl status awslogsd

##### Enabling SSM Agent #####
sudo systemctl enable amazon-ssm-agent
sudo systemctl start  amazon-ssm-agent
sudo systemctl status amazon-ssm-agent

##### Installing atop #####
sudo rpm -ivh https://www.atoptool.nl/download/atop-2.3.0-1.el7.x86_64.rpm
sudo systemctl enable atop
sudo systemctl start  atop
sudo systemctl status atop

##### Installing Sysdig Monitoring Tools #####
sudo rpm --import https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public
sudo curl -s -o /etc/yum.repos.d/draios.repo http://download.draios.com/stable/rpm/draios.repo
sudo rpm -i https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

sudo yum -y install kernel-devel-$(uname -r)
sudo yum -y install sysdig
sudo yum update -y

##### Prep for LinuxBrew #####
password=`openssl rand -base64 37 | cut -c1-20`
echo "$USER:$password" | sudo chpasswd

##### Installing LinuxBrew #####
echo  -e "\033[33;5mEnter the Password\033[0m: $password"
echo | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

##### Removing password for the user #####
sudo passwd -d `whoami`

##### Export LinuxBrew Path #####
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"' >>~/.bash_profile
source ~/.bash_profile
chmod go-w '/home/linuxbrew/.linuxbrew/share'

##### Tapping Brew Extras and Installing libpcap first as its a dependency for other Utilities #####
brew tap linuxbrew/extra
brew install libpcap

##### Installing the Shells and Plugins #####
brew install go bash fish zsh zsh-autosuggestions zsh-completions zshdb zsh-history-substring-search zsh-lovers zsh-navigation-tools zsh-syntax-highlighting

##### Adding Shells to list #####
echo '/home/linuxbrew/.linuxbrew/bin/bash' | sudo tee -a /etc/shells
echo '/home/linuxbrew/.linuxbrew/bin/zsh'  | sudo tee -a /etc/shells
echo '/home/linuxbrew/.linuxbrew/bin/fish' | sudo tee -a /etc/shells

##### Changing User Shells #####
sudo chsh -s /home/linuxbrew/.linuxbrew/bin/zsh $USER
#sudo chsh -s /usr/local/bin/bash $USER
#sudo chsh -s /usr/local/bin/fish $USER

##### Adding nanorc to config #####
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

##### Installing prezto #####
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
touch ~/.zshrc
/home/linuxbrew/.linuxbrew/bin/zsh -i -c 'setopt EXTENDED_GLOB && for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"; done'
wget $base_path/conf/linux/zshrc -q -O ~/.zshrc
wget $base_path/conf/zpreztorc -q -O ~/.zpreztorc

##### Downloading Custom Utils #####
sudo wget $base_path/assets/ls-instances -q -O /usr/bin/ls-instances
sudo chmod 777 /usr/bin/ls-instances
sudo wget $base_path/assets/ls-instances-all -q -O /usr/bin/ls-instances-all
sudo chmod 777 /usr/bin/ls-instances-all
sudo wget $base_path/assets/ciphers-test -q -O /usr/bin/ciphers-test
sudo chmod 777 /usr/bin/ciphers-test
sudo wget $base_path/assets/clone-instance -q -O /usr/bin/clone-instance
sudo chmod 777 /usr/bin/clone-instance
wget $base_path/assets/curl-format -q -O ~/curl-format

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

##### Downloading the next Script #####
wget $base_path/scripts/amzn/brew-install.sh -q -O ~/brew-install.sh
chmod +x ~/brew-install.sh

##### Print Additonal ToDo Stuff #####
cat << EOF
####################################################
The instance will reboot and kick you out. Please login back and run the following command
time ./brew-install.sh
####################################################
EOF

##### Rebooting Box #####
sudo reboot

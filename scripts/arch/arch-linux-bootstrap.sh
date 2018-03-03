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

##### Configuring Yaourt #####
cp /etc/yaourtrc ~/.yaourtrc
BUILD_NOCONFIRM=1 >> ~/.yaourtrc
EDITFILES=0 >> ~/.yaourtrc

##### Installing Arch Stuff #####
yaourt -S curl wget file git python-setuptools ruby mlocate awslogs wireshark-cli --noconfirm 
sudo usermod -a -G wireshark $USER

##### Installing atop #####
yaourt -S atop --noconfirm
sudo systemctl enable atop
sudo systemctl start  atop
sudo systemctl status atop

##### Installing Sysdig Monitoring Tools #####
yaourt -S sysdig --noconfirm

##### Installing LinuxBrew #####
echo | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

##### Removing password for the user #####
sudo passwd -d `whoami`

##### Export LinuxBrew Path #####
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"' >>~/.bash_profile
source ~/.bash_profile
chmod go-w '/home/linuxbrew/.linuxbrew/share'

##### Installing the Shells and Plugins #####
yaourt -S wget go bash fish zsh zsh-autosuggestions zsh-completions zshdb zsh-history-substring-search zsh-navigation-tools zsh-syntax-highlighting --noconfirm

##### Changing User Shells #####
sudo chsh -s /usr/bin/zsh $USER
#sudo chsh -s /usr/bin/bash $USER
#sudo chsh -s /usr/bin/fish $USER

##### Adding nanorc to config #####
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

##### Installing prezto #####
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
touch ~/.zshrc
/usr/bin/zsh -i -c 'setopt EXTENDED_GLOB && for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"; done'
wget $base_path/conf/linux/zshrc-arch -q -O ~/.zshrc
wget $base_path/conf/zpreztorc -q -O ~/.zpreztorc

##### Downloading Custom Utils #####
sudo curl $base_path/assets/ls-instances -o /usr/bin/ls-instances
sudo chmod 777 /usr/bin/ls-instances
sudo curl $base_path/assets/ls-instances-all -o /usr/bin/ls-instances-all
sudo chmod 777 /usr/bin/ls-instances-all
sudo curl $base_path/assets/ciphers-test -o /usr/bin/ciphers-test
sudo chmod 777 /usr/bin/ciphers-test
sudo curl $base_path/assets/clone-instance -o /usr/bin/clone-instance
sudo chmod 777 /usr/bin/clone-instance
wget $base_path/assets/curl-format -o ~/curl-format

##### Setting Brew Path #####
sudo curl $base_path/assets/brew-path -o /etc/sudoers.d/brew-path
sudo chmod 440 /etc/sudoers.d/brew-path

##### Giving user SuperPowers #####
cat << EOF
####################################################
Setting the Open file limits on the Box
####################################################
EOF
echo 'fs.file-max = 256000' | sudo tee /etc/sysctl.d/60-file-max.conf
echo '* soft nofile 256000' | sudo tee /etc/security/limits.d/60-nofile-limit.conf
echo '* hard nofile 256000' | sudo tee /etc/security/limits.d/60-nofile-limit.conf
echo 'root soft nofile 256000' | sudo tee /etc/security/limits.d/60-nofile-limit.conf
echo 'root hard nofile 256000' | sudo tee /etc/security/limits.d/60-nofile-limit.conf

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

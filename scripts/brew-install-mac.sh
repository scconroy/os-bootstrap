#!/bin/bash

##### Make sure only non-root user is running the script #####
if [ "$(id -u)" == "0" ]; then
   echo "This script must NOT be run as root. Please run as normal user" 1>&2
   exit 1
fi

##### Configuring Basepath and Repo #####
base_path="https://raw.githubusercontent.com/1ne/os-bootstrap/master"

##### Configuring ZSH Reverse Search #####
sed -i -e "s/local border=0/local border=1/g" ~/.config/znt/n-list.conf

########## Installing Utilities #########

##### Configuring toprc and htoprc #####
#mkdir -p ~/.config/htop/
#wget $base_path/assets/htoprc -q -O ~/.config/htop/htoprc
#chmod 644 ~/.config/htop/htoprc

##### Installing libpcap first as its a dependency for other Utilities ####
brew install libpcap

##### Installing AWS Utilities ####
brew install python python3 ruby pip-completion brew-pip 
sudo pip3 install --upgrade awscli aws-shell awsebcli awslogs s3cmd

##### Configuring AWS CLI Config #####
mkdir ~/.aws
wget $base_path/assets/aws-config -q -O ~/.aws/config

##### Installing OS Utilities ####
brew install htop
brew install binutils coreutils valgrind gawk nano jq findutils ddate pv peco
brew install openssh libssh2 sshrc openssl rsync screen unzip bzip2 xz ddar p7zip

##### Installing Network Utilities ####
brew install tcpdump tcpstat jnettop mtr tcptraceroute netcat nmap iperf3 whois arping fping liboping httpstat ipv6calc

##### Installing cURL with HTTP/2 Support ####
brew reinstall curl --with-c-ares  --with-libmetalink --with-libssh2 --with-nghttp2 --with-rtmpdump

##### Installing Monitoring Tools #####
pip3 install glances

##### Installing Amazon Tools #####
brew cask install amazon-chime amazon-workdocs amazon-workspaces

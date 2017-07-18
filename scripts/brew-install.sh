#!/bin/bash

##### Configuring Basepath and Repo #####
base_path="https://raw.githubusercontent.com/1ne/os-bootstrap/master"

##### Configuring ZSH Reverse Search #####
sed -i -e "s/local border=0/local border=1/g" ~/.config/znt/n-list.conf

########## Installing Utilities #########

##### Configuring toprc and htoprc #####
wget $base_path/assets/toprc -q -O ~/.toprc
mkdir -p ~/.config/htop/
wget $base_path/assets/htoprc -q -O ~/.config/htop/htoprc
chmod 644 ~/.config/htop/htoprc

root_home=$(eval echo "~root")

sudo wget $base_path/assets/toprc -q -O $root_home/.toprc
sudo mkdir -p $root_home/.config/htop/
sudo wget $base_path/assets/htoprc -q -O $root_home/.config/htop/htoprc
sudo chmod 644 $root_home/.config/htop/htoprc

##### Installing AWS Utilities ####
brew install python python3 ruby pip-completion brew-pip 
brew install awscli aws-shell s3cmd 

##### Installing OS Utilities ####
brew install htop procps sysstat 
brew install stress sysbench
brew install binutils coreutils strace curl wget gawk git nano jq findutils bsdmainutils libbsd valgrind pv
brew install openssh libssh2 sshrc openssl rsync screen ipbt unzip bzip2 xz
brew install redis

##### Installing Disk Utilities ####
brew install iotop ioping ncdu fio

##### Installing Network Utilities ####
brew install iftop tcpdump tcpstat nethogs ifstat dnstop jnettop mtr tcptraceroute netcat nmap iperf3
brew install arping fping liboping twoping httpstat ipv6calc ipv6toolkit ip_relay
brew install whois dns2tcp dnsmap dnsperf dnstracer dhcping  

##### Installing cURL with HTTP/2 Support ####
brew reinstall curl --with-c-ares  --with-libmetalink --with-libssh2 --with-nghttp2 --with-rtmpdump

##### Installing Monitoring Tools #####
pip install glances
sudo rpm -ivh https://www.atoptool.nl/download/atop-2.3.0-1.el6.x86_64.rpm

##### Installing Web-Benchmarking Tools #####
pip install beeswithmachineguns

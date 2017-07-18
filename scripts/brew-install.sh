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

##### Installing OS Utilities ####
brew install htop procps sysstat
brew install stress sysbench
brew install awscli aws-shell binutils coreutils curl wget bsdmainutils bzip2 findutils gawk git ipbt jq libbsd libssh2 mysql valgrind
brew install nano openssh openssl pv python python3 pip-completion brew-pip redis rsync ruby s3cmd screen sshrc strace unzip xz

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

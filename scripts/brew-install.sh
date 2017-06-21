#!/bin/bash

brew install awscli aws-shell binutils bzip2 coreutils curl wget findutils gawk git jq libbsd libssh2 mysql valgrind
brew install nano nmap openssh openssl pv python python3 pip-completion brew-pip redis rsync ruby sshrc strace unzip whois xz 

brew install bsdmainutils fping htop iftop iotop ioping procps sysstat tcpdump tcpstat twoping netcat ncdu
brew install arping dhcping dns2tcp dnsmap dnsperf dnstracer fio iperf3 liboping mtr stress sysbench tcptraceroute ipv6calc ipv6toolkit ipbt ip_relay

brew reinstall curl --with-c-ares  --with-libmetalink --with-libssh2 --with-nghttp2 --with-rtmpdump

sudo rpm -ivh https://www.atoptool.nl/download/atop-2.3.0-1.el6.x86_64.rpm
#go get -u github.com/rakyll/hey
pip install beeswithmachineguns

cat << EOF
##############################################################################################
vim ~/.config/znt/n-list.conf
local border=1
EOF

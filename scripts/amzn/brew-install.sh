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

##### Configuring toprc and htoprc for current User #####
wget $base_path/assets/toprc -q -O ~/.toprc
mkdir -p ~/.config/htop/
wget $base_path/assets/htoprc -q -O ~/.config/htop/htoprc
chmod 644 ~/.config/htop/htoprc

##### Configuring toprc and htoprc for root User #####
root_home=$(eval echo "~root")

sudo wget $base_path/assets/toprc -q -O $root_home/.toprc
sudo mkdir -p $root_home/.config/htop/
sudo wget $base_path/assets/htoprc -q -O $root_home/.config/htop/htoprc
sudo chmod 644 $root_home/.config/htop/htoprc

##### Installing Shiny new Python versions and AWS Utilities ####
brew install python python3 ruby
pip3 awscli aws-shell awsebcli awslogs s3cmd

##### Configuring AWS CLI Config #####
mkdir ~/.aws
wget $base_path/assets/aws-config -q -O ~/.aws/config

##### Configuring AWS CloudWatch Agent #####
instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
aws ssm send-command --document-name "AWS-ConfigureAWSPackage" --targets "Key=instanceids,Values=$instance_id" --parameters '{"action":["Install"],"version":["latest"],"name":["AmazonCloudWatchAgent"]}' --timeout-seconds 600 --max-concurrency "50" --max-errors "0" --region us-east-1

##### Setting up Linux Monintoring Scripts ####
sudo chown -R ec2-user:ec2-user /home/ec2-user/.cache/
pip3 install cloudwatchmon
(crontab -l 2>/dev/null; echo "* * * * * /home/linuxbrew/.linuxbrew/bin/mon-put-instance-stats.py --mem-util --mem-used --mem-avail --swap-util --swap-used --mem-used-incl-cache-buff --memory-units bytes --loadavg --loadavg-percpu --disk-path / --disk-space-util --disk-space-used --disk-space-avail --disk-space-units bytes --disk-inode-util --from-cron") | crontab -

##### Installing OS Utilities ####
brew install htop procps sysstat stress sysbench 
brew install binutils coreutils strace valgrind curl wget gawk git nano jq findutils ddate bsdmainutils libbsd pv peco
brew install openssh libssh2 sshrc openssl rsync screen ipbt unzip bzip2 xz ddar
brew install redis

##### Installing Disk Utilities ####
brew install iotop ioping ncdu fio dc3dd ddrescue iozone

##### Installing Network Utilities ####
brew install iftop tcpdump tcpstat nethogs ifstat dnstop jnettop mtr tcptraceroute netcat nmap iperf3
brew install arping fping liboping twoping httpstat ipv6calc ipv6toolkit ip_relay
brew install whois dns2tcp dnsmap dnsperf dnstracer dhcping

##### Installing cURL with HTTP/2 Support ####
brew reinstall curl --with-c-ares  --with-libmetalink --with-libssh2 --with-nghttp2 --with-rtmpdump

##### Installing Web-Benchmarking Tools #####
pip3 install six bottle
pip3 install https://github.com/newsapps/beeswithmachineguns/archive/master.zip
go get -u github.com/rakyll/hey
brew install vegeta

##### Other Web-Benchmarking Tools #####
# https://github.com/denji/awesome-http-benchmark
# https://github.com/davidsonfellipe/awesome-wpo
#!/bin/bash

##### Installing Sysdig Monitoring Tools #####
curl -s https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public | sudo apt-key add -  
curl -s -o /etc/apt/sources.list.d/draios.list https://s3.amazonaws.com/download.draios.com/stable/deb/draios.list  
sudo apt update
sudo apt -y install linux-headers-$(uname -r)
sudo apt -y install sysdig
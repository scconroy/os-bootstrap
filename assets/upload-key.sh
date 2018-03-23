#!/bin/bash

### Generate PublicKey (if required) ###
# ssh-keygen -t rsa -b 4096 -C `whoami` -f $HOME/.ssh/`whoami`.pem
# mv $HOME/.ssh/`whoami`.pem.pub $HOME/.ssh/`whoami`.pub 

pub_key_path=$1
if [ -z "$1" ]; then
    pub_key_path="$HOME/.ssh/authorized_keys"
fi

key_name=$2
if [ -z "$2" ]; then
    key_name="$(cat $pub_key_path | cut -f3 -d' ')"
fi

### Enumerate AWS Regions ###
regions=$(aws ec2 describe-regions --output text | cut -f 3)

while read line
do
    echo "For region: $line"
    aws ec2 import-key-pair --key-name $key_name --public-key-material file://$pub_key_path --region $line
done <<< "$regions"
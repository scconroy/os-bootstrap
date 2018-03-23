#!/bin/bash
$1="${$1:-~/.ssh/authorized_keys}"
regions=$(aws ec2 describe-regions --output text | cut -f 3)
while read line
do
    aws ec2 import-key-pair --key-name "$(cat $1 | cut -f3 -d' ')" --public-key-material "$(cat $1 | cut -f2 -d' ')" --region $line
done <<< "$regions"

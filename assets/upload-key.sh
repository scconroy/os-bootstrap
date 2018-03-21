#!/bin/bash
regions=$(aws ec2 describe-regions --output text | cut -f 3)
while read line
do
    aws ec2 import-key-pair --key-name $1 --public-key-material "$(cat $2)"
done <<< "$regions"

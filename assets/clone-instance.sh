#!/bin/bash

base_path="http://169.254.169.254/latest/meta-data"

iam_role=$(curl $base_path/iam/security-credentials/)
ami_id=$(curl $base_path/ami-id/)
availability_zone=$(curl $base_path/placement/availability-zone/)
instance_type=$(curl $base_path/instance-type/)
security_group=$(curl $base_path/network/interfaces/macs/$(curl $base_path/network/interfaces/macs/)security-group-ids)
subnet_id=$(curl $base_path/network/interfaces/macs/$(curl $base_path/network/interfaces/macs/)subnet-id/)
key_name=$(curl $base_path/public-keys/)
key_name=${key_name##*=}
ebs=$(curl $base_path/block-device-mapping/root/)
vol_size=$(lsblk  --output SIZE -n -d /dev/xvda)
vol_size=${vol_size:1:-1}
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)

#### AMI ID OverRide ####
#ami_id="ami-643b1972"

#### Get Latest Amazon Linux AMI ID ####
#ami_id=(aws ec2 describe-images --owners amazon --filters \
#    'Name=name,Values=amzn-ami-hvm-????.??.?.????????-x86_64-gp2' \
#    'Name=state,Values=available' \
#    'Name=architecture,Values=x86_64' \
#    'Name=virtualization-type,Values=hvm' \
#    'Name=root-device-type,Values=ebs' \
#  --query 'sort_by(Images, &CreationDate)[-1].ImageId')

#### Instance Type OverRide ####
#instance_type="t2.micro"

aws ec2 run-instances --iam-instance-profile Name=$iam_role --image-id $ami_id --count 1 --instance-type $instance_type --key-name $key_name --subnet-id $subnet_id --block-device-mappings "[ { \"DeviceName\": \"$ebs\", \"Ebs\": { \"VolumeSize\": $vol_size,  \"VolumeType\": \"gp2\", \"DeleteOnTermination\": true } } ]" --region $region

sleep 5
aws ec2 describe-instances --query 'Reservations[].Instances[].[ InstanceId,[Tags[?Key==`Name`].Value][0][0],PublicIpAddress,State.Name,InstanceType,Placement.AvailabilityZone ]' --output table --region $region "$@" 

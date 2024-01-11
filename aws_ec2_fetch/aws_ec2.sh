#!/bin/bash

set -x

# AUTHOR : Kshitij Patil
# Created : Jan 10, 2024
# Description : Bash script which will display a list of running aws instances. 


#Let us describe the instances 
today=$(date +"%Y-%m-%d")

aws ec2 describe-instances --output json | jq -r '.Reservations[].Instances[] | select(.State.Name == "running") | [.InstanceId, .State.Name, .LaunchTime, .InstanceType]' > ./report/${today}.txt 

{ set +x; } 2>/dev/null 

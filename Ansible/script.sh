#!/bin/bash

sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update -y
sudo apt install awscli git ansible -y 
aws s3 cp s3://ssh-key-frankfurt/terraform.pem ~/.ssh/
chmod 600 ~/.ssh/terraform.pem

git clone https://github.com/afshinpaydar/Terraform_Ansible_Demo.git
eval $(ssh-agent -s)
ssh-add ~/.ssh/terraform.pem

ansible-galaxy install undergreen.mongodb

echo  "eval $(ssh-agent -s)" >> ~/.bashrc
echo "ssh-add ~/.ssh/terraform.pem" >> ~/.bashrc 



#!/bin/bash

sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update -y
sudo apt install awscli git python-pip -y 
aws s3 cp s3://ssh-key-frankfurt/terraform.pem ~/.ssh/
chmod 600 ~/.ssh/afshingolang-production.pem

eval $(ssh-agent -s)
ssh-add ~/.ssh/afshingolang-production.pem

ansible-galaxy install undergreen.mongodb

echo  "eval $(ssh-agent -s)" >> ~/.bashrc
echo "ssh-add ~/.ssh/afshingolang-production.pem" >> ~/.bashrc 



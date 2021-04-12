#!/bin/bash

sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update -y
sudo apt install awscli git -y
aws s3 cp s3://ssh-key-frankfurt/afshingolang-production.pem ~/.ssh/
chmod 600 ~/.ssh/afshingolang-production.pem

eval $(ssh-agent -s)
ssh-add ~/.ssh/afshingolang-production.pem

git clone https://github.com/afshinpaydar/Terraform_Ansible_Demo.git
pip install -r Terraform_Ansible_Demo/Ansible/ansible-role-mongodb/requirements.txt

echo  "eval $(ssh-agent -s)" >> ~/.bashrc
echo "ssh-add ~/.ssh/afshingolang-production.pem" >> ~/.bashrc 



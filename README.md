# Frankfort Environment

![Terraform](_images/HomeLike_Diagram.png?raw=true "Terraform Diagram")

# Terraform Workspace Structure
A Terraform workspace is a collection of everything Terraform needs to run. a Terraform configuration, values for that configuration's variables, and state data to keep track of operations between runs. There are couple folders for each workspace to splits Terraform codes in different section:
1.DynamoDB
2.Network
3.Frankfurt_Environment

Terraform modules located in the `Frankfurt_Environment/modules` folder:
```
asg: auto scaling group
aws-lb: load balancer
instance: ec2
lc: launch configuration
sg_rule: security group rule
```

# Config AWS region and profile
In order to connect AWS with the proper user profile and configure the region, we need to edit `Frankfurt_Environment/config.tf` file:
```
variable "aws_region" {
  default = "us-east-1"
}

variable "aws_profile" {
  default = "demo-staging"
}
```

# Terraform state Management
In order to prevent interference of running multiple Terraform code in separate machines, we use Dynamodb  and S3 as a locking mechanism to save terraform-lock file. before setup terraform infrastructure we need to implement S3 and Dynamodb components:
```
$ git clone 
$ cd DynamoDB
$ terraform init
$ terraform apply
```
# Generate AWS Key pairs and add it to ssh-agent
1. Create new AWS key or import your own ssh key to AWS by following this (document](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
2. Change key name in Terraform code:
```
$ cd Terraform_Ansible_Demo
$ export AWS_KEY_NAME= <Name of Amazon EC2 key pairs>
MAC:
gsed -i 's/key_name                    = "afshingolang-production",/key_name                    = \"$AWS_KEY_NAME\",/g' ./*

Linux:
sed -i 's/key_name                    = "afshingolang-production",/key_name                    = \"$AWS_KEY_NAME\",/g' ./*
```
3. Add ssh key to ssh-agent:
```
ssh-add ~/.ssh/<ssh-keyname>.pem
```

# Setup Network Infra


# Setup Frankfurt Infra


### Tearing down
1. 
2. 
3.



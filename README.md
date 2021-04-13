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
named `terraform`
```
ssh-keygen -t rsa -m PEM
Generating public/private rsa key pair.
Enter file in which to save the key (~/.ssh/id_rsa): Frankfurt_Environment/.SSH_KEY/terraform.pem
```
2. Add ssh key to ssh-agent:
```
ssh-add Frankfurt_Environment/.SSH_KEY/terraform.pem
```
3. Upload private key to S3 bucket named `ssh-key-frankfurt`
4. Change name of your AWS profile in the `Frankfurt_Environment/variables.tf` and `../Frankfurt_Environment/frankfurt.tfvars` files:
```
variable "aws_profile" {
  default = "YOUR-AWS-PROFILE-NAME"
}
---
aws_profile = "YOUR-AWS-PROFILE-NAME"
```

# Setup Network Infra
```
$ cd Network
$ terraform init
$ terraform apply
```

# Setup Frankfurt Infra
```
$ cd Frankfurt_Environment
$ terraform apply
$ terraform apply -var-file=frankfurt.tfvars
```

### Tearing down
```
$ cd Frankfurt_Environment
$ terraform destroy
```

###  Ansible galaxy:
- https://github.com/UnderGreen/ansible-role-mongodb


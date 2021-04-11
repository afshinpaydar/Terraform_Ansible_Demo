# Frankfort Environment

![Terraform](_images/HomeLike_Diagram.png?raw=true "Terraform Diagram")

# Terraform Workspace Structure
A Terraform workspace is a collection of everything Terraform needs to run. a Terraform configuration, values for that configuration's variables, and state data to keep track of operations between runs. There are three folders for each workspace to splits Terraform codes in different section:
1.DynamoDB
2.Network
3.Frankfurt_Environment

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

### Setup
Edit AWS profile and region in the `config.tf` file.

1. Setup DynamoDB as a locking mechanism
2. Setup network infrastructure
3. Configuration values
4. Apply Terraform changes

### Tearing down
1. 
2. 
3.



terraform {
  required_version = ">= 0.13.0"
}

provider "aws" {
  profile = "afshingolang-production"
  region = var.region
}

variable "region" {
  default = "us-east-1"
}


# Terraform state file remote location
terraform {
  backend "s3" {
    bucket = "frankfurt-terraform"
    key    = "terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

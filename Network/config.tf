terraform {
  required_version = ">= 0.13.0"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}


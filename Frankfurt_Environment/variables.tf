variable "objects" {
  default = []
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_profile" {
  default = "afshingolang-production"
}

variable "private_key" {
  default = "./.SSH_KEY/terraform.pem"  
}

variable "default_tags" {
  default = {
    "Provisioner" = "terraform"
  }
}

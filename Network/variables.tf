variable "aws_region" {
  default = "us-east-1"
}

variable "aws_profile" {
  default = "afshingolang-production"
}

variable "default_tags" {
  default = {
    "Provisioner" = "terraform"
  }
}

variable "region" {
}

variable "default_tags" {
}

variable "private_key" {
}

variable "instance" {
  type = object({
    type                        = string
    category                    = string
    ami                         = string
    private_ip                  = list(string)
    instance_type               = string
    key_name                    = string
    monitoring                  = bool
    vpc_security_group_name     = list(string)
    count                       = number
    subnet_name                 = string
    associate_eip_address       = bool
    associate_public_ip_address = bool
    disable_api_termination     = bool #EC2 Instance Termination Protection
    ebs_optimized               = bool
    tags                        = map(string) # [tags]
    environment                 = string
    root_block_device = object({
      volume_type = string
      volume_size = number
    })
  })

  default = {
    type                        = "ec2",
    category                    = "",
    ami                         = "",
    private_ip                  = [],
    instance_type               = "",
    key_name                    = "",
    vpc_security_group_name     = [],
    monitoring                  = false,
    count                       = 0,
    subnet_name                 = "",
    associate_eip_address       = false,
    associate_public_ip_address = true,
    disable_api_termination     = false,
    ebs_optimized               = false,
    tags                        = {},
    environment                 = "frankfurt",
    root_block_device = {
      volume_type = "",
      volume_size = 0
    }
  }
}

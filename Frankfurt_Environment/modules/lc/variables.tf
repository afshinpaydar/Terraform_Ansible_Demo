variable "region" {
}

variable "default_tags" {
}

variable "instance" {
  type = object({
    type                        = string
    category                    = string
    name                        = string
    ami                         = string
    instance_type               = string
    key_name                    = string
    associate_public_ip_address = bool
    enable_monitoring           = bool
    security_groups             = list(string)
    environment                 = string
  })

  default = {
    type                        = "lc",
    category                    = "",
    name                        = "",
    ami                         = "",
    instance_type               = "",
    key_name                    = "",
    associate_public_ip_address = true,
    enable_monitoring           = true,
    security_groups             = [],
    environment                 = "",
  }

}
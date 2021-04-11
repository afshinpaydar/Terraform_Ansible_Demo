variable "region" {
}

variable "default_tags" {
}

variable "launch_configuration" {
}

variable "instance" {
  type = object({
    type                       = string
    category                   = string
    name                       = string
    vpc_zone_identifier        = list(string)
    min_size                   = number
    max_size                   = number
    timeout_delete             = string
    environment                = string
  })

  default = {
    type                       = "asg",
    category                   = "",
    name                       = "",
    vpc_zone_identifier        = [],
    min_size                   = 0,
    max_size                   = 0,
    timeout_delete             = "10m",
    environment                = "",
  }

}
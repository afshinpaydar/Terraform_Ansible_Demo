variable "region" {
}

variable "default_tags" {
}


variable "instance" {
  type = object({
    type                        = string
    category                    = string
    name                        = string
    ports                       = map(string)
    vpc_security_group_name     = list(string)
    internal                    = bool
    security_group              = string
    load_balancer_type          = string
    idle_timeout                = number
    tags                        = map(string)
    subnet_names                = list(string)
    environment                 = string
  })

  default = {
    type                        = "lb",
    category                    = "",
    name                        = "",
    ports                       = {}
    vpc_security_group_name     = [],
    internal                    = true,
    security_group              = "",
    load_balancer_type          = "application",
    idle_timeout                = 60,
    environment                 = "",
    tags                        = {},
    subnet_names                = [""],
  }

}
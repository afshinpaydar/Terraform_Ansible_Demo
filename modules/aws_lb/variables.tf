variable "region" {
}

variable "default_tags" {
}


variable "instance" {
  type = object({
    type                        = string
    category                    = string
    count                       = number
    name                        = string
    internal                    = bool
    security_groups             = list(string)
    load_balancer_type          = string
    idle_timeout                = number
    tags                        = map(string) # [tags]
    subnets                     = list(string)
    environment                 = string
  })

  default = {
    type                        = "lb",
    category                    = "",
    count                       = 0,
    name                        = "",
    internal                    = true,
    security_groups             = [],
    load_balancer_type          = "application",
    idle_timeout                = 60,
    environment                 = "",
    tags                        = {},
    subnets                     = [],
  }

}
variable "sg_rule" {
  type = list(object({
    type      = string
    name      = string
    vpc_name  = string
    from_port = number
    to_port   = number
    protocol  = string
    source    = list(string)
  }))

  default = [{
    type      = "sg",
    name      = "",
    vpc_name  = "",
    from_port = 0,
    to_port   = 0,
    protocol  = "",
    source    = []
  }]
}

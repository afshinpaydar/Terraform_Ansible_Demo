# Retrieve SG data
data "aws_security_groups" "selected" {
  count = length(var.sg_rule)

  filter {
    name   = "group-name"
    values = [for item in var.sg_rule : item.name]
  }

  tags = {
    usage = "terraform"
  }
}

# Create ingress (inbound) rules
resource "aws_security_group_rule" "ingress" {
  count             = length(var.sg_rule)
  type              = "ingress"
  from_port         = var.sg_rule[count.index].from_port
  to_port           = var.sg_rule[count.index].to_port
  protocol          = var.sg_rule[count.index].protocol
  # Look at ip to recognize version.
  # IPv6 contain ":"
  cidr_blocks       = length(regexall(":", var.sg_rule[count.index].source[0])) == 0 ? var.sg_rule[count.index].source : []
  ipv6_cidr_blocks  = length(regexall(":", var.sg_rule[count.index].source[0])) > 0 ? var.sg_rule[count.index].source : []
  security_group_id = data.aws_security_groups.selected[count.index].ids[0]
}

# Remove duplicated SG ids
locals {
  uniqe_sg_ids = distinct(data.aws_security_groups.selected[*].ids[0])
}

# Create egress (outbound) rules
resource "aws_security_group_rule" "egress_allow_all" {
  count             = length(local.uniqe_sg_ids)
  
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  security_group_id = local.uniqe_sg_ids[count.index]
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}
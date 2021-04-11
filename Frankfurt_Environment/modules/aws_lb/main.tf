data "aws_security_groups" "selected" {
  filter {
    name   = "group-name"
    values = [for item in var.instance.vpc_security_group_name : item]
  }
  tags = {
    usage = "terraform"
  }
}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_security_groups.selected.vpc_ids[0]
}

data "aws_subnet" "selected" {
  for_each = data.aws_subnet_ids.selected.ids
  id       = each.value
}

data "aws_security_group" "lb_sg" {
  name = var.instance.security_group
  tags = {
    usage = "terraform"
  }
}

resource "aws_lb" "lb" {
  count              = var.instance.count
  name               = var.instance.name
  subnets            = [for s in data.aws_subnet.selected : s.id]
  internal           = var.instance.internal
  security_groups    = var.instance.internal ? [""] : [data.aws_security_group.lb_sg.id]
  load_balancer_type = var.instance.load_balancer_type
  idle_timeout       = var.instance.idle_timeout
  
  tags        = merge(
    var.instance.tags,
    var.default_tags,
    {"Name" = join(".", [format("%s%02d", var.instance.category, count.index + 1), var.instance.environment])},
  )
}


resource "aws_lb_target_group" "tg" {
  count       = var.instance.count
  name        = var.instance.name
  port        = var.instance.ports.port
  protocol    = var.instance.ports.protocol
  vpc_id      = data.aws_security_groups.selected.vpc_ids[0]
  target_type = "instance"
  tags        = merge(
    var.instance.tags,
    var.default_tags,
  )
}

resource "aws_lb_listener" "listener" {
  count              = var.instance.count
  load_balancer_arn  = element(aws_lb.lb.*.arn,0)
  port = var.instance.ports.port
  protocol = var.instance.ports.protocol
  default_action {
    target_group_arn = element(aws_lb_target_group.tg.*.arn, count.index)
    type = "forward"
  }
}
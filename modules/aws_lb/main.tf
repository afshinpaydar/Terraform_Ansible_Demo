data "aws_security_groups" "selected" {
  filter {
    name   = "group-name"
    values = [for item in var.instance.vpc_security_group_name : item]
  }
  tags = {
    usage = "terraform"
  }
}

resource "aws_lb" "lb" {
  count              = var.instance.count
  name               = var.instance.name
  subnets            = var.instance.subnets
  internal           = var.instance.internal
  security_groups    = var.instance.security_groups
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
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_security_groups.selected.vpc_ids[0]
  target_type = "instance"
  health_check {
    path                = "/"
    port                = 80
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"  # has to be HTTP 200 or fails
  }
  tags        = merge(
    var.instance.tags,
    var.default_tags,
  )
}

resource "aws_lb_listener" "listener" {
  count              = var.instance.count
  load_balancer_arn  = element(aws_lb.lb.*.arn,0)
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = element(aws_lb_target_group.tg.*.arn, count.index)
    type = "forward"
  }
}
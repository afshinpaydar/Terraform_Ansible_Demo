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

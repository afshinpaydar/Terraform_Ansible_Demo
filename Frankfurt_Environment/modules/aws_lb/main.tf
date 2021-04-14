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
    Name  = var.instance.security_group
  }
}

resource "aws_lb" "lb" {
  name               = var.instance.name
  subnets            = [for s in data.aws_subnet.selected : s.id]
  internal           = var.instance.internal
  security_groups    = [data.aws_security_group.lb_sg.id] == var.instance.internal ? [data.aws_security_group.lb_sg.id] : null
  load_balancer_type = var.instance.load_balancer_type
  idle_timeout       = var.instance.idle_timeout
  tags        = merge(
    var.instance.tags,
    var.default_tags,
    {"Name" = join(".", [format("%s", var.instance.category), var.instance.environment])},
  )
}


resource "aws_lb_target_group" "tg" {
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
  load_balancer_arn   = element(aws_lb.lb.*.arn,0)
  port                = 80
  protocol = var.instance.ports.protocol
  default_action {
    target_group_arn  = element(aws_lb_target_group.tg.*.arn, 0)
    type              = "forward"
  }
}

resource "local_file" "foo" {
  content     = aws_lb.lb.dns_name
  filename    =  var.instance.name == "nginx" ? "/tmp/loadbalancer-dns-names-nginx.txt" : "/tmp/loadbalancer-dns-names-app.txt"
}

resource "aws_s3_bucket" "loadbalancer_dns_names" {
  bucket   = "frankfurt-loadbalancer-dns-names"
  acl      = "private"
}

# resource "aws_s3_bucket_object" "lb_dns_name_nginx" {
#   key        = "nginx-dns-name"
#   bucket     = aws_s3_bucket.loadbalancer_dns_names.id
#   source     = "./loadbalancer-dns-names-nginx.txt"
# }

# resource "aws_s3_bucket_object" "lb_dns_name_app" {
#   key        = "app-dns-name"
#   bucket     = aws_s3_bucket.loadbalancer_dns_names.id
#   source     = "./loadbalancer-dns-names-app.txt"
# }
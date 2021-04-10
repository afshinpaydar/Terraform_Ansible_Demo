locals {
  cats = [ for item in var.objects : item if item.type == "ec2" ]
}

locals {
  lb_cats = [ for item in var.objects : item if item.type == "lb" ]
}

locals {
  sg_rule = [ for item in var.objects : item if item.type == "sg_rule" ]
}
module "sg_rule" {
  source       = "./modules/sg_rule/"
  sg_rule      = local.sg_rule
}
output "security_group_rules" {
  value = module.sg_rule.ingress
}



locals {
  ec2_vpn = [ for item in local.cats : item if item.category == "vpn" ]
}
module "vpn" {
  source           = "./modules/instance/"
  instance         = local.ec2_vpn[0]
  region           = var.aws_region
  default_tags     = var.default_tags
}
output "ec2_vpn" {
  value = module.vpn.ec2_node
}

locals {
  ec2_db = [ for item in local.cats : item if item.category == "db" ]
}
module "db" {
  source           = "./modules/instance/"
  instance         = local.ec2_db[0]
  region           = var.aws_region
  default_tags     = var.default_tags
}
output "ec2_db" {
  value = module.db.ec2_node
}

locals {
  lb_nginx = [ for item in local.lb_cats : item if item.category == "nginx" ]
}
module "nginx" {
  source           = "./modules/aws_lb/"
  instance         = local.lb_nginx[0]
  region           = var.aws_region
  default_tags     = var.default_tags
}
output "lb_nginx" {
  value = module.nginx
}

locals {
  lb_app = [ for item in local.lb_cats : item if item.category == "app" ]
}
module "app" {
  source           = "./modules/aws_lb/"
  instance         = local.lb_app[0]
  region           = var.aws_region
  default_tags     = var.default_tags
}
output "lb_app" {
  value = module.app
}

# -----

# resource "aws_alb_listener" "my-alb-listener" {
#   default_action {
#     target_group_arn = "$"
#     type = "forward"
#   }
#   load_balancer_arn = "$"
#   port = 80
#   protocol = "HTTP"
# }

resource "aws_lb_target_group" "ip-example" {
  name        = "tf-example-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "vpc-0bbf4d1aa77f1de05"

  # health_check {
  #   path = "/api/1/resolve/default?path=/service/my-service"
  #   port = 2001
  #   healthy_threshold = 6
  #   unhealthy_threshold = 2
  #   timeout = 2
  #   interval = 5
  #   matcher = "200"  # has to be HTTP 200 or fails
  # }
}
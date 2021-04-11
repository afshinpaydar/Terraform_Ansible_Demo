locals {
  cats = [ for item in var.objects : item if item.type == "ec2" ]
}

locals {
  lb_cats = [ for item in var.objects : item if item.type == "lb" ]
}

locals {
  lc_cats = [ for item in var.objects : item if item.type == "lc" ]
}

locals {
  asg_cats = [ for item in var.objects : item if item.type == "asg" ]
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
module "ec2_vpn" {
  source           = "./modules/instance/"
  instance         = local.ec2_vpn[0]
  region           = var.aws_region
  default_tags     = var.default_tags
}
output "ec2_vpn" {
  value = module.ec2_vpn.ec2_node
}

locals {
  ec2_db = [ for item in local.cats : item if item.category == "db" ]
}
module "ec2_db" {
  source           = "./modules/instance/"
  instance         = local.ec2_db[0]
  region           = var.aws_region
  default_tags     = var.default_tags
}
output "ec2_db" {
  value = module.ec2_db.ec2_node
}

locals {
  lb_nginx = [ for item in local.lb_cats : item if item.category == "nginx" ]
}
module "lb_nginx" {
  source           = "./modules/aws_lb/"
  instance         = local.lb_nginx[0]
  region           = var.aws_region
  default_tags     = var.default_tags
}
output "lb_nginx" {
  value = module.lb_nginx
}

locals {
  lb_app = [ for item in local.lb_cats : item if item.category == "app" ]
}
module "lb_app" {
  source           = "./modules/aws_lb/"
  instance         = local.lb_app[0]
  region           = var.aws_region
  default_tags     = var.default_tags
}
output "lb_app" {
  value = module.lb_app
}


locals {
  lc_nginx = [ for item in local.lc_cats : item if item.category == "nginx" ]
}
module "lc_nginx" {
  source           = "./modules/lc/"
  instance         = local.lc_nginx[0]
  region           = var.aws_region
  default_tags     = var.default_tags
}
output "lc_nginx" {
  value = module.lc_nginx
}

locals {
  lc_app = [ for item in local.lc_cats : item if item.category == "app" ]
}
module "lc_app" {
  source           = "./modules/lc/"
  instance         = local.lc_app[0]
  region           = var.aws_region
  default_tags     = var.default_tags
}
output "lc_app" {
  value = module.lc_app
}

locals {
  asg_nginx = [ for item in local.asg_cats : item if item.category == "nginx" ]
}
module "asg_nginx" {
  source               = "./modules/asg/"
  instance             = local.asg_nginx[0]
  region               = var.aws_region
  default_tags         = var.default_tags
  launch_configuration = module.lc_app.name
}
output "asg_nginx" {
  value = module.asg_nginx
}

locals {
  asg_app = [ for item in local.asg_cats : item if item.category == "app" ]
}
module "asg_app" {
  source               = "./modules/asg/"
  instance             = local.asg_app[0]
  region               = var.aws_region
  default_tags         = var.default_tags
  launch_configuration = module.lc_nginx.name
}
output "asg_app" {
  value = module.asg_app
}
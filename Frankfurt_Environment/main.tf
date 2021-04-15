locals {
  cats = [ for item in var.objects : item if item.type == "ec2" ]
}

locals {
  db_cats = [ for item in var.objects : item if item.type == "db" ]
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
  private_key      = var.private_key
}
output "ec2_vpn" {
  value = module.ec2_vpn.ec2_node
}

locals {
  mongo_db_01 = [ for item in local.db_cats : item if item.name == "mongodb01" ]
}
module "mongodb_1" {
  source           = "./modules/mongodb/"
  instance         = local.mongo_db_01[0]
  region           = var.aws_region
  default_tags     = var.default_tags
}
output "mongodb_1" {
  value = module.mongodb_1
}

locals {
  mongo_db_02 = [ for item in local.db_cats : item if item.name == "mongodb02" ]
}
module "mongodb_2" {
  source           = "./modules/mongodb/"
  instance         = local.mongo_db_02[0]
  region           = var.aws_region
  default_tags     = var.default_tags
}
output "mongodb_2" {
  value = module.mongodb_2
}

locals {
  mongo_db_03 = [ for item in local.db_cats : item if item.name == "mongodb03" ]
}
module "mongodb_3" {
  source           = "./modules/mongodb/"
  instance         = local.mongo_db_03[0]
  region           = var.aws_region
  default_tags     = var.default_tags
}
output "mongodb_3" {
  value = module.mongodb_3
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
  value = module.lb_nginx.dns_name
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
  value = module.lb_app.dns_name
}


locals {
  lc_nginx = [ for item in local.lc_cats : item if item.category == "nginx" ]
}
module "lc_nginx" {
  source               = "./modules/lc/"
  instance             = local.lc_nginx[0]
  region               = var.aws_region
  default_tags         = var.default_tags
  iam_instance_profile = module.ec2_vpn.s3_access_profile
}
output "lc_nginx" {
  value = module.lc_nginx.name
}

locals {
  lc_app = [ for item in local.lc_cats : item if item.category == "app" ]
}
module "lc_app" {
  source           = "./modules/lc/"
  instance         = local.lc_app[0]
  region           = var.aws_region
  default_tags     = var.default_tags
  iam_instance_profile = module.ec2_vpn.s3_access_profile
}
output "lc_app" {
  value = module.lc_app.name
}

locals {
  asg_nginx = [ for item in local.asg_cats : item if item.category == "nginx" ]
}
module "asg_nginx" {
  source               = "./modules/asg/"
  instance             = local.asg_nginx[0]
  region               = var.aws_region
  default_tags         = var.default_tags
  launch_configuration = module.lc_nginx.name
  target_group_arns    = module.lb_nginx.id
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
  launch_configuration = module.lc_app.name
  target_group_arns    = module.lb_app.id
}
output "asg_app" {
  value = module.asg_app
}
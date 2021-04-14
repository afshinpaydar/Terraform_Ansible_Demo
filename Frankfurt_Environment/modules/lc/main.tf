data "aws_security_groups" "selected" {
  filter {
    name   = "group-name"
    values = [for item in var.instance.security_groups : item]
  }
  tags = {
    usage = "terraform"
  }
}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_security_groups.selected.vpc_ids[0]
}

data "aws_security_group" "lb_sg" {
  name = var.instance.security_group
  tags = {
    usage = "terraform"
    Name  = var.instance.security_group
  }
}

resource "aws_launch_configuration" "lc" {
  name                        = var.instance.name
  image_id                    = var.instance.ami
  instance_type               = var.instance.instance_type
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.instance.key_name
  associate_public_ip_address = var.instance.associate_public_ip_address
  enable_monitoring           = var.instance.enable_monitoring
  security_groups             = [data.aws_security_group.lb_sg.id]
  user_data                   = file("../Ansible/get_dns_name.sh") == var.instance.name == "nginx" ? file("../Ansible/get_dns_name.sh") : null
}

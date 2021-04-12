

resource "aws_autoscaling_group" "asg" {
  name                    = var.instance.name
  launch_configuration    = var.launch_configuration
  vpc_zone_identifier     = var.instance.vpc_zone_identifier
  max_size                = var.instance.max_size
  min_size                = var.instance.min_size
  timeouts {
    delete                = var.instance.timeout_delete
  }
  # because we're using target_group_arns
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
  default_cooldown        = 1800
  target_group_arns         = [var.target_group_arns]
}

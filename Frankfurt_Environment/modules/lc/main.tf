resource "aws_launch_configuration" "lc" {
  name                        = var.instance.name
  image_id                    = var.instance.ami
  instance_type               = var.instance.instance_type
  key_name                    = var.instance.key_name
  associate_public_ip_address = var.instance.associate_public_ip_address
  enable_monitoring           = var.instance.enable_monitoring
  security_groups             = var.instance.security_groups
}

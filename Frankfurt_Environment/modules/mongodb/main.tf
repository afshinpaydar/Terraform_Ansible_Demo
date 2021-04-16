# Gather existing SGs data base on group-name and "Name = frankfurt-sg" tag.
# This tag is used to avoid SGs with same name.
# Given list of SGs should be on same VPC
data "aws_security_groups" "selected" {
  filter {
    name   = "group-name"
    values = [for item in var.instance.vpc_security_group_name : item]
  }
  tags = {
    usage = "terraform"
  }
}

# Find a VPC subnet_ids by Name
# Get first vpc_id by "data.aws_security_groups.selected.vpc_ids[0]".
# Assumption is that all VPC_IDs are the same.
data "aws_subnet_ids" "selected" {
  count  = var.instance.count
  vpc_id = data.aws_security_groups.selected.vpc_ids[0]
  tags = {
    Name = var.instance.subnet_name[count.index]
  }
}

# Following block is to avoid instance recreation.
data "aws_subnet" "selected" {
  count = var.instance.count
  id    = join("", data.aws_subnet_ids.selected[count.index].ids)
}

resource "aws_instance" "mongo" {
  count                       = var.instance.count
  ami                         = var.instance.ami
  private_ip                  = var.instance.private_ip[count.index]
  instance_type               = var.instance.instance_type
  subnet_id                   = data.aws_subnet.selected[count.index].id
  key_name                    = var.instance.key_name
  monitoring                  = var.instance.monitoring
  vpc_security_group_ids      = data.aws_security_groups.selected.ids
  associate_public_ip_address = var.instance.associate_public_ip_address
  root_block_device           {
    volume_type = var.instance.root_block_device.volume_type
    volume_size = var.instance.root_block_device.volume_size
  }
  ebs_block_device {
    volume_type = var.instance.ebs_block_device.volume_type
    volume_size = var.instance.ebs_block_device.volume_size
    device_name = var.instance.ebs_block_device.device_name
  }

  volume_tags = merge(
    var.default_tags, {
      "Name" = join("-", [format("%s", var.instance.name), count.index + 1])
    },
  )

  tags        = merge(
    var.instance.tags,
    var.default_tags,
    {"Name" = join("-", [format("%s", var.instance.name), count.index + 1])},
  )

  lifecycle {
    ignore_changes = [
      user_data,
      associate_public_ip_address,
      private_ip,
      root_block_device,
      ebs_block_device,
    ]
  }

}

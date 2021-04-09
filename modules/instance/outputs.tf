locals {
  l   = [for j in aws_eip.assosiate : j.public_ip]
  eip = length(local.l) > 0 ? local.l[0] : "-"
}

output "ec2_node" {
  value = [for item in aws_instance.ec2 : format("Node: %s - Private IP: %s EIP: %s", item.tags.Name, item.private_ip, local.eip)]
}
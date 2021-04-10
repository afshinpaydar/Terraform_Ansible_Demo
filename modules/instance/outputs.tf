
output "ec2_node" {
  value = [for item in aws_instance.ec2 : format("Node: %s - Private IP: %s Public IP: %s", item.tags.Name, item.private_ip, item.public_ip)]
}
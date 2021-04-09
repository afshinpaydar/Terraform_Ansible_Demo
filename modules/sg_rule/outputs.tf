output "ingress" {
  value = [for item in aws_security_group_rule.ingress : format("Protocol: %s, Port range: %s-%s, Allowd IPs: %s", item.protocol, item.from_port, item.to_port, join(", ", concat(item.cidr_blocks, item.ipv6_cidr_blocks)))]
}
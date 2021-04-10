# output "this_lb_id" {
#   description = "The name of the ELB"
#   value       = concat(aws_lb.this.*.id, [""])[0]
# }

# output "this_lb_arn" {
#   description = "The ARN of the ELB"
#   value       = concat(aws_lb.this.*.arn, [""])[0]
# }

# output "this_lb_name" {
#   description = "The name of the ELB"
#   value       = concat(aws_lb.this.*.name, [""])[0]
# }

# output "this_lb_dns_name" {
#   description = "The DNS name of the ELB"
#   value       = concat(aws_lb.this.*.dns_name, [""])[0]
# }


# locals {
#   l   = [for j in aws_eip.assosiate : j.public_ip]
#   eip = length(local.l) > 0 ? local.l[0] : "-"
# }

# output "lb_node" {
#   value = [for item in aws_instance.ec2 : format("Node: %s - Private IP: %s EIP: %s", item.tags.Name, item.private_ip, local.eip)]
# }
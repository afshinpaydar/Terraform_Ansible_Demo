
# output "mongo_node" {
#   value = [for item in aws_instance.mongo : format("Node: %s - Private IP: %s ", item.tags.Name, item.private_ip)]
# }
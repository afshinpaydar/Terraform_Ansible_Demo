output "id" {
  value = aws_lb_target_group.tg.id
}
output "dns_name" {
  value = aws_lb.lb.dns_name
}
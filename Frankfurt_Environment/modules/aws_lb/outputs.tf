output "id" {
  value = aws_lb_target_group.tg.id
}
output "dns" {
  value = aws_lb.lb.dns_name  
}
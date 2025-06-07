output "alb_sg" {
  value = aws_security_group.practice_alb_sg.id
}

output "target_group_arns" {
  value = aws_lb_target_group.practice_target_group.arn
}

output "alb_dns_name" {
  value = aws_lb.practice_alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.practice_alb.zone_id
}
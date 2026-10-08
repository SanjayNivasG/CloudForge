output "alb_dns_name" {
  value = aws_lb.cloudforge.dns_name
}

output "alb_arn" {
  value = aws_lb.cloudforge.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.cloudforge.arn
}
output "alb_security_group_id" {
  description = "Security group ID of the CloudForge ALB"
  value       = aws_security_group.alb.id
}

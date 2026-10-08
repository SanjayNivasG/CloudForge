output "alb_dns_name" {
  description = "DNS name of the CloudForge Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the CloudForge Application Load Balancer"
  value       = module.alb.alb_arn
}

output "target_group_arn" {
  description = "ARN of the CloudForge target group"
  value       = module.alb.target_group_arn
}

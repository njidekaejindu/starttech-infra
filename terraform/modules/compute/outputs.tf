output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.this.dns_name
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb_sg.id
}

output "backend_security_group_id" {
  description = "Backend EC2 security group ID"
  value       = aws_security_group.backend_sg.id
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = aws_lb_target_group.backend.arn
}

output "asg_name" {
  description = "Backend Auto Scaling Group name"
  value       = aws_autoscaling_group.backend.name
}




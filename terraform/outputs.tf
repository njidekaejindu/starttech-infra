# Outputs will be added as resources are created
output "alb_dns_name" {
  description = "Public URL for backend via ALB"
  value       = module.compute.alb_dns_name
}

output "asg_name" {
  description = "Backend Auto Scaling Group name"
  value       = module.compute.asg_name
}
output "s3_bucket_name" {
  description = "S3 bucket name for frontend assets"
  value       = module.storage.s3_bucket_name
}

output "cloudfront_domain" {
  description = "CloudFront distribution domain for frontend"
  value       = module.storage.cloudfront_domain
}


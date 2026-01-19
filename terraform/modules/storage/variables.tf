variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "aws_region" {
  type = string
}

variable "alb_dns_name" {
  type        = string
  description = "ALB DNS name to use as CloudFront origin for backend"
}

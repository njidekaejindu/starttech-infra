variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs (for ALB)"
}

variable "app_private_subnet_ids" {
  type        = list(string)
  description = "Private app subnet IDs (for ASG)"
}

variable "instance_type" {
  type        = string
  description = "Backend EC2 instance type"
}

variable "ssh_key_name" {
  type        = string
  description = "Optional EC2 key pair name"
  default     = ""
}

variable "desired_capacity" {
  type        = number
  description = "ASG desired capacity"
}

variable "min_size" {
  type        = number
  description = "ASG minimum size"
}

variable "max_size" {
  type        = number
  description = "ASG maximum size"
}
variable "enable_alb_only_test" {
  description = "If true, create only the ALB/Listener/TargetGroup (no ASG)"
  type        = bool
  default     = false
}



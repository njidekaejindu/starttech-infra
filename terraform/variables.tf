variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "starttech"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
variable "backend_instance_type" {
  description = "EC2 instance type for backend"
  type        = string
  default     = "t3.micro"
}

variable "ssh_key_name" {
  description = "Existing EC2 key pair name for SSH access (optional)"
  type        = string
  default     = ""
}

variable "backend_desired_capacity" {
  description = "ASG desired capacity"
  type        = number
  default     = 2
}

variable "backend_min_size" {
  description = "ASG min size"
  type        = number
  default     = 2
}

variable "backend_max_size" {
  description = "ASG max size"
  type        = number
  default     = 4
}

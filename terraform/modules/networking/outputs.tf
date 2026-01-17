output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = [for s in aws_subnet.public : s.id]
}

output "app_private_subnet_ids" {
  description = "Private app subnet IDs"
  value       = [for s in aws_subnet.app_private : s.id]
}

output "data_private_subnet_ids" {
  description = "Private data subnet IDs"
  value       = [for s in aws_subnet.data_private : s.id]
}


terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = var.environment
}

provider "aws" {
  region = var.aws_region
}
module "compute" {
  source = "./modules/compute"

  project_name           = var.project_name
  environment            = var.environment
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  app_private_subnet_ids = module.networking.app_private_subnet_ids

  instance_type    = var.backend_instance_type
  ssh_key_name     = var.ssh_key_name
  desired_capacity = var.backend_desired_capacity
  min_size         = var.backend_min_size
  max_size         = var.backend_max_size
}
module "storage" {
  source = "./modules/storage"

  project_name = var.project_name
  environment  = var.environment
}



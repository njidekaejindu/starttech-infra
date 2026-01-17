data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  name_prefix = "${var.project_name}-${var.environment}"

  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  app_subnet_cidrs    = ["10.0.11.0/24", "10.0.12.0/24"]
  data_subnet_cidrs   = ["10.0.21.0/24", "10.0.22.0/24"]
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${local.name_prefix}-vpc"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${local.name_prefix}-igw"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Public subnets (ALB, NAT)
resource "aws_subnet" "public" {
  count                   = var.az_count
  vpc_id                  = aws_vpc.this.id
  cidr_block              = local.public_subnet_cidrs[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${local.name_prefix}-public-${count.index + 1}"
    Tier        = "public"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Private app subnets (EC2 ASG)
resource "aws_subnet" "app_private" {
  count             = var.az_count
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.app_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name        = "${local.name_prefix}-app-private-${count.index + 1}"
    Tier        = "app-private"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Private data subnets (ElastiCache)
resource "aws_subnet" "data_private" {
  count             = var.az_count
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.data_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name        = "${local.name_prefix}-data-private-${count.index + 1}"
    Tier        = "data-private"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Public route table -> IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${local.name_prefix}-public-rt"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# NAT Gateways (one per AZ)
resource "aws_eip" "nat" {
  count  = var.az_count
  domain = "vpc"

  tags = {
    Name        = "${local.name_prefix}-nat-eip-${count.index + 1}"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "this" {
  count         = var.az_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name        = "${local.name_prefix}-nat-${count.index + 1}"
    Project     = var.project_name
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.this]
}

# Private route tables (one per AZ) -> NAT in same AZ
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${local.name_prefix}-private-rt-${count.index + 1}"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_route" "private_to_nat" {
  count                  = var.az_count
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "app_private" {
  count          = var.az_count
  subnet_id      = aws_subnet.app_private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "data_private" {
  count          = var.az_count
  subnet_id      = aws_subnet.data_private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}


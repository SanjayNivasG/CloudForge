provider "aws" {
  region = "ap-south-1"
}
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
# ============================================================
# VPC
# ============================================================

resource "aws_vpc" "cloudforge" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "cloudforge-vpc"
    Project     = "CloudForge"
    Environment = "dev"
  }
}

# ============================================================
# PUBLIC SUBNET A
# ============================================================

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.cloudforge.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "cloudforge-public-a"
    Project     = "CloudForge"
    Environment = "dev"
    Tier        = "public"
  }
}

# ============================================================
# PUBLIC SUBNET B
# ============================================================

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.cloudforge.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "cloudforge-public-b"
    Project     = "CloudForge"
    Environment = "dev"
    Tier        = "public"
  }
}

# ============================================================
# PRIVATE SUBNET A
# ============================================================

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.cloudforge.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name        = "cloudforge-private-a"
    Project     = "CloudForge"
    Environment = "dev"
    Tier        = "private"
  }
}

# ============================================================
# PRIVATE SUBNET B
# ============================================================

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.cloudforge.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name        = "cloudforge-private-b"
    Project     = "CloudForge"
    Environment = "dev"
    Tier        = "private"
  }
}

# ============================================================
# INTERNET GATEWAY
# ============================================================

resource "aws_internet_gateway" "cloudforge" {
  vpc_id = aws_vpc.cloudforge.id

  tags = {
    Name        = "cloudforge-igw"
    Project     = "CloudForge"
    Environment = "dev"
  }
}

# ============================================================
# PUBLIC ROUTE TABLE
# ============================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.cloudforge.id

  tags = {
    Name        = "cloudforge-public-rt"
    Project     = "CloudForge"
    Environment = "dev"
  }
}

# ============================================================
# PUBLIC INTERNET ROUTE
# ============================================================

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cloudforge.id
}

# ============================================================
# PUBLIC SUBNET A ROUTE ASSOCIATION
# ============================================================

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# ============================================================
# PUBLIC SUBNET B ROUTE ASSOCIATION
# ============================================================

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# ============================================================
# ELASTIC IP FOR NAT GATEWAY
# ============================================================

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "cloudforge-nat-eip"
    Project     = "CloudForge"
    Environment = "dev"
  }
}

# ============================================================
# NAT GATEWAY
# ============================================================

resource "aws_nat_gateway" "cloudforge" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name        = "cloudforge-nat-gateway"
    Project     = "CloudForge"
    Environment = "dev"
  }

  depends_on = [
    aws_internet_gateway.cloudforge
  ]
}

# ============================================================
# PRIVATE ROUTE TABLE A
# ============================================================

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.cloudforge.id

  tags = {
    Name        = "cloudforge-private-a-rt"
    Project     = "CloudForge"
    Environment = "dev"
  }
}

# ============================================================
# PRIVATE A → NAT GATEWAY
# ============================================================

resource "aws_route" "private_a_nat" {
  route_table_id         = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.cloudforge.id
}

# ============================================================
# PRIVATE SUBNET A ROUTE ASSOCIATION
# ============================================================

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

# ============================================================
# PRIVATE ROUTE TABLE B
# ============================================================

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.cloudforge.id

  tags = {
    Name        = "cloudforge-private-b-rt"
    Project     = "CloudForge"
    Environment = "dev"
  }
}

# ============================================================
# PRIVATE B → NAT GATEWAY
# ============================================================

resource "aws_route" "private_b_nat" {
  route_table_id         = aws_route_table.private_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.cloudforge.id
}

# ============================================================
# PRIVATE SUBNET B ROUTE ASSOCIATION
# ============================================================

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}
# ============================================================
# IAM MODULE
# ============================================================

module "iam" {
  source = "./modules/iam"
}
# ============================================================
# ALB MODULE
# ============================================================

module "alb" {
  source = "./modules/alb"

  vpc_id = aws_vpc.cloudforge.id

  public_subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}
# ============================================================
# EC2 APPLICATION MODULE
# ============================================================

module "ec2" {
  source = "./modules/ec2"

  vpc_id = aws_vpc.cloudforge.id

  private_subnet_id = aws_subnet.private_a.id

  ami_id = data.aws_ami.ubuntu.id

  alb_security_group_id = module.alb.alb_security_group_id

  target_group_arn = module.alb.target_group_arn
}

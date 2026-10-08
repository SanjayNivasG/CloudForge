# ============================================================
# VPC MODULE
# ============================================================

module "vpc" {
  source = "./modules/vpc"
}

# ============================================================
# AMI DATA SOURCE
# ============================================================

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

  vpc_id = module.vpc.vpc_id

  public_subnet_ids = [
    module.vpc.public_subnet_a_id,
    module.vpc.public_subnet_b_id
  ]
}

# ============================================================
# EC2 MODULE
# ============================================================

module "ec2" {
  source = "./modules/ec2"

  vpc_id = module.vpc.vpc_id

  private_subnet_id = module.vpc.private_subnet_a_id

  ami_id = data.aws_ami.ubuntu.id

  alb_security_group_id = module.alb.alb_security_group_id

  target_group_arn = module.alb.target_group_arn
}

resource "aws_security_group" "alb" {
  name        = "cloudforge-alb-sg"
  description = "Security group for CloudForge ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "cloudforge-alb-sg"
    Project     = "CloudForge"
    Environment = "dev"
  }
}

resource "aws_lb" "cloudforge" {
  name               = "cloudforge-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = var.public_subnet_ids

  tags = {
    Name        = "cloudforge-alb"
    Project     = "CloudForge"
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "cloudforge" {
  name     = "cloudforge-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled  = true
    path     = "/"
    protocol = "HTTP"
  }

  tags = {
    Name        = "cloudforge-tg"
    Project     = "CloudForge"
    Environment = "dev"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.cloudforge.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn = aws_lb_target_group.cloudforge.arn
      }
    }
  }
}


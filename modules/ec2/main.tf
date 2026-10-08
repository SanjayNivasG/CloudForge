resource "aws_security_group" "app" {
  name        = "cloudforge-app-sg"
  description = "Security group for CloudForge application"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "cloudforge-app-sg"
    Project     = "CloudForge"
    Environment = "dev"
  }
}

resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl enable nginx
              systemctl start nginx

              cat > /var/www/html/index.html <<'HTML'
              <html>
                <head>
                  <title>CloudForge</title>
                </head>
                <body>
                  <h1>CloudForge Application</h1>
                  <p>Served through AWS Application Load Balancer.</p>
                </body>
              </html>
              HTML
              EOF

  tags = {
    Name        = "cloudforge-app"
    Project     = "CloudForge"
    Environment = "dev"
  }
}

resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.app.id
  port             = 80
}

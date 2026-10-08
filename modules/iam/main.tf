resource "aws_iam_policy" "cloudforge_readonly" {
  name        = "cloudforge-readonly"
  description = "Read-only AWS permissions for CloudForge"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ec2:Describe*",
          "elasticloadbalancing:Describe*",
          "eks:Describe*",
          "eks:List*",
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]

        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "cloudforge-readonly"
    Project     = "CloudForge"
    Environment = "dev"
  }
}
resource "aws_iam_role" "cloudforge" {
  name = "cloudforge-dev-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "cloudforge-dev-role"
    Project     = "CloudForge"
    Environment = "dev"
  }
}
resource "aws_iam_role_policy_attachment" "cloudforge_readonly" {
  role       = aws_iam_role.cloudforge.name
  policy_arn = aws_iam_policy.cloudforge_readonly.arn
}

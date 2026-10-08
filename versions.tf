terraform {
  required_version = ">= 1.16.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "cloudforge-terraform-state-583365237592"
    key    = "cloudforge/dev/terraform.tfstate"
    region = "ap-south-1"
  }
}

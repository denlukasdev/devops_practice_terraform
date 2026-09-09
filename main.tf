# main.tf
terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket       = "tf-state-lukasdev-2026"
    key          = "shop/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "eu-central-1"
}

# resource "aws_s3_bucket" "assets" {
#   bucket = "tf-shop-assets-lukasdev-2026"
#   tags = {
#     Name      = "tf-shop assets"
#     ManagedBy = "terraform"
#     Owner     = "Denys"
#   }
# }

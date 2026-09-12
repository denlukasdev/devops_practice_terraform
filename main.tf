# main.tf
locals {
  env         = terraform.workspace
  name_prefix = "${var.project}-${local.env}"
  common_tags = {
    Project   = var.project
    Env       = local.env
    ManagedBy = "terraform"
  }
  instance_type = {
    dev  = "t3.micro"
    prod = "t3.small"
  }[local.env]
}

terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  cloud {
    organization = "lukasdev_devops"
    workspaces {
      tags = ["shop"]
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "network" {
  source      = "./modules/network"
  project     = var.project
  region      = var.region
  vpc_cidr    = var.vpc_cidr
  subnets     = var.subnets
  tags        = local.common_tags
  name_prefix = local.name_prefix
}


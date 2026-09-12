terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_iam_openid_connect_provider" "tfc" {
  url            = "https://app.terraform.io"
  client_id_list = ["aws.workload.identity"]
}


locals {
  tfc_aud = "aws.workload.identity"
  tfc_sub_plan  = "organization:lukasdev_devops:project:*:workspace:dev:run_phase:plan"
  tfc_sub_apply = "organization:lukasdev_devops:project:*:workspace:dev:run_phase:apply"
}

data "aws_iam_policy_document" "trust_plan" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.tfc.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "app.terraform.io:aud"
      values   = [local.tfc_aud]
    }
    condition {
      test     = "StringLike"
      variable = "app.terraform.io:sub"
      values   = [local.tfc_sub_plan]
    }
  }
}

data "aws_iam_policy_document" "trust_apply" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.tfc.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "app.terraform.io:aud"
      values   = [local.tfc_aud]
    }
    condition {
      test     = "StringLike"
      variable = "app.terraform.io:sub"
      values   = [local.tfc_sub_apply]
    }
  }
}

resource "aws_iam_role" "tfc_plan" {
  name               = "tfc-shop-plan"
  assume_role_policy = data.aws_iam_policy_document.trust_plan.json
}

resource "aws_iam_role" "tfc_apply" {
  name               = "tfc-shop-apply"
  assume_role_policy = data.aws_iam_policy_document.trust_apply.json
}

resource "aws_iam_role_policy_attachment" "tfc_plan_readonly" {
  role       = aws_iam_role.tfc_plan.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "tfc_apply_admin" {
  role       = aws_iam_role.tfc_apply.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

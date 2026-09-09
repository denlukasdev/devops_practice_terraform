locals {
  name_prefix = "${var.project}-${var.env}"
  common_tags = {
    Project   = var.project
    Env       = var.env
    ManagedBy = "terraform"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = merge(local.common_tags, { Name = "${local.name_prefix}-vpc" })
  # tags                 = { Name = "${var.project}-vpc" }
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project}-igw" }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.project}-rt" }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.net["public-a"].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project}-rt-private" }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.net["private-b"].id
  route_table_id = aws_route_table.private.id
}

resource "aws_subnet" "net" {
  for_each = var.subnets
  vpc_id   = aws_vpc.main.id
  # cidr_block        = each.value.cidr
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value.netnum)
  availability_zone = "${var.region}${each.value.az}"
  tags              = { Name = "${var.project}-${each.key}" }
}


moved {
  from = aws_subnet.this
  to   = aws_subnet.net
}

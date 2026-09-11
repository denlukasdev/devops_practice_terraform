variable "project" {
  type = string
}
variable "region" {
  type = string
}
variable "vpc_cidr" {
  type = string
}

variable "subnets" {
  type = map(object({ netnum = string, az = string }))
}

variable "tags" {
  type = map(string)
}

variable "name_prefix" {
  type = string
}


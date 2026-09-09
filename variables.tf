variable "project" {
  type    = string
  default = "tf-shop"
}
variable "region" {
  type    = string
  default = "eu-central-1"
}
variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}
variable "subnet_cidr" {
  type    = string
  default = "10.10.1.0/24"
}
variable "private_subnet_cidr" {
  type    = string
  default = "10.10.11.0/24"
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "env" {
  type    = string
  default = "tst"
}

# variable "subnets" {
#   type = map(object({ cidr = string, az = string }))
#   default = {
#     public-a  = { cidr = "10.10.1.0/24", az = "a" }
#     private-b = { cidr = "10.10.11.0/24", az = "b" }
#     private-c = { cidr = "10.10.12.0/24", az = "c" }
#   }
# }
variable "subnets" {
  type = map(object({ netnum = string, az = string }))
  default = {
    public-a  = { netnum = "1", az = "a" }
    private-b = { netnum = "11", az = "b" }
    private-c = { netnum = "12", az = "c" }
    private-d = { netnum = "15", az = "c" }
  }
}

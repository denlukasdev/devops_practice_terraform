output "aws_vpc_id" {
  value = aws_vpc.main.id
}

output "aws_subnet_net" {
  value =  {for k,v in aws_subnet.net: k => v.id}
}
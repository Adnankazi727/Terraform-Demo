output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "pri_subnet_id" {
  value = aws_subnet.pri_sub.id
}

output "pub_subnet_id" {
  value = aws_subnet.pub_sub.id
}
output "vpc_id" {
  value = aws_vpc.practice_vpc.id
}

output "public_subnet_az_1a" {
  value = aws_subnet.public_subnet_az_1a.id
}

output "public_subnet_az_1b" {
  value = aws_subnet.public_subnet_az_1b.id
}
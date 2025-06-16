output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id  # Returns list of public subnet IDs
}

 
output "private_subnet_ids" {
  value = aws_subnet.private[*].id # Returns list of private subnet IDs
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}
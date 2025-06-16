output "public_instance_ips" {
  description = "Public IP addresses of the public EC2 instances"
  value       = aws_instance.public[*].public_ip
}

/*
output "private_instance_ips" {
  description = "Private IP addresses of the private EC2 instances"
  value       = aws_instance.private[*].private_ip
}
*/

output "ec2_security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.public.id  # Matches the SG name in your EC2 module
}

output "instance_ids" {
  value = aws_instance.public[*].id
}

output "security_group_id" {
  value = aws_security_group.public.id
}
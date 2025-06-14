output "allow_tls_sg_id" {
  value = aws_security_group.allow_tls.id
}

output "allow_internal_communication" {
  value = aws_security_group.allow_internal_communication.id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}
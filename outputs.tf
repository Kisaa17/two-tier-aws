output "vpc_id" {
  value = module.vpc.vpc_id
}


/*
output "public_instance_ips" {
  value = module.ec2.public_instance_ips
}

output "private_instance_ips" {
  value = module.ec2.private_instance_ips
}
*/

# outputs.tf - Updated version
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "rds_endpoint" {
  description = "Connection endpoint for RDS"
  value       = aws_db_instance.main.endpoint
}
variable "vpc_id" {
  description = "ID of the VPC where the ALB will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_sg_name" {
  description = "Name prefix for the ALB security group"
  type        = string
  default     = "alb-sg"
}

variable "target_ids" {}
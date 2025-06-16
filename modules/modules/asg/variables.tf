variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance (e.g., t2.micro)"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair for instances"
  type        = string
  default     = null  # Optional (omit if not using SSH)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for instance placement"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the ALB target group to attach instances"
  type        = string
}

variable "ec2_security_group_id" {
  description = "ID of the security group for EC2 instances"
  type        = string
}

variable "desired_capacity" {
  description = "Number of EC2 instances to run initially"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 4
}

variable "alb_security_group_id" {}

variable "vpc_id" {}
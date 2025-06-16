variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.172.0.0/16" # Or whatever you're using
}

variable "azs" {
  default = ["eu-north-1a", "eu-north-1b"]
}

variable "public_subnets" {
  default = ["10.172.1.0/24", "10.172.2.0/24"]
}

variable "private_subnets" {
  default = ["10.172.3.0/24", "10.172.4.0/24"]
}

variable "ami_id" {
  default = "ami-05fcfb9614772f051"  # Amazon Linux 2 (us-east-1)
}

variable "instance_type" {
  default = "t3.micro"
}

variable "db_username" {
  default = "test"
}

variable "db_password" {
  default = "password123!" 
}
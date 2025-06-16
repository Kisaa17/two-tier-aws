variable "vpc_id" {}
variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ami_id" {
  default = "ami-05fcfb9614772f051" # Amazon Linux 2
}
variable "instance_type" {
  default = "t3.micro"
}
variable "vpc_cidr" {}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}
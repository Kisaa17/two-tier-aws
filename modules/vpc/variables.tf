variable "vpc_cidr" {
  default = "10.172.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.172.1.0/24", "10.172.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.172.3.0/24", "10.172.4.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["eu-north-1a", "eu-north-1b"]
}
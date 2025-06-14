module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.172.0.0/16"
  public_subnet1 = "10.172.0.0/24"
  private_subnet1 = "10.172.1.0/24"
  az = "eu-north-1a"
  name_prefix = "demo-two-tier"
}

module "security_group" {
  source   = "./modules/sg"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
}

module "ec2" {
  source = "./modules/ec2"
  ami = "ami-05fcfb9614772f051"
  subnet_id = module.vpc.public_subnet1_id
  security_group_id = module.security_group.allow_tls_sg_id
}

module "ec2-private" {
  source = "./modules/ec2 private"
  ami = "ami-05fcfb9614772f051"
  subnet_id = module.vpc.private_subnet1_id
  security_group_id = module.security_group.allow_internal_communication
}
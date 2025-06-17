provider "aws" {
  region                  = "eu-north-1" 
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.172.0.0/16"
  azs      = ["eu-north-1a", "eu-north-1b"]
}


/* Remove if you want EC2 as backend in privat subnet


module "ec2" {
  source           = "./modules/ec2"
  vpc_id          = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_cidr        = module.vpc.vpc_cidr
  target_group_arn  = module.alb.target_group_arn
  depends_on = [module.vpc]
}
*/

module "ec2" {
  source            = "./modules/ec2"
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  ami_id           = "ami-05fcfb9614772f051" # Amazon Linux in eu-north-1
  instance_type    = "t3.micro"
  vpc_cidr        = module.vpc.vpc_cidr
  vpc_id          = module.vpc.vpc_id
  target_group_arn  = module.alb.target_group_arn
}


module "alb" {
  source           = "./modules/alb"
  vpc_id          = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  target_ids       = module.ec2.instance_ids # Register fixed instances
}

module "asg" {
  source              = "./modules/asg"
  ami_id             = "ami-05fcfb9614772f051"
  instance_type      = "t3.micro"
  public_subnet_ids  = module.vpc.public_subnet_ids
  target_group_arn   = module.alb.target_group_arn
  ec2_security_group_id = module.ec2.ec2_security_group_id
  alb_security_group_id = module.alb.alb_security_group_id
  vpc_id            = module.vpc.vpc_id

  # Scaling policy
  min_size         = 0   # Start with 0 instances
  max_size         = 4   # Maximum burst capacity
  # scaling_threshold = 60 # Scale when CPU > 60%
}

module "rds" {
  source               = "./modules/rds"
  private_subnet_ids   = module.vpc.private_subnet_ids
  vpc_id              = module.vpc.vpc_id
  db_username         = var.db_username  # Defined in root variables.tf
  db_password         = var.db_password  # Defined in root variables.tf
  app_security_group_id = module.ec2.ec2_security_group_id
}
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source              = "./VPC"
  vpc_cidr_block      = var.vpc_cidr_block
  public_cidr_block   = var.public_cidr_block
  private_cidr_block  = var.private_cidr_block
  availability_zone   = var.availability_zone
  tags = local.project_tags
}

module "alb" {
  source = "./ALB"
  public_subnet_az_1a = module.vpc.public_subnet_az_1a
  public_subnet_az_1b = module.vpc.public_subnet_az_1b
  vpc_id = module.vpc.vpc_id
  ssl_policy = var.ssl_policy
  certificate_arn = var.certificate_arn
  tags = local.project_tags
}

module "ec2" {
  source = "./EC2"
  vpc_id = module.vpc.vpc_id
  public_subnet_az_1a = module.vpc.public_subnet_az_1a
  public_subnet_az_1b = module.vpc.public_subnet_az_1b
  target_group_arns = module.alb.target_group_arns
  alb_sg = module.alb.alb_sg
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  tags = local.project_tags
}

module "route-53" {
  source = "./Route-53"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id = module.alb.alb_zone_id
  zone_id = var.zone_id
  dns_name = var.dns_name
}
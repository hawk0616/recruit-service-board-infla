module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "aws-ecs-terraform"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}c"]
  public_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  public_subnet_names  = ["Public Subnet 1a", "Public Subnet 1c"]
  private_subnet_names = ["Private Subnet 1a", "Private Subnet 1c"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = false
}

resource "aws_subnet" "rds_subnet" {
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "${local.region}d"
  map_public_ip_on_launch = false

  tags = {
    Name                  = "${local.app} RDS Private Subnet 1d"
    "MapPublicIpOnLaunch" = "false"
    "Type"                = "rds"
  }
}

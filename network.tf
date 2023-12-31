# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "aws-ecs-terraform"
#   cidr = "10.0.0.0/16"

#   azs             = ["${local.region}a", "${local.region}c"]
#   public_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

#   public_subnet_names  = ["Public Subnet 1a", "Public Subnet 1c"]
#   private_subnet_names = ["Private Subnet 1a", "Private Subnet 1c"]

#   enable_dns_hostnames = true
#   enable_dns_support   = true

#   enable_nat_gateway = true
#   single_nat_gateway = false
# }

# resource "aws_subnet" "rds_subnet_a" {
#   vpc_id                  = module.vpc.vpc_id
#   cidr_block              = "10.0.5.0/24"
#   availability_zone       = "${local.region}a"
#   map_public_ip_on_launch = false

#   tags = {
#     Name                  = "${local.app} RDS Private Subnet 1a"
#     "MapPublicIpOnLaunch" = "false"
#     "Type"                = "rds"
#   }
# }

# # RDSをcのAZに配置
# resource "aws_subnet" "rds_subnet_c" {
#   vpc_id                  = module.vpc.vpc_id
#   cidr_block              = "10.0.6.0/24"
#   availability_zone       = "${local.region}c"
#   map_public_ip_on_launch = false

#   tags = {
#     Name                  = "${local.app} RDS Private Subnet 1c"
#     "MapPublicIpOnLaunch" = "false"
#     "Type"                = "rds"
#   }
# }

# resource "aws_db_subnet_group" "my_db_subnet_group" {
#   name       = "${local.app}-db-subnet-group"
#   subnet_ids = [aws_subnet.rds_subnet_a.id, aws_subnet.rds_subnet_c.id]

#   tags = {
#     Name = "${local.app}-db-subnet-group"
#   }
# }

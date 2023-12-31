# resource "aws_security_group" "alb" {
#   name        = "${local.app}-alb"
#   description = "For ALB."
#   vpc_id      = module.vpc.vpc_id
#   ingress {
#     description = "Allow HTTP from ALL."
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     description = "Allow all to outbound."
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "${local.app}-alb"
#   }
# }

# resource "aws_security_group" "ecs" {
#   name        = "${local.app}-ecs"
#   description = "For ECS."
#   vpc_id      = module.vpc.vpc_id
#   egress {
#     description = "Allow all to outbound."
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "${local.app}-ecs"
#   }
# }

# resource "aws_security_group_rule" "ecs_from_alb" {
#   description              = "Allow 8080 from Security Group for ALB."
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.alb.id
#   security_group_id        = aws_security_group.ecs.id
# }

# resource "aws_security_group_rule" "ecs_from_nextjs" {
#   description              = "Allow 8080 from next.js to API."
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.ecs.id
#   security_group_id        = aws_security_group.ecs.id
# }

# resource "aws_security_group" "rds" {
#   name        = "${local.app}-rds"
#   description = "For RDS."
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     description     = "Allow MySQL from ECS security group"
#     from_port       = 3306
#     to_port         = 3306
#     protocol        = "tcp"
#     security_groups = [aws_security_group.ecs.id]
#   }

#   ingress {
#     description     = "Allow MySQL from Lambda security group"
#     from_port       = 3306
#     to_port         = 3306
#     protocol        = "tcp"
#     security_groups = [aws_security_group.lambda_sg.id]
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${local.app}-rds"
#   }
# }

# # For Lambda
# resource "aws_security_group" "lambda_sg" {
#   name        = "${local.app}-lambda"
#   description = "For ${local.app} Lambda"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     description     = "Allow MySQL connection to RDS"
#     from_port       = 3306
#     to_port         = 3306
#     protocol        = "tcp"
#     security_groups = [aws_security_group.rds.id]
#   }

#   egress {
#     description = "Allow all to outbound."
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${local.app}-lambda"
#   }
# }
# resource "aws_ecs_task_definition" "ecs_task_definition" {
#   family                   = local.app
#   network_mode             = "awsvpc"
#   cpu                      = 256
#   memory                   = 512
#   requires_compatibilities = ["FARGATE"]
#   execution_role_arn       = aws_iam_role.ecs.arn
#   task_role_arn            = aws_iam_role.ecs_task.arn
#   container_definitions    = <<CONTAINERS
# [
#   {
#     "name": "${local.app}",
#     "image": "medpeer/health_check:latest",
#     "portMappings": [
#       {
#         "containerPort": 8080
#       }

#     ],
#     "healthCheck": {
#       "command": ["CMD-SHELL", "curl -f http://localhost:8080/health_checks || exit 1"],
#       "interval": 30,
#       "timeout": 5,
#       "retries": 3,
#       "startPeriod": 10
#     },
#     "logConfiguration": {
#       "logDriver": "awslogs",
#       "options": {
#         "awslogs-group": "${aws_cloudwatch_log_group.cloudwatch_log_group.name}",
#         "awslogs-region": "${local.region}",
#         "awslogs-stream-prefix": "${local.app}"
#       }
#     },
#     "environment": [
#       {
#         "name": "NGINX_PORT",
#         "value": "8080"
#       },
#       {
#         "name": "HEALTH_CHECK_PATH",
#         "value": "/health_checks"
#       }
#     ]
#   }
# ]
# CONTAINERS
# }

# resource "aws_ecs_service" "ecs_service" {
#   name            = local.app
#   launch_type     = "FARGATE"
#   cluster         = aws_ecs_cluster.ecs_cluster.id
#   task_definition = aws_ecs_task_definition.ecs_task_definition.arn
#   desired_count   = 2
#   network_configuration {
#     subnets         = module.vpc.private_subnets
#     security_groups = [aws_security_group.ecs.id]
#   }
# }

# resource "aws_ecs_cluster" "ecs_cluster" {
#   name = local.app
# }

# resource "aws_ecs_task_definition" "nextjs_ecs_task_definition" {
#   family                   = "${local.app}-nextjs"
#   network_mode             = "awsvpc"
#   cpu                      = 256
#   memory                   = 512
#   requires_compatibilities = ["FARGATE"]
#   execution_role_arn       = aws_iam_role.ecs.arn
#   task_role_arn            = aws_iam_role.ecs_task.arn

#   container_definitions = <<CONTAINERS
# [
#   {
#     "name": "${local.app}-nextjs",
#     "image": "medpeer/nextjs_app:latest",
#     "portMappings": [
#       {
#         "containerPort": 8080
#       }
#     ],
#     "logConfiguration": {
#       "logDriver": "awslogs",
#       "options": {
#         "awslogs-group": "${aws_cloudwatch_log_group.cloudwatch_log_group.name}",
#         "awslogs-region": "${local.region}",
#         "awslogs-stream-prefix": "${local.app}-nextjs"
#       }
#     },
#     "environment": [
#       {
#         "name": "NGINX_PORT",
#         "value": "8080"
#       },
#       {
#         "name": "NEXTJS_ENV_VAR",
#         "value": "Your value here"
#       }
#     ]
#   }
# ]
# CONTAINERS
# }

# resource "aws_ecs_service" "nextjs_ecs_service" {
#   name            = "${local.app}-nextjs"
#   launch_type     = "FARGATE"
#   cluster         = aws_ecs_cluster.nextjs_ecs_cluster.id
#   task_definition = aws_ecs_task_definition.nextjs_ecs_task_definition.arn
#   desired_count   = 2
#   network_configuration {
#     subnets         = module.vpc.private_subnets
#     security_groups = [aws_security_group.ecs.id]
#   }
#   load_balancer {
#     target_group_arn = aws_lb_target_group.nextjs_target_group.arn
#     container_name   = "${local.app}-nextjs"
#     container_port   = 8080
#   }
#   depends_on = [aws_lb_listener_rule.nextjs_alb_listener_rule]
# }

# resource "aws_ecs_cluster" "nextjs_ecs_cluster" {
#   name = "${local.app}-nextjs"
# }

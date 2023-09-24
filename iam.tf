data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task" {
  name               = "${local.app}-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

data "aws_iam_policy_document" "ecs_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs" {
  name               = "${local.app}-ecs"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
}

resource "aws_iam_role_policy_attachment" "ecs_basic" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ssm_get_parameter" {
  statement {
    actions   = ["ssm:GetParameter"]
    resources = ["arn:aws:ssm:ap-northeast-1:113713103169:parameter//recruit-service-board/rds/*"]
  }
}

resource "aws_iam_policy" "ssm_get_parameter" {
  name        = "${local.app}-ssm-get-parameter"
  description = "Allows access to SSM GetParameter"
  policy      = data.aws_iam_policy_document.ssm_get_parameter.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_ssm_get_parameter" {
  policy_arn = aws_iam_policy.ssm_get_parameter.arn
  role       = aws_iam_role.ecs_task.name
}

# For EC2
resource "aws_iam_role" "bastion_role" {
  name = "${local.app}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${local.app}-bastion-profile"
  role = aws_iam_role.bastion_role.name
}
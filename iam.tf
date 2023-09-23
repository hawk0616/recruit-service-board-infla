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

# For Lambda
data "aws_iam_policy_document" "lambda" {
  statement {
    actions   = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "my_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.lambda.json
}

# For API GateWay
data "aws_iam_policy_document" "apigw" {
  statement {
    actions   = ["lambda:InvokeFunction"]
    resources = [aws_lambda_function.my_lambda.arn]
    effect    = "Allow"
  }
}

resource "aws_iam_role" "apigw_role" {
  name               = "my_apigw_role"
  assume_role_policy = data.aws_iam_policy_document.apigw_assume.json
}

data "aws_iam_policy_document" "apigw_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "apigw_policy" {
  name   = "my_apigw_policy"
  role   = aws_iam_role.apigw_role.id
  policy = data.aws_iam_policy_document.apigw.json
}
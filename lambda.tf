resource "aws_lambda_function" "migrate_function" {
  function_name = "${local.app}-migrate"
  handler       = "index.handler"
  runtime       = "go1.x"
  role          = aws_iam_role.lambda_execution_role.arn
  filename      = "lambda_binary.zip"

  vpc_config {
    subnet_ids         = [aws_subnet.rds_subnet_a.id, aws_subnet.rds_subnet_d.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

resource "aws_security_group_rule" "lambda_access_rds" {
  security_group_id = aws_security_group.lambda_sg.id

  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = ["10.0.5.0/24", "10.0.6.0/24"]
}
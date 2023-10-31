# resource "aws_lambda_function" "migrate_function" {
#   function_name = "${local.app}-migrate"
#   handler       = "index.handler"
#   runtime       = "go1.x"
#   role          = aws_iam_role.lambda_execution_role.arn
#   filename      = "lambda_binary.zip"

#   vpc_config {
#     subnet_ids         = [aws_subnet.rds_subnet_a.id, aws_subnet.rds_subnet_c.id]
#     security_group_ids = [aws_security_group.lambda_sg.id]
#   }
# }

# # 下記設定ワンチャンいらないかも
# resource "aws_security_group_rule" "lambda_from_apigw" {
#   security_group_id = aws_security_group.lambda_sg.id

#   type      = "ingress"
#   from_port = 0
#   to_port   = 0
#   protocol  = "-1"
#   # 一旦全てのIPからのアクセスを許可
#   cidr_blocks = ["0.0.0.0/0"]
# }
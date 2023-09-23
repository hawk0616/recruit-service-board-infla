data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "api"
  output_path = "api.zip"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "${local.app}-lambda"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "go1.x"

  filename = data.archive_file.lambda_zip.output_path
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}
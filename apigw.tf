resource "aws_api_gateway_rest_api" "my_api" {
  name        = "${local.app}-api"
  description = "${local.app} api with lambda"
}

resource "aws_api_gateway_resource" "my_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "myresource"
}

resource "aws_api_gateway_method" "my_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.my_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "my_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.my_resource.id
  http_method = aws_api_gateway_method.my_method.http_method

  credentials = aws_iam_role.apigw_role.arn
  
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/${aws_lambda_function.my_lambda.arn}/invocations"
}

resource "aws_api_gateway_deployment" "my_deployment" {
  depends_on  = [aws_api_gateway_integration.my_integration]
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "v1"
}

output "url" {
  value = "${aws_api_gateway_deployment.my_deployment.invoke_url}${aws_api_gateway_resource.my_resource.path_part}"
}
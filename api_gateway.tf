# resource "aws_api_gateway_rest_api" "api" {
#   name        = "${local.app}-api"
#   description = "API for triggering lambda"
# }

# resource "aws_api_gateway_resource" "resource" {
#   rest_api_id = aws_api_gateway_rest_api.api.id
#   parent_id   = aws_api_gateway_rest_api.api.root_resource_id
#   path_part   = "migrate"
# }

# resource "aws_api_gateway_method" "method" {
#   rest_api_id   = aws_api_gateway_rest_api.api.id
#   resource_id   = aws_api_gateway_resource.resource.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "integration" {
#   rest_api_id = aws_api_gateway_rest_api.api.id
#   resource_id = aws_api_gateway_resource.resource.id
#   http_method = aws_api_gateway_method.method.http_method

#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.migrate_function.invoke_arn
# }

# resource "aws_lambda_permission" "apigw" {
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.migrate_function.function_name
#   principal     = "apigateway.amazonaws.com"
# }

# resource "aws_api_gateway_deployment" "deployment" {
#   depends_on  = [aws_api_gateway_integration.integration]
#   rest_api_id = aws_api_gateway_rest_api.api.id
#   stage_name  = "prod"
# }
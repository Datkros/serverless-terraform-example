resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "ServerlessRESTAPI"
  description = "Serverless REST API Test"
}

# FIBONACCI
resource "aws_api_gateway_resource" "fibonacci_proxy" {
   rest_api_id = aws_api_gateway_rest_api.api_gateway.id
   parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
   path_part   = "fibonacci"
}

resource "aws_api_gateway_method" "fibonacci_proxy" {
   rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
   resource_id   = aws_api_gateway_resource.fibonacci_proxy.id
   http_method   = "ANY"
   authorization = "NONE"
 }

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_method.fibonacci_proxy.resource_id
  http_method = aws_api_gateway_method.fibonacci_proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_fibonacci.invoke_arn
}

 resource "aws_api_gateway_deployment" "api_deployment" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.ackermann_lambda,
   ]

   rest_api_id = aws_api_gateway_rest_api.api_gateway.id
   stage_name  = "api"
 }
resource "aws_api_gateway_resource" "ackermann_proxy" {
   rest_api_id = aws_api_gateway_rest_api.api_gateway.id
   parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
   path_part   = "ackermann"
}

resource "aws_api_gateway_method" "ackermann_proxy" {
   rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
   resource_id   = aws_api_gateway_resource.ackermann_proxy.id
   http_method   = "ANY"
   authorization = "NONE"
 }

resource "aws_api_gateway_integration" "ackermann_lambda" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_method.ackermann_proxy.resource_id
  http_method = aws_api_gateway_method.ackermann_proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_ackermann.invoke_arn
}
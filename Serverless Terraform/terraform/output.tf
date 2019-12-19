
 output "base_url" {
  value = aws_api_gateway_deployment.klarna_api_deployment.invoke_url
}
resource "aws_iam_role" "lambda_exec" {
    name = "lambda_exec"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
}
EOF
}

resource "aws_lambda_function" "serverless_fibonacci" {

  filename      = var.deployment
  function_name = "Serverless${var.app_name}"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "app.handler"

  runtime = "python3.7"
}


resource "aws_lambda_function" "serverless_ackermann" {

  filename      = var.deployment
  function_name = "ServerlessAckermann"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "app.handler"

  runtime = "python3.7"
}

 resource "aws_lambda_permission" "apigw_ackermann" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.serverless_ackermann.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
 }

 resource "aws_lambda_permission" "apigw_fibonacci" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.serverless_fibonacci.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
 }
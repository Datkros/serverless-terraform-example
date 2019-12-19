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

resource "aws_lambda_function" "serverless_klarna" {

  for_each = var.deployments 

  filename      = each.value
  function_name = "KlarnaServerless${each.value}"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "app.handler"

  runtime = "python3.7"
}
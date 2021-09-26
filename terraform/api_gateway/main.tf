# creating the HTTP API using API Gateway. I am getting the Lambda's arn from the parent module.
resource "aws_apigatewayv2_api" "http_api" {
  name          = "my_lambda_http_api"
  protocol_type = "HTTP"
  target        = var.lambda_name_arn.arn
  description   = "API for my lambda"
}

# permission to invoke Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name_arn.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}


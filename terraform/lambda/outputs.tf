output "lambda_name_arn" {
  value = tomap({
    "arn"           = aws_lambda_function.my_lambda.arn,
    "function_name" = aws_lambda_function.my_lambda.function_name
  })
}

module "lambdas" {
  source = "./lambda"
  # I didnt want to create 2 different accounts for different enviroments so I give my Lambdas env tags.
  #enviroments = var.enviroments
}

module "api_gateway" {
  source = "./api_gateway"
  # Lamdas module returns a map with {env: ,arn: } payload.
  lambda_name_arn = module.lambdas.lambda_name_arn
  #env_cloudwatch_arn_list = module.cloudwatch.env_cloudwatch_arn_list

}

module "s3" {
  source      = "./s3"
  enviroments = var.enviroments
}

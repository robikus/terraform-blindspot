/*
This is probably not the best code organization, but I wanted to test couple of things here:
- how modules work
- how to pass variables between modules
- how dependencies between modules works etc.

So in real life this would probably look differenlty. Moreover I couldnt make tfvars work here in GitHub (and Terraform Cloud)...
*/

module "lambdas" {
  source = "./lambda"
}

module "api_gateway" {
  source = "./api_gateway"
  # Lamda information returned from the Lambda module above
  # I wanted to test how to pass variables between modules
  lambda_name_arn = module.lambdas.lambda_name_arn

}

module "s3" {
  source = "./s3"
  # again, wanted to test how to pass variables to modules
  enviroments = var.enviroments
}

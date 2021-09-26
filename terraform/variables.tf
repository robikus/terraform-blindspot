variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

/*
This would be probably better to have in tfvars but I could not make it work here in GitHub actions and Terraform Cloud.
*/
variable "enviroments" {
  type    = list(string)
  default = ["dev", "prod"]
}



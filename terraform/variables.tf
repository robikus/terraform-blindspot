variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

/*
I didnt have enough time to figure out how to get around this as it seems impossible to 
pass in arguments to Terraform from GitHub actions. 

For now I would have 2 different versions of this file in DEV and MAIN branches.
*/
variable "enviroments" {
  type    = list(string)
  default = ["dev", "prod"]
}



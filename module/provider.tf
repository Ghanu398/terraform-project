# provider "aws" {
#   region = terraform.workspace == "dev" ? "us-east-2" : "us-east-1"
#   alias = terraform.workspace == "dev" ? "Prod" : "Dev"
# }
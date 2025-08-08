module "vpc_1" {
  source = "./module/vpc"
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  Name = var.Name
  Environment = var.Environment
  subnet = var.subnet
  
}


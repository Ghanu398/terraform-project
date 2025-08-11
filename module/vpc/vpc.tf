resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  tags = {
    Name = var.Name
    Environment = var.Environment
  }
}

resource "aws_subnet" "subnets" {
  for_each = local.subnet1
  vpc_id = aws_vpc.vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.az
  map_public_ip_on_launch = each.value.type == "public" ? true : false
  tags = {
    Name = each.value.name
    Environment = var.Environment
  }
}




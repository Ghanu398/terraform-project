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

resource "aws_security_group" "sg" {
  name = "vpc1-security-group"
  description = "security group for region1"
  vpc_id = aws_vpc.vpc.id
  dynamic "ingress" {
    for_each = var.ingress_rule
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      description = ingress.value.description
      cidr_blocks = ingress.value.cidr_blocks
    }
  }


    dynamic "egress" {
    for_each = var.egress_rule
    content {
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      protocol = egress.value.protocol
      description = egress.value.description
      cidr_blocks = egress.value.cidr_blocks
    }
  }
    tags = {
    Name = "sg-${var.Name}"
    Environment = var.Environment
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "nat_gateway" {
  subnet_id = one([for subnet in aws_subnet.subnets : subnet.id if can(regex("public-subnet-vpc-1-1",subnet.tags["Name"]))])
 allocation_id = aws_eip.eip.id
 tags = {
   Name = "nat-gateway"
   Environment = var.Environment
 }
}

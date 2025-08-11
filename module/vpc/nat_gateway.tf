resource "aws_eip" "eip" {
    count = terraform.workspace == "dev" ? 1 : 0
  domain = "vpc"
}
resource "aws_nat_gateway" "nat_gateway" {
    count = terraform.workspace == "dev" ? 1 : 0
  subnet_id = one([for subnet in aws_subnet.subnets : subnet.id if can(regex("public-subnet-vpc-1-1",subnet.tags["Name"]))])
 allocation_id = aws_eip.eip[0].allocation_id    #element(aws_eip.eip[*].id,0)
 tags = {
   Name = "nat-gateway-${var.Name}"
   Environment = var.Environment
 }
}

resource "aws_eip" "prod_eip" {
    count = terraform.workspace == "prod" ? 1 : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "prod_nat_gateway" {
    count = terraform.workspace == "prod" ? 1 : 0
  subnet_id = one([for subnet in aws_subnet.subnets : subnet.id if can(regex("public-subnet-vpc-2",subnet.tags["Name"]))])
 allocation_id = aws_eip.prod_eip[0].allocation_id    #element(aws_eip.eip[*].id,0)
 tags = {
   Name = "nat-gateway-${var.Name}"
   Environment = var.Environment
 }
}

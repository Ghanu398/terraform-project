resource "aws_eip" "eip" {
    count = terraform.workspace == "dev" ? 0 : 1
  domain = "vpc"
}
resource "aws_nat_gateway" "nat_gateway" {
    count = terraform.workspace == "dev" ? 0 : 1
  subnet_id = one([for subnet in aws_subnet.subnets : subnet.id if can(regex("public-subnet-vpc-1-1",subnet.tags["Name"]))])
 allocation_id = aws_eip.eip[*].id
 tags = {
   Name = "nat-gateway"
   Environment = var.Environment
 }
}

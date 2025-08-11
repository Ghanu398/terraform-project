

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  for_each = local.rt
  tags = {
    Name = "${each.value}-route-table-${var.Name}"
    Environment = var.Environment
  }
}


resource "aws_route_table_association" "public-route_table_association" {
  route_table_id = local.rt1
  subnet_id = one([for subnet in aws_subnet.subnets:subnet.id if can(regex("public-subnet-vpc-1-1",subnet.tags["Name"]))])
}

resource "aws_route_table_association" "public-route_table_association-2" {
  route_table_id = local.rt1
  subnet_id = one([for subnet in aws_subnet.subnets:subnet.id if can(regex("public-subnet-vpc-1-2",subnet.tags["Name"]))])
}

resource "aws_route_table_association" "private-route_table_association" {
  route_table_id = one([for rt in aws_route_table.route_table:rt.id if can(regex("private-subnet-vpc-1-1-",rt.tags["Name"]))])
  subnet_id = one([for subnet in aws_subnet.subnets:subnet.id if can(regex("private-subnet-",subnet.tags["Name"]))])
}



resource "aws_route" "public_route" {
  route_table_id = local.rt1
  gateway_id = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [ aws_route_table.route_table ]
}

resource "aws_route" "private_route" {
  route_table_id = one([for rt in aws_route_table.route_table:rt.id if can(regex("private-subnet-vpc-1-1-",rt.tags["Name"]))])
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [ aws_route_table.route_table ]
}
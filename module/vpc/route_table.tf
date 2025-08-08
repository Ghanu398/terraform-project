

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
  subnet_id = one([for subnet in aws_subnet.subnets:subnet.id if can(regex("public-subnet-",subnet.tags["Name"]))])
}

resource "aws_route_table_association" "private-route_table_association" {
  route_table_id = one([for rt in aws_route_table.route_table:rt.id if can(regex("private-route-table-",rt.tags["Name"]))])
  subnet_id = one([for subnet in aws_subnet.subnets:subnet.id if can(regex("private-subnet-",subnet.tags["Name"]))])
}
#adding
locals {
  subnet1 = merge({
  for idx , subnet in var.subnet : "public-subnet-${var.Name}-${idx+1}" => subnet if subnet.type == "public"
  },
  {
   for idx , subnet in var.subnet : "private-subnet-${var.Name}-${idx+1}" => subnet if subnet.type == "private" 
  })
}

locals {
  rt = {
    for idx,subnet in var.subnet : "${idx+1}" => subnet.name
  }
}

locals {
 rt1 = one([for rt in aws_route_table.route_table : rt.id if can(regex("public-subnet-vpc-1-1-", rt.tags["Name"]))])

}
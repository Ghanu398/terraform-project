output "vpc_id" {
  value = aws_vpc.vpc.id
}

# output "subnet_id" {
#   value = aws_subnet.subnets.id
# }


output "public_subnet_id" {
  value = one([for subnet in aws_subnet.subnets : subnet.id if can(regex("public-subnet-vpc-1-1",subnet.tags["Name"]))])
}

# output "public_subnet_id_2" {
  
#   value = one([for subnet in aws_subnet.subnets : subnet.id if can(regex("public-subnet-",subnet.tags["Name"]))])
# }


output "lb_subnet_id" {
  value = [for subnet in aws_subnet.subnets : subnet.id if can(regex("public-subnet-vpc-1-",subnet.tags["Name"]))]
}


output "sg_id" {
  value = aws_security_group.sg.id
}

output "private_subnet_id" {
  value = one([for subnet in aws_subnet.subnets : subnet.id if can(regex("private-subnet-",subnet.tags["Name"]))])
}

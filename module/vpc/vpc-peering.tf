# data "aws_vpc" "vpc-prod" {
#   count = terraform.workspace == "prod" ? 1 : 0 
#   filter {
#     name = "tag:Name"
#     values = [ "Vpc-us-east-2" ]

#   }
#   depends_on = [ aws_vpc.vpc ]
# }

# locals {
#   is_dev = terraform.workspace == "dev"
# }

# resource "aws_vpc_peering_connection" "peering" {
#   count = local.is_dev ? 1 : 0 
#   vpc_id = aws_vpc.vpc.id
#   peer_vpc_id = data.aws_vpc.vpc-prod[count.index].id
#   auto_accept = false
#   tags = {
#     Name = "dev-vpc-peering"
#     Environment = var.Environment
#   }
# }

# # resource "aws_vpc_peering_connection_accepter" "accepter" {
# #   count = local.is_dev ? 1 : 0 
  
# #   region = "us-east-2"
# #   vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
# #   auto_accept = true
# # }
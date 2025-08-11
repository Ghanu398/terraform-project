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
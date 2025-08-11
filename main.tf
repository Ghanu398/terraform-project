module "vpc_1" {
  source = "./module/vpc"
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  Name = var.Name
  Environment = var.Environment
  subnet = var.subnet
  ingress_rule = var.ingress_rule
  egress_rule = var.egress_rule
}

module "ec2" {
  source = "./module/ec2"
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = module.vpc_1.public_subnet_id
  sg_id = module.vpc_1.sg_id
  private_subnet_id = module.vpc_1.private_subnet_id
  Name = var.Name
  Environment = var.Environment
  vpc_id = module.vpc_1.vpc_id
  lb_subnet_id = module.vpc_1.lb_subnet_id
  userdata = file("${var.userdata}")
  assume-role-policy = file("${path.module}/assume-role-policy.json")
  policy = file("${path.module}/policy.json")
  ec2-policy = file("${path.module}/ec2-policy.json")
  public_subnet_id_2 = "module.vpc_1.public_subnet_id_2"
}

resource "aws_instance" "public_server" {
    count = 1
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [ var.sg_id ]
    tags = {
    Name = "public-server-${var.Name}"
    Environment = var.Environment
  }
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  user_data = var.userdata
}

resource "aws_instance" "private_server" {
    count = 1
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [ var.sg_id ]
    tags = {
    Name = "private-server-${var.Name}"
    Environment = var.Environment
  }
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  user_data = var.userdata
}



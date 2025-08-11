resource "aws_instance" "public_server" {
    count = 1
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = terraform.workspace == "dev" ? var.subnet_id : var.public_subnet_id_2
  vpc_security_group_ids = [ var.sg_id ]
    metadata_options {
    http_endpoint = "enabled"  # Allow metadata
    http_tokens   = "optional" # IMDSv1 allowed
  }
    tags = {
    Name = "public-server-${var.Name}"
    Environment = var.Environment
    server_type = "public"
  }
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  user_data = var.userdata
  user_data_replace_on_change = true
  #key_name = "first_key_pair"
}

resource "aws_instance" "private_server" {
    count = 1
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.private_subnet_id
  vpc_security_group_ids = [ var.sg_id ]
    metadata_options {
    http_endpoint = "enabled"  # Allow metadata
    http_tokens   = "optional" # IMDSv1 allowed
  }
    tags = {
    Name = "private-server-${var.Name}"
    Environment = var.Environment
    server_type = "private"
  }
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  user_data = var.userdata
  user_data_replace_on_change = true
  #key_name = "first_key_pair"
}



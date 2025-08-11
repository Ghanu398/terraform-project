resource "aws_iam_role" "ec2-s3-role" {
  name = "ec2-s3-role-assignment"
  assume_role_policy = var.assume-role-policy #file("${path.module}/assume-role-policy.json")
  tags = {
    Name = "ec2-s3-role-assignment"
  }
}

resource "aws_iam_policy" "policy" {
  policy = var.policy
  name = "s3-get-put-list-policy"
}

resource "aws_iam_policy_attachment" "policy_attachment" {
  policy_arn = aws_iam_policy.policy.arn
  roles = [aws_iam_role.ec2-s3-role.name]
  name = "iam-policy-attachment"
}

resource "aws_iam_instance_profile" "instance_profile" {
  role = aws_iam_role.ec2-s3-role.name 
  name = "ec2-s3-iam-role"
}
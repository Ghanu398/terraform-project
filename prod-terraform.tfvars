region = "us-east-2"
cidr_block = "10.1.0.0/16"
enable_dns_hostnames = true
enable_dns_support = true
Name = "Vpc-us-east-2"
Environment = "Prod"
subnet = [ {
  cidr_block = "10.1.0.0/24"
  az = "us-east-1a"
  type = "private"
  name = "private-subnet-vpc-2"
},
{
    cidr_block = "10.1.1.0/24"
    az = "us-east-1a"
    type = "public"
    name = "public-subnet-vpc-2"
}
]

ingress_rule = [ {
  cidr_blocks = [ "0.0.0.0/0" ]
  from_port = 0
  to_port = 0
  protocol = -1
  description = "allowing all inbound rule"
} ]


egress_rule = [ {
  cidr_blocks = [ "0.0.0.0/0" ]
  from_port = 0
  to_port = 0
  protocol = -1
  description = "allowing all outbound rule"
} ]

ami = "ami-0169aa51f6faf20d5"
instance_type = "t2.micro"
region = "us-east-1"
cidr_block = "10.0.0.0/16"
enable_dns_hostnames = true
enable_dns_support = true
Name = "Vpc-us-east-1"
Environment = "Dev"
subnet = [ {
  cidr_block = "10.0.0.0/24"
  az = "us-east-1a"
  type = "private"
  name = "private-subnet-vpc-1-1"
},
{
    cidr_block = "10.0.1.0/24"
    az = "us-east-1a"
    type = "public"
    name = "public-subnet-vpc-1-1"
},
{
    cidr_block = "10.0.2.0/24"
    az = "us-east-1b"
    type = "public"
    name = "public-subnet-vpc-1-2"
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

ami = "ami-084a7d336e816906b"
instance_type = "t2.micro"


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
},
{
    cidr_block = "10.1.1.0/24"
    az = "us-east-1b"
    type = "public"
}
]
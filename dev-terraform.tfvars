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
},
{
    cidr_block = "10.0.1.0/24"
    az = "us-east-1b"
    type = "public"
}
]
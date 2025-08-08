variable "cidr_block" {
type = string
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "enable_dns_support" {
  type = bool
}

variable "Environment" {
  type = string
}

variable "Name" {
  type = string
}

variable "subnet" {
  type = list(object({
    cidr_block = string
    az = string
    type = string 
  }))
}





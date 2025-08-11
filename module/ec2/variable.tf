variable "ami" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "sg_id" {
  type = string
}
variable "instance_type" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "Environment" {
  type = string
}

variable "Name" {
  type = string
}

variable "lb_subnet_id" {
    type = list(string)
}

variable "userdata" {
  type = string
}

variable "assume-role-policy" {
  type = string
}

variable "policy" {
  type = string
}
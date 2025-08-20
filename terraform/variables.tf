variable "instance_count" {
  default = 1
}

variable "ami_id" {
  default = "ami-0f918f7e67a3323f0"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "pem"
}

variable "security_group_id" {
  default = "sg-0d60ad85ad224e89e"
}

variable "vpc_id" {
  default = "vpc-0af2ef483f73e0f77"
}

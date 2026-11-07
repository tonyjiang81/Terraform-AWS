variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "stack_name" {
  type = string
}

variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "state_bucket" {
  type = string
}

variable "state_region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "single_nat_gateway" {
  type = bool
}

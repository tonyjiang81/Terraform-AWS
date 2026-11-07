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

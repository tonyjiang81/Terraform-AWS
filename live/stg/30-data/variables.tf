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

variable "db_instance_class" {
  type = string
}

variable "db_multi_az" {
  type = bool
}

variable "db_deletion_protection" {
  type = bool
}

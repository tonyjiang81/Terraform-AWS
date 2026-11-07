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

variable "cluster_version" {
  type = string
}

variable "endpoint_public_access" {
  type = bool
}

variable "node_instance_types" {
  type = list(string)
}

variable "node_desired_size" {
  type = number
}

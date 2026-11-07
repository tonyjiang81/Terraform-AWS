variable "name" {
  type        = string
  description = "Alias-friendly name for the CMK."
}

variable "description" {
  type    = string
  default = "Environment CMK managed by Terraform"
}

variable "deletion_window_in_days" {
  type    = number
  default = 30
}

variable "enable_key_rotation" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

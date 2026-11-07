variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the control plane."
  default     = "1.31"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for the control plane ENIs and node groups (usually private)."
}

variable "endpoint_public_access" {
  type    = bool
  default = true
}

variable "endpoint_private_access" {
  type    = bool
  default = true
}

variable "enable_irsa" {
  type    = bool
  default = true
}

variable "managed_node_groups" {
  type = map(object({
    instance_types = list(string)
    min_size       = number
    max_size       = number
    desired_size   = number
    capacity_type  = optional(string, "ON_DEMAND")
    disk_size      = optional(number, 50)
  }))
  description = "Map of EKS managed node groups. Keep this stack focused on cluster + nodes only."
  default     = {}
}

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the public API endpoint."
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  type    = map(string)
  default = {}
}
